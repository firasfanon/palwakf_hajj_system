# SESSION HANDOFF — Nosok v28A SQL/RLS/RPC Security Review

**Session:** تطوير نسك للحج والعمرة  
**Batch:** Nosok v28A — Sandbox SQL Apply Result Intake + RLS/RPC Security Review + Backend Binding Decision  
**Date:** 2026-05-20  
**Current baseline:** `nosok_v28a_sql_rls_rpc_binding_decision_2026_05_20.zip`

## Current status

```text
staging-stable /
nosok-v28a-sql-rls-rpc-security-review-applied /
v28-local-flutter-retest-passed /
sandbox-sql-apply-result-not-provided /
backend-binding-deferred /
production-not-approved /
no-waqf-assets-mutation
```

## What v28A did

1. Accepted the local v28 Flutter retest evidence.
2. Updated the v28 backend readiness provider and admin page to show v28A state.
3. Recorded the security review decision for RLS/RPC.
4. Deferred real backend binding until actual SQL sandbox evidence arrives.
5. Added a read-only SQL security review UAT script.
6. Preserved `production-not-approved` and `no-waqf-assets-mutation`.

## Evidence received

The uploaded PowerShell log shows:

```text
dart format .
flutter analyze -> No issues found
flutter run -d chrome -> Debug service listening / Chrome startup passed
```

## Evidence not received

No actual output was provided for applying:

```text
sql/27_nosok_v28_lottery_backend_schema_rpc_draft.sql
```

Therefore the phrase `Sandbox SQL Apply Result Intake` is treated as:

```text
SQL apply result not provided / pending
```

not as passed.

## Security decision

- Public tables remain inaccessible directly.
- Public result RPC returns one result only.
- Public objection RPC may insert but must not reveal internal review/audit data.
- Admin RPCs must be permission-gated.
- Mutating RPCs require audit context.
- Draw results are not manually editable without governance.
- Committee decisions are required for underfilled LGU quota redistribution or exception handling.

## Backend binding decision

```text
Deferred.
```

Do not wire the live Supabase repository yet. The next batch must first intake actual SQL sandbox results and readiness RPC output.

## Next batch

```text
Nosok v28B — Actual Sandbox SQL Apply Evidence + Readiness RPC Result Intake + Backend Binding Gate Re-decision
```

## Start commands for next session

```bash
dart format .
flutter analyze
flutter run -d chrome
```

Then run, in Supabase sandbox only:

```sql
-- Apply draft only after explicit approval and after changing ROLLBACK to COMMIT in a copied sandbox script.
-- Then run:
\i sql/29_nosok_v28a_rls_rpc_security_review_read_only_uat.sql
```
