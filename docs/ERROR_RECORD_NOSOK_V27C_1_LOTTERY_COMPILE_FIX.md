# ERROR RECORD — Nosok v27C-1 Lottery Compile Fix

## Error ID

`NOSOK-V27C-ANALYZER-001`

## Reported by local UAT

After `dart format .`, `flutter analyze` reported 2 issues and `flutter run -d chrome` stopped during compile.

## Error

```text
Undefined name 'NosokLguQuotaStatus'
The getter 'labelAr' isn't defined for the type 'NosokLguQuotaStatus'
```

## File

```text
lib/features/nosok_system/presentation/pages/public/nosok_waiting_list_page.dart
```

## Cause

The public waiting list page referenced the LGU quota enum and label extension without importing the domain model file that defines them.

## Fix

Added the missing import:

```dart
import '../../../domain/models/nosok_lottery_policy.dart';
```

## Verification required

Run locally:

```bash
flutter analyze
flutter run -d chrome
```

## Governance notes

This is a local compile/import fix only. It does not change policy rules, LGU quota logic, committee workflow, SQL, or production approval status.
