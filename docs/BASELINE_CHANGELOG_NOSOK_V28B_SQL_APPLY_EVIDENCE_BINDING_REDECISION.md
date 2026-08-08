# BASELINE CHANGELOG — Nosok v28B

**Batch:** Nosok v28B — Actual Sandbox SQL Apply Evidence + Readiness RPC Result Intake + Backend Binding Gate Re-decision  
**Date:** 2026-05-20  
**Source baseline:** `nosok_v28a_sql_rls_rpc_binding_decision_2026_05_20.zip`  
**Type:** Evidence intake + security/binding decision + SQL read-only UAT pack.  

## Decision

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

## Applied changes

1. Updated the lottery backend readiness contract from v28A to v28B.
2. Added explicit gates for:
   - Actual sandbox SQL apply evidence.
   - Readiness RPC output.
   - Backend binding re-decision.
3. Added route alias:
   - `/admin/systems/nosok/v28b-sql-apply-intake`
4. Updated admin navigation title and entry for v28B SQL evidence intake.
5. Added read-only SQL evidence intake file:
   - `sql/30_nosok_v28b_actual_sandbox_apply_readiness_result_intake.sql`
6. Added documentation pack:
   - Changelog.
   - SESSION_HANDOFF.
   - NEXT_SESSION_PROMPT.
   - UAT Matrix.
   - Error Record.
   - Routes Summary.
   - Modified Files List.
   - Guide Appendix.

## Evidence consumed

The attached local log proves:

```text
dart format .        passed
flutter analyze      No issues found
flutter run -d chrome Chrome startup passed
```

The same log does **not** include Supabase SQL sandbox apply output or readiness RPC output. Therefore backend binding remains deferred.

## Not done

- No production SQL was executed.
- No DML was applied.
- No real repository binding was enabled.
- No Production Gate was approved.
- No `waqf_assets`, `waqf`, or `awqaf_system` mutation.
