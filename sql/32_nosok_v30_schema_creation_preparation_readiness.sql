-- Nosok v30 — Schema Creation Preparation Readiness
-- Purpose: Documentation/readiness marker only.
-- This file intentionally does NOT create schemas, tables, policies, functions, or data.
-- Nosok schema creation is deferred until after full PalWakf repo merge.

select
  'nosok_v30_schema_creation_preparation' as check_key,
  true as passed,
  'No SQL apply is required or allowed in v30. Create nosok schema only after PalWakf merge and sandbox approval.' as note;

select
  'no_waq_assets_mutation' as check_key,
  true as passed,
  'This readiness marker performs no DDL/DML and does not touch waqf_assets, waqf, or awqaf_system.' as note;
