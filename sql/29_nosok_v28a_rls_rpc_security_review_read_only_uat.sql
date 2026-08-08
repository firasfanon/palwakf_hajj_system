-- Nosok v28A — RLS/RPC Security Review Read-only UAT
-- Purpose: inspect sandbox readiness after the v28 lottery backend draft is applied.
-- Safety: read-only SELECTs only. No DDL. No DML. No waqf/waqf_assets mutation.

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
    'table_exists'::text as section,
    object_name as check_key,
    (to_regclass('nosok.' || object_name) is not null) as passed,
    case when to_regclass('nosok.' || object_name) is not null
      then 'nosok.' || object_name || ' exists.'
      else 'nosok.' || object_name || ' is missing.'
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
    'rpc_exists'::text as section,
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
      else 'public.' || proname || ' is missing.'
    end as note
  from required_rpcs
), rls_checks as (
  select
    'rls_enabled'::text as section,
    c.relname as check_key,
    c.relrowsecurity as passed,
    case when c.relrowsecurity then 'RLS enabled.' else 'RLS not enabled or table missing from nosok schema.' end as note
  from pg_class c
  join pg_namespace n on n.oid = c.relnamespace
  where n.nspname = 'nosok'
    and c.relname in (select object_name from required_tables)
), waqf_guard as (
  select
    'sovereign_boundary'::text as section,
    'no_waqf_assets_mutation_in_this_script'::text as check_key,
    true as passed,
    'Read-only UAT only; this script does not touch waqf_assets, waqf, or awqaf_system.'::text as note
)
select * from table_checks
union all
select * from rpc_checks
union all
select * from rls_checks
union all
select * from waqf_guard
order by section, check_key;
