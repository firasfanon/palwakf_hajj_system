-- Nosok v31-v35 — Schema/RPC/RLS sandbox draft
-- SAFE DEFAULT: this script is a draft for sandbox review after PalWakf merge.
-- It intentionally avoids production DML and must not be applied to production without explicit approval.
-- no waqf_assets mutation.

begin;

-- Guard marker only. Replace the DO block with reviewed DDL after PalWakf repo merge.
do $$
begin
  raise notice 'Nosok v31-v35 schema/RPC/RLS draft loaded for review only. No production apply is approved.';
  raise notice 'Expected schema family: nosok.seasons/applications/applicants/companions/documents/companies/campaigns/lottery/audit.';
end $$;

-- Draft object families:
-- 1. create schema if not exists nosok;
-- 2. nosok.seasons, nosok.service_types, nosok.applications, nosok.applicants, nosok.companions;
-- 3. nosok.documents, nosok.messages, nosok.reviews, nosok.companies, nosok.campaigns, nosok.groups;
-- 4. nosok.lottery_policies, nosok.lgu_quota_snapshots, nosok.lottery_eligibility_snapshots;
-- 5. nosok.lottery_draw_runs, nosok.lottery_draw_results, nosok.lottery_waiting_list;
-- 6. nosok.lottery_committee_decisions, nosok.lottery_objections, nosok.lottery_audit_events;
-- 7. public-safe RPC wrappers only; no direct public table ownership.
-- 8. RLS enabled on all nosok tables before pilot.

-- Draft RPC wrappers to implement after schema approval:
-- public.rpc_nosok_public_service_home_v1()
-- public.rpc_nosok_application_submit_v1(jsonb)
-- public.rpc_nosok_track_application_v1(text, text)
-- public.rpc_nosok_lottery_result_get_v1(text, text)
-- public.rpc_nosok_waiting_list_status_get_v1(text, text)
-- public.rpc_nosok_objection_submit_v1(jsonb)
-- nosok.rpc_admin_requests_snapshot_v1(jsonb)
-- nosok.rpc_lottery_admin_snapshot_v1(jsonb)
-- nosok.rpc_lottery_freeze_eligibility_snapshot_v1(uuid)
-- nosok.rpc_lottery_draw_execute_v1(jsonb)
-- nosok.rpc_lottery_committee_decision_record_v1(jsonb)
-- nosok.rpc_readiness_v1()

rollback;
