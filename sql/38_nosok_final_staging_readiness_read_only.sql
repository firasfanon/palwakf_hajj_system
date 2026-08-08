-- Nosok v38 read-only readiness marker.
-- Safe to run: no DDL, no DML, no waqf_assets mutation.
select
  'nosok_v38_final_staging_readiness'::text as check_key,
  'schema_not_created_by_design'::text as database_state,
  'palwakf_merge_required_before_runtime_binding'::text as next_gate,
  true as no_waqf_assets_mutation;
