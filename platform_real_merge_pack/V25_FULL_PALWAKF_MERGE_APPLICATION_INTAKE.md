# V25 Full PalWakf Merge Application Intake

## Purpose
This file records the application checklist for moving Nosok from preview host into the full PalWakf repo.

## Required Apply Steps
1. Copy `lib/features/nosok_system` into PalWakf.
2. Register Nosok routes in the real GoRouter group.
3. Bind `nosokAccessProfileProvider` to the platform `AccessProfile` source.
4. Register `nosok` in Dynamic System Registry.
5. Register Nosok System Sections.
6. Register RBAC permissions and role templates.
7. Apply only authorized SQL after read-only UAT passes.
8. Re-run analyzer and browser UAT in the full PalWakf repo.

## Evidence Required
- Copy/apply log.
- `flutter analyze` full repo result.
- Browser route screenshots.
- Role UAT matrix.
- SQL UAT result.
- Console review.

## Decision
Until these are provided, Nosok remains `production-not-approved`.
