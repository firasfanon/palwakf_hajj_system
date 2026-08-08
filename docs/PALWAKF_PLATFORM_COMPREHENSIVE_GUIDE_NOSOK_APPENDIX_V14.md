# PalWakf Governing Contract Appendix — Nosok v14

## Governance Update
Nosok must be treated as a semi-independent system under the PalWakf parent platform. A semi-independent system must provide its own public system body, admin dashboard, sidebar, operational pages, unit surfaces, users/roles view, settings, health, maintenance/readiness and error/evidence surfaces, while consuming the platform-owned identity, RBAC, AccessProfile, system registry, route shell and core unit sources.

## Visual Rule Added
The public home of a semi-independent public service system must be designed as a government user interface, not as an administrative or architectural information page. Governance explanations may appear in secondary trust/FAQ blocks but must not dominate the service entry.

## Dashboard Rule Added
The admin home of a semi-independent system must be an operational dashboard. It must expose daily work queues, attention indicators, domain actions, readiness signals, role/permission surfaces, unit-scope links and production-gate evidence. A stat-only dashboard is not sufficient.

## Nosok v14 Decision
- `/systems/nosok` is the public government service entry.
- `/admin/systems/nosok` is the system operational command dashboard.
- Users and roles remain platform-bound.
- Unit pages remain scoped through `core.org_units` and `nosok.unit_service_scopes`.
- Production remains blocked until local analyzer, browser UAT, SQL UAT, role UAT, privacy review, and billing evidence are closed.

## Sovereign Boundary
No changes to:
- `waqf`
- `waqf_assets`
- `awqaf_system`
