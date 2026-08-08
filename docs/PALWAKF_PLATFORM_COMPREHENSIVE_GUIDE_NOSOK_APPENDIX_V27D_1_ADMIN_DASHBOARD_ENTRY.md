# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok Appendix v27D-1

## Rule added

Public service portals may expose a clear staff/admin entry button, provided that:

1. The citizen journey remains the dominant public experience.
2. The button does not grant permissions.
3. The actual target remains protected by platform RBAC and route guards.
4. The label clearly distinguishes staff/admin access from public service actions.

## Nosok application

Nosok public portal now includes:

```text
دخول الموظفين / لوحة التحكم → /admin/systems/nosok
```

This is a navigation affordance only. It does not weaken `nosokAccessProfileProvider`, route guards, or PalWakf access contracts.

## Governance state

```text
public-entry-visible /
rbac-authoritative /
public-internal-separation-preserved /
production-not-approved /
no-waqf-assets-mutation
```
