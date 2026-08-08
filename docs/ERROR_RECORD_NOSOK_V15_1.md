# Error Record — Nosok v15.1

## Error
`_NosokSidebarGroups` and `_NosokSidebarGroupHeader` were referenced in `nosok_admin_system_shell.dart` but not defined.

## Root Cause
Nosok v15 introduced grouped sidebar rendering but missed the private helper classes/widgets required by the new rendering loop.

## Failed Surface
- `lib/features/nosok_system/presentation/widgets/nosok_admin_system_shell.dart`
- `flutter run -d chrome`

## Fix
Added local private grouping model/helper/header widget in the same file to keep the sidebar self-contained and avoid changing navigation contracts.

## Stable baseline after fix
`Nosok v15.1 — Sidebar Compile Hotfix`

## Retest required
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```
