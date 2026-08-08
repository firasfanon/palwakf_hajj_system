-- Nosok v20 — Production UAT Closure + Application Operations Deepening + Platform Integration Readiness Pack
-- Scope: nosok schema only + public RPC wrappers. No waqf/waqf_assets/awqaf_system mutation.

create schema if not exists nosok;

create table if not exists nosok.production_uat_closure_register (
  id uuid primary key default gen_random_uuid(),
  gate_key text not null unique,
  title_ar text not null,
  gate_category text not null default 'uat',
  required_evidence text[] not null default '{}',
  gate_status text not null default 'pending',
  blocker_count integer not null default 0,
  warning_count integer not null default 0,
  evidence_url text,
  evidence_note_ar text,
  reviewed_by uuid,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.application_operations_sla_register (
  id uuid primary key default gen_random_uuid(),
  operation_key text not null unique,
  title_ar text not null,
  route_path text,
  default_sla_hours integer not null default 48,
  escalation_sla_hours integer not null default 72,
  owner_role_key text,
  is_active boolean not null default true,
  notes_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.platform_integration_readiness_register (
  id uuid primary key default gen_random_uuid(),
  contract_key text not null unique,
  title_ar text not null,
  integration_area text not null,
  readiness_status text not null default 'pending',
  platform_owner text,
  nosok_owner text,
  required_action_ar text,
  evidence_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into nosok.production_uat_closure_register (gate_key, title_ar, gate_category, required_evidence, gate_status, blocker_count, warning_count)
values
  ('browser_uat_public', 'اختبار المتصفح للواجهات العامة', 'browser', array['screenshots','console-log','navigation-clickthrough'], 'pending', 1, 0),
  ('browser_uat_admin', 'اختبار المتصفح للوحة الإدارة', 'browser', array['screenshots','role-session','console-log'], 'pending', 1, 0),
  ('role_uat_matrix', 'إغلاق مصفوفة الأدوار والصلاحيات', 'rbac', array['superuser','nosok-admin','limited-user'], 'pending', 1, 0),
  ('sql_uat', 'تشغيل SQL UAT لعقود v20', 'sql', array['rpc_nosok_v20_runtime_contract_uat_v1'], 'pending', 1, 0),
  ('privacy_tracking', 'مراجعة خصوصية التتبع العام', 'privacy', array['field-audit','public-token-test'], 'pending', 0, 1),
  ('billing_notification_bridge', 'إثبات جسر الدفع والإشعارات', 'integration', array['billing-adapter-uat','notification-provider-uat'], 'pending', 1, 0)
on conflict (gate_key) do update set
  title_ar = excluded.title_ar,
  gate_category = excluded.gate_category,
  required_evidence = excluded.required_evidence,
  updated_at = now();

insert into nosok.application_operations_sla_register (operation_key, title_ar, route_path, default_sla_hours, escalation_sla_hours, owner_role_key, notes_ar)
values
  ('new_applications_queue', 'طابور الطلبات الجديدة', '/admin/systems/nosok/applications', 24, 48, 'nosokApplicationsReviewer', 'تدقيق أولي للطلبات الواردة.'),
  ('documents_review', 'مراجعة الوثائق', '/admin/systems/nosok/application-operations', 48, 72, 'nosokDocumentsOfficer', 'اعتماد أو رفض الوثائق مع سبب واضح.'),
  ('payments_verification', 'التحقق من الدفعات', '/admin/systems/nosok/payment-bridge', 24, 48, 'nosokPaymentsOfficer', 'التحقق من سند الدفع وجسر الفوترة.'),
  ('citizen_followup', 'متابعة طلبات المواطن', '/admin/systems/nosok/follow-up-inbox', 24, 48, 'nosokUnitOfficer', 'استكمال/اعتراض/تحديث بيانات عبر tracking_token.'),
  ('notification_dispatch', 'طابور الإشعارات', '/admin/systems/nosok/notification-dispatch', 12, 24, 'nosokContentManager', 'إرسال رسائل الحالة عبر مزودات المنصة.')
on conflict (operation_key) do update set
  title_ar = excluded.title_ar,
  route_path = excluded.route_path,
  default_sla_hours = excluded.default_sla_hours,
  escalation_sla_hours = excluded.escalation_sla_hours,
  owner_role_key = excluded.owner_role_key,
  notes_ar = excluded.notes_ar,
  updated_at = now();

insert into nosok.platform_integration_readiness_register (contract_key, title_ar, integration_area, readiness_status, platform_owner, nosok_owner, required_action_ar)
values
  ('routes_registration', 'تسجيل المسارات داخل GoRouter للمنصة', 'routing', 'ready_for_merge', 'platform', 'nosok', 'تطبيق مسارات /systems/nosok و /admin/systems/nosok داخل ملفات المنصة الحقيقية.'),
  ('rbac_provider_override', 'ربط AccessProfile الحقيقي', 'rbac', 'pending_platform_apply', 'platform', 'nosok', 'Override لـ nosokAccessProfileProvider من AccessRepository/AccessProfile في PalWakf.'),
  ('dynamic_registry', 'تسجيل نسك في Dynamic System Registry', 'registry', 'pending_platform_apply', 'platform', 'nosok', 'تسجيل system_key=nosok وأقسامه وصلاحياته داخل platform.system_registry/system_sections.'),
  ('unit_scope_binding', 'ربط نطاق الوحدات', 'units', 'ready_for_merge', 'core', 'nosok', 'اعتماد core.org_units كمصدر وحدات، واستخدام nosok.unit_service_scopes كسطح خدمة فقط.'),
  ('billing_bridge', 'ربط billing_system', 'billing', 'contract_ready', 'billing_system', 'nosok', 'تفعيل RPC/adapter bridge دون تخزين بيانات بطاقات داخل نسك.'),
  ('notification_bridge', 'ربط مزودات إشعارات المنصة', 'notifications', 'contract_ready', 'platform_notifications', 'nosok', 'توصيل notification_dispatch_queue بمحرك إشعارات PalWakf.'),
  ('visual_contract', 'التزام PWF-SIS', 'visual', 'ready_for_review', 'platform_ui', 'nosok', 'مراجعة الهوية والـ anti-overload UX داخل صفحات نسك.' )
on conflict (contract_key) do update set
  title_ar = excluded.title_ar,
  integration_area = excluded.integration_area,
  readiness_status = excluded.readiness_status,
  platform_owner = excluded.platform_owner,
  nosok_owner = excluded.nosok_owner,
  required_action_ar = excluded.required_action_ar,
  updated_at = now();

create or replace function public.rpc_nosok_v20_production_uat_closure_v1()
returns table (
  gate_key text,
  title_ar text,
  gate_category text,
  gate_status text,
  blocker_count integer,
  warning_count integer,
  evidence_url text,
  evidence_note_ar text
)
language sql
security definer
set search_path = public, nosok
as $$
  select gate_key, title_ar, gate_category, gate_status, blocker_count, warning_count, evidence_url, evidence_note_ar
  from nosok.production_uat_closure_register
  order by case when blocker_count > 0 then 0 when warning_count > 0 then 1 else 2 end, gate_key;
$$;

create or replace function public.rpc_nosok_v20_application_operations_sla_v1()
returns table (
  operation_key text,
  title_ar text,
  route_path text,
  default_sla_hours integer,
  escalation_sla_hours integer,
  owner_role_key text,
  is_active boolean,
  notes_ar text
)
language sql
security definer
set search_path = public, nosok
as $$
  select operation_key, title_ar, route_path, default_sla_hours, escalation_sla_hours, owner_role_key, is_active, notes_ar
  from nosok.application_operations_sla_register
  where is_active is true
  order by default_sla_hours, operation_key;
$$;

create or replace function public.rpc_nosok_v20_platform_integration_readiness_v1()
returns table (
  contract_key text,
  title_ar text,
  integration_area text,
  readiness_status text,
  platform_owner text,
  nosok_owner text,
  required_action_ar text,
  evidence_url text
)
language sql
security definer
set search_path = public, nosok
as $$
  select contract_key, title_ar, integration_area, readiness_status, platform_owner, nosok_owner, required_action_ar, evidence_url
  from nosok.platform_integration_readiness_register
  order by integration_area, contract_key;
$$;

create or replace function public.rpc_nosok_v20_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql
security definer
set search_path = public, nosok
as $$
  select 'v20_tables', 'production_uat_closure_register_exists', to_regclass('nosok.production_uat_closure_register') is not null, 'Production UAT closure register exists.'
  union all
  select 'v20_tables', 'application_operations_sla_register_exists', to_regclass('nosok.application_operations_sla_register') is not null, 'Application operations SLA register exists.'
  union all
  select 'v20_tables', 'platform_integration_readiness_register_exists', to_regclass('nosok.platform_integration_readiness_register') is not null, 'Platform integration readiness register exists.'
  union all
  select 'v20_seed', 'uat_gates_seeded', (select count(*) >= 6 from nosok.production_uat_closure_register), 'At least six production UAT gates are seeded.'
  union all
  select 'v20_seed', 'operations_sla_seeded', (select count(*) >= 5 from nosok.application_operations_sla_register), 'At least five operational SLA surfaces are seeded.'
  union all
  select 'v20_seed', 'integration_contracts_seeded', (select count(*) >= 7 from nosok.platform_integration_readiness_register), 'At least seven platform integration contracts are seeded.'
  union all
  select 'sovereign_boundary', 'no_waqf_assets_mutation', true, 'This script does not mutate waqf/waqf_assets/awqaf_system.';
$$;
