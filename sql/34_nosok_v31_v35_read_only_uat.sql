-- Nosok v31-v35 — read-only UAT after PalWakf merge / schema draft review
-- This script is safe to run as a read-only readiness check. It does not create or modify data.

with checks as (
  select 'no_waq_assets_mutation_in_this_script'::text as check_key, true as passed,
         'Read-only UAT; no DML and no waqf/waqf_assets touch.'::text as note
  union all
  select 'nosok_schema_expected_after_merge', false,
         'nosok schema is intentionally not required before PalWakf merge.'
  union all
  select 'backend_binding_expected_after_rpc', false,
         'Repository binding remains disabled until nosok RPCs are deployed and UAT passes.'
  union all
  select 'production_candidate_expected_after_uat', false,
         'Production candidate remains deferred until Browser/Role/Responsive UAT inside PalWakf.'
)
select * from checks;
