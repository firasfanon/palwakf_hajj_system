-- Nosok v31 — Authorization Token Evidence + Apply Certification Read-only Gate
-- READ ONLY. No DDL. No DML. No CREATE SCHEMA. No CREATE TABLE.

with schema_presence as (
  select
    exists(select 1 from information_schema.schemata where schema_name = 'nosok') as nosok_present,
    exists(select 1 from information_schema.schemata where schema_name = 'core') as core_present,
    exists(select 1 from information_schema.schemata where schema_name = 'public') as public_present,
    exists(select 1 from information_schema.schemata where schema_name = 'billing_system') as billing_system_present,
    exists(select 1 from information_schema.schemata where schema_name = 'platform_access') as platform_access_present,
    exists(select 1 from information_schema.schemata where schema_name = 'waqf') as waqf_present,
    exists(select 1 from information_schema.schemata where schema_name = 'awqaf_system') as awqaf_system_present
), expected_objects as (
  select * from (values
    ('nosok','campaigns'),
    ('nosok','applications'),
    ('nosok','application_documents'),
    ('nosok','eligibility_rules'),
    ('nosok','quota_rules'),
    ('nosok','lgu_quotas'),
    ('nosok','workflow_events'),
    ('nosok','audit_events')
  ) as v(schema_name, object_name)
), object_status as (
  select
    e.schema_name,
    e.object_name,
    exists(
      select 1 from information_schema.tables t
      where t.table_schema = e.schema_name
        and t.table_name = e.object_name
        and t.table_type = 'BASE TABLE'
    ) as present_as_base_table
  from expected_objects e
), rls_status as (
  select
    n.nspname as schema_name,
    c.relname as table_name,
    c.relrowsecurity as rls_enabled,
    c.relforcerowsecurity as force_rls
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'nosok'
    and c.relkind = 'r'
), public_guard as (
  select
    count(*) filter (where table_schema = 'public' and table_name like 'nosok_%' and table_type = 'BASE TABLE') as public_nosok_base_tables,
    count(*) filter (where table_schema = 'public' and table_name like 'hajj_%' and table_type = 'BASE TABLE') as public_hajj_base_tables,
    count(*) filter (where table_schema = 'public' and table_name like 'umrah_%' and table_type = 'BASE TABLE') as public_umrah_base_tables
  from information_schema.tables
)
select '01_schema_presence' as section,
       jsonb_build_object(
         'decision','NOSOK_V31_AUTHORIZATION_APPLY_CERTIFICATION_READ_ONLY',
         'nosok_present', nosok_present,
         'core_present', core_present,
         'public_present', public_present,
         'billing_system_present', billing_system_present,
         'platform_access_present', platform_access_present,
         'waqf_present', waqf_present,
         'awqaf_system_present', awqaf_system_present
       ) as payload
from schema_presence
union all
select '02_expected_object_status' as section,
       coalesce(jsonb_agg(to_jsonb(object_status) order by object_name), '[]'::jsonb) as payload
from object_status
union all
select '03_rls_status_if_any' as section,
       coalesce(jsonb_agg(to_jsonb(rls_status) order by table_name), '[]'::jsonb) as payload
from rls_status
union all
select '04_public_base_table_guard' as section,
       jsonb_build_object(
         'decision','PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
         'public_nosok_base_tables', public_nosok_base_tables,
         'public_hajj_base_tables', public_hajj_base_tables,
         'public_umrah_base_tables', public_umrah_base_tables,
         'new_public_service_base_tables_detected', (public_nosok_base_tables + public_hajj_base_tables + public_umrah_base_tables) > 0
       ) as payload
from public_guard
union all
select '05_final_gate' as section,
       jsonb_build_object(
         'decision', case
           when (select nosok_present from schema_presence) is true
            and not exists(select 1 from object_status where present_as_base_table is false)
            and not exists(select 1 from rls_status where rls_enabled is false)
            and (select public_nosok_base_tables + public_hajj_base_tables + public_umrah_base_tables from public_guard) = 0
             then 'NOSOK_V31_POST_APPLY_OBJECTS_AND_RLS_DETECTED_REQUIRES_NEGATIVE_UAT'
           else 'NOSOK_V31_APPLY_NOT_CERTIFIED_OR_POST_APPLY_EVIDENCE_INCOMPLETE'
         end,
         'read_only', true,
         'ddl_executed_by_this_script', false,
         'dml_executed_by_this_script', false,
         'controlled_apply_certified_by_this_script', false,
         'production_approved', false,
         'create_table_public_authorized', false,
         'waqf_assets_mutation_authorized', false
       ) as payload;
