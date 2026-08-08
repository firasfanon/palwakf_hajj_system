# BASELINE CHANGELOG — Nosok v19.3

**Batch:** Nosok v19.3 — Public Scaffold / SnackBar Runtime Hotfix  
**Date:** 2026-05-18  
**Base:** v19.2 — Analyzer Boundary + Runtime Hygiene Hotfix  
**Type:** Runtime hotfix over a clean analyzer baseline

## Evidence Intake

Local evidence after v19.2 showed:

- `flutter clean` passed.
- `flutter pub get` passed.
- `dart format .` passed.
- `flutter analyze` passed with `No issues found`.
- `flutter run -d chrome` launched successfully.
- Runtime gesture error appeared on `/systems/nosok/application-status` when pressing search with an empty token:
  `ScaffoldMessenger.showSnackBar was called, but there are currently no descendant Scaffolds to present to.`

## Fix Applied

Updated:

- `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`

The public shell now provides a real `Scaffold` around its body. This ensures public Nosok pages have a descendant Scaffold for `ScaffoldMessenger.showSnackBar(...)` while preserving the existing public navigation bar and material styling.

## Scope

No SQL change.  
No RBAC change.  
No lifecycle/workflow change.  
No billing/payment change.  
No mutation to `waqf`, `waqf_assets`, or `awqaf_system`.

## Result

`hotfix-ready / analyzer-clean-prior-to-runtime-fix / public-snackbar-runtime-fixed / local-retest-required / production-not-approved`
