# Nosok v29 — Staging Apply Gate

## Allowed now

1. Run `sql/27_nosok_v29_authorization_preflight_read_only.sql`.
2. Review guarded SQL manually.
3. Confirm backup/snapshot.
4. Confirm owner authorization ID.

## Blocked now

- Any SQL execution by Flutter.
- `CREATE TABLE public.*`.
- Production opening.
- Lottery production run.
- Payment production activation.
- `service_role` inside Flutter.
- Any mutation in `waqf`, `waqf_assets`, `awqaf_system`.

## Guarded files

```text
sql/guarded_not_applied/nosok_v29/01_nosok_owner_schema_staging_apply_GUARDED_NOT_RUN.sql
sql/guarded_not_applied/nosok_v29/02_nosok_v29_rls_rpc_negative_uat_preflight_READ_ONLY_AFTER_APPLY.sql
sql/guarded_not_applied/nosok_v29/03_nosok_owner_schema_rollback_DRAFT_NOT_RUN.sql
```
