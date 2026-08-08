-- Nosok v38I — Core Reference Shape Discovery
-- READ ONLY. No DDL. No DML.
-- Purpose: discover sovereign reference shapes in core before creating hard FK/mapping.

select
  'core_reference_candidate_tables' as section,
  table_schema,
  table_name,
  table_type
from information_schema.tables
where table_schema = 'core'
  and (
    table_name ilike '%governor%'
    or table_name ilike '%محافظ%'
    or table_name ilike '%lgu%'
    or table_name ilike '%local%'
    or table_name ilike '%unit%'
    or table_name ilike '%profile%'
  )
order by table_schema, table_name;

select
  'core_reference_candidate_columns' as section,
  table_schema,
  table_name,
  column_name,
  data_type,
  udt_name,
  is_nullable
from information_schema.columns
where table_schema = 'core'
  and (
    table_name ilike '%governor%'
    or table_name ilike '%محافظ%'
    or table_name ilike '%lgu%'
    or table_name ilike '%local%'
    or table_name ilike '%unit%'
    or table_name ilike '%profile%'
  )
order by table_name, ordinal_position;

select
  'platform_rbac_reference_candidate_tables' as section,
  table_schema,
  table_name,
  table_type
from information_schema.tables
where table_schema = 'platform'
  and (
    table_name ilike '%role%'
    or table_name ilike '%permission%'
    or table_name ilike '%system%'
    or table_name ilike '%section%'
  )
order by table_name;

select
  'public_admin_auth_surface_presence' as section,
  exists(select 1 from information_schema.tables where table_schema = 'public' and table_name = 'admin_users') as public_admin_users_exists,
  exists(select 1 from information_schema.schemata where schema_name = 'auth') as auth_schema_exists,
  exists(select 1 from information_schema.schemata where schema_name = 'core') as core_schema_exists,
  exists(select 1 from information_schema.schemata where schema_name = 'platform') as platform_schema_exists,
  true as no_waq_assets_mutation;

select
  'decision' as section,
  'core is sovereign source for LGU/governorates/org_units; public is wrapper surface only; do not create FK until object names and columns are confirmed.' as note;
