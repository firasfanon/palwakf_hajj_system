# ROUTES SUMMARY — Nosok v38

## New routes

```text
/admin/systems/nosok/evidence-center
/admin/systems/nosok/v38-readiness-consolidation
```

Both render the v38 readiness/evidence consolidation surface.

## Operational admin routes kept visible

```text
/admin/systems/nosok
/admin/systems/nosok/requests
/admin/systems/nosok/review
/admin/systems/nosok/lottery
/admin/systems/nosok/campaigns
/admin/systems/nosok/companies
/admin/systems/nosok/documents
/admin/systems/nosok/messages
/admin/systems/nosok/reports
/admin/systems/nosok/settings
/admin/systems/nosok/evidence-center
```

## Evidence-only routes retained but removed from operational sidebar

Historical v24–v36, SQL UAT, merge readiness, RBAC override, browser evidence, production-gate pages remain routable for superuser/audit use through Evidence Center but do not clutter ordinary operational navigation.
