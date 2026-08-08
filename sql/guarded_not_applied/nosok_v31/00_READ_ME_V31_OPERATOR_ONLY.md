# Nosok v31 Operator-Only SQL Pack

Status: `GUARDED_NOT_APPLIED / OPERATOR_ONLY / STAGING_ONLY`

The user authorized preparation of v31. This folder does **not** prove DDL was executed.

Before any SQL apply, the DBA/operator must confirm:

1. `owner_authorization_id` is bound to the current staging database session.
2. The target database is staging, not production.
3. A backup/snapshot or restore point exists and is recorded.
4. No `public.*` base tables will be created.
5. No writes occur to `core`, `platform_access`, `billing_system`, `waqf`, `waqf_assets`, or `awqaf_system`.
6. Post-apply read-only UAT must be executed immediately.

Do not run the apply file as-is. It contains a fail-closed guard and operator placeholders.
