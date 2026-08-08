# Nosok v29 — Platform Registry/RBAC Binding Plan

## Registry
Nosok joins PalWakf as a semi-independent system under the Dynamic System Registry:

- `system_key`: `nosok`
- `route_base`: `/admin/systems/nosok`
- `public_route_base`: `/services/nosok`
- `system_type`: `semi_independent_service_system`
- `owner_schema`: `nosok` after merge and schema creation
- `health_check`: required
- `maintenance_mode`: required
- `error_boundary`: required

## Sections
Primary sections:

- requests
- review
- lottery
- companies
- campaigns
- groups
- documents
- messages
- reports
- settings
- v29 merge readiness

## RBAC Rule
Nosok does not own independent RBAC. It consumes PalWakf AccessProfile and platform permissions. Preview access must be replaced after merge.

## Roles

- visitor: public surfaces only
- citizen: own application/result/objection only
- nosok_employee: assigned requests and review surfaces
- nosok_supervisor: unit/scoped operational control
- hajj_committee: committee decisions for quota gaps/exceptions
- system_admin: settings/readiness/reports
- superuser: full audit and platform gate view
- restricted: forbidden/read-only according to platform contract
