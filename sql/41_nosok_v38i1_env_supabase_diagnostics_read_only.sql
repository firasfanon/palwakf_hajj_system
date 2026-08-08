-- Nosok v38I-1 — Env-Based Supabase Binding Diagnostics Read-only Pack
-- Purpose: inspect the real development database environment before applying any nosok schema DDL.
-- Safety: READ ONLY. No CREATE/ALTER/INSERT/UPDATE/DELETE/DROP.

with schemas as (
  select nspname as schema_name
  from pg_namespace
  where nspname in ('nosok', 'core', 'platform', 'public', 'gis', 'auth', 'storage')
)
select
  'schema_presence' as section,
  s.schema_name,
  exists(select 1 from pg_namespace n where n.nspname = s.schema_name) as present
from (values ('nosok'), ('core'), ('platform'), ('public'), ('gis'), ('auth'), ('storage')) as s(schema_name)
order by s.schema_name;

select
  'nosok_object_presence' as section,
  n.nspname as source_schema,
  c.relname as object_name,
  c.relkind as relkind,
  obj_description(c.oid) as comment
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'nosok'
order by c.relkind, c.relname;

select
  'core_reference_candidate_objects' as section,
  table_schema,
  table_name,
  column_name,
  data_type
from information_schema.columns
where table_schema = 'core'
  and (
    lower(table_name) like '%governor%'
    or lower(table_name) like '%lgu%'
    or lower(table_name) like '%local%'
    or lower(table_name) like '%unit%'
    or lower(table_name) like '%profile%'
    or lower(column_name) in ('slug', 'unit_slug', 'governorate_id', 'lgu_id', 'code')
  )
order by table_schema, table_name, ordinal_position;

select
  'public_nosok_rpc_collision_check' as section,
  n.nspname as routine_schema,
  p.proname as routine_name,
  pg_get_function_arguments(p.oid) as arguments,
  pg_get_function_result(p.oid) as returns
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname like 'rpc_nosok_%'
order by p.proname;

select
  'rls_status_for_nosok' as section,
  schemaname,
  tablename,
  rowsecurity as rls_enabled,
  forcerowsecurity as rls_forced
from pg_tables
where schemaname = 'nosok'
order by tablename;
