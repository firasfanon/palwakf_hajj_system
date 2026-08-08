# BASELINE CHANGELOG — Nosok v27C-1 Lottery Compile Fix

**Date:** 2026-05-19  
**Batch:** Nosok v27C-1 — Lottery Waiting List Compile Fix  
**Source baseline:** `nosok_v27c_lottery_governance_lgu_quota_2026_05_19.zip`  
**Type:** Hotfix / compile blocker closure  

## Summary

Applied a targeted import fix to close the analyzer/Chrome compile blocker reported after v27C.

## Root cause

`lib/features/nosok_system/presentation/pages/public/nosok_waiting_list_page.dart` used `NosokLguQuotaStatus` and the `labelAr` extension defined in `domain/models/nosok_lottery_policy.dart`, but the page did not import that model file.

## Change applied

Added:

```dart
import '../../../domain/models/nosok_lottery_policy.dart';
```

to:

```text
lib/features/nosok_system/presentation/pages/public/nosok_waiting_list_page.dart
```

## Scope discipline

- No SQL production change.
- No DML.
- No `waqf_assets` mutation.
- No `waqf` schema mutation.
- No `awqaf_system` mutation.
- No lottery algorithm behavior change.
- No route behavior change.

## Retest status

The container environment does not provide `dart`/`flutter`, so local retest is required:

```bash
flutter analyze
flutter run -d chrome
```

Expected result: the previous `NosokLguQuotaStatus` / `labelAr` compile blocker should be closed.
