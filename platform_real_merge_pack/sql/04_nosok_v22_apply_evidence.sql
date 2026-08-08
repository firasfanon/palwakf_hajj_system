-- Nosok v22 platform merge evidence SQL
-- Run after sql/20_nosok_v22_full_merge_role_evidence_gate_decision.sql
select * from public.rpc_nosok_v22_runtime_contract_uat_v1();
select * from public.rpc_nosok_v22_full_platform_merge_execution_v1();
select * from public.rpc_nosok_v22_remaining_work_register_v1();
select * from public.rpc_nosok_v22_production_gate_decision_v1('not_approved','Awaiting full PalWakf repo apply, SQL UAT and Browser/Role evidence', '{}'::jsonb);
