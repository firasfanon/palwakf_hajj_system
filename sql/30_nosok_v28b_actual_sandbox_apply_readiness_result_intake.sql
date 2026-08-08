-- Nosok v28B — Actual Sandbox SQL Apply Evidence + Readiness RPC Result Intake
-- Purpose: read-only evidence intake after applying the v28 lottery backend draft in a sandbox.
-- Safety: SELECT only. No DDL. No DML. No waqf/waqf_assets/awqaf_system mutation.
-- Expected use:
--   1) Run the v28 schema/RPC draft in a reviewed Supabase sandbox only.
--   2) Run this file and attach the result table.
--   3) Do not enable backend binding unless all required checks pass and role UAT is scheduled.

with required_tables(object_name) as (
  values
    ('lottery_policies'),
    ('lgu_quota_snapshots'),
    ('lottery_eligibility_snapshots'),
    ('lottery_draw_runs'),
    ('lottery_draw_results'),
    ('lottery_committee_decisions'),
    ('lottery_objections'),
    ('lottery_audit_events')
), table_checks as (
  select
    'required_tables'::text as section,
    object_name as check_key,
    (to_regclass('nosok.' || object_name) is not null) as passed,
    case when to_regclass('nosok.' || object_name) is not null
      then 'nosok.' || object_name || ' exists after sandbox apply.'
      else 'nosok.' || object_name || ' is missing; backend binding must remain disabled.'
    end as note
  from required_tables
), required_rpcs(proname) as (
  values
    ('rpc_nosok_lottery_public_result_v1'),
    ('rpc_nosok_lottery_submit_objection_v1'),
    ('rpc_nosok_lottery_admin_policy_snapshot_v1'),
    ('rpc_nosok_lottery_admin_freeze_eligibility_v1'),
    ('rpc_nosok_lottery_admin_execute_draw_v1'),
    ('rpc_nosok_lottery_committee_decision_v1'),
    ('rpc_nosok_v28_lottery_backend_readiness_v1')
), rpc_checks as (
  select
    'required_rpcs'::text as section,
    proname as check_key,
    exists (
      select 1
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public'
        and p.proname = required_rpcs.proname
    ) as passed,
    case when exists (
      select 1
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public'
        and p.proname = required_rpcs.proname
    )
      then 'public.' || proname || ' exists.'
      else 'public.' || proname || ' is missing; affected frontend binding must remain preview/disabled.'
    end as note
  from required_rpcs
), rls_checks as (
  select
    'rls_enabled'::text as section,
    t.object_name as check_key,
    coalesce(c.relrowsecurity, false) as passed,
    case when coalesce(c.relrowsecurity, false)
      then 'RLS enabled on nosok.' || t.object_name || '.'
      else 'RLS is not enabled or table is missing; backend binding must remain disabled.'
    end as note
  from required_tables t
  left join pg_class c on c.relname = t.object_name
  left join pg_namespace n on n.oid = c.relnamespace and n.nspname = 'nosok'
), direct_public_table_guard as (
  select
    'public_exposure_guard'::text as section,
    'no_public_lottery_tables_expected'::text as check_key,
    not exists (
      select 1
      from pg_class c
      join pg_namespace n on n.oid = c.relnamespace
      where n.nspname = 'public'
        and c.relkind in ('r','p')
        and c.relname like 'lottery_%'
    ) as passed,
    'Lottery storage should remain in nosok schema; public is for RPC wrappers only.'::text as note
), readiness_rpc_contract as (
  select
    'readiness_rpc_contract'::text as section,
    'rpc_nosok_v28_lottery_backend_readiness_v1_exists'::text as check_key,
    exists (
      select 1
      from pg_proc p
      join pg_namespace n on n.oid = p.pronamespace
      where n.nspname = 'public'
        and p.proname = 'rpc_nosok_v28_lottery_backend_readiness_v1'
    ) as passed,
    'If this check passes, run select * from public.rpc_nosok_v28_lottery_backend_readiness_v1() and attach the output for binding decision.'::text as note
), sovereign_boundary as (
  select
    'sovereign_boundary'::text as section,
    'no_waqf_assets_mutation_in_this_script'::text as check_key,
    true as passed,
    'This read-only intake does not touch waqf_assets, waqf schema, or awqaf_system.'::text as note
)
select * from table_checks
union all select * from rpc_checks
union all select * from rls_checks
union all select * from direct_public_table_guard
union all select * from readiness_rpc_contract
union all select * from sovereign_boundary
order by section, check_key;
