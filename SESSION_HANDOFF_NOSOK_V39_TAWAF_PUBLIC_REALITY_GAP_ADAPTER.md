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

## Current LGU administrative scope reconciliation — 2026-09-20

- Current administrative geography authority is `core.core_lgus`, not `core.core_communities`.
- `core.core_communities` is historical/reference-only for Nosok authorization.
- All 722 active LGUs in governorates 1–11 match `gis.lgus_boundary` 1:1 by current LGU numeric identity.
- 569 LGUs are deterministic single-directorate candidates.
- 153 Hebron LGUs remain fail-closed because four active Awqaf directorates share the same governorate and no canonical Unit→LGU jurisdiction table exists yet.
- Recent public evidence uses North/South Hebron Awqaf labels not present in current `core.org_units`; this is an organizational drift warning, not authorization evidence.
- No DB data load occurred.
- New read-only artifacts: SQL 49 current LGU candidates and SQL 50 Hebron multi-directorate census.

## Hebron Awqaf organizational identity reconciliation — 2026-09-20

- Core UUID identities for Hebron/Dura/Yatta/Halhul are preserved as canonical authorization identities.
- Public/current evidence supports Hebron and Yatta as current labels.
- Halhul ↔ North Hebron is a high-confidence organizational rename/scope-label candidate.
- Dura ↔ South Hebron is a high-confidence organizational rename/scope-label candidate.
- These identity-lineage findings do not authorize any Core rename/update.
- North Hebron public evidence states service coverage across 14 local authorities; South Hebron evidence includes Dura with activity in al-Dhahiriya and as-Samu.
- Full Hebron Unit→LGU crosswalk remains incomplete and fail-closed.
- No database mutation occurred.

## Hebron LGU scope evidence matrix — 2026-09-20

- Matrix rows: 153.
- Current operational rows (city_status=موجوده): 132.
- Authority-verified rows: 3 (Halhul→North Hebron, Yatta→Yatta, Dura→South Hebron).
- Supporting-evidence-only rows: 20.
- Unresolved current rows: 109; all remain fail-closed.
- Removed/displaced rows excluded from current authorization: 20.
- One LGU has missing city_status and remains STATUS_REVIEW_REQUIRED.
- Matrix CSV SHA256: 83C5169E111F401E420A98A7B609A15C180241FF5B906B82C1AFAB96AD058206.
- Evidence registry SHA256: 325B7401B6EAFF437D2FB47DFCE391B71106E8F29E99B0596C769E04CCD5E864.
- SQL52 SHA256: 766F44886E4721BB8A232507329C16454EBF917A614491213078A321EB1547B0.
- POLICY_LOAD_READY=NO; no database mutation performed.

## Targeted Hebron LGU evidence expansion — Batch 01 — 2026-09-20

- Authority-verified rows increased from 3 to 7.
- Newly verified: Kharas→North Hebron, Beit Ula→North Hebron, Beit Ummar→North Hebron, al-Dhahiriya→South Hebron.
- Tarqumiya→Hebron received direct historical evidence but remains SUPPORTING_EVIDENCE_ONLY because the evidence is from 2015.
- Current matrix: 153 total / 132 current operational / 7 verified / 16 supporting / 109 unresolved / 20 excluded non-current / 1 status-review.
- SQL52 and CSV classification counts match exactly.
- A 2025-08-01 public preacher-schedule image explicitly belongs to South Hebron / Dura Awqaf. Its local review SHA256 was 79B4CC5F9B569C66F78361818F5A8A72880863FAFCEEF1F26172E422360BCE24, but no LGU was promoted from it because the image text could not be read with sufficient certainty and Arabic OCR was unavailable.
- No policy insert, DB data load, main merge, baseline promotion, or production action occurred.

## Targeted Hebron LGU evidence expansion — Batch 02 — 2026-09-20

- New authority-verified row: Samu→South Hebron, based on Samu Municipality's 2024 Tajweed-exam record explicitly at South Hebron Awqaf Directorate level.
- New supporting-only row: Ennab al-Saghira→South Hebron candidate, based on a 2025 South Hebron Awqaf Directorate visit record plus exact Core/GIS locality identity; no jurisdiction inference was promoted from the visit alone.
- Current matrix: 153 total / 132 current operational / 8 verified / 17 supporting / 107 unresolved / 20 excluded non-current / 1 status-review.
- Live read-only SQL count parity with CSV classification: PASS.
- No policy insert, DB data load, main merge, baseline promotion, or production action occurred.

## Targeted Hebron LGU evidence expansion — Batch 03 — 2026-09-20

- Hajj-specific current jurisdiction evidence found for South Hebron Awqaf.
- Newly authority-verified exact Core LGU matches: Kharsa→South Hebron, Deir Razah→South Hebron, Faqiqis→South Hebron.
- Salama→South Hebron remains SUPPORTING_EVIDENCE_ONLY because the source says “Khirbet Salama” while Core says “Salama”; no canonical alias currently proves exact identity.
- Current matrix: 153 total / 132 current operational / 11 verified / 18 supporting / 103 unresolved / 20 excluded non-current / 1 status-review.
- Matrix SHA256: ACC7A9F2D0E1E58AFF77F6C3EFC3823915168D35AEFC6DD7132A443E013B84CC.
- Registry SHA256: 920A3EC6A1CDFFD87CAA9A1F7F738274D231AC53D0F8FEC04B641F054CFD1C1F.
- SQL52 SHA256: BF5E4215A6B05B77B8AD5FCB2B71DC449FCD89FCA59F7D6FF7194F8A9B74E495.
- No policy insert, DB data load, main merge, baseline promotion, or production action occurred.

## Targeted Hebron LGU evidence expansion — Batch 04 — 2026-09-20

- Evidence quality improved for Nuba and Surif without promoting either row.
- Nuba now uses a current Palestinian Government Communication Center / WAFA Awqaf-intervention source; remains SUPPORTING_EVIDENCE_ONLY because jurisdiction is not explicit.
- Surif now uses a direct Surif Municipality relation with the Director of North Hebron Awqaf; remains SUPPORTING_EVIDENCE_ONLY because jurisdiction is not explicit.
- South Hebron regional-health/service evidence for Deir Samet, Beit Awwa, ar-Rihiya and related localities was explicitly rejected as authorization proof because another ministry's regional boundary does not establish Awqaf jurisdiction.
- Counts remain: 153 total / 132 current / 11 verified / 18 supporting / 103 unresolved / 20 excluded / 1 status-review.
- No policy insert, DB data load, main merge, baseline promotion, or production action occurred.

## Targeted Hebron LGU evidence expansion — Batch 05 — 2026-09-20

- No new LGU met AUTHORITY_VERIFIED threshold; FALSE_PROMOTIONS=0.
- Current Hajj operating evidence treats Halhul, Yatta, Dura, and Hebron as distinct pilgrim regions and directs winning pilgrims to their Awqaf directorate in their own region.
- Current South Hebron preacher schedules are explicitly labelled as mosques affiliated with South Hebron / Dura Awqaf, but individual mosque/locality rows remain image-only in the available source, so no row was inferred.
- Yatta Municipality development evidence confirms Awqaf Yatta manages Hajj/religious affairs in Yatta city and environs, but does not enumerate the unresolved LGUs sufficiently for authorization.
- Counts remain 153 total / 132 current / 11 verified / 18 supporting / 103 unresolved / 20 excluded / 1 status-review.
- No policy insert, DB data load, main merge, baseline promotion, or production action occurred.

## Targeted Hebron LGU evidence expansion — Batch 06 — 2026-09-20

- Tarqumiya→Hebron promoted to AUTHORITY_VERIFIED using direct 2022 Directorate of Awqaf Hebron restoration activity, corroborated by 2015/2016 records.
- Bani Na'im historical 2013 Directorate of Awqaf Hebron evidence retained as SUPPORTING_EVIDENCE_ONLY because it predates creation of North Hebron Awqaf.
- North Hebron 14-LGU composite model was explicitly rejected for authorization: a 2014 Awqaf source says North Hebron serves 14 local authorities, and a public-service list yields exactly 14 current Core LGU matches, but Tarqumiya is among that service-region set while direct 2022 Awqaf evidence assigns active operational control in Tarqumiya to Hebron Awqaf.
- Therefore SERVICE_REGION_BOUNDARY != AWQAF_JURISDICTION is now evidence-backed, not merely a design assumption.
- Counts: 153 total / 132 current / 12 verified / 17 supporting / 103 unresolved / 20 excluded / 1 status-review.
- No policy insert, DB data load, main merge, baseline promotion, or production action occurred.
