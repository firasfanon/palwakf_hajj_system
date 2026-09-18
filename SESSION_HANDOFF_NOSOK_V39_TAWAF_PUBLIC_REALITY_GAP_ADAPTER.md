# Session Handoff — Nosok v39 Tawaf Public Reality Gap Adapter

Date: 2026-09-16

## Current target

`Nosok v39 — Tawaf Public Reality Gap Adapter + Civil Registry/OTP/Payment/Company/Captcha/Lottery Evidence Matrix`

## Decision

`TAWAF_PUBLIC_REALITY_GAP_ADAPTER_AND_EVIDENCE_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_NO_EXTERNAL_INTEGRATION`

## Current state

```text
STAGING_STABLE = YES
V39_REALITY_GAP_ADAPTER = IMPLEMENTED_CONTRACT_ONLY
PUBLIC_TAWAF_SOURCE_OBSERVATIONS = CAPTURED_FROM_PUBLIC_PAGES
CIVIL_REGISTRY_INTEGRATION = NO
OTP_SMS_INTEGRATION = NO
PAYMENT_ESADAD_BANK_INTEGRATION = NO
COMPANY_CAPTCHA_AUTH_INTEGRATION = NO
LOTTERY_OFFICIAL_FEED_INTEGRATION = NO
PRODUCTION_APPROVAL = NO
GITHUB_SYNC = NOT_DONE_IN_THIS_CHAT
LOCAL_FLUTTER_RETEST = REQUIRED
```

## Implemented files

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

## New route

`/admin/systems/nosok/v39-tawaf-reality-gap`

Permission:

`NosokPermissionKeys.redecideNosokProductionGate`

## Important boundary

This is not an integration with Tawaf/Nosok official systems. It is an evidence adapter and production blocker matrix only.

## Next exact work

`Nosok v39 — Local Flutter Analyzer + Browser Route Evidence + Negative Role/Network No-External-Call Evidence Intake`

Do not proceed to production approval, GitHub integration, or authority/provider integration without explicit authorization and fresh reconciliation.

## Fresh local reconciliation + compile repair — 2026-09-17

```text
GITHUB_MAIN_HEAD = cb8c4f32111ca7759cd2af36c96dc9b90406568a
LOCAL_PRE_REPAIR_BRANCH = main
LOCAL_WIP_BRANCH = task/NOSOK-V39-LOCAL-COMPILE-REPAIR-V1
TASK_BRANCH_BASE_SHA = cb8c4f32111ca7759cd2af36c96dc9b90406568a
GITHUB_MAIN_MUTATION = NO
BASELINE_PROMOTION = NO
PRODUCTION_APPROVAL = NO
NOSOK_SCOPED_ANALYZE = PASS
WEB_BUILD = PASS
CHROME_DEBUG_RUNTIME = PENDING_EVIDENCE
WHOLE_REPO_ANALYZE = FAIL_OUT_OF_SCOPE_DRIFT
```

The original Chrome compile failure was caused by an incomplete local artifact overlay: three v38 public-runtime dependency files existed in the v39 ZIP but were absent locally. They were restored from the v39 artifact, then formatted and verified through Nosok-scoped analyze and Web build.

Do not classify this repair as GitHub integration, main merge, baseline promotion, or production approval until a separate authorized decision and post-push readback are completed.

## Repository cleanup update — 2026-09-17

`awqaf_system` / `waqf_assets` source contamination was removed on a dedicated WIP branch after authority reconciliation.

```text
CLEANUP_BRANCH=task/NOSOK-REMOVE-AWQAF-WAQF-ASSETS-LEFTOVERS-V1
CLEANUP_BASE=5389ecb85cb6e89ed97f9a0f691ec4953d13cc21
FOREIGN_FEATURE_ROOTS=REMOVED
DEDICATED_AWQAF_DOCS_SANDBOX=REMOVED
WHOLE_REPO_ANALYZE=PASS
WEB_BUILD=PASS
MAIN_MERGE=NO
BASELINE_PROMOTION=NO
PRODUCTION_APPROVAL=NO
```

Read-only schema census/evidence mentioning external Awqaf/Waqf authorities is preserved intentionally.

## Administrative Unit Scope Reconciliation — 2026-09-17

`NOSOK_V39_ADMINISTRATIVE_UNIT_SCOPE_RECONCILED_PRODUCTION_DEFERRED`

The unit-scope model was reconciled against live Supabase reality. `core.org_units.id` is now the authorization identity and `slug` is display/navigation compatibility only. Runtime unit discovery uses `public.rpc_org_units_core_lookup_v1`; the legacy `nosok.unit_service_scopes` path is no longer used by the live Supabase repository.

Canonical evidence:

- Bethlehem Directorate: `1b39cc65-dc74-401f-a431-1fbf78cfbd0e`, slug `bth`, governorate `17b45c86-a439-47a0-9ca7-085a1f5e75d4`.
- Hebron Directorate: `8e0238db-2e20-49d4-8cf2-db7c376d512b`.
- Wrong-scope browser UAT: Bethlehem ALLOW; Hebron DENY.
- Governorate is derived from the canonical org unit.
- LGU authorization is fail-closed until an explicit authoritative Unit→LGU mapping exists.

Full analyzer PASS. Web release evidence build PASS. Production remains deferred; no main merge or baseline promotion is authorized by this handoff.

## Unit→LGU authority dataset review — 2026-09-18

`NOSOK_V39_UNIT_LGU_DATASET_REVIEW_PARTIAL_AUTHORITY_GAP_BLOCKS_DATA_LOAD`

- Migration 45 schema exists in Supabase; policy rows remain 0.
- Current official Hajj instructions establish that each address belongs to an Awqaf directorate, but the public site does not expose a complete current Directorate→LGU roster.
- `core.org_units` + `core.core_lgus` produce 722 active LGUs in governorates 1–11.
- 569 rows are deterministic single-directorate candidates.
- 153 Hebron rows remain unresolved because Hebron has four active directorates.
- Historical 2018 Awqaf-source locality groupings are supporting evidence only, not current production authority.
- `AUTHORITY_VERIFIED_ROWS=0`; therefore data load is not ready and not authorized.
- New read-only artifacts: SQL 47 candidate dataset review and SQL 48 data-load preflight.

Next required evidence: current Ministry of Awqaf Directorate→address/LGU roster/export, followed by row-by-row reconciliation and a separate data-load authorization.
