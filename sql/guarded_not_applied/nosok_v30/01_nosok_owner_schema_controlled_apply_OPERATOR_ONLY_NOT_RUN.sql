-- Nosok v30 — Controlled DDL Apply Placeholder
-- STATUS: OPERATOR_ONLY_NOT_RUN
-- This file is intentionally non-executable until all placeholders are replaced by the DBA/operator.
-- Required before use:
--   1) owner_authorization_id
--   2) staging target confirmation
--   3) backup/snapshot evidence
--   4) rollback decision path
--   5) explicit confirmation that public.* base tables are forbidden
--
-- DO NOT RUN THIS PLACEHOLDER AS-IS.
-- Use the v28/v29 guarded DDL after owner review, not this placeholder.
select 'NOSOK_V30_CONTROLLED_APPLY_PLACEHOLDER_NOT_RUN' as decision,
       false as ddl_executed_by_this_file,
       false as production_approved;
