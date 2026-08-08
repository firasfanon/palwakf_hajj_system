# V24 Evidence and Merge Closure Runbook

## Purpose
This runbook converts the Nosok preview host evidence into PalWakf full-repo merge evidence. It does not approve production by itself.

## Required Inputs
1. `flutter analyze` result from preview host.
2. Chrome startup/browser screenshots for public and internal routes.
3. Role UAT screenshots/logs for visitor, citizen, employee, supervisor, system admin, superuser, restricted user.
4. Responsive screenshots: desktop, laptop, tablet, mobile.
5. Supabase read-only UAT output from `sql/22_nosok_v24_read_only_uat_pack.sql`.
6. Full PalWakf repo apply result.

## PalWakf Merge Steps
1. Copy `lib/features/nosok_system` into the full platform repo.
2. Register Nosok routes under the platform's real GoRouter route groups.
3. Override `nosokAccessProfileProvider` from the platform AccessProfile provider.
4. Register system metadata in Dynamic Registry and System Sections.
5. Register Nosok permissions with platform RBAC.
6. Verify Visual Identity Admin published overrides still apply to Nosok surfaces.
7. Run `flutter analyze` and browser UAT in the full platform repo.

## Gate Decision
Do not mark production-approved until all P0 gates close.
