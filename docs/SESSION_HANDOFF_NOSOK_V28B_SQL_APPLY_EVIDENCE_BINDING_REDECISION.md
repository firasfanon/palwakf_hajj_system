# SESSION HANDOFF — Nosok v28B

## Current operational state

```text
staging-stable /
nosok-v28b-sql-apply-evidence-intake-applied /
v28-flutter-retest-passed /
actual-sandbox-sql-apply-evidence-not-attached /
readiness-rpc-result-pending /
backend-binding-deferred /
production-not-approved /
no-waqf-assets-mutation
```

## What v28B did

v28B converted the previous v28A security review into a stricter evidence intake and binding gate. It does not claim that SQL was applied, because no actual Supabase SQL apply result was provided in the attached log.

The Flutter side remains healthy based on the supplied local evidence:

- `dart format .` passed.
- `flutter analyze` returned `No issues found`.
- `flutter run -d chrome` reached Chrome Debug Service.

## Files to inspect first next session

1. `docs/BASELINE_CHANGELOG_NOSOK_V28B_SQL_APPLY_EVIDENCE_BINDING_REDECISION.md`
2. `docs/UAT_MATRIX_NOSOK_V28B_SQL_APPLY_EVIDENCE_BINDING_REDECISION.md`
3. `docs/ERROR_RECORD_NOSOK_V28B_SQL_APPLY_EVIDENCE_BINDING_REDECISION.md`
4. `docs/ROUTES_SUMMARY_NOSOK_V28B_SQL_APPLY_EVIDENCE_BINDING_REDECISION.md`
5. `sql/30_nosok_v28b_actual_sandbox_apply_readiness_result_intake.sql`
6. `lib/features/nosok_system/application/nosok_lottery_backend_controller.dart`
7. `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v28_lottery_backend_readiness_page.dart`

## Critical next action

Run the SQL draft in a reviewed sandbox only, then run the v28B read-only intake:

```sql
-- sandbox only, after review:
-- sql/27_nosok_v28_lottery_backend_schema_rpc_draft.sql

-- then read-only evidence intake:
\i sql/30_nosok_v28b_actual_sandbox_apply_readiness_result_intake.sql

-- then readiness RPC output:
select * from public.rpc_nosok_v28_lottery_backend_readiness_v1();
```

Attach the result tables exactly. Do not enable backend binding from assumptions.

## Backend binding gate

Binding can only move from deferred to candidate after all of these are attached:

1. Sandbox SQL apply output.
2. v28B read-only intake output.
3. Readiness RPC output.
4. RLS/RPC security review with no public table exposure.
5. Role UAT plan for citizen/employee/supervisor/admin/superuser/restricted.

## Prohibitions

- No production SQL without explicit approval.
- No DML seeds unless requested.
- No `waqf_assets` mutation.
- No backend binding before evidence.
- No production-ready declaration.
