-- Nosok v35 — Post-Apply Wrapper/RPC Evidence Read-Only Pointer
-- Run the canonical v35 read-only check after controlled wrapper/RPC staging apply.
-- In Supabase SQL Editor, open and run:
-- sql/33_nosok_v35_public_wrapper_rpc_apply_result_read_only.sql

SELECT
  'NOSOK_V35_POST_APPLY_WRAPPER_RPC_READ_ONLY_POINTER' AS decision,
  'Run sql/33_nosok_v35_public_wrapper_rpc_apply_result_read_only.sql after controlled wrapper/RPC staging apply and paste the full result.' AS instruction,
  true AS read_only,
  false AS ddl_executed_by_this_file,
  false AS dml_executed_by_this_file,
  false AS production_approved;
