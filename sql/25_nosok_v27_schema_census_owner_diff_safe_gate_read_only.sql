-- Nosok v27 — Schema Census + Owner Diff + Safe SQL Execution Gate
-- Execution mode: READ ONLY. This script must not create, alter, insert, update, delete, grant, revoke, or call service_role.
-- Purpose: validate the database state before any future guarded owner-schema build for nosok.*.

with schema_summary as (
  select
    n.nspname as schema_name,
    count(*) filter (where c.relkind = 'r') as base_tables,
    count(*) filter (where c.relkind = 'v') as views,
    count(*) filter (where c.relkind = 'S') as sequences,
    count(*) filter (where c.relkind = 'm') as materialized_views
  from pg_namespace n
  left join pg_class c on c.relnamespace = n.oid
  where n.nspname not like 'pg_%'
    and n.nspname <> 'information_schema'
  group by n.nspname
), public_base_tables as (
  select table_name
  from information_schema.tables
  where table_schema = 'public'
    and table_type = 'BASE TABLE'
), core_reference_objects as (
  select table_schema, table_name, table_type
  from information_schema.tables
  where table_schema = 'core'
    and (
      table_name ilike '%org_unit%'
      or table_name ilike '%lgu%'
      or table_name ilike '%governorate%'
      or table_name ilike '%communit%'
    )
), duplicate_relevant_names as (
  select table_name, array_agg(table_schema order by table_schema) as schemas, count(distinct table_schema) as schema_count
  from information_schema.tables
  where table_schema in ('core', 'public', 'billing_system', 'platform_access', 'nosok', 'waqf', 'awqaf_system')
    and (
      table_name ilike '%org_unit%'
      or table_name ilike '%lgu%'
      or table_name ilike '%governorate%'
      or table_name ilike '%payment%'
      or table_name ilike '%application%'
      or table_name ilike '%waqf%'
    )
  group by table_name
  having count(distinct table_schema) > 1
)
select *
from (
  select
    '01_schema_presence' as section,
    jsonb_build_object(
      'decision', 'NOSOK_V27_SCHEMA_CENSUS_GATE_READ_ONLY',
      'nosok_present', exists(select 1 from pg_namespace where nspname = 'nosok'),
      'core_present', exists(select 1 from pg_namespace where nspname = 'core'),
      'public_present', exists(select 1 from pg_namespace where nspname = 'public'),
      'billing_system_present', exists(select 1 from pg_namespace where nspname = 'billing_system'),
      'platform_access_present', exists(select 1 from pg_namespace where nspname = 'platform_access'),
      'waqf_present', exists(select 1 from pg_namespace where nspname = 'waqf'),
      'awqaf_system_present', exists(select 1 from pg_namespace where nspname = 'awqaf_system')
    ) as payload

  union all

  select
    '02_schema_summary' as section,
    coalesce(jsonb_agg(to_jsonb(schema_summary) order by schema_name), '[]'::jsonb) as payload
  from schema_summary

  union all

  select
    '03_public_base_table_gate' as section,
    jsonb_build_object(
      'decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
      'public_base_table_count', (select count(*) from public_base_tables),
      'new_public_base_table_creation_allowed', false,
      'existing_public_base_tables', coalesce((select jsonb_agg(table_name order by table_name) from public_base_tables), '[]'::jsonb)
    ) as payload

  union all

  select
    '04_core_reference_reuse' as section,
    jsonb_build_object(
      'decision', 'CORE_REFERENCE_REUSE_REQUIRED_DO_NOT_DUPLICATE_AS_TRUTH',
      'core_reference_candidates', coalesce((select jsonb_agg(to_jsonb(core_reference_objects) order by table_name) from core_reference_objects), '[]'::jsonb)
    ) as payload

  union all

  select
    '05_duplicate_relevant_names' as section,
    coalesce(jsonb_agg(to_jsonb(duplicate_relevant_names) order by table_name), '[]'::jsonb) as payload
  from duplicate_relevant_names

  union all

  select
    '06_safe_sql_execution_gate' as section,
    jsonb_build_object(
      'read_only', true,
      'ddl_executed_by_this_script', false,
      'dml_executed_by_this_script', false,
      'create_schema_nosok_authorized', false,
      'create_table_public_authorized', false,
      'create_table_nosok_authorized', false,
      'waqf_assets_mutation_authorized', false,
      'production_approved', false,
      'decision', 'SQL_EXECUTION_BLOCKED_OWNER_REVIEW_AND_EXPLICIT_AUTHORIZATION_REQUIRED'
    ) as payload
) result
order by section;
