-- Nosok v38I-3 / 38A
-- Real Supabase Environment Census Before Any Nosok Schema Apply
-- READ-ONLY ONLY: no CREATE, no ALTER, no INSERT, no UPDATE, no DELETE, no DROP.
-- Purpose:
--   1) Inspect the real PalWakf/Supabase environment before creating nosok schema.
--   2) Confirm core is the sovereign source for LGU/governorates/org units.
--   3) Treat public as wrappers/views/RPC surface only.
--   4) Detect object/function/policy collisions before running any DDL.
-- Run this first in Supabase SQL Editor, then send the result sets back for intake.

-- -----------------------------------------------------------------------------
-- 00. Census banner / guard
-- -----------------------------------------------------------------------------
select
  '00_census_banner'::text as section,
  'read_only_census'::text as check_key,
  true::boolean as passed,
  'This script performs SELECT-only environment discovery before any nosok schema creation.'::text as note;

-- -----------------------------------------------------------------------------
-- 01. Required/important schemas presence
-- -----------------------------------------------------------------------------
with expected(schema_name, role_note) as (
  values
    ('core', 'sovereign source for org_units / governorates / LGUs according to project contract'),
    ('platform', 'system registry / RBAC / system sections'),
    ('public', 'safe wrapper/RPC/view surface only; not sovereign source for LGU/governorates'),
    ('gis', 'possible spatial references; read-only only if needed'),
    ('auth', 'Supabase auth schema; index only'),
    ('storage', 'Supabase storage schema; index only'),
    ('nosok', 'Nosok operational schema; may be absent before apply')
)
select
  '01_schema_presence' as section,
  e.schema_name,
  (s.schema_name is not null) as exists,
  e.role_note
from expected e
left join information_schema.schemata s on s.schema_name = e.schema_name
order by e.schema_name;

-- -----------------------------------------------------------------------------
-- 02. Object counts by relevant schema
-- -----------------------------------------------------------------------------
select
  '02_object_counts' as section,
  n.nspname as schema_name,
  case c.relkind
    when 'r' then 'table'
    when 'v' then 'view'
    when 'm' then 'materialized_view'
    when 'S' then 'sequence'
    when 'f' then 'foreign_table'
    when 'p' then 'partitioned_table'
    else c.relkind::text
  end as object_type,
  count(*)::int as object_count
from pg_namespace n
join pg_class c on c.relnamespace = n.oid
where n.nspname in ('core','platform','public','gis','auth','storage','nosok')
  and c.relkind in ('r','v','m','S','f','p')
group by n.nspname, c.relkind
order by n.nspname, object_type;

-- -----------------------------------------------------------------------------
-- 03. Core candidate reference objects for governorates / LGUs / org units / profiles
--     This intentionally uses broad name patterns. Review before creating FK/RPC.
-- -----------------------------------------------------------------------------
select
  '03_core_reference_candidate_objects' as section,
  t.table_schema,
  t.table_name,
  t.table_type,
  case
    when t.table_name ilike '%govern%' or t.table_name ilike '%محافظ%' then 'governorate_candidate'
    when t.table_name ilike '%lgu%' or t.table_name ilike '%local%' or t.table_name ilike '%بلد%' or t.table_name ilike '%هيئ%' then 'lgu_candidate'
    when t.table_name ilike '%org_unit%' or t.table_name ilike '%unit%' or t.table_name ilike '%director%' or t.table_name ilike '%مدير%' then 'org_unit_candidate'
    when t.table_name ilike '%profile%' then 'profile_candidate'
    else 'other_reference_candidate'
  end as candidate_kind
from information_schema.tables t
where t.table_schema = 'core'
  and (
    t.table_name ilike '%govern%'
    or t.table_name ilike '%محافظ%'
    or t.table_name ilike '%lgu%'
    or t.table_name ilike '%local%'
    or t.table_name ilike '%بلد%'
    or t.table_name ilike '%هيئ%'
    or t.table_name ilike '%org_unit%'
    or t.table_name ilike '%unit%'
    or t.table_name ilike '%director%'
    or t.table_name ilike '%مدير%'
    or t.table_name ilike '%profile%'
  )
order by candidate_kind, t.table_name;

-- -----------------------------------------------------------------------------
-- 04. Column shape for core candidates
-- -----------------------------------------------------------------------------
with core_candidates as (
  select t.table_schema, t.table_name
  from information_schema.tables t
  where t.table_schema = 'core'
    and (
      t.table_name ilike '%govern%'
      or t.table_name ilike '%محافظ%'
      or t.table_name ilike '%lgu%'
      or t.table_name ilike '%local%'
      or t.table_name ilike '%بلد%'
      or t.table_name ilike '%هيئ%'
      or t.table_name ilike '%org_unit%'
      or t.table_name ilike '%unit%'
      or t.table_name ilike '%director%'
      or t.table_name ilike '%مدير%'
      or t.table_name ilike '%profile%'
    )
)
select
  '04_core_reference_candidate_columns' as section,
  c.table_schema,
  c.table_name,
  c.column_name,
  c.ordinal_position,
  c.data_type,
  c.udt_name,
  c.is_nullable,
  c.column_default
from information_schema.columns c
join core_candidates cc
  on cc.table_schema = c.table_schema
 and cc.table_name = c.table_name
order by c.table_name, c.ordinal_position;

-- -----------------------------------------------------------------------------
-- 05. Platform RBAC / registry candidate objects
-- -----------------------------------------------------------------------------
select
  '05_platform_rbac_registry_candidate_objects' as section,
  t.table_schema,
  t.table_name,
  t.table_type,
  case
    when t.table_name ilike '%system%' and t.table_name ilike '%role%' then 'system_roles_candidate'
    when t.table_name ilike '%system%' and t.table_name ilike '%permission%' then 'system_permissions_candidate'
    when t.table_name ilike '%registry%' or t.table_name ilike '%system%' then 'system_registry_candidate'
    when t.table_name ilike '%section%' then 'system_sections_candidate'
    when t.table_name ilike '%user%' and t.table_name ilike '%role%' then 'user_roles_candidate'
    when t.table_name ilike '%user%' and t.table_name ilike '%permission%' then 'user_permissions_candidate'
    else 'platform_candidate'
  end as candidate_kind
from information_schema.tables t
where t.table_schema = 'platform'
  and (
    t.table_name ilike '%system%'
    or t.table_name ilike '%role%'
    or t.table_name ilike '%permission%'
    or t.table_name ilike '%registry%'
    or t.table_name ilike '%section%'
    or t.table_name ilike '%user%'
  )
order by candidate_kind, t.table_name;

-- -----------------------------------------------------------------------------
-- 06. Column shape for platform RBAC / registry candidates
-- -----------------------------------------------------------------------------
with platform_candidates as (
  select t.table_schema, t.table_name
  from information_schema.tables t
  where t.table_schema = 'platform'
    and (
      t.table_name ilike '%system%'
      or t.table_name ilike '%role%'
      or t.table_name ilike '%permission%'
      or t.table_name ilike '%registry%'
      or t.table_name ilike '%section%'
      or t.table_name ilike '%user%'
    )
)
select
  '06_platform_candidate_columns' as section,
  c.table_schema,
  c.table_name,
  c.column_name,
  c.ordinal_position,
  c.data_type,
  c.udt_name,
  c.is_nullable,
  c.column_default
from information_schema.columns c
join platform_candidates pc
  on pc.table_schema = c.table_schema
 and pc.table_name = c.table_name
order by c.table_name, c.ordinal_position;

-- -----------------------------------------------------------------------------
-- 07. Public wrapper/view surface inventory relevant to nosok/core/org units
-- -----------------------------------------------------------------------------
select
  '07_public_view_surface_inventory' as section,
  t.table_schema,
  t.table_name,
  t.table_type
from information_schema.tables t
where t.table_schema = 'public'
  and (
    t.table_name ilike '%nosok%'
    or t.table_name ilike '%org_unit%'
    or t.table_name ilike '%unit%'
    or t.table_name ilike '%lgu%'
    or t.table_name ilike '%govern%'
    or t.table_name ilike '%admin_user%'
  )
order by t.table_type, t.table_name;

-- -----------------------------------------------------------------------------
-- 08. Function/RPC inventory and collision check for public.rpc_nosok_* names
-- -----------------------------------------------------------------------------
select
  '08_public_rpc_inventory_nosok_and_references' as section,
  n.nspname as function_schema,
  p.proname as function_name,
  pg_get_function_identity_arguments(p.oid) as identity_arguments,
  pg_get_function_result(p.oid) as result_type
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and (
    p.proname ilike 'rpc_nosok%'
    or p.proname ilike '%org_unit%'
    or p.proname ilike '%unit%'
    or p.proname ilike '%lgu%'
    or p.proname ilike '%govern%'
  )
order by p.proname;

-- -----------------------------------------------------------------------------
-- 09. Existing nosok schema objects, if any. If rows exist, do not drop/recreate
--     without explicit decision.
-- -----------------------------------------------------------------------------
select
  '09_existing_nosok_objects' as section,
  n.nspname as schema_name,
  c.relname as object_name,
  case c.relkind
    when 'r' then 'table'
    when 'v' then 'view'
    when 'm' then 'materialized_view'
    when 'S' then 'sequence'
    when 'f' then 'foreign_table'
    when 'p' then 'partitioned_table'
    else c.relkind::text
  end as object_type
from pg_namespace n
join pg_class c on c.relnamespace = n.oid
where n.nspname = 'nosok'
order by object_type, object_name;

-- -----------------------------------------------------------------------------
-- 10. RLS status for relevant schemas. RLS is required for nosok operational tables
--     after schema apply.
-- -----------------------------------------------------------------------------
select
  '10_rls_status_relevant_tables' as section,
  n.nspname as schema_name,
  c.relname as table_name,
  c.relrowsecurity as rls_enabled,
  c.relforcerowsecurity as rls_forced
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname in ('core','platform','public','gis','nosok')
  and c.relkind in ('r','p')
order by n.nspname, c.relname;

-- -----------------------------------------------------------------------------
-- 11. Policy inventory for relevant schemas
-- -----------------------------------------------------------------------------
select
  '11_policy_inventory_relevant_schemas' as section,
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
from pg_policies
where schemaname in ('core','platform','public','gis','nosok')
order by schemaname, tablename, policyname;

-- -----------------------------------------------------------------------------
-- 12. Grants on existing public nosok/reference RPCs
-- -----------------------------------------------------------------------------
select
  '12_function_grants_for_public_surface' as section,
  routine_schema,
  routine_name,
  grantee,
  privilege_type,
  is_grantable
from information_schema.routine_privileges
where routine_schema = 'public'
  and (
    routine_name ilike 'rpc_nosok%'
    or routine_name ilike '%org_unit%'
    or routine_name ilike '%lgu%'
    or routine_name ilike '%govern%'
  )
order by routine_name, grantee, privilege_type;

-- -----------------------------------------------------------------------------
-- 13. Auth/admin surface existence by metadata only. Do not expose user rows here.
-- -----------------------------------------------------------------------------
select
  '13_auth_admin_surface_presence' as section,
  target_schema,
  target_object,
  exists_flag,
  note
from (
  select 'auth'::text as target_schema, 'users'::text as target_object,
    exists(select 1 from information_schema.tables where table_schema='auth' and table_name='users') as exists_flag,
    'Supabase auth users table; index only, do not expose rows.'::text as note
  union all
  select 'public', 'admin_users',
    exists(select 1 from information_schema.tables where table_schema='public' and table_name='admin_users'),
    'Admin user compatibility/operation surface if present.'
  union all
  select 'platform', 'system_user_roles',
    exists(select 1 from information_schema.tables where table_schema='platform' and table_name='system_user_roles'),
    'Platform RBAC roles candidate.'
  union all
  select 'platform', 'system_user_permissions',
    exists(select 1 from information_schema.tables where table_schema='platform' and table_name='system_user_permissions'),
    'Platform RBAC permissions candidate.'
) x
order by target_schema, target_object;

-- -----------------------------------------------------------------------------
-- 14. Storage bucket metadata, if accessible. Documents integration remains later.
-- -----------------------------------------------------------------------------
select
  '14_storage_bucket_inventory' as section,
  table_schema,
  table_name,
  column_name,
  data_type
from information_schema.columns
where table_schema = 'storage'
  and table_name in ('buckets','objects')
order by table_name, ordinal_position;

-- -----------------------------------------------------------------------------
-- 15. Safe apply decision helper. This does not approve apply; it only indicates
--     whether the expected prerequisites were discoverable.
-- -----------------------------------------------------------------------------
with flags as (
  select
    exists(select 1 from information_schema.schemata where schema_name='core') as core_schema_exists,
    exists(select 1 from information_schema.schemata where schema_name='platform') as platform_schema_exists,
    exists(select 1 from information_schema.schemata where schema_name='public') as public_schema_exists,
    exists(select 1 from information_schema.schemata where schema_name='nosok') as nosok_schema_exists,
    exists(
      select 1 from information_schema.tables
      where table_schema='core'
        and (
          table_name ilike '%govern%'
          or table_name ilike '%محافظ%'
          or table_name ilike '%lgu%'
          or table_name ilike '%local%'
          or table_name ilike '%بلد%'
          or table_name ilike '%هيئ%'
        )
    ) as core_geo_reference_candidates_exist,
    exists(
      select 1 from information_schema.tables
      where table_schema='core'
        and (table_name ilike '%org_unit%' or table_name ilike '%unit%' or table_name ilike '%director%' or table_name ilike '%مدير%')
    ) as core_org_unit_candidates_exist,
    exists(
      select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace
      where n.nspname='public' and p.proname ilike 'rpc_nosok%'
    ) as nosok_rpc_collision_or_existing_surface
)
select
  '15_safe_apply_decision_helper' as section,
  core_schema_exists,
  platform_schema_exists,
  public_schema_exists,
  nosok_schema_exists,
  core_geo_reference_candidates_exist,
  core_org_unit_candidates_exist,
  nosok_rpc_collision_or_existing_surface,
  case
    when not core_schema_exists then 'BLOCKED: core schema missing; cannot bind sovereign LGU/governorates.'
    when not core_geo_reference_candidates_exist then 'BLOCKED/REVIEW: no core LGU/governorate candidates discovered; inspect core manually.'
    when nosok_schema_exists then 'REVIEW: nosok schema already exists; decide reuse/migrate/archive before any apply.'
    when nosok_rpc_collision_or_existing_surface then 'REVIEW: public rpc_nosok* already exists; avoid collision before applying wrappers.'
    else 'DISCOVERY_OK_FOR_REVIEW: schema apply may be prepared after human review; this is not production approval.'
  end as apply_gate_decision
from flags;

-- -----------------------------------------------------------------------------
-- 16. Final sovereign boundary assertion
-- -----------------------------------------------------------------------------
select
  '16_sovereign_boundary' as section,
  'no_waq_assets_mutation' as check_key,
  true as passed,
  'This census contains SELECT statements only and does not touch waqf_assets, waqf, or awqaf_system.' as note
union all
select
  '16_sovereign_boundary',
  'core_reference_read_only',
  true,
  'Core is inspected as sovereign reference source only; no writes to core/platform/gis/public admin surfaces.';
