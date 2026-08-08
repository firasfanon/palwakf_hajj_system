# BASELINE CHANGELOG — Nosok v18

## Batch
Nosok v18 — Application Lifecycle State Machine + Citizen Follow-up Actions + Notification Dispatch Bridge

## Baseline
Built on: `nosok_platform_integration_patch_v17_data_bound_workbench_service_desk_season_gate_under_platform.zip`

## Scope
- Added application lifecycle state machine contracts and UI.
- Added public citizen follow-up actions by `tracking_token`.
- Added notification dispatch queue bridge to platform notification service.
- Added SQL runtime file `sql/16_nosok_v18_application_lifecycle_followup_notification_bridge.sql`.
- Updated routes, navigation, permissions, repository contract, Supabase repository, and in-memory preview repository.

## Governance
- Nosok remains a semi-independent system under PalWakf.
- PalWakf remains the parent platform and owner of RBAC, AccessProfile, platform shell, and final notification/billing providers.
- Nosok does not create independent users or roles.
- Notification dispatch is a bridge/queue only; final delivery belongs to platform notification service.
- No mutation to `waqf`, `waqf_assets`, or `awqaf_system`.

## New routes
Public:
- `/systems/nosok/follow-up`

Admin:
- `/admin/systems/nosok/application-lifecycle`
- `/admin/systems/nosok/notification-dispatch`

## SQL UAT
Run:
```sql
select * from public.rpc_nosok_v18_runtime_contract_uat_v1();
```

## Status
`staging-ready / lifecycle-state-machine-added / citizen-followup-enabled / notification-dispatch-bridge-added / local-retest-required / production-not-approved / no-waqf-assets-mutation`
