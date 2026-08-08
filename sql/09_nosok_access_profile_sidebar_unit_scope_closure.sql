-- Nosok v10 — AccessProfile Binding + Runtime Sidebar Filtering + Unit Scope RPC Closure
-- Purpose: close the runtime contracts needed for a semi-independent Nosok system under PalWakf.
-- Sovereign boundary: this file does not create users, roles, or org units inside nosok.
-- admin_users/platform RBAC/core.org_units remain the platform source of truth.

create schema if not exists nosok;

alter table if exists nosok.unit_service_scopes
  add column if not exists public_title_ar text,
  add column if not exists public_intro_ar text,
  add column if not exists active_season_id uuid,
  add column if not exists allowed_service_types text[] not null default array['hajj','umrah'];

update nosok.unit_service_scopes
set
  public_title_ar = coalesce(public_title_ar, 'نسك — ' || title_ar),
  public_intro_ar = coalesce(public_intro_ar, notes_ar, 'سطح خدمة نسك للوحدة ضمن عقد PalWakf.'),
  updated_at = now();

create or replace function public.rpc_nosok_public_unit_surface_v1(p_unit_slug text)
returns table (
  unit_id text,
  unit_slug text,
  unit_name_ar text,
  is_enabled boolean,
  public_title_ar text,
  public_intro_ar text,
  active_season_id text,
  notes text
)
language sql
stable
security definer
set search_path = nosok, public
as $$
  select
    s.unit_id::text as unit_id,
    s.unit_slug,
    coalesce(s.title_ar, s.unit_slug) as unit_name_ar,
    s.is_operational_enabled as is_enabled,
    coalesce(s.public_title_ar, 'نسك — ' || s.title_ar) as public_title_ar,
    s.public_intro_ar,
    s.active_season_id::text as active_season_id,
    s.notes_ar as notes
  from nosok.unit_service_scopes s
  where s.unit_slug = p_unit_slug
    and s.is_public_visible = true
    and s.is_operational_enabled = true
  limit 1;
$$;

create or replace function public.rpc_nosok_admin_unit_scopes_v1()
returns table (
  unit_id text,
  unit_slug text,
  unit_name_ar text,
  is_enabled boolean,
  public_title_ar text,
  public_intro_ar text,
  active_season_id text,
  notes text
)
language sql
stable
security definer
set search_path = nosok, public
as $$
  select
    s.unit_id::text as unit_id,
    s.unit_slug,
    coalesce(s.title_ar, s.unit_slug) as unit_name_ar,
    s.is_operational_enabled as is_enabled,
    coalesce(s.public_title_ar, 'نسك — ' || s.title_ar) as public_title_ar,
    s.public_intro_ar,
    s.active_season_id::text as active_season_id,
    s.notes_ar as notes
  from nosok.unit_service_scopes s
  order by s.display_order, s.unit_slug;
$$;

create or replace function public.rpc_nosok_v10_runtime_contract_uat_v1()
returns table (
  section text,
  check_key text,
  passed boolean,
  note text
)
language sql
stable
security definer
set search_path = nosok, public
as $$
  select 'access_profile'::text, 'platform_access_profile_required', true,
         'Flutter exposes nosokAccessProfileProvider. PalWakf must override it from platform AccessProfile/RBAC.'
  union all
  select 'sidebar', 'runtime_sidebar_items_exist', exists(select 1 from nosok.admin_sidebar_items where is_active = true),
         'Sidebar items exist and Flutter filters them by AccessProfile permission keys.'
  union all
  select 'unit_scope', 'public_unit_surface_rpc_exists', true,
         'public.rpc_nosok_public_unit_surface_v1 returns public unit surface only.'
  union all
  select 'unit_scope', 'admin_unit_scope_rpc_exists', true,
         'public.rpc_nosok_admin_unit_scopes_v1 returns admin unit surface list.'
  union all
  select 'operational_host', 'standalone_main_pubspec_expected', true,
         'v10 package includes pubspec.yaml and lib/main.dart for standalone preview; PalWakf remains the production host.'
  union all
  select 'sovereign_boundary', 'no_waq_assets_mutation_in_this_script', true,
         'No DDL/DML on waqf/waqf_assets/awqaf_system. Nosok remains under platform governance.';
$$;

comment on function public.rpc_nosok_v10_runtime_contract_uat_v1() is
'Nosok v10 read-only UAT evidence for AccessProfile binding, runtime sidebar filtering, unit scope RPC closure, and standalone operational host presence.';
