# ERROR RECORD — Nosok v27D-1

## Issue

No obvious visual button existed for staff/admin users to reach the Nosok dashboard from the public portal.

## Root cause

The public/internal separation batches correctly isolated citizen and staff experiences, but the public shell retained only public service routes and a generic switch entry. The direct dashboard route existed but was not discoverable enough.

## Files affected

- `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_public_home_page.dart`

## Fix

- Added a top-shell button: `دخول الموظفين / لوحة التحكم`.
- Added a home-page staff entry panel.
- Kept route target as `/admin/systems/nosok`.
- Preserved RBAC and route guard authority.

## Risk

Low. This is a navigation UX fix. It does not grant permissions and does not alter backend, SQL, or waqf assets.

## Verification status

Local Flutter retest is required because Flutter/Dart tools are unavailable in this environment.
