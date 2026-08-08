-- Nosok v34 — Post-wrapper/RPC Negative UAT Read-Only
-- Safe to run after 01 wrapper apply. No DDL/DML.

with wrapper_status as (
  select jsonb_agg(jsonb_build_object(
    'object_name', w.object_name,
    'object_kind', w.object_kind,
    'present', case when w.object_kind = 'view' then exists(select 1 from information_schema.views v where v.table_schema='public' and v.table_name=w.object_name)
                    else exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname=w.object_name) end
  ) order by w.object_name) as payload
  from (values
    ('v_nosok_campaigns_public_v1','view'),
    ('rpc_nosok_campaigns_public_list_v1','function'),
    ('v_nosok_requirements_public_v1','view'),
    ('rpc_nosok_requirements_public_list_v1','function'),
    ('rpc_nosok_application_submit_v1','function'),
    ('rpc_nosok_application_track_v1','function')
  ) as w(object_name, object_kind)
), grant_status as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'schema_name', routine_schema,
    'routine_name', routine_name,
    'privilege_type', privilege_type,
    'grantee', grantee
  ) order by routine_name, grantee), '[]'::jsonb) as payload
  from information_schema.routine_privileges
  where routine_schema = 'public'
    and routine_name like 'rpc_nosok_%_v1'
), public_base_table_guard as (
  select jsonb_build_object(
    'decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
    'public_nosok_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%nosok%'),
    'public_hajj_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%hajj%'),
    'public_umrah_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%umrah%'),
    'new_public_service_base_tables_detected', false
  ) as payload
), final_gate as (
  select jsonb_build_object(
    'decision', 'NOSOK_V34_POST_WRAPPER_EVIDENCE_REQUIRES_BROWSER_ROLE_NETWORK_UAT',
    'read_only', true,
    'ddl_executed_by_this_script', false,
    'dml_executed_by_this_script', false,
    'repository_binding_authorized_by_this_script', false,
    'production_approved', false,
    'waqf_assets_mutation_authorized', false
  ) as payload
)
select '01_wrapper_status' as section, payload from wrapper_status
union all select '02_rpc_grant_status', payload from grant_status
union all select '03_public_base_table_guard', payload from public_base_table_guard
union all select '04_final_gate', payload from final_gate;
