-- Nosok v30 — Apply Result Intake Read-Only Gate
-- Purpose: verify whether guarded owner schema DDL was applied by an operator.
-- Safety: SELECT-only. No DDL. No DML. No public base table creation. No waqf mutation.

with schema_presence as (
  select jsonb_build_object(
    'decision', 'NOSOK_V30_APPLY_RESULT_INTAKE_READ_ONLY',
    'nosok_present', exists(select 1 from information_schema.schemata where schema_name = 'nosok'),
    'core_present', exists(select 1 from information_schema.schemata where schema_name = 'core'),
    'public_present', exists(select 1 from information_schema.schemata where schema_name = 'public'),
    'billing_system_present', exists(select 1 from information_schema.schemata where schema_name = 'billing_system'),
    'platform_access_present', exists(select 1 from information_schema.schemata where schema_name = 'platform_access'),
    'waqf_present', exists(select 1 from information_schema.schemata where schema_name = 'waqf'),
    'awqaf_system_present', exists(select 1 from information_schema.schemata where schema_name = 'awqaf_system')
  ) payload
),
expected_nosok_objects as (
  select * from (values
    ('campaigns'),
    ('applications'),
    ('application_documents'),
    ('eligibility_rules'),
    ('quota_rules'),
    ('lgu_quotas'),
    ('workflow_events'),
    ('audit_events')
  ) as t(object_name)
),
nosok_object_status as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'schema', 'nosok',
    'object', e.object_name,
    'present_as_base_table', exists (
      select 1 from information_schema.tables t
      where t.table_schema = 'nosok'
        and t.table_name = e.object_name
        and t.table_type = 'BASE TABLE'
    )
  ) order by e.object_name), '[]'::jsonb) payload
  from expected_nosok_objects e
),
public_base_table_guard as (
  select jsonb_build_object(
    'decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
    'new_public_nosok_base_tables_detected', exists (
      select 1 from information_schema.tables
      where table_schema = 'public'
        and table_type = 'BASE TABLE'
        and table_name like 'nosok%'
    ),
    'public_base_table_creation_allowed', false
  ) payload
),
rls_status as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'table', c.relname,
    'rls_enabled', c.relrowsecurity,
    'rls_forced', c.relforcerowsecurity
  ) order by c.relname), '[]'::jsonb) payload
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'nosok'
    and c.relkind = 'r'
),
final_gate as (
  select jsonb_build_object(
    'decision', case
      when exists(select 1 from information_schema.schemata where schema_name = 'nosok')
      then 'NOSOK_SCHEMA_DETECTED_REQUIRES_RLS_RPC_NEGATIVE_UAT_RESULT_REVIEW'
      else 'NOSOK_SCHEMA_NOT_DETECTED_APPLY_RESULT_PENDING'
    end,
    'read_only', true,
    'ddl_executed_by_this_script', false,
    'dml_executed_by_this_script', false,
    'create_table_public_authorized', false,
    'waqf_assets_mutation_authorized', false,
    'controlled_apply_result_required', true,
    'production_approved', false
  ) payload
)
select '01_schema_presence' as section, payload from schema_presence
union all
select '02_expected_nosok_object_status' as section, payload from nosok_object_status
union all
select '03_public_base_table_guard' as section, payload from public_base_table_guard
union all
select '04_rls_status_if_any' as section, payload from rls_status
union all
select '05_final_gate' as section, payload from final_gate
order by section;
