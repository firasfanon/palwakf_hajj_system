# Nosok v28 — Rollback and Safe Disable Plan

This batch does not execute SQL. Rollback is therefore conceptual and prepared as draft only.

## Disable-before-apply

- Keep repository mode in `preview` or guarded `standaloneSupabaseDevelopment`.
- Keep production gate: `production-not-approved`.
- Keep application submission and lottery execution blocked.

## If a future staging DDL apply is authorized

1. Apply only to staging.
2. Record operator authorization id.
3. Record exact SQL file checksum.
4. Run read-only validation.
5. Run negative RLS UAT.
6. Run rollback dry review before any production candidate decision.

## Rollback draft

`sql/guarded_not_applied/nosok_v28/02_nosok_owner_schema_rollback_DRAFT_NOT_RUN.sql`

The rollback draft contains an intentional blocker and ends with `ROLLBACK` by default.
