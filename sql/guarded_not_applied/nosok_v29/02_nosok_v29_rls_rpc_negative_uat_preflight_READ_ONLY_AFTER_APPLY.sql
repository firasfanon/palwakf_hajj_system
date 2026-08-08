-- Nosok v29 — RLS/RPC/Negative UAT Preflight (READ ONLY AFTER STAGING APPLY)
-- Run only after guarded staging apply has been executed by authorized DBA/operator.

with expected_tables as (
  select unnest(array[
    'campaigns','applications','application_documents','eligibility_rules','quota_rules','lgu_quotas','workflow_events','audit_events'
  ]) as table_name
), table_presence as (
  select e.table_name,
         exists (
           select 1 from information_schema.tables t
           where t.table_schema = 'nosok' and t.table_name = e.table_name and t.table_type = 'BASE TABLE'
         ) as present
  from expected_tables e
), rls_status as (
  select c.relname as table_name, c.relrowsecurity as rls_enabled
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'nosok'
), public_nosok_base_tables as (
  select table_name
  from information_schema.tables
  where table_schema = 'public'
    and table_type = 'BASE TABLE'
    and table_name like 'nosok%'
), final_gate as (
  select jsonb_build_object(
    'decision', 'NOSOK_V29_NEGATIVE_UAT_PREFLIGHT_READ_ONLY',
    'read_only', true,
    'expected_tables_present', (select bool_and(present) from table_presence),
    'all_present_tables_have_rls', coalesce((select bool_and(rls_enabled) from rls_status where table_name in (select table_name from expected_tables)), false),
    'public_nosok_base_table_count', (select count(*) from public_nosok_base_tables),
    'waqf_assets_mutation_authorized', false
  ) as payload
)
select '01_table_presence' as section, jsonb_agg(to_jsonb(table_presence) order by table_name) as payload from table_presence
union all
select '02_rls_status', coalesce(jsonb_agg(to_jsonb(rls_status) order by table_name), '[]'::jsonb) from rls_status
union all
select '03_public_nosok_base_tables', coalesce(jsonb_agg(to_jsonb(public_nosok_base_tables) order by table_name), '[]'::jsonb) from public_nosok_base_tables
union all
select '04_final_gate', payload from final_gate
order by section;
