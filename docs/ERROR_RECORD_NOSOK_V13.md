# Error Record — Nosok v13

## Error class: Public tracking sensitive-field exposure risk

**Reason:** Previous public tracking RPC returned fields required by the broad application model, including personal fields.  
**Files involved:** `sql/04_nosok_public_rpc_wrappers.sql`, `nosok_application_status_page.dart`.  
**Resolution in v13:** Override the public tracking RPC in `sql/12_nosok_v13_billing_privacy_readiness_closure.sql` and return `NULL` for sensitive personal fields while keeping the shape compatible with the Flutter model.

## Error class: Payment bridge lacked explicit provider hardening

**Reason:** v12 could execute/sync bridge requests but did not expose adapter-level health, signature, callback, or idempotency readiness.  
**Resolution in v13:** Add `billing_provider_adapters`, health events, idempotency columns, adapter page, and UAT RPC.

## Error class: Production readiness evidence not first-class

**Reason:** Evidence existed as docs/matrix concepts but not as a runtime data surface.  
**Resolution in v13:** Add `production_readiness_evidence` table, RPCs, page, and evidence intake form.

## Last stable baseline

`nosok_platform_integration_patch_v12_billing_unit_queues_role_uat_under_platform.zip`

## New baseline status

`staging-ready / v13-hardening-applied / production-not-approved / no-waqf-assets-mutation`
