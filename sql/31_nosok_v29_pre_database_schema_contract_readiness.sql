-- Nosok v29 — Pre-Database Schema Contract Readiness
-- Purpose: design/readiness only. Do NOT execute as schema creation.
-- Context: The nosok schema will be created only after merging Nosok into PalWakf.
-- This file is intentionally non-mutating: no CREATE, no ALTER, no INSERT, no UPDATE, no DELETE.

select 'nosok_v29_pre_database_schema_contract' as check_key,
       true as passed,
       'Database schema is not created by design until PalWakf merge. This file is a contract/readiness marker only.' as note;

select * from (values
  ('nosok.seasons', 'season windows and lifecycle governance', 'design-finalized-not-created'),
  ('nosok.applications', 'service application root and public tracking contract', 'design-finalized-not-created'),
  ('nosok.applicants', 'applicant identity and official-card LGU mapping', 'design-finalized-not-created'),
  ('nosok.companions', 'companions/mahram and total_people_count for capacity-aware lottery', 'design-finalized-not-created'),
  ('nosok.documents', 'documents and storage/document-intelligence contract', 'design-finalized-not-created'),
  ('nosok.companies', 'qualified companies and partner workspace', 'design-finalized-not-created'),
  ('nosok.campaigns', 'campaigns, capacity and company assignment', 'design-finalized-not-created'),
  ('nosok.lottery_policies', 'seasonal ministry-editable lottery policy', 'design-finalized-not-created'),
  ('nosok.lgu_quota_snapshots', 'LGU quota snapshots from official address and population/quota inputs', 'design-finalized-not-created'),
  ('nosok.lottery_draw_runs/results/committee_decisions/objections/audit_events', 'lottery execution, public result, committee decisions, objections and audit', 'design-finalized-not-created')
) as v(contract_name, purpose, state);

select * from (values
  ('public.rpc_nosok_public_application_submit_v1', 'future controlled public submit wrapper', 'draft-contract-only'),
  ('public.rpc_nosok_public_tracking_v1', 'future safe public tracking wrapper', 'draft-contract-only'),
  ('public.rpc_nosok_lottery_public_result_v1', 'future single-application lottery result wrapper', 'draft-contract-only'),
  ('public.rpc_nosok_lottery_submit_objection_v1', 'future public objection wrapper with audit', 'draft-contract-only'),
  ('public.rpc_nosok_admin_lottery_policy_snapshot_v1', 'future admin policy/snapshot read wrapper', 'draft-contract-only'),
  ('public.rpc_nosok_admin_execute_lgu_draw_v1', 'future capacity-aware LGU draw wrapper', 'draft-contract-only'),
  ('public.rpc_nosok_committee_decision_v1', 'future committee decision wrapper', 'draft-contract-only'),
  ('public.rpc_nosok_v29_merge_readiness_v1', 'future readiness RPC after schema creation', 'draft-contract-only')
) as v(rpc_name, purpose, state);

select 'no_waqf_assets_mutation' as check_key,
       true as passed,
       'This v29 readiness file has no DML/DDL and does not touch waqf, waqf_assets, or awqaf_system.' as note;
