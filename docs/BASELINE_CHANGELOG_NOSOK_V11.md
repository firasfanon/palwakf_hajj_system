# Nosok v11 — Production Runtime Batch

## Date
2026-05-17

## Baseline
Built on `nosok_platform_integration_patch_v10_1_compile_web_hotfix_under_platform.zip`.

## Scope
Large operational batch for semi-independent Nosok under PalWakf. PalWakf remains the sovereign platform. Nosok receives production-runtime surfaces and contracts without creating an independent user/RBAC universe.

## Added
- Production Operations Center.
- Payment/Billing Bridge preparation under platform billing governance.
- Role-Based UAT Matrix UI and SQL contract.
- Notification Templates cockpit.
- Operational readiness SQL tables/RPCs.
- Repository/controller/model bindings for the above.
- Platform merge patch route constants and route entries.

## Sovereign boundary
No `waqf_assets`, `waqf`, or `awqaf_system` mutation.
