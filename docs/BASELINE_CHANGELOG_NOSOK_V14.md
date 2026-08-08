# Nosok v14 — Public UX + Operational Dashboard Realignment

## Date
2026-05-18

## Scope
This batch corrects the visual and operational position of Nosok as a semi-independent system under PalWakf. It addresses the review note that the public homepage was closer to an administrative information page than a citizen-facing government service interface, and that the system dashboard was not yet a true operational dashboard.

## Changes

### Public Home
- Rebuilt `NosokPublicHomePage` as a modern government service interface.
- Added a large service-oriented hero for Hajj/Umrah services.
- Added citizen-first service actions:
  - Submit application.
  - Track application securely.
  - Browse qualified companies.
  - Submit complaint.
- Added service journey section:
  - Season.
  - Application.
  - Documents.
  - Review.
  - Tracking.
- Kept dynamic announcements and FAQ from the existing public home controller.
- Removed governance-heavy wording from the main public surface.

### Admin Dashboard
- Rebuilt `NosokAdminDashboardPage` as an operational command dashboard.
- Added operational hero with immediate attention indicators.
- Added responsive stat grid with meaningful subtitles.
- Added daily operations workbench with direct links to:
  - Seasons.
  - Applications.
  - Companies.
  - Payment bridge.
  - Unit queues.
  - Complaints.
  - Role UAT.
  - Readiness evidence.
- Added semi-independent system gates block.
- Added seasonal operational timeline.
- Added governance block for users, roles, units, routes and health.

## Contract Alignment
- PalWakf remains the parent platform.
- Nosok remains a semi-independent system under `/systems/nosok` and `/admin/systems/nosok`.
- Users, RBAC and AccessProfile remain platform-owned.
- Units remain platform/core-owned; Nosok owns only its service scope overlays.
- No `waqf`, `waqf_assets`, or `awqaf_system` mutation.

## Verification
- Dart formatter/analyzer could not be executed in this environment because the local toolchain is not installed.
- Static structural checks were performed for bracket/parenthesis balance in the modified Dart files.
- Local retest is required.
