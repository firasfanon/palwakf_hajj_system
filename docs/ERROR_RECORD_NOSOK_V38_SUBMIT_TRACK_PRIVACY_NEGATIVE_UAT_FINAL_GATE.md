# Error Record — Nosok v38 Submit/Track Privacy + Negative UAT Final Gate

## Error 1 — Compile blocker inherited from previous baseline

- File: `lib/features/nosok_system/data/repositories/nosok_public_wrapper_rpc_adapter.dart`
- Symptom: duplicated `try` inside `_rpcListWithFallbacks`.
- Cause: malformed generated patch in previous v38 public runtime adapter batch.
- Fix: rewrote the adapter with a compile-safe implementation and retained campaigns/requirements RPC fallback logic.
- Retest: local `dart format`, `flutter analyze`, and `flutter run -d chrome` required.

## Error 2 — Public tracking privacy boundary weakness

- File: `lib/features/nosok_system/data/repositories/nosok_supabase_repository.dart`
- Symptom: `lookupApplicationByTrackingToken` had direct fallback to `nosok.applications` selecting sensitive columns.
- Cause: legacy standalone fallback was still reachable from citizen tracking surface.
- Fix: removed direct fallback for public tracking. Public tracking now uses `rpc_nosok_public_application_status_by_token_v1` only and fails closed to null if unavailable.

## Error 3 — Public submit unsafe fallback

- File: `lib/features/nosok_system/data/repositories/nosok_supabase_repository.dart`
- Symptom: `submitApplication` could fallback to direct inserts into `nosok.*` tables from Flutter.
- Cause: legacy standalone fallback path remained active after RPC wrapper transition.
- Fix: removed direct DML fallback for citizen submit. Submit now requires the public RPC and fails safely if missing.

## Last stable baseline before this batch

`nosok_v38_public_campaigns_requirements_runtime_adapter_network_gate_2026_06_09.zip`
