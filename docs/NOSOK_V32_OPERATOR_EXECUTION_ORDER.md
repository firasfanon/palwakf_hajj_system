# NOSOK v32 — Operator Execution Order

## Answer to: should I execute these files?

Yes, but not all at once and not all are normal execution files.

1. Read `00_READ_ME_V31_OPERATOR_ONLY.md`.
2. Run `01_nosok_owner_schema_controlled_staging_apply_OPERATOR_ONLY_NOT_RUN.sql` only on staging, after backup/restore point confirmation.
3. Run `02_nosok_v31_post_apply_rls_rpc_negative_uat_READ_ONLY.sql` immediately after 01 succeeds.
4. Do not run `03_nosok_v31_controlled_rollback_DRAFT_NOT_RUN.sql` unless rollback is explicitly required.

## Hard boundaries

- No production.
- No `public.*` base tables.
- No `waqf`, `waqf_assets`, or `awqaf_system` mutation.
- No lottery production execution.
- No payment production execution.
