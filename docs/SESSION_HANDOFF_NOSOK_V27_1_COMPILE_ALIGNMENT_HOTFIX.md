# Session Handoff — Nosok v27.1 Route/Permission Compile Alignment Hotfix

## Current Status

`staging-stable-patch-prepared / v27-route-permission-compile-drift-addressed / local-retest-required / sql-execution-still-blocked / production-not-approved`

## What Changed

v27.1 addresses the retest blocker after v27 by restoring compatibility route constants and permission keys referenced by the existing Nosok preview/pre-join surfaces.

## Files Changed

- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/system_permissions.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart` in full baseline packaging

## Database State

The v27 SQL census remains read-only. `nosok` schema is not yet present in the supplied census, and no owner schema build is authorized by v27.1.

## Next Required Local Retest

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Then open:

```text
/admin/systems/nosok/v27-schema-census-result
/admin/systems/nosok/v27-existing-object-reconciliation
/admin/systems/nosok/v27-owner-schema-diff-plan
/admin/systems/nosok/v27-safe-sql-execution-gate
```

## Next Development Step After Clean Retest

`Nosok v28 — Owner Schema Design + Guarded DDL Draft Pack`, only after explicit operator authorization for `nosok.*` schema/table creation.
