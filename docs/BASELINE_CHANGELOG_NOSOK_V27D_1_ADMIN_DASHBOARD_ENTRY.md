# BASELINE CHANGELOG — Nosok v27D-1

**Batch:** Nosok v27D-1 — Public Dashboard Entry Access Fix  
**Date:** 2026-05-20  
**Type:** UX/Routing access hotfix over v27D  
**Production decision:** production-not-approved  
**Waqf assets:** no mutation

## Reason

After the public/internal separation batches, the public portal kept citizen journeys separate from employee operations, but the public shell did not expose a clear staff/admin entry button. This created a UX gap: authorized staff could still use the direct `/admin/systems/nosok` route, but there was no obvious visual access point from the public portal.

## Applied changes

1. Added a persistent top navigation button in `NosokPublicSystemShell`:
   - Label: `دخول الموظفين / لوحة التحكم`
   - Target: `NosokSystemRoutes.adminHome`
   - Route: `/admin/systems/nosok`

2. Added a visible public-home access panel:
   - Title: `مدخل الموظفين ولوحة التحكم`
   - Clarifies that the button is for staff/supervisors/admins.
   - States that the button itself does not grant permissions; RBAC/Route Guard remains authoritative.

## Governance

This does not merge the citizen and employee experiences. It only adds a role-aware entry point. Actual access remains controlled by platform RBAC and route guards.

## Local retest required

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## Expected routes to test

- `/services/nosok`
- `/admin/systems/nosok`
- direct click from public header to admin dashboard
- direct click from public home panel to admin dashboard

## Final state

```text
staging-stable /
nosok-v27d1-admin-dashboard-entry-applied /
public-internal-separation-preserved /
rbac-route-guard-still-authoritative /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```
