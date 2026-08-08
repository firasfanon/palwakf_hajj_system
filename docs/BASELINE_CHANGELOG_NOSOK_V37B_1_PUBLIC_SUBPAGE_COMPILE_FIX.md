# BASELINE CHANGELOG — Nosok v37B-1 Public Subpage Compile Fix

**Date:** 2026-05-20  
**Source baseline:** `nosok_v37b_external_premium_public_ui_integration_2026_05_20.zip`  
**Patch type:** Targeted compile hotfix after local analyzer/browser retest evidence.  

## Evidence intake

The provided local log showed that `dart format .` could not parse three public pages and `flutter analyze` reported exactly three `Expected to find ','` issues:

- `lib/features/nosok_system/presentation/pages/public/nosok_application_status_page.dart:36:7`
- `lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart:81:7`
- `lib/features/nosok_system/presentation/pages/public/nosok_citizen_followup_page.dart:35:7`

Chrome compile stopped for the same syntax blockers.

## Root cause

`NosokPageScaffold(...)` calls in the three pages had a `subtitle:` string immediately followed by `children:` without the required comma between named parameters.

## Applied fix

Added the missing trailing comma after the `subtitle:` parameter in each affected page.

## Files modified

- `lib/features/nosok_system/presentation/pages/public/nosok_application_status_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_citizen_followup_page.dart`
- `docs/BASELINE_CHANGELOG_NOSOK_V37B_1_PUBLIC_SUBPAGE_COMPILE_FIX.md`
- `docs/ERROR_RECORD_NOSOK_V37B_1_PUBLIC_SUBPAGE_COMPILE_FIX.md`
- `docs/SESSION_HANDOFF_NOSOK_V37B_1_PUBLIC_SUBPAGE_COMPILE_FIX.md`
- `docs/UAT_MATRIX_NOSOK_V37B_1_PUBLIC_SUBPAGE_COMPILE_FIX.md`
- `CHANGED_FILES_NOSOK_V37B_1.txt`

## Guardrails

- No SQL.
- No backend binding.
- No database schema creation.
- No `waqf_assets` mutation.
- No route or RBAC behavior change.
