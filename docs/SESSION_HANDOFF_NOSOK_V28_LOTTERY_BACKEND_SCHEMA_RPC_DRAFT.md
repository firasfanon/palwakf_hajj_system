# SESSION HANDOFF — Nosok v28 Lottery Backend Schema/RPC Draft

**Date:** 2026-05-20  
**Previous stable baseline:** `nosok_v27d1_admin_dashboard_entry_fix_2026_05_20.zip`  
**Batch:** `Nosok v28 — Lottery Backend Schema/RPC Draft + SQL UAT + Real Supabase Integration Plan`

## Current state

```text
staging-stable /
nosok-v27d1-local-format-analyze-chrome-passed /
nosok-v28-lottery-backend-schema-rpc-draft-applied /
sql-uat-read-only-pack-added /
real-supabase-integration-plan-documented /
production-not-approved /
no-waq_assets_mutation
```

## Evidence carried into v28

The user provided local evidence after v27D-1:

```text
dart format .        passed
flutter analyze      No issues found
flutter run -d chrome passed to Debug Service
```

This allowed v28 to proceed as a backend draft/readiness batch.

## What v28 delivered

### 1. Backend contract surface

New admin route:

```text
/admin/systems/nosok/v28-lottery-backend-readiness
```

Purpose:

- display proposed backend tables,
- display RPC contracts,
- display RLS/privacy boundaries,
- display read-only UAT checks,
- display Supabase integration plan,
- keep production blockers explicit.

### 2. SQL draft

File:

```text
sql/27_nosok_v28_lottery_backend_schema_rpc_draft.sql
```

Important:

- transaction-based draft,
- ends with `ROLLBACK`,
- does not persist by default,
- can be reviewed for sandbox apply only after approval.

### 3. SQL UAT

File:

```text
sql/28_nosok_v28_lottery_backend_read_only_uat.sql
```

Purpose:

- verify schema exists,
- verify tables exist,
- verify RPCs exist,
- verify RLS enabled,
- prove no `waqf_assets` mutation.

## Production blockers after v28

Do not declare production-ready until all are closed:

1. SQL draft reviewed by platform/database owner.
2. SQL applied in Supabase sandbox only.
3. `sql/28_nosok_v28_lottery_backend_read_only_uat.sql` returns expected results.
4. RPC security review completed.
5. RLS policies finalized beyond enablement.
6. Real repository binding implemented in Flutter.
7. Browser UAT after real backend binding.
8. Role UAT for citizen/employee/supervisor/admin/superuser/restricted.
9. Responsive UAT after backend binding.
10. Production Gate approved explicitly.

## Next recommended batch

```text
Nosok v28A — Sandbox SQL Apply Result Intake + RLS/RPC Security Review + Backend Binding Decision
```

## Do not do next without approval

- Do not change final `ROLLBACK` to `COMMIT` in production.
- Do not run mutating RPCs against production.
- Do not seed citizen data.
- Do not expose lottery result lists publicly.
- Do not bypass committee decision for underfilled LGU quota.
