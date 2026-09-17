# Nosok v38 — Submit/Track Privacy Network Evidence + Role/Scope Negative UAT Closure + Final Production Gate Re-decision

Date: 2026-06-09

## Decision

`SUBMIT_TRACK_PRIVACY_HARDENED_NEGATIVE_UAT_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_PENDING_ACTUAL_BROWSER_EVIDENCE`

## Scope

This Mega Batch continues the v38 public runtime closure after campaigns/requirements adapter integration.

Implemented changes:

1. Fixed compile blocker in `nosok_public_wrapper_rpc_adapter.dart` caused by duplicated `try` in `_rpcListWithFallbacks`.
2. Hardened public submit in `NosokSupabaseRepository.submitApplication` to use `rpc_nosok_public_submit_application_v1` only and fail safely if the RPC is not available.
3. Hardened public tracking in `NosokSupabaseRepository.lookupApplicationByTrackingToken` to use `rpc_nosok_public_application_status_by_token_v1` only and avoid direct REST reads from `nosok.applications`.
4. Added v38 final production gate contract/controller/page:
   - `/admin/systems/nosok/v38-final-production-gate`
5. Added navigation entry: `قرار v38 النهائي`.
6. Added read-only SQL evidence/gate script:
   - `sql/43_nosok_v38_submit_track_privacy_negative_uat_final_gate_read_only.sql`
7. Updated baseline pointer, comprehensive guide, handoff, UAT matrix, error record, next prompt, and modified-files manifest.

## Safety Boundary

- No DDL/DML/GRANT/REVOKE.
- No service_role in Flutter.
- No direct public fallback to `nosok.*` for submit/track from citizen surfaces.
- No platformHosted switch.
- No Join approval.
- No mutation to `waqf_assets`, `waqf`, `awqaf_system`, `core`, or `gis`.

## Production Decision

Production remains **not approved**.

Reason: code hardening and evidence matrix are prepared, but actual local Browser/Network evidence and Flutter retest are still required.
