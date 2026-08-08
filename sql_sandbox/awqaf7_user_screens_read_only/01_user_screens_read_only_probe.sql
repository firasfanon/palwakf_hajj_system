-- Awqaf System 7 — Waqf Assets User Screens Read-Only Probe
-- Purpose: inventory only. Do not execute DDL/DML/GRANT/REVOKE here.

select
  'AWQAF7_USER_SCREENS_READ_ONLY_PROBE' as section,
  exists (
    select 1
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname = 'rpc_waqf_assets_runtime_auth_gate_v1'
  ) as runtime_auth_gate_rpc_present,
  exists (
    select 1
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname = 'rpc_waqf_assets_search_v1'
  ) as search_rpc_present,
  exists (
    select 1
    from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public'
      and p.proname = 'rpc_waqf_asset_source_records_v1'
  ) as source_records_rpc_present,
  false as ddl_dml_authorized,
  false as write_review_apply_authorized,
  false as waqf_assets_mutation_authorized,
  true as read_only;
