-- NOSOK v39 DRAFT — AUTHORITATIVE UNIT→LGU POLICY MAPPING
-- STATUS: REVIEWED DESIGN / NOT AUTHORIZED FOR DATABASE APPLY
-- No seed rows are included. Do not apply without separate DB authorization.

begin;

create table if not exists nosok.administrative_unit_lgu_scope_policy (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references core.org_units(id) on delete restrict,
  lgu_id uuid not null references core.core_lgus(id) on delete restrict,
  campaign_id uuid references nosok.campaigns(id) on delete cascade,
  status text not null default 'draft'
    check (status in ('draft','approved','revoked')),
  is_active boolean not null default true,
  valid_from timestamptz,
  valid_until timestamptz,
  source_authority text not null,
  source_reference text,
  basis_note text,
  created_by uuid default auth.uid(),
  approved_by uuid,
  approved_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (length(btrim(source_authority)) > 0),
  check (valid_until is null or valid_from is null or valid_until > valid_from)
);
create unique index if not exists uq_nosok_unit_lgu_policy_default_live
on nosok.administrative_unit_lgu_scope_policy(unit_id, lgu_id)
where campaign_id is null and is_active and status in ('draft','approved');

create unique index if not exists uq_nosok_unit_lgu_policy_campaign_live
on nosok.administrative_unit_lgu_scope_policy(campaign_id, unit_id, lgu_id)
where campaign_id is not null and is_active and status in ('draft','approved');

create index if not exists idx_nosok_unit_lgu_policy_unit
on nosok.administrative_unit_lgu_scope_policy(unit_id, status, is_active);

create index if not exists idx_nosok_unit_lgu_policy_campaign
on nosok.administrative_unit_lgu_scope_policy(campaign_id, unit_id, status, is_active);

comment on table nosok.administrative_unit_lgu_scope_policy is
'Nosok-owned authorization policy linking canonical core.org_units IDs to canonical core.core_lgus IDs. Slugs/names are never authority keys.';

alter table nosok.administrative_unit_lgu_scope_policy enable row level security;
revoke all on nosok.administrative_unit_lgu_scope_policy from anon, authenticated;
create or replace function nosok.fn_validate_administrative_unit_lgu_scope_policy_v1()
returns trigger
language plpgsql
security definer
set search_path = nosok, core, public, pg_temp
as $$
declare
  v_unit_type text;
  v_unit_governorate_id uuid;
  v_unit_active boolean;
  v_lgu_governorate_id uuid;
  v_lgu_active boolean;
begin
  select u.unit_type::text, u.governorate_id, coalesce(u.is_active, true)
    into v_unit_type, v_unit_governorate_id, v_unit_active
  from core.org_units u
  where u.id = new.unit_id;

  if not found or not v_unit_active then
    raise exception 'NOSOK_UNIT_SCOPE_INVALID_OR_INACTIVE_UNIT';
  end if;
  if v_unit_type <> 'directorate' or v_unit_governorate_id is null then
    raise exception 'NOSOK_UNIT_SCOPE_REQUIRES_GEOGRAPHIC_DIRECTORATE';
  end if;
  select g.id, coalesce(l.is_active, true)
    into v_lgu_governorate_id, v_lgu_active
  from core.core_lgus l
  left join core.core_governorates g
    on g.governorate_no = l.governorate_no
  where l.id = new.lgu_id;

  if not found or not v_lgu_active then
    raise exception 'NOSOK_UNIT_SCOPE_INVALID_OR_INACTIVE_LGU';
  end if;
  if v_lgu_governorate_id is distinct from v_unit_governorate_id then
    raise exception 'NOSOK_UNIT_SCOPE_CROSS_GOVERNORATE_MAPPING_DENIED';
  end if;
  if new.status = 'approved'
     and (new.approved_by is null or new.approved_at is null) then
    raise exception 'NOSOK_UNIT_SCOPE_APPROVAL_METADATA_REQUIRED';
  end if;

  new.updated_at := now();
  return new;
end;
$$;

revoke all on function nosok.fn_validate_administrative_unit_lgu_scope_policy_v1()
from public, anon, authenticated;
drop trigger if exists trg_nosok_validate_administrative_unit_lgu_scope_policy_v1
on nosok.administrative_unit_lgu_scope_policy;

create trigger trg_nosok_validate_administrative_unit_lgu_scope_policy_v1
before insert or update
on nosok.administrative_unit_lgu_scope_policy
for each row execute function
nosok.fn_validate_administrative_unit_lgu_scope_policy_v1();

create or replace function public.rpc_nosok_unit_lgu_scope_resolve_v1(
  p_unit_id uuid,
  p_campaign_id uuid default null
)
returns table(
  unit_id uuid,
  unit_slug text,
  unit_name_ar text,
  governorate_id uuid,
  lgu_id uuid,
  lgu_no integer,
  lgu_code text,
  lgu_name_ar text,
  campaign_id uuid,
  source_authority text,
  source_reference text
)
language sql
stable
security definer
set search_path = public, nosok, core, pg_temp
set row_security = off
as $$
with authorized as (
  select exists (
    select 1 from public.admin_users au
    where au.id = auth.uid()
      and coalesce(au.is_active, true)
      and (coalesce(au.is_superuser, false)
           or lower(coalesce(au.role, '')) = 'super_admin'
           or au.unit_id = p_unit_id)
    union all
    select 1
    from public.user_scope_assignments usa
    left join public.user_scope_assignment_units usau on usau.assignment_id = usa.id
    where usa.user_id = auth.uid()
      and usa.is_active = true
      and (usa.expires_at is null or usa.expires_at > now())
      and (usa.unit_id = p_unit_id or usau.unit_id = p_unit_id)
  ) as allowed
), candidate as (
  select p.*
  from nosok.administrative_unit_lgu_scope_policy p, authorized a
  where a.allowed and p.unit_id = p_unit_id
    and p.status = 'approved'
    and p.is_active = true
    and (p.valid_from is null or p.valid_from <= now())
    and (p.valid_until is null or p.valid_until > now())
    and (p.campaign_id is null or p.campaign_id = p_campaign_id)
), specific as (
  select exists(
    select 1 from candidate c
    where p_campaign_id is not null and c.campaign_id = p_campaign_id
  ) as has_specific
), effective as (
  select c.*
  from candidate c cross join specific s
  where (s.has_specific and c.campaign_id = p_campaign_id)
     or (not s.has_specific and c.campaign_id is null)
)
select
  e.unit_id,
  u.slug as unit_slug,
  u.name_ar as unit_name_ar,
  u.governorate_id,
  e.lgu_id,
  l.lgus_no as lgu_no,
  l.code as lgu_code,
  l.name_ar as lgu_name_ar,
  e.campaign_id,
  e.source_authority,
  e.source_reference
from effective e
join core.org_units u on u.id = e.unit_id
join core.core_lgus l on l.id = e.lgu_id
order by l.lgus_no, l.name_ar;
$$;

revoke all on function public.rpc_nosok_unit_lgu_scope_resolve_v1(uuid, uuid)
from public, anon;
grant execute on function public.rpc_nosok_unit_lgu_scope_resolve_v1(uuid, uuid)
to authenticated;

comment on function public.rpc_nosok_unit_lgu_scope_resolve_v1(uuid, uuid) is
'Resolves approved Nosok Unit→LGU policy using canonical Core IDs. Campaign-specific approved rows override defaults; no mapping means empty/fail-closed.';

commit;
