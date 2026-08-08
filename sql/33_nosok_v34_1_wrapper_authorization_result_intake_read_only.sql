-- Nosok v34.1 — Wrapper Authorization Result Intake Read-Only
-- Safe to run. No DDL/DML. Does not create public base tables.

with schema_presence as (
  select jsonb_build_object(
    'decision', 'NOSOK_V34_1_WRAPPER_AUTHORIZATION_RESULT_INTAKE_READ_ONLY',
    'read_only', true,
    'core_present', exists(select 1 from information_schema.schemata where schema_name = 'core'),
    'nosok_present', exists(select 1 from information_schema.schemata where schema_name = 'nosok'),
    'public_present', exists(select 1 from information_schema.schemata where schema_name = 'public'),
    'billing_system_present', exists(select 1 from information_schema.schemata where schema_name = 'billing_system'),
    'platform_access_present', exists(select 1 from information_schema.schemata where schema_name = 'platform_access')
  ) as payload
), expected_tables as (
  select jsonb_agg(jsonb_build_object('schema_name', 'nosok', 'table_name', t.table_name, 'present_as_base_table', exists(
    select 1 from information_schema.tables it where it.table_schema = 'nosok' and it.table_name = t.table_name and it.table_type = 'BASE TABLE'
  )) order by t.table_name) as payload
  from (values
    ('campaigns'), ('applications'), ('application_documents'), ('eligibility_rules'),
    ('quota_rules'), ('lgu_quotas'), ('workflow_events'), ('audit_events')
  ) as t(table_name)
), wrapper_status as (
  select jsonb_agg(jsonb_build_object(
    'object_name', w.object_name,
    'object_kind', w.object_kind,
    'present', case when w.object_kind = 'view' then exists(select 1 from information_schema.views v where v.table_schema='public' and v.table_name=w.object_name)
                    else exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname=w.object_name) end
  ) order by w.object_name) as payload
  from (values
    ('v_nosok_campaigns_public_v1','view'),
    ('v_nosok_requirements_public_v1','view'),
    ('rpc_nosok_campaigns_public_list_v1','function'),
    ('rpc_nosok_requirements_public_list_v1','function'),
    ('rpc_nosok_application_submit_v1','function'),
    ('rpc_nosok_application_track_v1','function')
  ) as w(object_name, object_kind)
), public_base_table_guard as (
  select jsonb_build_object(
    'decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
    'public_nosok_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%nosok%'),
    'public_hajj_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%hajj%'),
    'public_umrah_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%umrah%'),
    'public_base_table_creation_authorized_by_this_script', false
  ) as payload
), final_gate as (
  select jsonb_build_object(
    'decision', 'NOSOK_V34_1_WRAPPER_APPLY_STILL_REQUIRES_OPERATOR_AUTHORIZATION',
    'read_only', true,
    'ddl_executed_by_this_script', false,
    'dml_executed_by_this_script', false,
    'public_wrapper_apply_executed_by_this_script', false,
    'repository_binding_authorized', false,
    'production_approved', false,
    'waqf_assets_mutation_authorized', false
  ) as payload
)
select '01_schema_presence' as section, payload from schema_presence
union all select '02_expected_table_status', payload from expected_tables
union all select '03_wrapper_status', payload from wrapper_status
union all select '04_public_base_table_guard', payload from public_base_table_guard
union all select '05_final_gate', payload from final_gate;
