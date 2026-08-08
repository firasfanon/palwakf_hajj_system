-- Nosok v21 — Real Platform Merge Pack + RBAC Provider Override + SQL UAT Result Intake
-- Scope: nosok schema + public RPC wrappers only. No waqf/waqf_assets/awqaf_system mutation.

create schema if not exists nosok;

create table if not exists nosok.platform_merge_readiness_register (
  id uuid primary key default gen_random_uuid(),
  merge_area text not null unique,
  contract_key text not null,
  status text not null default 'pending',
  required_action_ar text,
  evidence_url text,
  notes_ar text,
  updated_at timestamptz not null default now()
);

create table if not exists nosok.rbac_provider_override_contracts (
  id uuid primary key default gen_random_uuid(),
  contract_key text not null unique,
  platform_source text not null,
  nosok_target text not null,
  fail_mode text not null default 'fail_closed',
  status text not null default 'pending',
  notes_ar text,
  updated_at timestamptz not null default now()
);

create table if not exists nosok.sql_uat_result_intake (
  id uuid primary key default gen_random_uuid(),
  uat_key text not null unique,
  uat_status text not null default 'pending',
  summary_ar text,
  evidence_url text,
  executed_by uuid,
  executed_at timestamptz default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into nosok.platform_merge_readiness_register (merge_area, contract_key, status, required_action_ar, notes_ar)
values
  ('routing', 'nosok_routes_group', 'ready', 'تسجيل NosokRoutes.publicRoutes و NosokRoutes.adminRoutes داخل route groups الفعلية في PalWakf.', 'لا يتم استخدام /nosok المباشر؛ الدخول عبر /switch/nosok و /systems/nosok.'),
  ('rbac', 'nosok_access_profile_override', 'ready', 'ربط nosokAccessProfileProvider بمصدر AccessProfile الحقيقي في المنصة.', 'الافتراضي fail-closed ولا يسمح بالوصول دون override.'),
  ('dynamic_registry', 'nosok_system_registry', 'ready', 'تسجيل system_key=nosok في Dynamic System Registry.', 'system_type=semi_independent_service_system.'),
  ('system_sections', 'nosok_system_sections', 'ready', 'تسجيل أقسام السايدبار والدashboard في platform.system_sections.', 'الظهور النهائي محكوم بالصلاحيات.'),
  ('billing_bridge', 'nosok_billing_bridge_to_billing_system', 'pending_uat', 'تشغيل UAT لجسر الدفع وربطه بـ billing_system.', 'لا تخزين لأسرار أو بطاقات داخل نسك.'),
  ('notification_bridge', 'nosok_notification_bridge_to_platform_notifications', 'pending_uat', 'تشغيل UAT لمزودات الإشعارات المركزية.', 'نسك يجهز queue فقط.'),
  ('sql_uat', 'nosok_v21_sql_uat', 'pending', 'تشغيل rpc_nosok_v21_runtime_contract_uat_v1 وتوثيق النتيجة.', 'شرط قبل production decision.')
on conflict (merge_area) do update set
  contract_key = excluded.contract_key,
  required_action_ar = excluded.required_action_ar,
  notes_ar = excluded.notes_ar,
  updated_at = now();

insert into nosok.rbac_provider_override_contracts (contract_key, platform_source, nosok_target, fail_mode, status, notes_ar)
values
  ('authenticated', 'AccessProfile.isAuthenticated', 'NosokAccessProfile.isAuthenticated', 'fail_closed', 'ready', 'أي قيمة null أو غياب profile تعني deny.'),
  ('superuser', 'AccessProfile.isSuperuser OR platformAdmin override', 'NosokAccessProfile.isSuperuser', 'fail_closed', 'ready', 'السوبر يوزر لا يحتاج system role محلي داخل نسك.'),
  ('permissions', 'platform permission assignments', 'NosokAccessProfile.permissionKeys', 'fail_closed', 'ready', 'تستخدم مفاتيح NosokPermissionKeys كما هي.'),
  ('roles', 'platform role assignments', 'NosokAccessProfile.roleKeys', 'fail_closed', 'ready', 'الأدوار قوالب تشغيلية لا جداول مستخدمين داخل نسك.'),
  ('units', 'user_scope_assignments/core.org_units', 'NosokAccessProfile.unitIds/unitSlugs', 'fail_closed', 'ready', 'الوحدات من core.org_units فقط.'),
  ('source', 'PalWakf runtime provider', 'NosokAccessProfile.source=palwakf', 'fail_closed', 'ready', 'تمييز binding الحقيقي عن standalone-preview.')
on conflict (contract_key) do update set
  platform_source = excluded.platform_source,
  nosok_target = excluded.nosok_target,
  fail_mode = excluded.fail_mode,
  status = excluded.status,
  notes_ar = excluded.notes_ar,
  updated_at = now();

create or replace function public.rpc_nosok_v21_platform_merge_readiness_v1()
returns table(
  merge_area text,
  contract_key text,
  status text,
  required_action_ar text,
  evidence_url text,
  notes_ar text
)
language sql
security definer
set search_path = nosok, public
as $$
  select r.merge_area, r.contract_key, r.status, r.required_action_ar, r.evidence_url, r.notes_ar
  from nosok.platform_merge_readiness_register r
  order by r.merge_area;
$$;

create or replace function public.rpc_nosok_v21_rbac_override_contract_v1()
returns table(
  contract_key text,
  platform_source text,
  nosok_target text,
  fail_mode text,
  status text,
  notes_ar text
)
language sql
security definer
set search_path = nosok, public
as $$
  select c.contract_key, c.platform_source, c.nosok_target, c.fail_mode, c.status, c.notes_ar
  from nosok.rbac_provider_override_contracts c
  order by c.contract_key;
$$;

create or replace function public.rpc_nosok_v21_sql_uat_result_intake_v1(
  p_uat_key text default 'nosok_v21_runtime_contract',
  p_uat_status text default 'pending',
  p_summary_ar text default null,
  p_evidence_url text default null
)
returns table(
  uat_key text,
  uat_status text,
  summary_ar text,
  evidence_url text,
  executed_at timestamptz
)
language plpgsql
security definer
set search_path = nosok, public
as $$
begin
  insert into nosok.sql_uat_result_intake (uat_key, uat_status, summary_ar, evidence_url, executed_at)
  values (p_uat_key, p_uat_status, p_summary_ar, p_evidence_url, now())
  on conflict (uat_key) do update set
    uat_status = excluded.uat_status,
    summary_ar = excluded.summary_ar,
    evidence_url = excluded.evidence_url,
    executed_at = now(),
    updated_at = now();

  return query
  select i.uat_key, i.uat_status, i.summary_ar, i.evidence_url, i.executed_at
  from nosok.sql_uat_result_intake i
  where i.uat_key = p_uat_key;
end;
$$;

create or replace function public.rpc_nosok_v21_runtime_contract_uat_v1()
returns table(
  section text,
  check_key text,
  passed boolean,
  note text
)
language sql
security definer
set search_path = nosok, public
as $$
  select 'schema'::text, 'nosok_schema_exists'::text, exists(select 1 from information_schema.schemata where schema_name='nosok'), 'nosok schema must exist.'::text
  union all
  select 'merge_tables', 'platform_merge_readiness_register_exists', to_regclass('nosok.platform_merge_readiness_register') is not null, 'Merge readiness register table exists.'
  union all
  select 'merge_tables', 'rbac_provider_override_contracts_exists', to_regclass('nosok.rbac_provider_override_contracts') is not null, 'RBAC override contract table exists.'
  union all
  select 'merge_tables', 'sql_uat_result_intake_exists', to_regclass('nosok.sql_uat_result_intake') is not null, 'SQL UAT intake table exists.'
  union all
  select 'merge_seed', 'merge_readiness_seeded', (select count(*) >= 7 from nosok.platform_merge_readiness_register), 'Minimum merge readiness contracts are seeded.'
  union all
  select 'merge_seed', 'rbac_override_seeded', (select count(*) >= 6 from nosok.rbac_provider_override_contracts), 'Minimum RBAC override contracts are seeded.'
  union all
  select 'rpc', 'platform_merge_readiness_rpc_exists', to_regprocedure('public.rpc_nosok_v21_platform_merge_readiness_v1()') is not null, 'Merge readiness RPC exists.'
  union all
  select 'rpc', 'rbac_override_contract_rpc_exists', to_regprocedure('public.rpc_nosok_v21_rbac_override_contract_v1()') is not null, 'RBAC override contract RPC exists.'
  union all
  select 'rpc', 'sql_uat_intake_rpc_exists', to_regprocedure('public.rpc_nosok_v21_sql_uat_result_intake_v1(text,text,text,text)') is not null, 'SQL UAT intake RPC exists.'
  union all
  select 'sovereign_boundary', 'no_waqf_assets_mutation_in_this_script', true, 'This script does not mutate waqf, waqf_assets, or awqaf_system.';
$$;
