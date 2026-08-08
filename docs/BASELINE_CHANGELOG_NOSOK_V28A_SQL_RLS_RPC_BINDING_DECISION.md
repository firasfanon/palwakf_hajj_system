# BASELINE CHANGELOG — Nosok v28A

**Batch:** Nosok v28A — Sandbox SQL Apply Result Intake + RLS/RPC Security Review + Backend Binding Decision  
**Date:** 2026-05-20  
**Source baseline:** `nosok_v28_lottery_backend_schema_rpc_draft_2026_05_20.zip`  
**Type:** Evidence intake + security decision + backend binding decision. No production SQL. No DML.

## Final status

```text
staging-stable /
nosok-v28a-sql-rls-rpc-security-review-applied /
v28-local-flutter-retest-passed /
sandbox-sql-apply-result-not-provided /
backend-binding-deferred /
production-not-approved /
no-waqf-assets-mutation
```

## Intake result

The provided local log proves:

- `dart format .` completed successfully across 187 files, with 151 files changed by formatting.
- `flutter analyze` completed with `No issues found`.
- `flutter run -d chrome` launched successfully and reached the Chrome Debug Service.

This closes the local Flutter gate for v28.

## Important limitation

The attached evidence does **not** include a Supabase/Sandbox SQL apply log. Therefore:

- `sql/27_nosok_v28_lottery_backend_schema_rpc_draft.sql` is still treated as a draft.
- No backend repository binding is approved.
- No Production Gate is approved.

## Security review decision

RLS/RPC security stance recorded for the lottery backend:

1. No direct public table access to lottery tables.
2. Public result lookup must return one application/result only, by secure lookup token/proof.
3. Public objections must insert only through controlled RPC, not direct table insert.
4. Administrative reads must be role-gated through admin RPC wrappers.
5. Mutating RPCs must require explicit permissions and write audit events.
6. Draw execution must be single-run guarded per policy unless formally unlocked with audit.
7. Committee decisions require reason + evidence reference.
8. Audit events must be append-only.
9. No exposure of draw seed/random internals or other applicants' data to public users.
10. No automatic cross-LGU quota transfer without committee decision.

## Backend binding decision

```text
Backend binding is DEFERRED.
```

The UI/provider remains in contract/readiness mode. Binding to real Supabase repositories is allowed only after:

- Sandbox SQL apply evidence is attached.
- Readiness RPC returns expected checks.
- RLS/RPC security UAT passes.
- Role/Browser UAT passes after backend binding.

## Files changed in v28A

- `lib/features/nosok_system/application/nosok_lottery_backend_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v28_lottery_backend_readiness_page.dart`
- `sql/29_nosok_v28a_rls_rpc_security_review_read_only_uat.sql`
- `docs/BASELINE_CHANGELOG_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
- `docs/SESSION_HANDOFF_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
- `docs/UAT_MATRIX_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
- `docs/ERROR_RECORD_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
- `docs/ROUTES_SUMMARY_NOSOK_V28A_SQL_RLS_RPC_BINDING_DECISION.md`
- `docs/PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE_NOSOK_APPENDIX_V28A.md`
- `docs/NEXT_SESSION_PROMPT_NOSOK_V28A.md`
- `docs/MODIFIED_FILES_LIST_NOSOK_V28A.txt`
- `evidence/V28A_LOCAL_FLUTTER_RETEST_LOG.txt`
