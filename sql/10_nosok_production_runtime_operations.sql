-- Nosok v11 — Production Runtime Operations
-- Scope: nosok schema only + public RPC wrappers. No waqf_assets mutation.

create schema if not exists nosok;
create extension if not exists pgcrypto;

create table if not exists nosok.operational_checklist (
  check_key text primary key,
  title_ar text not null,
  status text not null default 'pending',
  severity text not null default 'info',
  details_ar text,
  owner_role text,
  source text default 'nosok_v11',
  due_at timestamptz,
  updated_at timestamptz not null default now()
);

create table if not exists nosok.payment_bridge_requests (
  id uuid primary key default gen_random_uuid(),
  application_id uuid not null,
  payment_id uuid,
  amount numeric(14,2),
  currency_code text not null default 'ILS',
  bridge_status text not null default 'draft',
  billing_reference text,
  provider_reference text,
  payment_method text,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_nosok_payment_bridge_application on nosok.payment_bridge_requests(application_id);
create index if not exists idx_nosok_payment_bridge_status on nosok.payment_bridge_requests(bridge_status);

create table if not exists nosok.role_uat_matrix (
  id uuid primary key default gen_random_uuid(),
  role_key text not null,
  surface_key text not null,
  expected_access text not null,
  actual_access text,
  status text not null default 'pending',
  notes_ar text,
  last_tested_at timestamptz,
  unique(role_key, surface_key)
);

create table if not exists nosok.notification_templates (
  id uuid primary key default gen_random_uuid(),
  template_key text not null unique,
  channel text not null default 'in_app',
  title_ar text not null,
  body_ar text not null,
  trigger_event text,
  is_active boolean not null default true,
  notes_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

insert into nosok.operational_checklist(check_key, title_ar, status, severity, details_ar, owner_role)
values
('schema_runtime', 'سكيما نسك التشغيلية مثبتة', 'passed', 'info', 'جداول v11 التشغيلية جاهزة.', 'nosokAdmin'),
('application_workflow', 'مسار الطلبات والوثائق والدفعات قابل للتشغيل', 'contract_ready', 'warning', 'يلزم Browser UAT كامل قبل الإنتاج.', 'nosokApplicationsReviewer'),
('billing_bridge', 'جسر billing_system جاهز كعقد تكامل', 'contract_ready', 'warning', 'يلزم ربط محرك الدفع المركزي في PalWakf.', 'nosokPaymentsOfficer'),
('role_uat', 'مصفوفة Role UAT جاهزة', 'pending_browser_evidence', 'warning', 'يلزم اختبار أدوار فعلية.', 'platformAdmin'),
('no_waq_assets_mutation', 'عدم لمس waqf_assets', 'passed', 'info', 'ملف v11 لا ينفذ أي DDL/DML على waqf أو waqf_assets.', 'platformAdmin')
on conflict (check_key) do update set
  title_ar = excluded.title_ar,
  status = excluded.status,
  severity = excluded.severity,
  details_ar = excluded.details_ar,
  owner_role = excluded.owner_role,
  updated_at = now();

insert into nosok.role_uat_matrix(role_key, surface_key, expected_access, status, notes_ar)
values
('superuser', 'admin_dashboard', 'allow', 'pending', 'يجب أن يرى لوحة نسك وكل المسارات الإدارية.'),
('nosokViewer', 'payment_bridge', 'deny', 'pending', 'المطلع لا يدير الدفع.'),
('nosokPaymentsOfficer', 'payment_bridge', 'allow_limited', 'pending', 'يرى جسر الدفع ولا يدير المواسم.'),
('nosokApplicationsReviewer', 'applications_detail', 'allow_limited', 'pending', 'يراجع الطلبات والوثائق دون إعدادات النظام.'),
('nosokUnitOfficer', 'unit_scoped_applications', 'allow_scoped', 'pending', 'يُقيّد لاحقًا بـ unitIds/unitSlugs من AccessProfile.')
on conflict(role_key, surface_key) do update set
  expected_access = excluded.expected_access,
  status = excluded.status,
  notes_ar = excluded.notes_ar;

insert into nosok.notification_templates(template_key, channel, title_ar, body_ar, trigger_event, notes_ar)
values
('application_submitted', 'in_app', 'تم استلام طلبك', 'تم استلام طلب نسك الخاص بك. احتفظ برمز التتبع.', 'submit', 'لا يرسل SMS/Email قبل ربط خدمة الإشعارات المركزية.'),
('payment_verified', 'in_app', 'تم اعتماد الدفعة', 'تم اعتماد دفعة مرتبطة بطلب نسك.', 'payment_verified', 'قالب تشغيل أولي.'),
('document_rejected', 'in_app', 'وثيقة تحتاج متابعة', 'يرجى مراجعة وثائق الطلب واستكمال المطلوب.', 'document_rejected', 'قالب تشغيل أولي.'),
('application_requires_followup', 'in_app', 'مطلوب استكمال', 'يرجى مراجعة حالة طلبك واستكمال المطلوب.', 'needs_action', 'قالب تشغيل أولي.')
on conflict(template_key) do update set
  channel = excluded.channel,
  title_ar = excluded.title_ar,
  body_ar = excluded.body_ar,
  trigger_event = excluded.trigger_event,
  notes_ar = excluded.notes_ar,
  updated_at = now();

create or replace function public.rpc_nosok_admin_operational_readiness_v1()
returns table(
  check_key text,
  title_ar text,
  status text,
  severity text,
  details_ar text,
  owner_role text,
  source text,
  due_at timestamptz,
  updated_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select check_key, title_ar, status, severity, details_ar, owner_role, source, due_at, updated_at
  from nosok.operational_checklist
  order by case severity when 'blocker' then 0 when 'warning' then 1 else 2 end, check_key;
$$;

create or replace function public.rpc_nosok_admin_payment_bridge_requests_v1()
returns table(
  id uuid,
  application_id uuid,
  application_no text,
  payment_id uuid,
  amount numeric,
  currency_code text,
  bridge_status text,
  billing_reference text,
  provider_reference text,
  payment_method text,
  notes text,
  created_at timestamptz,
  updated_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select
    pbr.id,
    pbr.application_id,
    a.application_no,
    pbr.payment_id,
    pbr.amount,
    pbr.currency_code,
    pbr.bridge_status,
    pbr.billing_reference,
    pbr.provider_reference,
    pbr.payment_method,
    pbr.notes,
    pbr.created_at,
    pbr.updated_at
  from nosok.payment_bridge_requests pbr
  left join nosok.applications a on a.id = pbr.application_id
  order by pbr.created_at desc;
$$;

create or replace function public.rpc_nosok_admin_payment_bridge_request_create_v1(
  p_application_id uuid,
  p_payment_id uuid default null,
  p_amount numeric default null,
  p_currency_code text default 'ILS',
  p_payment_method text default null,
  p_notes text default null
)
returns table(
  id uuid,
  application_id uuid,
  application_no text,
  payment_id uuid,
  amount numeric,
  currency_code text,
  bridge_status text,
  billing_reference text,
  provider_reference text,
  payment_method text,
  notes text,
  created_at timestamptz,
  updated_at timestamptz
)
language plpgsql
security definer
set search_path = public, nosok
as $$
declare
  v_id uuid;
begin
  insert into nosok.payment_bridge_requests(application_id, payment_id, amount, currency_code, payment_method, notes)
  values(p_application_id, p_payment_id, p_amount, coalesce(nullif(p_currency_code,''), 'ILS'), p_payment_method, p_notes)
  returning payment_bridge_requests.id into v_id;

  return query
  select * from public.rpc_nosok_admin_payment_bridge_requests_v1() where rpc_nosok_admin_payment_bridge_requests_v1.id = v_id;
end;
$$;

create or replace function public.rpc_nosok_admin_role_uat_matrix_v1()
returns table(
  id uuid,
  role_key text,
  surface_key text,
  expected_access text,
  actual_access text,
  status text,
  notes_ar text,
  last_tested_at timestamptz
)
language sql
security definer
set search_path = public, nosok
as $$
  select id, role_key, surface_key, expected_access, actual_access, status, notes_ar, last_tested_at
  from nosok.role_uat_matrix
  order by role_key, surface_key;
$$;

create or replace function public.rpc_nosok_admin_notification_templates_v1()
returns table(
  id uuid,
  template_key text,
  channel text,
  title_ar text,
  body_ar text,
  trigger_event text,
  is_active boolean,
  notes_ar text
)
language sql
security definer
set search_path = public, nosok
as $$
  select id, template_key, channel, title_ar, body_ar, trigger_event, is_active, notes_ar
  from nosok.notification_templates
  order by template_key;
$$;

create or replace function public.rpc_nosok_v11_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql
security definer
set search_path = public, nosok
as $$
  select 'nosok_v11'::text, 'operational_checklist_exists'::text, to_regclass('nosok.operational_checklist') is not null, 'Production runtime checklist table exists.'
  union all select 'nosok_v11', 'payment_bridge_exists', to_regclass('nosok.payment_bridge_requests') is not null, 'Billing/payment bridge requests table exists.'
  union all select 'nosok_v11', 'role_uat_matrix_exists', to_regclass('nosok.role_uat_matrix') is not null, 'Role UAT matrix table exists.'
  union all select 'nosok_v11', 'notification_templates_exists', to_regclass('nosok.notification_templates') is not null, 'Notification templates table exists.'
  union all select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script', true, 'This script is nosok/public RPC only; no waqf_assets mutation.';
$$;

notify pgrst, 'reload schema';
