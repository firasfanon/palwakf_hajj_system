-- Nosok v29 — Owner Schema DDL Authorization Preflight (READ ONLY)
-- Purpose: verify that the environment is still safe before any guarded staging DDL is reviewed.
-- This file MUST NOT execute DDL/DML/GRANT/REVOKE and MUST NOT create nosok/public tables.

with schema_presence as (
  select
    exists (select 1 from information_schema.schemata where schema_name = 'nosok') as nosok_present,
    exists (select 1 from information_schema.schemata where schema_name = 'core') as core_present,
    exists (select 1 from information_schema.schemata where schema_name = 'public') as public_present,
    exists (select 1 from information_schema.schemata where schema_name = 'billing_system') as billing_system_present,
    exists (select 1 from information_schema.schemata where schema_name = 'platform_access') as platform_access_present,
    exists (select 1 from information_schema.schemata where schema_name = 'waqf') as waqf_present,
    exists (select 1 from information_schema.schemata where schema_name = 'awqaf_system') as awqaf_system_present
), public_tables as (
  select count(*)::int as public_base_table_count
  from information_schema.tables
  where table_schema = 'public' and table_type = 'BASE TABLE'
), candidate_conflicts as (
  select jsonb_agg(to_jsonb(x) order by x.object_name) as conflicts
  from (
    select table_schema, table_name as object_name, table_type
    from information_schema.tables
    where (table_schema = 'nosok' and table_name in (
      'campaigns','applications','application_documents','eligibility_rules','quota_rules','lgu_quotas','workflow_events','audit_events'
    ))
       or (table_schema = 'public' and table_name like 'nosok%')
  ) x
), final_gate as (
  select jsonb_build_object(
    'decision', 'NOSOK_V29_AUTHORIZATION_PREFLIGHT_READ_ONLY_COMPLETED',
    'read_only', true,
    'ddl_executed_by_this_script', false,
    'dml_executed_by_this_script', false,
    'create_schema_nosok_authorized_by_this_script', false,
    'create_table_public_authorized', false,
    'waqf_assets_mutation_authorized', false,
    'owner_authorization_required_for_guarded_apply', true
  ) as payload
)
select '01_schema_presence' as section, to_jsonb(schema_presence.*) as payload from schema_presence
union all
select '02_public_base_table_gate', jsonb_build_object(
  'decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
  'public_base_table_count', public_base_table_count,
  'new_public_base_table_creation_allowed', false
) from public_tables
union all
select '03_candidate_conflicts', coalesce(conflicts, '[]'::jsonb) from candidate_conflicts
union all
select '04_final_gate', payload from final_gate
order by section;
