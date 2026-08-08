-- Nosok v38F — Pre-Join Operational Admin Tooling Contract
-- Scope: design/draft only. Do not apply in production. Nosok schema is not created before PalWakf hosting.

BEGIN;

-- Intended future objects after PalWakf hosting and sandbox approval:
-- 1) nosok.admin_tooling_preview_states
-- 2) nosok.legal_lottery_simulation_runs
-- 3) nosok.company_workspace_scopes
-- 4) nosok.public_responsive_uat_evidence
-- 5) nosok.prejoin_closure_audit_events

-- Future RPC draft names:
-- public.rpc_nosok_homepage_sections_admin_snapshot_v1()
-- nosok.rpc_lottery_algorithm_simulate_v1(...)
-- nosok.rpc_company_workspace_scope_snapshot_v1(...)
-- nosok.rpc_public_responsive_uat_intake_v1(...)
-- nosok.rpc_prejoin_closure_readiness_v1()

-- Sovereign boundary assertion:
-- No waqf/waqf_assets/awqaf_system DDL or DML belongs to this pack.

ROLLBACK;
