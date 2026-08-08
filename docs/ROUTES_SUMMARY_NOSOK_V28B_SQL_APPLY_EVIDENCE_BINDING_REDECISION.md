# ROUTES SUMMARY — Nosok v28B

## Existing backend readiness route

```text
/admin/systems/nosok/v28-lottery-backend-readiness
```

Purpose: backend schema/RPC/security readiness dashboard.

## New route alias

```text
/admin/systems/nosok/v28b-sql-apply-intake
```

Purpose: direct access to v28B actual SQL apply evidence intake and backend binding re-decision surface.

## Required permission gate

```text
NosokPermissionKeys.intakeNosokSqlUatResults
NosokPermissionKeys.manageNosokPlatformIntegrationReadiness
```

## Notes

- Both routes render the same controlled readiness surface.
- No public route was added.
- No citizen data is exposed.
