# Manifest

- README.md
- docs/NOSOK_V35_1_WRAPPER_RPC_APPLY_RESULT_INTAKE.md
- docs/NOSOK_V35_1_REPOSITORY_BINDING_PREFLIGHT_DECISION.md
- docs/NOSOK_V35_1_PRODUCTION_GATE_DECISION.md
- sql/34_nosok_v35_1_wrapper_rpc_browser_role_uat_read_only.sql
- evidence/NOSOK_V35_1_USER_RESULT_SUMMARY.md
- handoff/NEXT_STEP.md
- CHECKSUMS_SHA256.txt

---

## Nosok v38 — Submit/Track Privacy + Role/Scope Negative UAT + Final Gate — 2026-06-09

Decision: `SUBMIT_TRACK_PRIVACY_HARDENED_NEGATIVE_UAT_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_PENDING_ACTUAL_BROWSER_EVIDENCE`.

Primary files:
- `lib/features/nosok_system/data/repositories/nosok_public_wrapper_rpc_adapter.dart`
- `lib/features/nosok_system/data/repositories/nosok_supabase_repository.dart`
- `lib/features/nosok_system/domain/models/nosok_v38_final_production_gate_contract.dart`
- `lib/features/nosok_system/application/nosok_v38_final_production_gate_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v38_final_production_gate_page.dart`
- `sql/43_nosok_v38_submit_track_privacy_negative_uat_final_gate_read_only.sql`

Boundary: no DDL/DML/GRANT/REVOKE, no service_role, no production approval, no waqf_assets mutation.

---

## Nosok v39 — Tawaf Public Reality Gap Adapter + Evidence Matrix — 2026-09-16

Decision: `TAWAF_PUBLIC_REALITY_GAP_ADAPTER_AND_EVIDENCE_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_NO_EXTERNAL_INTEGRATION`.

Primary files:
- `lib/features/nosok_system/domain/models/nosok_v39_tawaf_reality_gap_contract.dart`
- `lib/features/nosok_system/application/nosok_v39_tawaf_reality_gap_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v39_tawaf_reality_gap_page.dart`
- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart`
- `lib/features/nosok_system/system_navigation.dart`
- `sql/44_nosok_v39_tawaf_public_reality_gap_evidence_matrix_read_only.sql`
- `BASELINE_CHANGELOG_NOSOK_V39_TAWAF_PUBLIC_REALITY_GAP_ADAPTER.md`
- `UAT_MATRIX_NOSOK_V39_TAWAF_PUBLIC_REALITY_GAP_ADAPTER.md`
- `ERROR_RECORD_NOSOK_V39_TAWAF_PUBLIC_REALITY_GAP_ADAPTER.md`
- `SESSION_HANDOFF_NOSOK_V39_TAWAF_PUBLIC_REALITY_GAP_ADAPTER.md`
- `NEXT_SESSION_PROMPT_NOSOK_V39_LOCAL_EVIDENCE_INTAKE.md`
- `CHECKSUMS_NOSOK_V39_TAWAF_PUBLIC_REALITY_GAP_ADAPTER_SHA256.txt`

Boundary: no external integration, no scraping, no Captcha bypass, no private data extraction, no DDL/DML/GRANT/REVOKE, no service_role, no production approval, no waqf_assets mutation.
