-- Nosok v36 Seasonal Operations Contract Readiness
-- READ-ONLY / DESIGN MARKER ONLY
-- No CREATE / ALTER / INSERT / UPDATE / DELETE.
-- No waqf_assets / waqf / awqaf_system mutation.

select
  'nosok_v36_seasonal_operations_contract_readiness' as check_key,
  true as passed,
  'V36 defines advanced reports, payment bridge, document intelligence bridge, assistant bridge, campaign/company operations, UX rules, and ministry policy addons as contracts only until PalWakf merge and nosok schema creation.' as note;

select
  'no_waq_assets_mutation_in_this_script' as check_key,
  true as passed,
  'This script is read-only and contains no DML/DDL.' as note;
