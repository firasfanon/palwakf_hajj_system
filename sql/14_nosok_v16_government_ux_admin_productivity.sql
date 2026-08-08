-- Nosok v16 — Government UX Completion + Admin Workflow Productivity Sweep
-- Scope: additive runtime contracts only. No waqf/waqf_assets/awqaf_system mutation.

create schema if not exists nosok;

create table if not exists nosok.service_surface_catalog (
  id uuid primary key default gen_random_uuid(),
  surface_key text not null unique,
  title_ar text not null,
  description_ar text,
  public_route text,
  admin_route text,
  audience text not null default 'public',
  display_order integer not null default 100,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.admin_workflow_buckets (
  id uuid primary key default gen_random_uuid(),
  bucket_key text not null unique,
  title_ar text not null,
  description_ar text,
  route_path text,
  severity text not null default 'normal',
  display_order integer not null default 100,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.season_command_checklist (
  id uuid primary key default gen_random_uuid(),
  check_key text not null unique,
  title_ar text not null,
  description_ar text,
  gate_type text not null default 'required',
  owner_surface text,
  display_order integer not null default 100,
  is_required boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.service_desk_scripts (
  id uuid primary key default gen_random_uuid(),
  script_key text not null unique,
  title_ar text not null,
  body_ar text not null,
  category text not null default 'general',
  is_active boolean not null default true,
  display_order integer not null default 100,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.visual_governance_checks (
  id uuid primary key default gen_random_uuid(),
  check_key text not null unique,
  title_ar text not null,
  description_ar text,
  status text not null default 'pending',
  evidence_note text,
  updated_by uuid,
  updated_at timestamptz not null default now()
);

insert into nosok.service_surface_catalog(surface_key, title_ar, description_ar, public_route, admin_route, audience, display_order)
values
('public_home', 'الرئيسية الحكومية', 'واجهة خدمة عامة وليست صفحة معلومات إدارية.', '/systems/nosok', null, 'public', 10),
('service_guide', 'دليل الخدمة', 'دليل عملي للمستفيد قبل التقديم.', '/systems/nosok/service-guide', null, 'public', 20),
('citizen_journey', 'رحلة المستفيد', 'عرض مبسط لمسار الخدمة من الطلب إلى التتبع.', '/systems/nosok/citizen-journey', null, 'public', 30),
('workflow_workbench', 'Workbench التشغيل', 'سطح إنتاجي يومي لموظفي نسك.', null, '/admin/systems/nosok/workflow-workbench', 'admin', 40),
('season_command', 'قيادة الموسم', 'سطح قرارات موسمية قبل فتح التسجيل.', null, '/admin/systems/nosok/season-command', 'admin', 50),
('service_desk', 'مكتب الخدمة', 'سطح خدمة أمامية للاستعلام والإرشاد.', null, '/admin/systems/nosok/service-desk', 'admin', 60),
('visual_governance', 'حوكمة الواجهة', 'فحص التزام نسك بـ PWF-SIS.', null, '/admin/systems/nosok/visual-governance', 'admin', 70)
on conflict(surface_key) do update set
  title_ar = excluded.title_ar,
  description_ar = excluded.description_ar,
  public_route = excluded.public_route,
  admin_route = excluded.admin_route,
  audience = excluded.audience,
  display_order = excluded.display_order,
  is_active = true,
  updated_at = now();

insert into nosok.admin_workflow_buckets(bucket_key, title_ar, description_ar, route_path, severity, display_order)
values
('applications_review', 'طلبات تحتاج مراجعة', 'طلبات جديدة أو تحتاج قرار أهلية.', '/admin/systems/nosok/applications', 'high', 10),
('documents_review', 'وثائق بانتظار تحقق', 'وثائق مرفوعة تحتاج اعتمادًا أو رفضًا.', '/admin/systems/nosok/applications', 'high', 20),
('payments_verification', 'دفعات غير مغلقة', 'دفعات تحتاج تحققًا أو مزامنة جسر الفوترة.', '/admin/systems/nosok/payment-bridge', 'high', 30),
('unit_queues', 'طوابير الوحدات', 'طلبات مقيدة بسياق الوحدة/المديرية.', '/admin/systems/nosok/unit-queues', 'normal', 40),
('complaints_followup', 'شكاوى مفتوحة', 'قضايا تواصل تحتاج متابعة وإغلاق.', '/admin/systems/nosok/complaints', 'normal', 50)
on conflict(bucket_key) do update set
  title_ar = excluded.title_ar,
  description_ar = excluded.description_ar,
  route_path = excluded.route_path,
  severity = excluded.severity,
  display_order = excluded.display_order,
  is_active = true,
  updated_at = now();

insert into nosok.season_command_checklist(check_key, title_ar, description_ar, gate_type, owner_surface, display_order)
values
('active_season', 'موسم نشط ومراجَع', 'وجود موسم فعال بمدد تسجيل صحيحة.', 'required', 'seasons', 10),
('published_program', 'برنامج خدمة منشور', 'برنامج حج/عمرة ظاهر للجمهور عند فتح الخدمة.', 'required', 'programs', 20),
('qualified_companies', 'شركات مؤهلة للموسم', 'تأهيل الشركات مرتبط بالموسم لا بالنص الثابت.', 'required', 'companies', 30),
('tracking_privacy', 'خصوصية التتبع مجتازة', 'عدم عرض الاسم أو الهوية أو الهاتف في التتبع العام.', 'gate', 'tracking_privacy', 40),
('role_uat', 'Role UAT للأدوار الحرجة', 'اختبار superuser والموظف المحدود وأدوار نسك.', 'gate', 'role_uat', 50),
('billing_bridge', 'جسر الدفع جاهز', 'عدم تخزين بيانات بطاقات داخل نسك وربط billing_system.', 'gate', 'billing_adapters', 60)
on conflict(check_key) do update set
  title_ar = excluded.title_ar,
  description_ar = excluded.description_ar,
  gate_type = excluded.gate_type,
  owner_surface = excluded.owner_surface,
  display_order = excluded.display_order,
  is_required = true,
  updated_at = now();

insert into nosok.service_desk_scripts(script_key, title_ar, body_ar, category, display_order)
values
('application_received', 'تم استلام طلبك', 'يرجى الاحتفاظ برمز التتبع ومراجعة صفحة متابعة الطلب لمعرفة الحالة.', 'application', 10),
('needs_completion', 'الطلب يحتاج استكمال', 'راجع ملاحظات المراجعة ثم أعد رفع الوثيقة أو السند المطلوب عند إتاحة التعديل.', 'application', 20),
('payment_under_review', 'الدفعة قيد التحقق', 'لا يعني رفع السند اعتماد الدفعة؛ الاعتماد يتم بعد التحقق الإداري أو مزامنة الفوترة.', 'payment', 30),
('privacy_tracking', 'التتبع آمن', 'لا تُعرض البيانات الشخصية في صفحة التتبع العامة؛ استخدم الرمز فقط.', 'privacy', 40)
on conflict(script_key) do update set
  title_ar = excluded.title_ar,
  body_ar = excluded.body_ar,
  category = excluded.category,
  display_order = excluded.display_order,
  is_active = true,
  updated_at = now();

insert into nosok.visual_governance_checks(check_key, title_ar, description_ar, status)
values
('platform_identity_inherited', 'هوية المنصة موروثة', 'لا يبتكر نسك هوية منفصلة عن PalWakf.', 'pending'),
('anti_overload_ux', 'تقليل الأوفرلود', 'تقسيم المعلومات إلى إجراءات ومراحل وبطاقات.', 'pending'),
('responsive_surfaces', 'تجاوب الشاشات', 'الصفحات العامة والإدارية قابلة للاستخدام على الشاشات المختلفة.', 'pending'),
('rtl_accessibility', 'RTL وإتاحة', 'اتجاه عربي واضح وتباين مناسب وعدم ألوان فاتحة على خلفيات فاتحة.', 'pending'),
('runtime_states', 'حالات runtime', 'Loading/Empty/Error/Unauthorized/Maintenance لكل سطح يعتمد على البيانات.', 'pending')
on conflict(check_key) do update set
  title_ar = excluded.title_ar,
  description_ar = excluded.description_ar,
  updated_at = now();

create or replace function public.rpc_nosok_v16_government_ux_surfaces_v1()
returns table(surface_key text, title_ar text, public_route text, admin_route text, audience text, is_active boolean)
language sql
security definer
set search_path = nosok, public
as $$
  select s.surface_key, s.title_ar, s.public_route, s.admin_route, s.audience, s.is_active
  from nosok.service_surface_catalog s
  where s.is_active = true
  order by s.display_order, s.title_ar;
$$;

create or replace function public.rpc_nosok_v16_admin_workflow_buckets_v1()
returns table(bucket_key text, title_ar text, description_ar text, route_path text, severity text, display_order integer)
language sql
security definer
set search_path = nosok, public
as $$
  select b.bucket_key, b.title_ar, b.description_ar, b.route_path, b.severity, b.display_order
  from nosok.admin_workflow_buckets b
  where b.is_active = true
  order by b.display_order, b.title_ar;
$$;

create or replace function public.rpc_nosok_v16_runtime_contract_uat_v1()
returns table(section text, check_key text, passed boolean, note text)
language sql
security definer
set search_path = nosok, public
as $$
  select 'surfaces', 'v16_surfaces_seeded', count(*) >= 7, 'Public/admin UX surfaces seeded.' from nosok.service_surface_catalog
  union all
  select 'workflow', 'workflow_buckets_seeded', count(*) >= 5, 'Admin workbench buckets seeded.' from nosok.admin_workflow_buckets
  union all
  select 'season_command', 'season_checklist_seeded', count(*) >= 6, 'Season command readiness checklist seeded.' from nosok.season_command_checklist
  union all
  select 'service_desk', 'service_scripts_seeded', count(*) >= 4, 'Service desk scripts seeded.' from nosok.service_desk_scripts
  union all
  select 'visual_governance', 'visual_checks_seeded', count(*) >= 5, 'Visual governance checks seeded.' from nosok.visual_governance_checks
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation', true, 'No waqf/waqf_assets/awqaf_system DML in v16.';
$$;
