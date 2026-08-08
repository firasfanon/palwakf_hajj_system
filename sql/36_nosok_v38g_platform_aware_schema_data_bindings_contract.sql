-- Nosok v38G — Platform-Aware Schema + Data Bindings Contract
-- Purpose: prepare nosok schema objects and their links to PalWakf platform sources.
-- Status: DRAFT ONLY. Do not run for production. No schema is created before PalWakf hosting.
-- Safety: wrapped in transaction + ROLLBACK.

BEGIN;

-- -----------------------------------------------------------------------------
-- 0) Shape discovery checklist (read-only intent when extracted separately)
-- -----------------------------------------------------------------------------
-- Expected platform sources observed from PalWakf code/SQL contracts:
--   identity: public.admin_users, auth.users
--   dynamic RBAC: platform.system_user_roles, platform.system_user_permissions
--   org units: core.org_units, core.org_unit_profiles, public.org_units compatibility view
--   org unit RPCs: public.pwf_resolve_unit_id, public.pwf_list_units_with_profiles,
--                  public.pwf_get_unit_with_profile_by_slug
--   GIS/LGU/Governorate: requires final shape discovery inside PalWakf runtime.

-- -----------------------------------------------------------------------------
-- 1) Schema shell — draft only
-- -----------------------------------------------------------------------------
create schema if not exists nosok;
comment on schema nosok is 'Nosok subsystem schema. Draft only in v38G; apply only after PalWakf hosting and approval.';

-- -----------------------------------------------------------------------------
-- 2) Platform source registry for documentation/runtime diagnostics
-- -----------------------------------------------------------------------------
create table if not exists nosok.platform_binding_sources (
  id uuid primary key default gen_random_uuid(),
  source_key text not null unique,
  source_schema text not null,
  source_object text not null,
  source_kind text not null check (source_kind in ('table','view','rpc','schema','external_contract')),
  authority_level text not null check (authority_level in ('sovereign','compatibility','wrapper','shape_discovery_required')),
  nosok_usage text not null,
  direct_access_allowed boolean not null default false,
  required_before_apply boolean not null default true,
  notes_ar text,
  created_at timestamptz not null default now()
);

insert into nosok.platform_binding_sources
  (source_key, source_schema, source_object, source_kind, authority_level, nosok_usage, direct_access_allowed, required_before_apply, notes_ar)
values
  ('identity_admin_users','public','admin_users','table','sovereign','هوية الموظفين وممثلي الجهات الإدارية؛ id يطابق auth.users.id وفق AccessRepository.',false,true,'لا ينشئ نسك جدول هوية مستقل.'),
  ('identity_auth_users','auth','users','table','sovereign','مصدر المصادقة الأساسي؛ لا يقرأه نسك مباشرة إلا عبر سياسات/RPC.',false,true,'التحقق يتم عبر auth.uid().'),
  ('dynamic_system_roles','platform','system_user_roles','table','sovereign','أدوار نسك الديناميكية بعد تسجيل system_key=nosok.',false,true,'يستعملها AccessProfile في المنصة عند توفرها.'),
  ('dynamic_system_permissions','platform','system_user_permissions','table','sovereign','صلاحيات نسك التفصيلية مثل manageNosokHomepageSections.',false,true,'تحتاج seed منفصل في مسار المنصة.'),
  ('org_units_core','core','org_units','table','sovereign','مصدر الوحدات والمديريات وunitSlug.',false,true,'الوصول المباشر إلى core غير مفضل من clients.'),
  ('org_units_public_view','public','org_units','view','compatibility','قراءة توافقية للوحدات عند الحاجة.',true,true,'تقرأ من core.org_units حسب عقود PalWakf.'),
  ('org_unit_resolve_rpc','public','pwf_resolve_unit_id','rpc','wrapper','حل unit_id من unitSlug.',true,true,'يفضل عند ربط نطاق المستخدم.'),
  ('org_unit_list_rpc','public','pwf_list_units_with_profiles','rpc','wrapper','قراءة الوحدات مع profiles.',true,false,'مفيد لأدوات الإدارة.'),
  ('gis_lgu_authority','gis','lgus_boundary_or_equivalent','external_contract','shape_discovery_required','مصدر LGU/التجمعات/الهيئات المحلية؛ يلزم shape discovery قبل apply.',false,true,'لا نفترض اسمًا نهائيًا قبل فحص بيئة PalWakf.'),
  ('gis_governorate_authority','gis','governorates_boundary_or_equivalent','external_contract','shape_discovery_required','مصدر المحافظات؛ يلزم shape discovery قبل apply.',false,true,'يمكن اعتماد public compatibility wrapper إن توفر.')
on conflict (source_key) do nothing;

-- -----------------------------------------------------------------------------
-- 3) Core Nosok schema objects — draft
-- -----------------------------------------------------------------------------
create table if not exists nosok.seasons (
  id uuid primary key default gen_random_uuid(),
  season_key text not null unique,
  title_ar text not null,
  season_type text not null check (season_type in ('hajj','umrah','mixed')),
  registration_open_at timestamptz,
  registration_close_at timestamptz,
  deficiency_window_close_at timestamptz,
  lottery_pool_freeze_at timestamptz,
  policy_version text not null,
  legal_regulation_version text,
  is_active boolean not null default false,
  created_by uuid references public.admin_users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.governorate_reference_snapshots (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references nosok.seasons(id),
  source_key text not null,
  platform_governorate_id text,
  code text,
  name_ar text not null,
  name_en text,
  snapshot_status text not null default 'active',
  created_at timestamptz not null default now(),
  unique(season_id, platform_governorate_id),
  unique(season_id, code)
);

create table if not exists nosok.lgu_reference_snapshots (
  id uuid primary key default gen_random_uuid(),
  season_id uuid not null references nosok.seasons(id),
  governorate_snapshot_id uuid references nosok.governorate_reference_snapshots(id),
  platform_lgu_id text,
  platform_org_unit_id uuid,
  lgu_code text,
  lgu_slug text,
  name_ar text not null,
  name_en text,
  population_count integer,
  quota_divisor integer,
  quota_people_count integer,
  quota_request_count integer,
  source_key text not null,
  snapshot_status text not null default 'active',
  created_at timestamptz not null default now(),
  unique(season_id, platform_lgu_id),
  unique(season_id, lgu_code)
);

create table if not exists nosok.user_unit_scope_assignments (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.admin_users(id),
  season_id uuid references nosok.seasons(id),
  platform_org_unit_id uuid,
  unit_slug text,
  governorate_snapshot_id uuid references nosok.governorate_reference_snapshots(id),
  lgu_snapshot_id uuid references nosok.lgu_reference_snapshots(id),
  scope_kind text not null check (scope_kind in ('all','governorate','lgu','org_unit','company')),
  allow_read boolean not null default true,
  allow_review boolean not null default false,
  allow_update boolean not null default false,
  allow_override boolean not null default false,
  is_active boolean not null default true,
  created_by uuid references public.admin_users(id),
  created_at timestamptz not null default now()
);

create table if not exists nosok.homepage_sections (
  id uuid primary key default gen_random_uuid(),
  section_key text not null,
  surface_key text not null default 'public_homepage',
  title_ar text not null,
  subtitle_ar text,
  template_key text not null,
  payload jsonb not null default '{}'::jsonb,
  display_order integer not null default 100,
  visibility text not null default 'draft' check (visibility in ('draft','published','hidden','archived')),
  season_id uuid references nosok.seasons(id),
  unit_slug text,
  publish_from timestamptz,
  publish_until timestamptz,
  created_by uuid references public.admin_users(id),
  updated_by uuid references public.admin_users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(surface_key, section_key, coalesce(season_id, '00000000-0000-0000-0000-000000000000'::uuid), coalesce(unit_slug,''))
);

create table if not exists nosok.page_registry (
  id uuid primary key default gen_random_uuid(),
  page_key text not null unique,
  slug text not null unique,
  title_ar text not null,
  template_key text not null,
  route_kind text not null check (route_kind in ('public_content','public_season','company_public','admin_dynamic')),
  permission_key text,
  visibility text not null default 'draft' check (visibility in ('draft','published','hidden','archived')),
  payload jsonb not null default '{}'::jsonb,
  created_by uuid references public.admin_users(id),
  updated_by uuid references public.admin_users(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists nosok.page_sections (
  id uuid primary key default gen_random_uuid(),
  page_id uuid not null references nosok.page_registry(id) on delete cascade,
  section_key text not null,
  template_key text not null,
  title_ar text,
  payload jsonb not null default '{}'::jsonb,
  display_order integer not null default 100,
  visibility text not null default 'draft' check (visibility in ('draft','published','hidden','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(page_id, section_key)
);

-- -----------------------------------------------------------------------------
-- 4) Public-safe wrappers — signatures only / draft
-- -----------------------------------------------------------------------------
-- create or replace function public.rpc_nosok_homepage_sections_public_v1(...)
-- returns jsonb security definer set search_path = public, nosok as $$ ... $$;
-- create or replace function public.rpc_nosok_dynamic_page_public_v1(p_slug text, p_unit_slug text default null)
-- returns jsonb security definer set search_path = public, nosok as $$ ... $$;
-- create or replace function public.rpc_nosok_admin_homepage_section_upsert_v1(p_payload jsonb)
-- returns jsonb security definer set search_path = public, nosok as $$ ... $$;
-- create or replace function public.rpc_nosok_admin_unit_scope_list_v1(p_user_id uuid default null)
-- returns jsonb security definer set search_path = public, nosok as $$ ... $$;

-- -----------------------------------------------------------------------------
-- 5) RLS intent — draft only
-- -----------------------------------------------------------------------------
alter table nosok.seasons enable row level security;
alter table nosok.governorate_reference_snapshots enable row level security;
alter table nosok.lgu_reference_snapshots enable row level security;
alter table nosok.user_unit_scope_assignments enable row level security;
alter table nosok.homepage_sections enable row level security;
alter table nosok.page_registry enable row level security;
alter table nosok.page_sections enable row level security;

comment on table nosok.user_unit_scope_assignments is
  'Nosok extension for user scope only. It must not replace PalWakf AccessProfile/RBAC; it narrows user access to org_unit/LGU/governorate/company.';
comment on table nosok.homepage_sections is
  'Admin-managed homepage sections. Public reads must go through published-only RPC/view; no draft exposure.';
comment on table nosok.lgu_reference_snapshots is
  'Seasonal LGU reference snapshot for identity-address-based quota and lottery. Do not read live GIS during draw.';

ROLLBACK;
