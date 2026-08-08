# SESSION HANDOFF — Nosok v27D-1 Admin Dashboard Entry Fix

## Current baseline

`nosok_v27d1_admin_dashboard_entry_fix_2026_05_20.zip`

## Source baseline

`nosok_v27d_lottery_operational_hardening_2026_05_19.zip`

## Operational judgement

```text
staging-stable /
nosok-v27d1-admin-dashboard-entry-applied /
public-internal-separation-preserved /
rbac-route-guard-still-authoritative /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## What changed

The public portal now exposes a clear employee/admin dashboard entry:

- In the public top navigation shell:
  - `دخول الموظفين / لوحة التحكم`
  - routes to `/admin/systems/nosok`

- In the public home page:
  - an explicit panel titled `مدخل الموظفين ولوحة التحكم`
  - includes governance badges explaining staff-only access and RBAC control.

## Why this was needed

The previous public/internal split correctly prevented citizen UI from becoming an admin dashboard. However, it overcorrected by leaving no obvious visual entry point for authorized staff. This fix restores expected government-portal behavior without weakening RBAC.

## Files changed

1. `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`
2. `lib/features/nosok_system/presentation/pages/public/nosok_public_home_page.dart`
3. `docs/BASELINE_CHANGELOG_NOSOK_V27D_1_ADMIN_DASHBOARD_ENTRY.md`
4. `docs/SESSION_HANDOFF_NOSOK_V27D_1_ADMIN_DASHBOARD_ENTRY.md`
5. `docs/UAT_MATRIX_NOSOK_V27D_1_ADMIN_DASHBOARD_ENTRY.md`
6. `docs/ERROR_RECORD_NOSOK_V27D_1_ADMIN_DASHBOARD_ENTRY.md`
7. `docs/ROUTES_SUMMARY_NOSOK_V27D_1_ADMIN_DASHBOARD_ENTRY.md`
8. `CHANGED_FILES_NOSOK_V27D_1_ADMIN_DASHBOARD_ENTRY.txt`

## Retest checklist

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Browser checks:

1. Open `/services/nosok`.
2. Confirm the top shell shows `دخول الموظفين / لوحة التحكم`.
3. Click it and confirm navigation to `/admin/systems/nosok`.
4. Return to `/services/nosok`.
5. Confirm the home-page panel also includes the dashboard button.
6. Confirm unauthorized users are still handled by route guard/forbidden behavior in the real platform integration.

## Next recommended batch

`Nosok v27E — Lottery Browser UAT Result Intake + Staff Entry RBAC Evidence + Production Gate Re-decision`
