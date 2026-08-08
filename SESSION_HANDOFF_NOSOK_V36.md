# Session Handoff — Nosok v36

## Status

```text
staging-stable / v36-controlled-development-applied / wrapper-rpc-present / repository-adapter-prepared-not-globally-bound / browser-role-scope-uat-required / production-not-approved / no-waqf-assets-mutation
```

## Next

Run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Then run SQL read-only:

```sql
\i sql/35_nosok_v36_browser_role_scope_wrapper_uat_read_only.sql
```

Collect Browser/Role/Scope evidence for public and admin cases.
