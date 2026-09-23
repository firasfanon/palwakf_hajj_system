-- NOSOK v39 — Production Blocker Closure Mega Batch (DRAFT)
-- Date: 2026-09-23
-- Scope: campaign runtime, unit queue RPC, encrypted PII contract, integration readiness registry, production gate.
-- SAFETY: development artifact only. Ends with ROLLBACK. Separate exact-head DB-apply authorization is required.

begin;

create table if not exists nosok.application_private_payloads (
  application_id uuid primary key references nosok.applications(id) on delete cascade,
  national_id_hash text not null,
  encrypted_payload bytea not null,
  key_name text not null default 'NOSOK_PII_ENCRYPTION_KEY_V1',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table nosok.application_private_payloads enable row level security;
revoke all on nosok.application_private_payloads from public, anon, authenticated;

create table if not exists nosok.production_integration_readiness (
  integration_key text primary key,
  status text not null check (status in ('external_evidence_required','configured_not_certified','certified')),
  evidence_reference text,
  notes text,
  updated_by uuid,
  updated_at timestamptz not null default now()
);

alter table nosok.production_integration_readiness enable row level security;
revoke all on nosok.production_integration_readiness from public, anon, authenticated;

insert into nosok.production_integration_readiness(integration_key,status,notes)
values
  ('civil_registry','external_evidence_required','No production provider evidence bound.'),
  ('otp_sms','external_evidence_required','No production provider evidence bound.'),
  ('payment_esadad','external_evidence_required','No production provider evidence bound.'),
  ('company_auth_captcha','external_evidence_required','No production provider evidence bound.'),
  ('official_lottery','external_evidence_required','No official production integration evidence bound.')
on conflict (integration_key) do nothing;

-- Close the legacy public-document exposure and use a private citizen-upload bucket.
update storage.buckets set public=false where id='nosok-public';
drop policy if exists "Public can view nosok storage" on storage.objects;
drop policy if exists "Public can upload nosok storage" on storage.objects;
drop policy if exists "Authenticated can update nosok storage" on storage.objects;
drop policy if exists "Authenticated can delete nosok storage" on storage.objects;

insert into storage.buckets(id,name,public,file_size_limit)
values('nosok-private','nosok-private',false,10485760)
on conflict(id) do update set public=false,file_size_limit=excluded.file_size_limit;

do $$
begin
  if not exists (
    select 1 from pg_policies
    where schemaname='storage' and tablename='objects'
      and policyname='Nosok citizen private draft upload'
  ) then
    create policy "Nosok citizen private draft upload"
    on storage.objects for insert
    to anon, authenticated
    with check (
      bucket_id='nosok-private'
      and (storage.foldername(name))[1]='applications'
      and (storage.foldername(name))[2]='drafts'
    );
  end if;
  if not exists (
    select 1 from pg_policies
    where schemaname='storage' and tablename='objects'
      and policyname='Nosok document officers private read'
  ) then
    create policy "Nosok document officers private read"
    on storage.objects for select
    to authenticated
    using (
      bucket_id='nosok-private'
      and public.has_permission('nosok'::text,'manageNosokDocuments')
    );
  end if;
  if not exists (
    select 1 from pg_policies
    where schemaname='storage' and tablename='objects'
      and policyname='Nosok document officers private delete'
  ) then
    create policy "Nosok document officers private delete"
    on storage.objects for delete
    to authenticated
    using (
      bucket_id='nosok-private'
      and public.has_permission('nosok'::text,'manageNosokDocuments')
    );
  end if;
end $$;

create or replace function nosok._can_access_unit_v1(p_unit_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public, core, pg_temp
set row_security = off
as $$
  select case
    when auth.uid() is null then false
    when public.is_superuser() then true
    when p_unit_id is null then false
    else exists (
      select 1 from public.admin_users au
      where au.id = auth.uid()
        and coalesce(au.is_active,true)
        and au.unit_id = p_unit_id
    ) or exists (
      select 1
      from public.user_scope_assignments usa
      left join public.user_scope_assignment_units usau on usau.assignment_id = usa.id
      where usa.user_id = auth.uid()
        and usa.is_active = true
        and (usa.expires_at is null or usa.expires_at > now())
        and (usa.unit_id = p_unit_id or usau.unit_id = p_unit_id)
    )
  end;
$$;

revoke all on function nosok._can_access_unit_v1(uuid) from public, anon, authenticated;

create or replace function nosok._pii_key_v1()
returns text
language plpgsql
stable
security definer
set search_path = vault, pg_temp
as $$
declare
  v_key text;
begin
  select ds.decrypted_secret into v_key
  from vault.decrypted_secrets ds
  where ds.name = 'NOSOK_PII_ENCRYPTION_KEY_V1'
  order by ds.updated_at desc
  limit 1;
  if v_key is null or length(v_key) < 32 then
    raise exception 'NOSOK_PII_KEY_NOT_PROVISIONED';
  end if;
  return v_key;
end;
$$;

revoke all on function nosok._pii_key_v1() from public, anon, authenticated;

create or replace function public.rpc_nosok_admin_campaigns_list_v1()
returns table(
  id uuid, campaign_code text, title_ar text, service_type text, season_year integer,
  status text, unit_id uuid, application_open_at timestamptz, application_close_at timestamptz
)
language sql
stable
security definer
set search_path = public, nosok, pg_temp
set row_security = off
as $$
  select c.id,c.campaign_code,c.title_ar,c.service_type,c.season_year,c.status,
         c.unit_id,c.application_open_at,c.application_close_at
  from nosok.campaigns c
  where public.has_permission('nosok'::text,'manageNosokCampaigns')
    and (public.is_superuser() or nosok._can_access_unit_v1(c.unit_id))
  order by c.season_year desc,c.created_at desc;
$$;

revoke all on function public.rpc_nosok_admin_campaigns_list_v1() from public, anon;
grant execute on function public.rpc_nosok_admin_campaigns_list_v1() to authenticated;

create or replace function public.rpc_nosok_campaign_lgus_public_list_v1(p_campaign_code text)
returns table(lgu_id uuid, lgu_no integer, lgu_code text, lgu_name_ar text)
language sql
stable
security definer
set search_path = public, nosok, core, pg_temp
set row_security = off
as $$
  with campaign as (
    select c.id,c.unit_id
    from nosok.campaigns c
    where c.campaign_code=trim(p_campaign_code)
      and c.status='published'
      and (c.application_open_at is null or c.application_open_at<=now())
      and (c.application_close_at is null or c.application_close_at>=now())
    limit 1
  ),
  candidate as (
    select p.*
    from nosok.administrative_unit_lgu_scope_policy p
    join campaign c on c.unit_id=p.unit_id
    where p.status='approved'
      and p.is_active
      and (p.valid_from is null or p.valid_from<=now())
      and (p.valid_until is null or p.valid_until>now())
      and (p.campaign_id is null or p.campaign_id=c.id)
  ),
  specific as (
    select exists(
      select 1 from candidate p join campaign c on true
      where p.campaign_id=c.id
    ) as has_specific
  )
  select l.id,l.lgus_no,l.code,l.name_ar
  from candidate p
  join campaign c on true
  cross join specific x
  join core.core_lgus l on l.id=p.lgu_id and l.is_active
  where (x.has_specific and p.campaign_id=c.id)
     or (not x.has_specific and p.campaign_id is null)
  order by l.lgus_no,l.name_ar;
$$;

revoke all on function public.rpc_nosok_campaign_lgus_public_list_v1(text) from public;
grant execute on function public.rpc_nosok_campaign_lgus_public_list_v1(text) to anon, authenticated;

create or replace function public.rpc_nosok_admin_campaign_upsert_v1(
  p_campaign_code text,
  p_title_ar text,
  p_service_type text,
  p_season_year integer,
  p_status text default 'draft',
  p_unit_id uuid default null,
  p_application_open_at timestamptz default null,
  p_application_close_at timestamptz default null,
  p_metadata jsonb default '{}'::jsonb
)
returns setof nosok.campaigns
language plpgsql
security definer
set search_path = public, nosok, core, pg_temp
set row_security = off
as $$
declare
  v_row nosok.campaigns%rowtype;
  v_unit_id uuid;
begin
  if not public.has_permission('nosok'::text,'manageNosokCampaigns') then
    raise exception 'NOSOK_PERMISSION_DENIED';
  end if;
  if p_campaign_code is null or trim(p_campaign_code) = '' then
    raise exception 'NOSOK_CAMPAIGN_CODE_REQUIRED';
  end if;
  if p_service_type not in ('hajj','umrah','mixed') then
    raise exception 'NOSOK_INVALID_SERVICE_TYPE';
  end if;
  if p_status not in ('draft','published','closed','archived') then
    raise exception 'NOSOK_INVALID_CAMPAIGN_STATUS';
  end if;

  v_unit_id := p_unit_id;
  if v_unit_id is null then
    select au.unit_id into v_unit_id
    from public.admin_users au
    where au.id=auth.uid() and coalesce(au.is_active,true)
    limit 1;
  end if;
  if v_unit_id is null then
    raise exception 'NOSOK_CAMPAIGN_UNIT_REQUIRED';
  end if;
  if not nosok._can_access_unit_v1(v_unit_id) then
    raise exception 'NOSOK_UNIT_SCOPE_DENIED';
  end if;
  if p_status = 'published' and not exists (
    select 1 from nosok.administrative_unit_lgu_scope_policy p
    where p.unit_id = v_unit_id
      and p.status = 'approved'
      and p.is_active
      and p.campaign_id is null
      and (p.valid_from is null or p.valid_from <= now())
      and (p.valid_until is null or p.valid_until > now())
  ) then
    raise exception 'NOSOK_CAMPAIGN_UNIT_HAS_NO_APPROVED_LGU_SCOPE';
  end if;
  if p_application_open_at is not null and p_application_close_at is not null
     and p_application_close_at < p_application_open_at then
    raise exception 'NOSOK_INVALID_CAMPAIGN_WINDOW';
  end if;

  insert into nosok.campaigns(
    campaign_code,title_ar,service_type,season_year,status,unit_id,
    application_open_at,application_close_at,metadata
  ) values (
    trim(p_campaign_code),trim(p_title_ar),p_service_type,p_season_year,p_status,v_unit_id,
    p_application_open_at,p_application_close_at,coalesce(p_metadata,'{}'::jsonb)
  )
  on conflict (campaign_code) do update set
    title_ar=excluded.title_ar,
    service_type=excluded.service_type,
    season_year=excluded.season_year,
    status=excluded.status,
    unit_id=excluded.unit_id,
    application_open_at=excluded.application_open_at,
    application_close_at=excluded.application_close_at,
    metadata=excluded.metadata,
    updated_at=now()
  returning * into v_row;

  return next v_row;
end;
$$;

revoke all on function public.rpc_nosok_admin_campaign_upsert_v1(text,text,text,integer,text,uuid,timestamptz,timestamptz,jsonb) from public, anon;
grant execute on function public.rpc_nosok_admin_campaign_upsert_v1(text,text,text,integer,text,uuid,timestamptz,timestamptz,jsonb) to authenticated;

create or replace function public.rpc_nosok_admin_campaign_delete_v1(p_campaign_id uuid)
returns void
language plpgsql
security definer
set search_path = public, nosok, pg_temp
set row_security = off
as $$
declare
  v_unit uuid;
begin
  if not public.has_permission('nosok'::text,'manageNosokCampaigns') then
    raise exception 'NOSOK_PERMISSION_DENIED';
  end if;
  select unit_id into v_unit from nosok.campaigns where id=p_campaign_id;
  if v_unit is null or not nosok._can_access_unit_v1(v_unit) then
    raise exception 'NOSOK_UNIT_SCOPE_DENIED';
  end if;
  if exists(select 1 from nosok.applications where campaign_id=p_campaign_id) then
    raise exception 'NOSOK_CAMPAIGN_HAS_APPLICATIONS';
  end if;
  delete from nosok.campaigns where id=p_campaign_id;
end;
$$;

revoke all on function public.rpc_nosok_admin_campaign_delete_v1(uuid) from public, anon;
grant execute on function public.rpc_nosok_admin_campaign_delete_v1(uuid) to authenticated;

create or replace function public.rpc_nosok_application_submit_v2(
  p_campaign_code text,
  p_applicant_display_name text,
  p_lgu_id uuid default null,
  p_governorate_id uuid default null,
  p_pii_payload jsonb default '{}'::jsonb,
  p_metadata jsonb default '{}'::jsonb
)
returns table(application_id uuid, tracking_code text, status text, eligibility_status text)
language plpgsql
security definer
set search_path = public, nosok, core, extensions, vault, pg_temp
set row_security = off
as $$
declare
  v_campaign nosok.campaigns%rowtype;
  v_application_id uuid;
  v_tracking_code text;
  v_key text;
  v_national_id text;
  v_unit_id uuid;
  v_governorate_id uuid;
  v_has_specific boolean;
begin
  select * into v_campaign
  from nosok.campaigns c
  where c.campaign_code=trim(p_campaign_code)
    and c.status='published'
    and (c.application_open_at is null or c.application_open_at <= now())
    and (c.application_close_at is null or c.application_close_at >= now())
  limit 1;
  if v_campaign.id is null then raise exception 'NOSOK_CAMPAIGN_NOT_OPEN'; end if;
  if v_campaign.unit_id is null then raise exception 'NOSOK_CAMPAIGN_UNIT_REQUIRED'; end if;
  v_unit_id := v_campaign.unit_id;

  if p_lgu_id is null then raise exception 'NOSOK_LGU_REQUIRED'; end if;

  select exists(
    select 1 from nosok.administrative_unit_lgu_scope_policy p
    where p.unit_id=v_unit_id
      and p.campaign_id=v_campaign.id
      and p.status='approved' and p.is_active
      and (p.valid_from is null or p.valid_from<=now())
      and (p.valid_until is null or p.valid_until>now())
  ) into v_has_specific;

  if not exists (
    select 1 from nosok.administrative_unit_lgu_scope_policy p
    where p.unit_id=v_unit_id and p.lgu_id=p_lgu_id
      and p.status='approved' and p.is_active
      and (p.valid_from is null or p.valid_from<=now())
      and (p.valid_until is null or p.valid_until>now())
      and (
        (v_has_specific and p.campaign_id=v_campaign.id)
        or (not v_has_specific and p.campaign_id is null)
      )
  ) then
    raise exception 'NOSOK_LGU_SCOPE_UNRESOLVED';
  end if;

  select g.id into v_governorate_id
  from core.core_lgus l
  join core.core_governorates g on g.governorate_no=l.governorate_no
  where l.id=p_lgu_id and l.is_active
  limit 1;
  if v_governorate_id is null then raise exception 'NOSOK_LGU_INVALID'; end if;
  if p_governorate_id is not null and p_governorate_id<>v_governorate_id then
    raise exception 'NOSOK_GOVERNORATE_LGU_MISMATCH';
  end if;

  if p_metadata ?| array['national_id','phone','mobile','email','birth_date','address_text','companions','documents','payments'] then
    raise exception 'NOSOK_PII_FORBIDDEN_IN_METADATA';
  end if;

  v_national_id := nullif(trim(coalesce(p_pii_payload->>'national_id','')),'');
  if v_national_id is null then raise exception 'NOSOK_NATIONAL_ID_REQUIRED'; end if;
  v_key := nosok._pii_key_v1();

  v_tracking_code := 'NSK-' || to_char(now(),'YYYYMMDD') || '-' ||
                     upper(substr(replace(gen_random_uuid()::text,'-',''),1,8));

  insert into nosok.applications(
    campaign_id,tracking_code,applicant_national_id_hash,applicant_display_name,
    lgu_id,governorate_id,unit_id,status,eligibility_status,submitted_at,metadata
  ) values (
    v_campaign.id,v_tracking_code,
    encode(extensions.hmac(v_national_id,v_key || ':national-id-index','sha256'),'hex'),
    nullif(trim(coalesce(p_applicant_display_name,'')),''),
    p_lgu_id,v_governorate_id,v_unit_id,'submitted','pending',now(),coalesce(p_metadata,'{}'::jsonb)
  )
  returning id into v_application_id;

  insert into nosok.application_private_payloads(application_id,national_id_hash,encrypted_payload)
  values (
    v_application_id,
    encode(extensions.hmac(v_national_id,v_key || ':national-id-index','sha256'),'hex'),
    extensions.pgp_sym_encrypt(coalesce(p_pii_payload,'{}'::jsonb)::text,v_key,'cipher-algo=aes256')
  );

  insert into nosok.workflow_events(application_id,event_key,to_status,reason,metadata)
  values (
    v_application_id,'public_submit_v2','submitted','encrypted PII submit',
    jsonb_build_object('pii_contract','vault-encrypted-v1')
  );
  insert into nosok.audit_events(event_key,target_table,target_id,reason,metadata)
  values (
    'public_submit_v2','nosok.applications',v_application_id,'encrypted PII submit',
    jsonb_build_object('tracking_code',v_tracking_code)
  );

  return query select v_application_id,v_tracking_code,'submitted'::text,'pending'::text;
end;
$$;

revoke all on function public.rpc_nosok_application_submit_v2(text,text,uuid,uuid,jsonb,jsonb) from public;
grant execute on function public.rpc_nosok_application_submit_v2(text,text,uuid,uuid,jsonb,jsonb) to anon, authenticated;

create or replace function public.rpc_nosok_admin_application_private_v1(p_application_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = public, nosok, extensions, pg_temp
set row_security = off
as $$
declare
  v_unit uuid;
  v_cipher bytea;
  v_key text;
begin
  if not public.has_permission('nosok'::text,'manageNosokApplications') then
    raise exception 'NOSOK_PERMISSION_DENIED';
  end if;
  select a.unit_id,p.encrypted_payload into v_unit,v_cipher
  from nosok.applications a
  join nosok.application_private_payloads p on p.application_id=a.id
  where a.id=p_application_id;
  if v_cipher is null then return null; end if;
  if not nosok._can_access_unit_v1(v_unit) then raise exception 'NOSOK_UNIT_SCOPE_DENIED'; end if;
  v_key := nosok._pii_key_v1();
  return extensions.pgp_sym_decrypt(v_cipher,v_key)::jsonb;
end;
$$;

revoke all on function public.rpc_nosok_admin_application_private_v1(uuid) from public, anon;
grant execute on function public.rpc_nosok_admin_application_private_v1(uuid) to authenticated;

create or replace function public.rpc_nosok_admin_unit_application_queue_v1(
  p_unit_id uuid default null,
  p_unit_slug text default null,
  p_status text default null
)
returns table(
  id uuid, application_no text, applicant_full_name text, service_type text,
  application_status text, eligibility_status text, unit_id uuid, unit_slug text,
  unit_name_ar text, season_title_ar text, program_title_ar text, mobile text,
  submitted_at timestamptz, documents_count integer, pending_documents_count integer,
  rejected_documents_count integer, payments_count integer, total_paid_amount numeric,
  pending_payments_count integer, verified_payments_count integer, needs_action boolean
)
language plpgsql
stable
security definer
set search_path = public, nosok, core, pg_temp
set row_security = off
as $$
begin
  if p_unit_slug is not null and trim(p_unit_slug) <> '' then
    raise exception 'NOSOK_UNIT_SLUG_AUTHORIZATION_FORBIDDEN';
  end if;
  if p_unit_id is null then raise exception 'NOSOK_UNIT_ID_REQUIRED'; end if;
  if not public.has_permission('nosok'::text,'viewNosokUnitQueues') then
    raise exception 'NOSOK_PERMISSION_DENIED';
  end if;
  if not nosok._can_access_unit_v1(p_unit_id) then
    raise exception 'NOSOK_UNIT_SCOPE_DENIED';
  end if;

  return query
  select a.id,a.tracking_code,a.applicant_display_name,c.service_type,a.status,a.eligibility_status,
         a.unit_id,u.slug,u.name_ar,c.title_ar,c.title_ar,null::text,a.submitted_at,
         0,0,0,0,0::numeric,0,0,(a.status in ('submitted','under_review'))::boolean
  from nosok.applications a
  join nosok.campaigns c on c.id=a.campaign_id
  join core.org_units u on u.id=a.unit_id
  where a.unit_id=p_unit_id
    and (p_status is null or trim(p_status)='' or a.status=trim(p_status))
  order by a.submitted_at desc nulls last,a.created_at desc;
end;
$$;

revoke all on function public.rpc_nosok_admin_unit_application_queue_v1(uuid,text,text) from public, anon;
grant execute on function public.rpc_nosok_admin_unit_application_queue_v1(uuid,text,text) to authenticated;

create or replace function public.rpc_nosok_admin_integration_readiness_v1()
returns setof nosok.production_integration_readiness
language sql
stable
security definer
set search_path = public, nosok, pg_temp
set row_security = off
as $$
  select r.*
  from nosok.production_integration_readiness r
  where public.has_permission('nosok'::text,'manageNosokPlatformIntegrationReadiness')
  order by r.integration_key;
$$;

revoke all on function public.rpc_nosok_admin_integration_readiness_v1() from public, anon;
grant execute on function public.rpc_nosok_admin_integration_readiness_v1() to authenticated;

create or replace function public.rpc_nosok_admin_integration_readiness_update_v1(
  p_integration_key text,
  p_status text,
  p_evidence_reference text default null,
  p_notes text default null
)
returns setof nosok.production_integration_readiness
language plpgsql
security definer
set search_path = public, nosok, pg_temp
set row_security = off
as $$
begin
  if not public.has_permission('nosok'::text,'manageNosokPlatformIntegrationReadiness') then
    raise exception 'NOSOK_PERMISSION_DENIED';
  end if;
  if p_status not in ('external_evidence_required','configured_not_certified','certified') then
    raise exception 'NOSOK_INVALID_INTEGRATION_STATUS';
  end if;
  if p_status='certified' and (
    not public.is_superuser()
    or nullif(trim(coalesce(p_evidence_reference,'')),'') is null
  ) then
    raise exception 'NOSOK_CERTIFICATION_REQUIRES_SUPERUSER_AND_EVIDENCE';
  end if;

  insert into nosok.production_integration_readiness(
    integration_key,status,evidence_reference,notes,updated_by,updated_at
  ) values (
    trim(p_integration_key),p_status,
    nullif(trim(coalesce(p_evidence_reference,'')),''),
    p_notes,auth.uid(),now()
  )
  on conflict(integration_key) do update set
    status=excluded.status,
    evidence_reference=excluded.evidence_reference,
    notes=excluded.notes,
    updated_by=excluded.updated_by,
    updated_at=excluded.updated_at;

  return query
    select * from nosok.production_integration_readiness
    where integration_key=trim(p_integration_key);
end;
$$;

revoke all on function public.rpc_nosok_admin_integration_readiness_update_v1(text,text,text,text) from public, anon;
grant execute on function public.rpc_nosok_admin_integration_readiness_update_v1(text,text,text,text) to authenticated;

create or replace function public.rpc_nosok_production_gate_readiness_v1()
returns table(check_key text, passed boolean, detail text)
language sql
stable
security definer
set search_path = public, nosok, vault, pg_temp
set row_security = off
as $$
  with authorized as (
    select public.has_permission('nosok'::text,'redecideNosokProductionGate') as allowed
  )
  select 'authority_policy_rows',
         exists(select 1 from nosok.administrative_unit_lgu_scope_policy where status='approved' and is_active),
         'requires approved authority mappings'
  from authorized where allowed
  union all
  select 'open_campaign',
         exists(select 1 from nosok.campaigns where status='published'
           and (application_open_at is null or application_open_at<=now())
           and (application_close_at is null or application_close_at>=now())),
         'requires published/open campaign'
  from authorized where allowed
  union all
  select 'pii_encryption_key',
         exists(select 1 from vault.decrypted_secrets
           where name='NOSOK_PII_ENCRYPTION_KEY_V1' and length(decrypted_secret)>=32),
         'requires provisioned Vault secret'
  from authorized where allowed
  union all
  select 'public_campaign_lgu_rpc',
         to_regprocedure('public.rpc_nosok_campaign_lgus_public_list_v1(text)') is not null,
         'requires public-safe campaign LGU resolver'
  from authorized where allowed
  union all
  select 'private_storage_bucket',
         exists(select 1 from storage.buckets where id='nosok-private' and public=false),
         'requires private citizen document bucket'
  from authorized where allowed
  union all
  select 'unit_queue_rpc',
         to_regprocedure('public.rpc_nosok_admin_unit_application_queue_v1(uuid,text,text)') is not null,
         'requires canonical unit queue RPC'
  from authorized where allowed
  union all
  select 'pii_submit_v2',
         to_regprocedure('public.rpc_nosok_application_submit_v2(text,text,uuid,uuid,jsonb,jsonb)') is not null,
         'requires encrypted PII submit RPC'
  from authorized where allowed
  union all
  select 'external_integrations',
         (
           select count(*)=5
           from nosok.production_integration_readiness
           where integration_key in (
             'civil_registry','otp_sms','payment_esadad',
             'company_auth_captcha','official_lottery'
           )
             and status='certified'
             and nullif(trim(coalesce(evidence_reference,'')),'') is not null
         ),
         'requires all five external integrations certified with evidence'
  from authorized where allowed;
$$;

revoke all on function public.rpc_nosok_production_gate_readiness_v1() from public, anon;
grant execute on function public.rpc_nosok_production_gate_readiness_v1() to authenticated;

-- No live mutation in this development artifact.
rollback;
