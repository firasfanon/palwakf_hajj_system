-- Nosok v31 — Post-Apply RLS/RPC/Negative UAT Read-only Closure Probe
-- Run only after controlled staging DDL apply. This script is read-only.
-- For a full certification probe, run from project root:
--   \i sql/29_nosok_v31_authorization_apply_certification_read_only.sql

select 'NOSOK_V31_POST_APPLY_UAT_READ_ONLY_POINTER' as decision,
       'Run sql/29_nosok_v31_authorization_apply_certification_read_only.sql after controlled staging apply and paste the full result.' as instruction,
       true as read_only,
       false as ddl_executed_by_this_file,
       false as dml_executed_by_this_file,
       false as production_approved;
