-- Nosok v32.1 Post-Apply Negative UAT Read-Only Gate
-- READ ONLY ONLY. No DDL. No DML. No GRANT. No REVOKE. No service_role.

with expected_tables(table_name) as (
  values
    ('campaigns'),
    ('applications'),
    ('application_documents'),
    ('eligibility_rules'),
    ('quota_rules'),
    ('lgu_quotas'),
    ('workflow_events'),
    ('audit_events')
), schema_presence as (
  select jsonb_build_object(
    'decision','NOSOK_V32_1_POST_APPLY_NEGATIVE_UAT_READ_ONLY',
    'nosok_present', exists(select 1 from information_schema.schemata where schema_name='nosok'),
    'public_present', exists(select 1 from information_schema.schemata where schema_name='public'),
    'core_present', exists(select 1 from information_schema.schemata where schema_name='core'),
    'billing_system_present', exists(select 1 from information_schema.schemata where schema_name='billing_system'),
    'platform_access_present', exists(select 1 from information_schema.schemata where schema_name='platform_access'),
    'read_only', true
  ) payload
), table_status as (
  select jsonb_agg(jsonb_build_object(
    'schema_name','nosok',
    'table_name', et.table_name,
    'present_as_base_table', exists(
      select 1
      from information_schema.tables t
      where t.table_schema='nosok'
        and t.table_name=et.table_name
        and t.table_type='BASE TABLE'
    )
  ) order by et.table_name) payload
  from expected_tables et
), rls_status as (
  select jsonb_agg(jsonb_build_object(
    'schema_name', n.nspname,
    'table_name', c.relname,
    'rls_enabled', c.relrowsecurity,
    'force_rls', c.relforcerowsecurity
  ) order by c.relname) payload
  from pg_class c
  join pg_namespace n on n.oid=c.relnamespace
  where n.nspname='nosok'
    and c.relkind='r'
    and c.relname in (select table_name from expected_tables)
), policy_summary as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'schema_name', schemaname,
    'table_name', tablename,
    'policy_name', policyname,
    'roles', roles,
    'command', cmd,
    'qual_present', qual is not null,
    'with_check_present', with_check is not null
  ) order by tablename, policyname), '[]'::jsonb) payload
  from pg_policies
  where schemaname='nosok'
    and tablename in (select table_name from expected_tables)
), public_guard as (
  select jsonb_build_object(
    'decision','PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
    'public_nosok_base_tables', count(*) filter (where table_schema='public' and table_name ilike '%nosok%' and table_type='BASE TABLE'),
    'public_hajj_base_tables', count(*) filter (where table_schema='public' and table_name ilike '%hajj%' and table_type='BASE TABLE'),
    'public_umrah_base_tables', count(*) filter (where table_schema='public' and table_name ilike '%umrah%' and table_type='BASE TABLE'),
    'new_public_service_base_tables_detected', (
      count(*) filter (where table_schema='public' and (table_name ilike '%nosok%' or table_name ilike '%hajj%' or table_name ilike '%umrah%') and table_type='BASE TABLE') > 0
    )
  ) payload
  from information_schema.tables
), final_gate as (
  select jsonb_build_object(
    'decision','NOSOK_V32_1_RLS_PRESENT_POLICY_NEGATIVE_UAT_REQUIRES_BROWSER_AND_ROLE_EVIDENCE',
    'read_only',true,
    'ddl_executed_by_this_script',false,
    'dml_executed_by_this_script',false,
    'production_approved',false,
    'create_table_public_authorized',false,
    'waqf_assets_mutation_authorized',false
  ) payload
)
select '01_schema_presence' section, payload from schema_presence
union all select '02_expected_table_status', payload from table_status
union all select '03_rls_status', coalesce(payload,'[]'::jsonb) from rls_status
union all select '04_policy_summary', payload from policy_summary
union all select '05_public_base_table_guard', payload from public_guard
union all select '06_final_gate', payload from final_gate;
