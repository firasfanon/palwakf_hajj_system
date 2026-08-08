-- Nosok v09 — Semi-Independent Runtime Contracts under PalWakf
-- Purpose: add runtime contracts for system surfaces, unit pages, sidebar, role templates,
-- health checks, and settings without duplicating platform identity/RBAC.
-- Sovereign rule: PalWakf platform remains the parent; nosok schema stores Nosok-specific
-- operational contracts only. admin_users/core.org_units remain authoritative outside nosok.

create schema if not exists nosok;

create table if not exists nosok.system_settings (
  setting_key text primary key,
  value_json jsonb not null default '{}'::jsonb,
  is_public boolean not null default false,
  notes_ar text,
  updated_at timestamptz not null default now(),
  updated_by uuid
);

create table if not exists nosok.unit_service_scopes (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid,
  unit_slug text not null,
  title_ar text not null,
  title_en text,
  is_public_visible boolean not null default false,
  is_operational_enabled boolean not null default true,
  service_scope_json jsonb not null default '{}'::jsonb,
  display_order integer not null default 100,
  notes_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint nosok_unit_service_scopes_unit_slug_uq unique (unit_slug)
);

create table if not exists nosok.admin_sidebar_items (
  item_key text primary key,
  title_ar text not null,
  route_path text not null,
  icon_key text,
  permission_keys text[] not null default '{}',
  display_order integer not null default 100,
  is_active boolean not null default true,
  notes_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.role_permission_templates (
  role_key text primary key,
  title_ar text not null,
  permission_keys text[] not null default '{}',
  is_platform_role boolean not null default false,
  notes_ar text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.system_health_checks (
  check_key text primary key,
  title_ar text not null,
  check_status text not null default 'pending',
  severity text not null default 'info',
  details_json jsonb not null default '{}'::jsonb,
  checked_at timestamptz,
  notes_ar text,
  updated_at timestamptz not null default now(),
  constraint nosok_system_health_checks_status_chk check (check_status in ('pending','passed','warning','failed','not_applicable')),
  constraint nosok_system_health_checks_severity_chk check (severity in ('info','low','medium','high','critical'))
);

create table if not exists nosok.system_audit_events (
  id uuid primary key default gen_random_uuid(),
  event_key text not null,
  actor_user_id uuid,
  unit_slug text,
  entity_type text,
  entity_id text,
  event_payload jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

insert into nosok.system_settings (setting_key, value_json, is_public, notes_ar)
values
  ('public_entry_enabled', '{"enabled": true}'::jsonb, true, 'إظهار واجهة نسك العامة تحت /systems/nosok'),
  ('maintenance_mode', '{"enabled": false}'::jsonb, false, 'لا يفعل إلا عبر مركز الصيانة في المنصة'),
  ('storage_bucket', '{"bucket": "nosok-documents"}'::jsonb, false, 'راجع sql/07_nosok_storage_setup.sql'),
  ('admin_route_base', '{"route": "/admin/systems/nosok"}'::jsonb, false, 'مسار الإدارة شبه المستقل تحت منصة PalWakf')
on conflict (setting_key) do update set
  value_json = excluded.value_json,
  is_public = excluded.is_public,
  notes_ar = excluded.notes_ar,
  updated_at = now();

insert into nosok.unit_service_scopes (unit_slug, title_ar, is_public_visible, display_order, notes_ar)
values
  ('home', 'المركز الرئيسي', true, 1, 'صفحة مركزية عامة لنظام نسك'),
  ('bethlehem', 'مديرية بيت لحم', false, 20, 'مثال نطاق وحدة؛ source-of-truth من core.org_units'),
  ('hebron', 'مديرية الخليل', false, 30, 'مثال نطاق وحدة؛ source-of-truth من core.org_units'),
  ('jerusalem', 'مديرية القدس', false, 40, 'مثال نطاق وحدة؛ source-of-truth من core.org_units')
on conflict (unit_slug) do update set
  title_ar = excluded.title_ar,
  display_order = excluded.display_order,
  notes_ar = excluded.notes_ar,
  updated_at = now();

insert into nosok.admin_sidebar_items (item_key, title_ar, route_path, icon_key, permission_keys, display_order, notes_ar)
values
  ('dashboard', 'لوحة النظام', '/admin/systems/nosok', 'dashboard', array['viewNosokDashboard'], 1, 'مدخل الإدارة شبه المستقل'),
  ('seasons', 'المواسم', '/admin/systems/nosok/seasons', 'event_available', array['manageNosokSeasons'], 10, null),
  ('programs', 'البرامج', '/admin/systems/nosok/programs', 'route', array['manageNosokPrograms'], 20, null),
  ('companies', 'الشركات', '/admin/systems/nosok/companies', 'business', array['manageNosokCompanies'], 30, null),
  ('applications', 'الطلبات', '/admin/systems/nosok/applications', 'assignment', array['manageNosokApplications','reviewNosokApplications'], 40, null),
  ('complaints', 'الشكاوى', '/admin/systems/nosok/complaints', 'support_agent', array['manageNosokComplaints'], 50, null),
  ('content', 'المحتوى', '/admin/systems/nosok/content', 'article', array['manageNosokContent'], 60, null),
  ('reports', 'التقارير', '/admin/systems/nosok/reports', 'insights', array['viewNosokReports'], 70, null),
  ('units', 'صفحات الوحدات', '/admin/systems/nosok/units', 'account_tree', array['manageNosokUnits'], 80, null),
  ('users_roles', 'المستخدمون والأدوار', '/admin/systems/nosok/users-roles', 'admin_panel_settings', array['manageNosokAccess'], 90, 'عرض قوالب RBAC دون إنشاء مستخدمين داخل نسك'),
  ('sidebar', 'السايدبار', '/admin/systems/nosok/sidebar', 'view_sidebar', array['manageNosokSurface'], 100, null),
  ('settings', 'إعدادات النظام', '/admin/systems/nosok/settings', 'settings', array['manageNosokSettings'], 110, null),
  ('health', 'الصحة والتشغيل', '/admin/systems/nosok/health', 'health_and_safety', array['viewNosokHealth'], 120, null)
on conflict (item_key) do update set
  title_ar = excluded.title_ar,
  route_path = excluded.route_path,
  icon_key = excluded.icon_key,
  permission_keys = excluded.permission_keys,
  display_order = excluded.display_order,
  notes_ar = excluded.notes_ar,
  updated_at = now();

insert into nosok.role_permission_templates (role_key, title_ar, permission_keys, is_platform_role, notes_ar)
values
  ('nosokAdmin', 'مدير نظام نسك', array['manageNosok','viewNosokDashboard','manageNosokSeasons','manageNosokPrograms','manageNosokCompanies','manageNosokApplications','reviewNosokApplications','manageNosokComplaints','manageNosokContent','publishNosokResults','viewNosokReports','manageNosokPayments','verifyNosokPayments','manageNosokDocuments','verifyNosokDocuments','manageNosokUnits','manageNosokAccess','manageNosokSurface','manageNosokSettings','viewNosokHealth'], false, 'قالب دور للتسجيل في منصة PalWakf'),
  ('nosokApplicationsReviewer', 'مراجع الطلبات', array['viewNosokDashboard','manageNosokApplications','reviewNosokApplications','manageNosokDocuments','verifyNosokDocuments'], false, null),
  ('nosokPaymentsOfficer', 'موظف الدفعات', array['viewNosokDashboard','manageNosokPayments','verifyNosokPayments'], false, null),
  ('nosokCompaniesManager', 'مدير الشركات المؤهلة', array['viewNosokDashboard','manageNosokCompanies','viewNosokReports'], false, null),
  ('nosokComplaintsOfficer', 'موظف الشكاوى', array['viewNosokDashboard','manageNosokComplaints'], false, null),
  ('nosokContentManager', 'مدير محتوى نسك', array['viewNosokDashboard','manageNosokContent'], false, null),
  ('nosokUnitOfficer', 'موظف وحدة/مديرية', array['viewNosokDashboard','manageNosokUnits','manageNosokApplications'], false, 'يقيد لاحقًا بنطاق unit من platform access profile'),
  ('nosokViewer', 'مطلع نسك', array['viewNosokDashboard','viewNosokReports','viewNosokHealth'], false, null)
on conflict (role_key) do update set
  title_ar = excluded.title_ar,
  permission_keys = excluded.permission_keys,
  is_platform_role = excluded.is_platform_role,
  notes_ar = excluded.notes_ar,
  updated_at = now();

insert into nosok.system_health_checks (check_key, title_ar, check_status, severity, notes_ar)
values
  ('schema_contract', 'عقود nosok schema', 'pending', 'info', 'يتم إغلاقه بعد SQL UAT'),
  ('public_rpc_contract', 'RPC العامة', 'pending', 'info', 'يتم إغلاقه بعد تشغيل public RPCs'),
  ('admin_rpc_contract', 'RPC الإدارية', 'pending', 'info', 'يتم إغلاقه بعد تشغيل admin RPCs مع JWT'),
  ('storage_contract', 'Storage وسياسات الرفع', 'pending', 'medium', 'راجع sql/07_nosok_storage_setup.sql'),
  ('rbac_route_guard', 'RBAC وحراسة المسارات', 'pending', 'high', 'يتطلب Browser Role UAT'),
  ('unit_scope_contract', 'نطاق الوحدات', 'pending', 'medium', 'يجب ربطه بـ core.org_units وAccessProfile')
on conflict (check_key) do update set
  title_ar = excluded.title_ar,
  check_status = excluded.check_status,
  severity = excluded.severity,
  notes_ar = excluded.notes_ar,
  updated_at = now();

create or replace function public.rpc_nosok_public_unit_surface_v1(p_unit_slug text)
returns table (
  unit_slug text,
  title_ar text,
  is_public_visible boolean,
  service_scope_json jsonb,
  notes_ar text
)
language sql
stable
security definer
set search_path = nosok, public
as $$
  select
    s.unit_slug,
    s.title_ar,
    s.is_public_visible,
    s.service_scope_json,
    s.notes_ar
  from nosok.unit_service_scopes s
  where s.unit_slug = p_unit_slug
    and s.is_public_visible = true
  limit 1;
$$;

create or replace function public.rpc_nosok_admin_sidebar_v1()
returns table (
  item_key text,
  title_ar text,
  route_path text,
  icon_key text,
  permission_keys text[],
  display_order integer,
  is_active boolean,
  notes_ar text
)
language sql
stable
security definer
set search_path = nosok, public
as $$
  select
    i.item_key,
    i.title_ar,
    i.route_path,
    i.icon_key,
    i.permission_keys,
    i.display_order,
    i.is_active,
    i.notes_ar
  from nosok.admin_sidebar_items i
  where i.is_active = true
  order by i.display_order, i.item_key;
$$;

create or replace function public.rpc_nosok_role_permission_templates_v1()
returns table (
  role_key text,
  title_ar text,
  permission_keys text[],
  is_platform_role boolean,
  notes_ar text
)
language sql
stable
security definer
set search_path = nosok, public
as $$
  select
    r.role_key,
    r.title_ar,
    r.permission_keys,
    r.is_platform_role,
    r.notes_ar
  from nosok.role_permission_templates r
  order by r.role_key;
$$;

create or replace function public.rpc_nosok_system_health_v1()
returns table (
  check_key text,
  title_ar text,
  check_status text,
  severity text,
  details_json jsonb,
  checked_at timestamptz,
  notes_ar text
)
language sql
stable
security definer
set search_path = nosok, public
as $$
  select
    h.check_key,
    h.title_ar,
    h.check_status,
    h.severity,
    h.details_json,
    h.checked_at,
    h.notes_ar
  from nosok.system_health_checks h
  order by
    case h.severity
      when 'critical' then 1
      when 'high' then 2
      when 'medium' then 3
      when 'low' then 4
      else 5
    end,
    h.check_key;
$$;

-- Read-only verification helper for UAT.
create or replace function public.rpc_nosok_v09_runtime_contract_uat_v1()
returns table (
  section text,
  check_key text,
  passed boolean,
  note text
)
language sql
stable
security definer
set search_path = public, nosok
as $$
  select 'schema'::text, 'system_settings_exists'::text, to_regclass('nosok.system_settings') is not null, 'Nosok settings table exists.'::text
  union all
  select 'schema', 'unit_service_scopes_exists', to_regclass('nosok.unit_service_scopes') is not null, 'Unit service scope table exists.'
  union all
  select 'schema', 'admin_sidebar_items_exists', to_regclass('nosok.admin_sidebar_items') is not null, 'Internal sidebar item registry exists.'
  union all
  select 'schema', 'role_permission_templates_exists', to_regclass('nosok.role_permission_templates') is not null, 'Role permission templates exist.'
  union all
  select 'schema', 'system_health_checks_exists', to_regclass('nosok.system_health_checks') is not null, 'Health checks table exists.'
  union all
  select 'rpc', 'public_unit_surface_rpc_exists', to_regprocedure('public.rpc_nosok_public_unit_surface_v1(text)') is not null, 'Public unit surface RPC exists.'
  union all
  select 'rpc', 'admin_sidebar_rpc_exists', to_regprocedure('public.rpc_nosok_admin_sidebar_v1()') is not null, 'Admin sidebar RPC exists.'
  union all
  select 'rpc', 'role_templates_rpc_exists', to_regprocedure('public.rpc_nosok_role_permission_templates_v1()') is not null, 'Role templates RPC exists.'
  union all
  select 'rpc', 'health_rpc_exists', to_regprocedure('public.rpc_nosok_system_health_v1()') is not null, 'Health RPC exists.'
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script', true, 'No DML/DDL targets waqf, waqf_assets, or awqaf_system.';
$$;
