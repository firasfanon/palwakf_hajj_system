-- Nosok v28 — Lottery Backend Read-only SQL UAT
-- Purpose: verify the v28 lottery backend schema/RPC contract after sandbox apply.
-- Safety: read-only checks only. No DDL, no DML, no waqf_assets mutation.

select
  'schema' as section,
  'nosok_schema_exists' as check_key,
  exists(select 1 from information_schema.schemata where schema_name = 'nosok') as passed,
  'Schema nosok exists.' as note;

select
  'tables' as section,
  table_name as object_name,
  case when table_name is not null then true else false end as present
from information_schema.tables
where table_schema = 'nosok'
  and table_name in (
    'lottery_policies',
    'lgu_quota_snapshots',
    'lottery_eligibility_snapshots',
    'lottery_draw_runs',
    'lottery_draw_results',
    'lottery_committee_decisions',
    'lottery_objections',
    'lottery_audit_events'
  )
order by table_name;

select
  'rpc' as section,
  p.proname as object_name,
  true as present
from pg_proc p
join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'public'
  and p.proname in (
    'rpc_nosok_lottery_public_result_v1',
    'rpc_nosok_lottery_submit_objection_v1',
    'rpc_nosok_lottery_admin_policy_snapshot_v1',
    'rpc_nosok_lottery_admin_freeze_eligibility_v1',
    'rpc_nosok_lottery_admin_execute_draw_v1',
    'rpc_nosok_lottery_committee_decision_v1',
    'rpc_nosok_v28_lottery_backend_readiness_v1'
  )
order by p.proname;

select
  'rls' as section,
  c.relname as table_name,
  c.relrowsecurity as rls_enabled
from pg_class c
join pg_namespace n on n.oid = c.relnamespace
where n.nspname = 'nosok'
  and c.relname in (
    'lottery_policies',
    'lgu_quota_snapshots',
    'lottery_eligibility_snapshots',
    'lottery_draw_runs',
    'lottery_draw_results',
    'lottery_committee_decisions',
    'lottery_objections',
    'lottery_audit_events'
  )
order by c.relname;

select
  'safety' as section,
  'no_waqf_assets_mutation_in_this_uat' as check_key,
  true as passed,
  'Read-only UAT only; no DML/DDL and no waqf_assets/waqf/awqaf_system touch.' as note;

-- Optional if the readiness RPC was applied in sandbox:
-- select * from public.rpc_nosok_v28_lottery_backend_readiness_v1();
