# UAT Matrix — Nosok v38 Submit/Track Privacy + Role/Scope Negative Closure

## Required local retest commands

```bash
dart format lib/features/nosok_system/data/repositories/nosok_public_wrapper_rpc_adapter.dart lib/features/nosok_system/data/repositories/nosok_supabase_repository.dart lib/features/nosok_system/domain/models/nosok_v38_final_production_gate_contract.dart lib/features/nosok_system/application/nosok_v38_final_production_gate_controller.dart lib/features/nosok_system/presentation/pages/admin/nosok_admin_v38_final_production_gate_page.dart lib/features/nosok_system/system_routes.dart lib/features/nosok_system/presentation/routes/nosok_routes.dart lib/features/nosok_system/system_navigation.dart
flutter analyze
flutter run -d chrome
```

## Network privacy evidence

| Case | Route | Expected Network Evidence | Decision |
|---|---|---|---|
| N38_PRIV_001 | `/services/nosok/apply` | RPC submit `rpc_nosok_public_submit_application_v1` only; no REST direct `/nosok/applications` | Pending local screenshot |
| N38_PRIV_002 | `/services/nosok/track` | RPC track only; no REST direct `/nosok/applications` | Pending local screenshot |
| N38_PRIV_003 | `/services/nosok/track` | Response excludes national_id/phone/mobile/email/document URLs/payment receipts | Pending Network/SQL proof |

## Role/scope negative UAT

| Case | Actor | Route | Expected |
|---|---|---|---|
| N38_NEG_001 | anonymous | `/admin/systems/nosok/v38-public-runtime-evidence` | denied/redirected |
| N38_NEG_002 | no-role authenticated | `/admin/systems/nosok/v38-final-production-gate` | denied by AccessGate |
| N38_NEG_003 | wrong-role | `/admin/systems/nosok/role-uat` | denied or limited |
| N38_NEG_004 | wrong-unit/wrong-scope | `/admin/systems/nosok/unit-queues` | no cross-unit visibility/mutation |

## Acceptance condition

Do not approve production until all cases above have actual screenshots or exported logs and `flutter analyze` + `flutter run` pass locally.
