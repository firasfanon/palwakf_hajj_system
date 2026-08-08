# SESSION HANDOFF — Nosok v17

## Current baseline
Nosok v17 — Data-Bound Workbench + Service Desk Search + Season Command Gate Enforcement

## Architectural position
- PalWakf هي المنصة الأم.
- Nosok نظام شبه مستقل تحت المنصة.
- Preview standalone موجود للفحص المحلي فقط.
- RBAC الحقيقي وAccessProfile النهائي من PalWakf.

## Implemented in this batch
1. Data-bound Workbench
   - `nosok_workflow_bucket.dart`
   - `nosok_workbench_controller.dart`
   - `nosok_admin_workflow_workbench_page.dart`
   - RPC: `public.rpc_nosok_v17_admin_workflow_buckets_bound_v1`

2. Service Desk Search
   - `nosok_service_desk_search_result.dart`
   - `nosok_service_desk_controller.dart`
   - `nosok_admin_service_desk_page.dart`
   - RPC: `public.rpc_nosok_v17_service_desk_search_v1`
   - RPC: `public.rpc_nosok_v17_service_desk_scripts_v1`

3. Season Command Gate Enforcement
   - `nosok_season_command_gate.dart`
   - `nosok_season_command_controller.dart`
   - `nosok_admin_season_command_page.dart`
   - RPC: `public.rpc_nosok_v17_season_command_gates_v1`
   - RPC: `public.rpc_nosok_v17_season_open_gate_decision_v1`

4. SQL UAT
   - `sql/15_nosok_v17_data_bound_workbench_service_desk_season_gate.sql`
   - `public.rpc_nosok_v17_runtime_contract_uat_v1`

## Required local test
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## Required browser paths
- `/admin/systems/nosok/workflow-workbench`
- `/admin/systems/nosok/service-desk`
- `/admin/systems/nosok/season-command`
- `/admin/systems/nosok/applications/APP_ID`

## Required SQL UAT
```sql
select * from public.rpc_nosok_v17_runtime_contract_uat_v1();
select * from public.rpc_nosok_v17_admin_workflow_buckets_bound_v1();
select * from public.rpc_nosok_v17_service_desk_search_v1('NSK');
select * from public.rpc_nosok_v17_season_command_gates_v1();
select * from public.rpc_nosok_v17_season_open_gate_decision_v1();
```

## Production gate
Still not approved. Production requires successful browser/UAT/analyzer evidence and platform RBAC provider override.

## Next recommended batch
Nosok v18 — Application Lifecycle State Machine + Citizen Follow-up Actions + Notification Dispatch Bridge.
