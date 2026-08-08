# Changelog — Awqaf System 7 User Screens

Decision: `AWQAF_SYSTEM_7_WAQF_ASSETS_USER_SCREENS_READ_ONLY_IMPLEMENTED_RETEST_REQUIRED`

## Added

- Added `PwfWaqfAssetsUserScreensPage`.
- Added route constants:
  - `PwfWaqfAssetsRoutePaths.userScreens`
  - `PwfWaqfAssetsChildRoutePaths.userScreens`
  - `AwqafSystemRoutes.waqfAssetsUserScreens`
- Added central and unit-scoped routes for user screens.
- Added navigation registry entry: `شاشات مستخدمي الأصول`.
- Added contract: `AwqafSystem7WaqfAssetsUserScreensContract`.

## Preserved

- Platform Access Gateway dependency remains authoritative.
- Existing Operational Read Console routes remain unchanged.
- Write/review/apply surfaces remain disabled.
- No SQL execution.
