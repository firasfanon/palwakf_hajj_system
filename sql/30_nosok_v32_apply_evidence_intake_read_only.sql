
-- NOSOK v32 — Controlled Staging DDL Apply Evidence Intake + Post-Apply Census/RLS Result Closure
-- READ ONLY. This script does not execute DDL/DML and does not create nosok/public objects.

select '01_schema_presence' as section,
       jsonb_build_object(
         'decision','NOSOK_V32_CONTROLLED_APPLY_EVIDENCE_READ_ONLY',
         'nosok_present', exists(select 1 from information_schema.schemata where schema_name = 'nosok'),
         'public_present', exists(select 1 from information_schema.schemata where schema_name = 'public'),
         'core_present', exists(select 1 from information_schema.schemata where schema_name = 'core'),
         'waqf_present', exists(select 1 from information_schema.schemata where schema_name = 'waqf'),
         'awqaf_system_present', exists(select 1 from information_schema.schemata where schema_name = 'awqaf_system'),
         'billing_system_present', exists(select 1 from information_schema.schemata where schema_name = 'billing_system'),
         'platform_access_present', exists(select 1 from information_schema.schemata where schema_name = 'platform_access')
       ) as payload
union all
select '02_expected_nosok_object_status' as section,
       coalesce(jsonb_agg(jsonb_build_object(
         'schema_name', candidate.schema_name,
         'object_name', candidate.object_name,
         'present_as_base_table', exists (
           select 1 from information_schema.tables t
           where t.table_schema = candidate.schema_name
             and t.table_name = candidate.object_name
             and t.table_type = 'BASE TABLE'
         )
       ) order by candidate.object_name), '[]'::jsonb) as payload
from (
  values
    ('nosok','campaigns'),
    ('nosok','applications'),
    ('nosok','application_documents'),
    ('nosok','eligibility_rules'),
    ('nosok','quota_rules'),
    ('nosok','lgu_quotas'),
    ('nosok','workflow_events'),
    ('nosok','audit_events')
) as candidate(schema_name, object_name)
union all
select '03_public_base_table_guard' as section,
       jsonb_build_object(
         'decision','PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
         'public_nosok_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name like '%nosok%'),
         'public_hajj_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name like '%hajj%'),
         'public_umrah_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name like '%umrah%'),
         'new_public_service_base_tables_detected', exists(select 1 from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and (table_name like '%nosok%' or table_name like '%hajj%' or table_name like '%umrah%'))
       ) as payload
union all
select '04_rls_status_if_any' as section,
       coalesce(jsonb_agg(jsonb_build_object(
         'schema_name', schemaname,
         'table_name', tablename,
         'rls_enabled', rowsecurity
       ) order by tablename), '[]'::jsonb) as payload
from pg_tables
where schemaname = 'nosok'
union all
select '05_final_gate' as section,
       jsonb_build_object(
         'decision', case
           when exists(select 1 from information_schema.schemata where schema_name='nosok')
            and not exists(select 1 from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and (table_name like '%nosok%' or table_name like '%hajj%' or table_name like '%umrah%'))
           then 'NOSOK_V32_POST_APPLY_CENSUS_PRESENT_REQUIRES_RLS_NEGATIVE_UAT_REVIEW'
           else 'NOSOK_V32_CONTROLLED_APPLY_NOT_CERTIFIED_YET'
         end,
         'read_only', true,
         'ddl_executed_by_this_script', false,
         'dml_executed_by_this_script', false,
         'production_approved', false,
         'create_table_public_authorized', false,
         'waqf_assets_mutation_authorized', false
       ) as payload;
