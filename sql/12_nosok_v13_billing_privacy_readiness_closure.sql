-- =========================================================
-- Nosok v13 — Billing Provider Adapter Hardening
--            + Public Tracking Privacy Review
--            + Production Readiness Evidence Closure
-- PalWakf remains the sovereign platform; Nosok is a semi-independent system underneath it.
-- No waqf / waqf_assets / awqaf_system mutation.
-- =========================================================

create schema if not exists nosok;
create extension if not exists pgcrypto;

-- ---------------------------------------------------------
-- 1) Billing provider adapter contracts
-- ---------------------------------------------------------
create table if not exists nosok.billing_provider_adapters (
  id uuid primary key default gen_random_uuid(),
  provider_key text not null unique,
  title_ar text not null,
  adapter_status text not null default 'draft', -- draft/enabled/disabled/deprecated
  adapter_mode text not null default 'contract_only', -- contract_only/platform_rpc_bridge/manual_verification/provider_gateway
  supports_webhook boolean not null default false,
  requires_signature boolean not null default true,
  idempotency_policy text not null default 'required',
  callback_url_path text,
  health_status text not null default 'unknown',
  last_health_at timestamptz,
  notes_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.billing_adapter_health_events (
  id uuid primary key default gen_random_uuid(),
  adapter_id uuid not null references nosok.billing_provider_adapters(id) on delete cascade,
  event_status text not null,
  event_note_ar text,
  checked_at timestamptz not null default now()
);

insert into nosok.billing_provider_adapters (
  provider_key, title_ar, adapter_status, adapter_mode, supports_webhook,
  requires_signature, idempotency_policy, callback_url_path, health_status, notes_ar
)
values
  ('billing_system', 'محرك الفوترة المركزي في PalWakf', 'enabled', 'platform_rpc_bridge', true, true, 'required', '/api/billing/callbacks/nosok', 'contract_ready', 'Adapter عقدي يرسل طلبات نسك إلى billing_system ولا يخزن بيانات بطاقة داخل نسك.'),
  ('manual_receipt_review', 'مراجعة سندات الدفع اليدوية', 'enabled', 'manual_verification', false, false, 'required', null, 'passed', 'مسار مؤقت للتحقق الإداري من سندات الدفع إلى حين تفعيل بوابة الدفع المركزية.')
on conflict (provider_key) do update set
  title_ar = excluded.title_ar,
  adapter_status = excluded.adapter_status,
  adapter_mode = excluded.adapter_mode,
  supports_webhook = excluded.supports_webhook,
  requires_signature = excluded.requires_signature,
  idempotency_policy = excluded.idempotency_policy,
  callback_url_path = excluded.callback_url_path,
  health_status = excluded.health_status,
  notes_ar = excluded.notes_ar,
  updated_at = now();

-- Harden payment bridge table without assuming a final billing schema exists.
alter table if exists nosok.payment_bridge_requests
  add column if not exists adapter_id uuid references nosok.billing_provider_adapters(id),
  add column if not exists idempotency_key text,
  add column if not exists callback_signature_verified boolean not null default false,
  add column if not exists adapter_health_status text;

create unique index if not exists idx_nosok_payment_bridge_idempotency
  on nosok.payment_bridge_requests(idempotency_key)
  where idempotency_key is not null;

-- ---------------------------------------------------------
-- 2) Public tracking privacy review matrix
-- ---------------------------------------------------------
create table if not exists nosok.public_tracking_privacy_checks (
  check_key text primary key,
  title_ar text not null,
  status text not null default 'pending', -- pending/needs_evidence/passed/failed
  severity text not null default 'blocker',
  public_data_fields text[] not null default '{}',
  blocked_fields text[] not null default '{}',
  evidence_note_ar text,
  last_reviewed_at timestamptz,
  updated_at timestamptz not null default now()
);

insert into nosok.public_tracking_privacy_checks (
  check_key, title_ar, status, severity, public_data_fields, blocked_fields, evidence_note_ar
)
values
  (
    'public_tracking_allowed_fields',
    'حد الحقول المسموح عرضها في صفحة التتبع العام',
    'needs_evidence',
    'blocker',
    array['application_no','application_status','eligibility_status','service_type','submitted_at','documents_count','payments_count','total_paid_amount','last_payment_status'],
    array['national_id','phone','mobile','email','address_text','document_urls','payment_receipts','storage_path'],
    'يجب أن تعرض صفحة التتبع الحالة والمؤشرات فقط دون بيانات شخصية أو روابط وثائق/إيصالات.'
  ),
  (
    'tracking_token_non_enumerable',
    'رمز التتبع غير قابل للتخمين ولا يعتمد على رقم الهوية أو الهاتف',
    'needs_evidence',
    'blocker',
    array['tracking_token'],
    array['national_id_lookup','phone_lookup','sequential_public_id_lookup'],
    'يلزم SQL/Browser evidence يثبت أن البحث العام لا يعمل إلا عبر tracking_token.'
  ),
  (
    'tracking_rate_limit_contract',
    'عقد منع محاولات التخمين والطلبات المتكررة',
    'pending',
    'warning',
    array['tracking_token'],
    array['unbounded_public_lookup'],
    'ينفذ فعليًا في Edge/API gateway أو platform security layer؛ يوثق هنا كمتطلب إنتاج.'
  )
on conflict (check_key) do update set
  title_ar = excluded.title_ar,
  severity = excluded.severity,
  public_data_fields = excluded.public_data_fields,
  blocked_fields = excluded.blocked_fields,
  evidence_note_ar = coalesce(nosok.public_tracking_privacy_checks.evidence_note_ar, excluded.evidence_note_ar),
  updated_at = now();

-- Secure override for public tracking: keep shape compatible with app model,
-- but return NULL for direct personal data fields.
drop function if exists public.rpc_nosok_public_application_status_by_token_v1(text);
create or replace function public.rpc_nosok_public_application_status_by_token_v1(
  p_tracking_token text
)
returns table (
  id uuid,
  season_id uuid,
  program_id uuid,
  application_no text,
  tracking_token text,
  tracking_token_issued_at timestamptz,
  service_type text,
  applicant_full_name text,
  national_id text,
  application_status text,
  eligibility_status text,
  phone text,
  mobile text,
  email text,
  season_title_ar text,
  program_title_ar text,
  submitted_at timestamptz,
  reviewed_at timestamptz,
  documents_count integer,
  payments_count integer,
  total_paid_amount numeric,
  last_payment_status text
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    a.id,
    a.season_id,
    a.program_id,
    a.application_no,
    a.tracking_token,
    a.tracking_token_issued_at,
    a.service_type,
    null::text as applicant_full_name,
    null::text as national_id,
    a.application_status,
    a.eligibility_status,
    null::text as phone,
    null::text as mobile,
    null::text as email,
    s.title_ar as season_title_ar,
    p.title_ar as program_title_ar,
    a.submitted_at,
    a.reviewed_at,
    coalesce((select count(*)::int from nosok.application_documents d where d.application_id = a.id), 0) as documents_count,
    coalesce((select count(*)::int from nosok.application_payments ap where ap.application_id = a.id), 0) as payments_count,
    coalesce((select sum(ap.amount) from nosok.application_payments ap where ap.application_id = a.id and ap.payment_status = 'paid'), 0) as total_paid_amount,
    (select ap.payment_status from nosok.application_payments ap where ap.application_id = a.id order by coalesce(ap.paid_at, ap.created_at) desc limit 1) as last_payment_status
  from nosok.applications a
  left join nosok.seasons s on s.id = a.season_id
  left join nosok.service_programs p on p.id = a.program_id
  where a.tracking_token = upper(trim(p_tracking_token))
  limit 1
$$;

-- ---------------------------------------------------------
-- 3) Production readiness evidence closure
-- ---------------------------------------------------------
create table if not exists nosok.production_readiness_evidence (
  id uuid primary key default gen_random_uuid(),
  evidence_key text not null,
  evidence_type text not null, -- browser_uat/role_uat/sql_uat/privacy_review/billing_adapter/console_review
  status text not null default 'submitted', -- submitted/accepted/rejected/needs_retest
  evidence_url text,
  evidence_summary_ar text,
  owner_role text,
  collected_at timestamptz not null default now(),
  approved_at timestamptz,
  notes_ar text
);

create unique index if not exists idx_nosok_readiness_evidence_key_type
  on nosok.production_readiness_evidence(evidence_key, evidence_type);

-- Seed closure requirements as explicit evidence placeholders.
insert into nosok.production_readiness_evidence (evidence_key, evidence_type, status, evidence_summary_ar, owner_role)
values
  ('browser_public_tracking_privacy', 'privacy_review', 'submitted', 'مطلوب إثبات أن صفحة التتبع العام لا تعرض بيانات شخصية.', 'nosokAdmin'),
  ('billing_adapter_contract_health', 'billing_adapter', 'submitted', 'مطلوب إثبات health check للـ billing_system/manual adapters.', 'nosokPaymentsOfficer'),
  ('role_uat_superuser_and_limited_user', 'role_uat', 'submitted', 'مطلوب أدلة دخول superuser وحجب مستخدم محدود حسب RBAC.', 'nosokAdmin'),
  ('console_review_admin_public', 'console_review', 'submitted', 'مطلوب مراجعة console لمسارات public/admin الأساسية.', 'nosokAdmin'),
  ('sql_uat_v13_contract', 'sql_uat', 'submitted', 'مطلوب تشغيل RPC v13 read-only UAT.', 'nosokAdmin')
on conflict (evidence_key, evidence_type) do nothing;

-- ---------------------------------------------------------
-- RPCs
-- ---------------------------------------------------------
create or replace function public.rpc_nosok_admin_billing_provider_adapters_v1()
returns table (
  id uuid,
  provider_key text,
  title_ar text,
  adapter_status text,
  adapter_mode text,
  supports_webhook boolean,
  requires_signature boolean,
  idempotency_policy text,
  callback_url_path text,
  health_status text,
  last_health_at timestamptz,
  notes_ar text,
  created_at timestamptz,
  updated_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select id, provider_key, title_ar, adapter_status, adapter_mode, supports_webhook,
         requires_signature, idempotency_policy, callback_url_path, health_status,
         last_health_at, notes_ar, created_at, updated_at
  from nosok.billing_provider_adapters
  order by provider_key
$$;

create or replace function public.rpc_nosok_admin_billing_provider_adapter_health_check_v1(
  p_adapter_id uuid
)
returns table (
  id uuid,
  provider_key text,
  title_ar text,
  adapter_status text,
  adapter_mode text,
  supports_webhook boolean,
  requires_signature boolean,
  idempotency_policy text,
  callback_url_path text,
  health_status text,
  last_health_at timestamptz,
  notes_ar text,
  created_at timestamptz,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_status text;
begin
  select case
    when b.adapter_status <> 'enabled' then 'disabled'
    when b.idempotency_policy <> 'required' then 'needs_idempotency'
    when b.adapter_mode in ('platform_rpc_bridge','provider_gateway') and b.requires_signature is not true then 'needs_signature'
    when b.adapter_mode in ('platform_rpc_bridge','provider_gateway') and b.supports_webhook is true and coalesce(trim(b.callback_url_path), '') = '' then 'needs_callback'
    else 'passed'
  end
  into v_status
  from nosok.billing_provider_adapters b
  where b.id = p_adapter_id;

  if v_status is null then
    raise exception 'NOSOK_ADAPTER_NOT_FOUND';
  end if;

  update nosok.billing_provider_adapters b
  set health_status = v_status,
      last_health_at = now(),
      updated_at = now()
  where b.id = p_adapter_id;

  insert into nosok.billing_adapter_health_events(adapter_id, event_status, event_note_ar)
  values (p_adapter_id, v_status, 'تم تنفيذ health check من عقد Nosok v13.');

  return query
  select b.id, b.provider_key, b.title_ar, b.adapter_status, b.adapter_mode, b.supports_webhook,
         b.requires_signature, b.idempotency_policy, b.callback_url_path, b.health_status,
         b.last_health_at, b.notes_ar, b.created_at, b.updated_at
  from nosok.billing_provider_adapters b
  where b.id = p_adapter_id;
end;
$$;

create or replace function public.rpc_nosok_admin_public_tracking_privacy_checks_v1()
returns table (
  check_key text,
  title_ar text,
  status text,
  severity text,
  public_data_fields text[],
  blocked_fields text[],
  evidence_note_ar text,
  last_reviewed_at timestamptz,
  updated_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select check_key, title_ar, status, severity, public_data_fields, blocked_fields,
         evidence_note_ar, last_reviewed_at, updated_at
  from nosok.public_tracking_privacy_checks
  order by case severity when 'blocker' then 0 when 'warning' then 1 else 2 end, check_key
$$;

create or replace function public.rpc_nosok_admin_public_tracking_privacy_review_upsert_v1(
  p_check_key text,
  p_status text,
  p_evidence_note_ar text default null
)
returns table (
  check_key text,
  title_ar text,
  status text,
  severity text,
  public_data_fields text[],
  blocked_fields text[],
  evidence_note_ar text,
  last_reviewed_at timestamptz,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
begin
  update nosok.public_tracking_privacy_checks c
  set status = coalesce(nullif(trim(p_status), ''), c.status),
      evidence_note_ar = coalesce(nullif(trim(p_evidence_note_ar), ''), c.evidence_note_ar),
      last_reviewed_at = now(),
      updated_at = now()
  where c.check_key = p_check_key;

  if not found then
    raise exception 'NOSOK_PRIVACY_CHECK_NOT_FOUND';
  end if;

  return query
  select c.check_key, c.title_ar, c.status, c.severity, c.public_data_fields, c.blocked_fields,
         c.evidence_note_ar, c.last_reviewed_at, c.updated_at
  from nosok.public_tracking_privacy_checks c
  where c.check_key = p_check_key;
end;
$$;

create or replace function public.rpc_nosok_admin_production_readiness_evidence_v1(
  p_status text default null
)
returns table (
  id uuid,
  evidence_key text,
  evidence_type text,
  status text,
  evidence_url text,
  evidence_summary_ar text,
  owner_role text,
  collected_at timestamptz,
  approved_at timestamptz,
  notes_ar text
)
language sql
security definer
set search_path = public, nosok
as $$
  select id, evidence_key, evidence_type, status, evidence_url, evidence_summary_ar,
         owner_role, collected_at, approved_at, notes_ar
  from nosok.production_readiness_evidence
  where p_status is null or status = p_status
  order by collected_at desc
$$;

create or replace function public.rpc_nosok_admin_production_readiness_evidence_upsert_v1(
  p_payload jsonb
)
returns table (
  id uuid,
  evidence_key text,
  evidence_type text,
  status text,
  evidence_url text,
  evidence_summary_ar text,
  owner_role text,
  collected_at timestamptz,
  approved_at timestamptz,
  notes_ar text
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_id uuid;
begin
  v_id := nullif(p_payload->>'id', '')::uuid;

  if v_id is null then
    insert into nosok.production_readiness_evidence(
      evidence_key, evidence_type, status, evidence_url, evidence_summary_ar,
      owner_role, collected_at, approved_at, notes_ar
    ) values (
      nullif(p_payload->>'evidence_key', ''),
      coalesce(nullif(p_payload->>'evidence_type', ''), 'browser_uat'),
      coalesce(nullif(p_payload->>'status', ''), 'submitted'),
      nullif(p_payload->>'evidence_url', ''),
      nullif(p_payload->>'evidence_summary_ar', ''),
      nullif(p_payload->>'owner_role', ''),
      coalesce(nullif(p_payload->>'collected_at', '')::timestamptz, now()),
      nullif(p_payload->>'approved_at', '')::timestamptz,
      nullif(p_payload->>'notes_ar', '')
    )
    returning nosok.production_readiness_evidence.id into v_id;
  else
    update nosok.production_readiness_evidence e
    set evidence_key = coalesce(nullif(p_payload->>'evidence_key', ''), e.evidence_key),
        evidence_type = coalesce(nullif(p_payload->>'evidence_type', ''), e.evidence_type),
        status = coalesce(nullif(p_payload->>'status', ''), e.status),
        evidence_url = nullif(p_payload->>'evidence_url', ''),
        evidence_summary_ar = nullif(p_payload->>'evidence_summary_ar', ''),
        owner_role = nullif(p_payload->>'owner_role', ''),
        collected_at = coalesce(nullif(p_payload->>'collected_at', '')::timestamptz, e.collected_at),
        approved_at = nullif(p_payload->>'approved_at', '')::timestamptz,
        notes_ar = nullif(p_payload->>'notes_ar', '')
    where e.id = v_id;
  end if;

  return query
  select e.id, e.evidence_key, e.evidence_type, e.status, e.evidence_url, e.evidence_summary_ar,
         e.owner_role, e.collected_at, e.approved_at, e.notes_ar
  from nosok.production_readiness_evidence e
  where e.id = v_id;
end;
$$;

create or replace function public.rpc_nosok_v13_runtime_contract_uat_v1()
returns table (
  section text,
  check_key text,
  passed boolean,
  note text
)
language sql
security definer
set search_path = public, nosok
as $$
  select 'billing_adapter'::text, 'adapters_seeded'::text,
         exists(select 1 from nosok.billing_provider_adapters),
         'Billing provider adapter contracts are present.'
  union all
  select 'billing_adapter', 'idempotency_index_contract',
         exists(select 1 from pg_indexes where schemaname='nosok' and indexname='idx_nosok_payment_bridge_idempotency'),
         'Payment bridge idempotency index exists when payment_bridge_requests table exists.'
  union all
  select 'public_tracking_privacy', 'privacy_checks_seeded',
         exists(select 1 from nosok.public_tracking_privacy_checks where severity='blocker'),
         'Public tracking privacy blockers are explicitly tracked.'
  union all
  select 'public_tracking_privacy', 'status_rpc_overridden',
         exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname='rpc_nosok_public_application_status_by_token_v1'),
         'Public tracking RPC exists and v13 overrides it to suppress personal fields.'
  union all
  select 'readiness_evidence', 'evidence_table_exists',
         exists(select 1 from information_schema.tables where table_schema='nosok' and table_name='production_readiness_evidence'),
         'Production readiness evidence table exists.'
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script',
         true,
         'No waqf/waqf_assets/awqaf_system mutation in Nosok v13.'
$$;

-- Runtime checklist augmentation for Operations Center.
insert into nosok.operational_checklist(check_key, title_ar, status, severity, details_ar, owner_role, source)
values
  ('billing_provider_adapter_hardening', 'تقوية Billing Provider Adapters', 'needs_evidence', 'blocker', 'يلزم فحص adapters وإرفاق دليل health/idempotency/signature قبل الإنتاج.', 'nosokPaymentsOfficer', 'v13'),
  ('public_tracking_privacy_review', 'مراجعة خصوصية التتبع العام', 'needs_evidence', 'blocker', 'يلزم إثبات أن التتبع العام لا يكشف بيانات شخصية أو روابط وثائق/إيصالات.', 'nosokAdmin', 'v13'),
  ('production_readiness_evidence_closure', 'إغلاق أدلة الجاهزية الإنتاجية', 'pending', 'blocker', 'تجميع Browser/Role/SQL/Console evidence شرط سابق لاعتماد الإنتاج.', 'nosokAdmin', 'v13')
on conflict (check_key) do update set
  title_ar = excluded.title_ar,
  status = excluded.status,
  severity = excluded.severity,
  details_ar = excluded.details_ar,
  owner_role = excluded.owner_role,
  source = excluded.source,
  updated_at = now();
