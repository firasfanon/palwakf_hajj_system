
-- Nosok v33 — Post-Apply RLS/RPC Negative UAT Read-Only Evidence
-- READ ONLY. No DDL/DML. No GRANT/REVOKE. No public base table creation.

with schema_presence as (
  select jsonb_build_object(
    'decision', 'NOSOK_V33_POST_APPLY_RLS_RPC_NEGATIVE_UAT_READ_ONLY',
    'read_only', true,
    'nosok_present', exists(select 1 from information_schema.schemata where schema_name = 'nosok'),
    'public_present', exists(select 1 from information_schema.schemata where schema_name = 'public'),
    'core_present', exists(select 1 from information_schema.schemata where schema_name = 'core'),
    'billing_system_present', exists(select 1 from information_schema.schemata where schema_name = 'billing_system'),
    'platform_access_present', exists(select 1 from information_schema.schemata where schema_name = 'platform_access')
  ) as payload
), expected_tables as (
  select jsonb_agg(jsonb_build_object(
    'schema_name', 'nosok',
    'table_name', t.table_name,
    'present_as_base_table', exists (
      select 1 from information_schema.tables it
      where it.table_schema = 'nosok'
        and it.table_name = t.table_name
        and it.table_type = 'BASE TABLE'
    )
  ) order by t.table_name) as payload
  from (values
    ('application_documents'),
    ('applications'),
    ('audit_events'),
    ('campaigns'),
    ('eligibility_rules'),
    ('lgu_quotas'),
    ('quota_rules'),
    ('workflow_events')
  ) as t(table_name)
), rls_status as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'schema_name', n.nspname,
    'table_name', c.relname,
    'rls_enabled', c.relrowsecurity,
    'force_rls', c.relforcerowsecurity
  ) order by c.relname), '[]'::jsonb) as payload
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'nosok'
    and c.relkind = 'r'
    and c.relname in ('application_documents','applications','audit_events','campaigns','eligibility_rules','lgu_quotas','quota_rules','workflow_events')
), policy_summary as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'schema_name', schemaname,
    'table_name', tablename,
    'policy_name', policyname,
    'command', cmd,
    'roles', roles,
    'qual_present', qual is not null,
    'with_check_present', with_check is not null
  ) order by tablename, policyname), '[]'::jsonb) as payload
  from pg_policies
  where schemaname = 'nosok'
), public_guard as (
  select jsonb_build_object(
    'decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
    'public_nosok_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%nosok%'),
    'public_hajj_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%hajj%'),
    'public_umrah_base_tables', (select count(*) from information_schema.tables where table_schema='public' and table_type='BASE TABLE' and table_name ilike '%umrah%'),
    'new_public_service_base_tables_detected', false
  ) as payload
), draft_wrapper_presence as (
  select jsonb_build_object(
    'public_wrapper_apply_executed_by_this_script', false,
    'expected_wrappers_draft_only', jsonb_build_array(
      'public.v_nosok_campaigns_public_v1',
      'public.rpc_nosok_campaigns_public_list_v1',
      'public.rpc_nosok_application_submit_v1',
      'public.rpc_nosok_application_track_v1',
      'public.v_nosok_requirements_public_v1',
      'public.rpc_nosok_requirements_public_list_v1'
    )
  ) as payload
), final_gate as (
  select jsonb_build_object(
    'decision', 'NOSOK_V33_SQL_NEGATIVE_UAT_SQL_EVIDENCE_PRESENT_BROWSER_ROLE_SCOPE_EVIDENCE_STILL_REQUIRED',
    'read_only', true,
    'production_approved', false,
    'ddl_executed_by_this_script', false,
    'dml_executed_by_this_script', false,
    'create_table_public_authorized', false,
    'waqf_assets_mutation_authorized', false,
    'repository_binding_authorized', false,
    'public_wrapper_apply_authorized_by_this_script', false
  ) as payload
)
select '01_schema_presence' as section, payload from schema_presence
union all select '02_expected_table_status', payload from expected_tables
union all select '03_rls_status', payload from rls_status
union all select '04_policy_summary', payload from policy_summary
union all select '05_public_base_table_guard', payload from public_guard
union all select '06_public_wrapper_draft_status', payload from draft_wrapper_presence
union all select '07_final_gate', payload from final_gate;
