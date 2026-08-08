# SESSION_HANDOFF_NOSOK_V27

## Current state

```text
staging-stable / schema-census-accepted / owner-schema-diff-prepared / sql-execution-blocked-owner-review-required / public-base-table-creation-blocked / production-not-approved / no-waqf-assets-mutation
```

## Important decision

Nosok must not build new tables before owner review. The current database census shows `core`, `public`, `billing_system`, `platform_access`, `waqf`, and `awqaf_system`; `nosok` is not detected in the light census. This means the next SQL stage must be guarded and explicitly authorized before `nosok.*` can be created.

## New admin routes

```text
/admin/systems/nosok/v27-schema-census-result
/admin/systems/nosok/v27-existing-object-reconciliation
/admin/systems/nosok/v27-owner-schema-diff-plan
/admin/systems/nosok/v27-safe-sql-execution-gate
```

## Next batch

Nosok v28 should prepare the guarded owner-schema DDL draft only after explicit authorization, or otherwise continue with Flutter integration/read-only adapters.
