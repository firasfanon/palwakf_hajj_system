# PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE — Awqaf System 7 Update

## 2026-06-05 — Operational Read Console Asset Drilldown Expansion

Decision:

```text
AWQAF_SYSTEM_7_WAQF_ASSETS_OPERATIONAL_READ_CONSOLE_ASSET_DRILLDOWN_EXPANSION_IMPLEMENTED_READ_ONLY_RETEST_REQUIRED
```

Status:

```text
scoped-production-active / operational-read-console-asset-summary-surface-added / rpc-waqf-assets-search-wired / source-records-review-queue-lifecycle-preserved / no-new-table-build / no-sql-apply / write-still-disabled / global-production-not-approved / no-waqf-assets-mutation
```

The Operational Read Console now includes a matched waqf-assets read surface backed by `public.rpc_waqf_assets_search_v1` via the existing repository. This continues Waqf Assets development without building tables and without enabling any write/review/apply operation.

---

# PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE — Awqaf System 7 Update

## 2026-06-04 — Operational Read Console Network Evidence Closure

Decision:

```text
AWQAF_SYSTEM_7_OPERATIONAL_READ_CONSOLE_NETWORK_EVIDENCE_ACCEPTED_ROUTE_NETWORK_BINDING_CERTIFIED_ANALYZER_RETEST_PENDING_FULL_READ_ONLY_CERTIFICATION_DEFERRED_NO_WRITE
```

Status:

```text
scoped-production-active / operational-read-console-route-renders-correct-surface / network-rpc-200-evidence-accepted / route-network-binding-certified / analyzer-retest-not-supplied-after-hotfix / full-read-only-runtime-certification-deferred-analyzer-pending / write-still-disabled / global-production-not-approved / no-waqf-assets-mutation
```

The Operational Read Console route now renders the correct read-only surface and Network evidence shows RPC 200 responses for the operational read-surface family. Full static certification remains deferred pending a fresh analyzer run after the latest dependency inclusion hotfix.

No SQL apply, no table build, no write/review/apply enablement, and no mutation on `waqf.waqf_assets` were performed in this pack.


---

## Awqaf System 7 — Operational Read Console Asset Drilldown Browser/Analyzer Result Intake — 2026-06-05

**Decision:** `AWQAF_SYSTEM_7_OPERATIONAL_READ_CONSOLE_ASSET_DRILLDOWN_FORMAT_ANALYZER_ACCEPTED_BROWSER_RUNTIME_BLOCKED_BY_DWDS_TIMEOUT_RETEST_REQUIRED_NO_WRITE`

**Summary:** Local retest evidence after Asset Drilldown expansion was ingested. `flutter pub get` passed, targeted `dart format` passed for four files, `flutter analyze` remained at 182 known platform-wide issues with no visible Asset Drilldown missing dependency blocker, and `flutter run -d chrome` was blocked by a DWDS web debug service timeout. Browser runtime certification for the matching-assets section is deferred pending a clean Chrome retest.

**Status:** `scoped-production-active / asset-drilldown-expansion-applied / dart-format-passed-4-files-3-changed / analyzer-preserved-182-platform-wide-issues / asset-drilldown-compile-blocker-not-observed / flutter-run-blocked-by-dwds-web-debug-service-timeout / browser-runtime-retest-required / write-still-disabled / global-production-not-approved / no-waqf-assets-mutation`

**Next:** `Awqaf System 7 — Operational Read Console Asset Drilldown Chrome DWDS Retest + Browser Evidence Intake`


---

## Awqaf System 7 — Operational Read Console Asset Drilldown DWDS/Platform Gateway Evidence Intake — 2026-06-05

Decision: `AWQAF_SYSTEM_7_OPERATIONAL_READ_CONSOLE_ASSET_DRILLDOWN_DWDS_RETEST_PLATFORM_GATEWAY_CENTRAL_EVIDENCE_ACCEPTED_ROLE_UNIT_UAT_PENDING_NO_WRITE`.

Description: evidence intake only. Central Chrome evidence shows the operational-read-console route, actor strip, RBAC banner, startup logs, and Asset Drilldown metric. Role/unit and search RPC Network evidence remain pending. No SQL/write/source-code change.


## Awqaf System 7 — Waqf Assets User Screens Read-Only Workspace

Decision: `AWQAF_SYSTEM_7_WAQF_ASSETS_USER_SCREENS_READ_ONLY_IMPLEMENTED_RETEST_REQUIRED`

Added a read-only user-facing route for Waqf Assets:
`/systems/awqaf-system/waqf-assets/user-screens`

Unit route pattern:
`/{unitSlug}/systems/awqaf-system/waqf-assets/user-screens`

The screen consumes governed read surfaces only and does not authorize write/review/apply.

---

## Nosok v38 — Public Campaigns/Requirements Runtime Adapter Integration — 2026-06-09

**Decision:** `PUBLIC_CAMPAIGNS_REQUIREMENTS_RUNTIME_ADAPTER_INTEGRATED_NETWORK_RPC_EVIDENCE_CLOSABLE_PRODUCTION_DEFERRED`

**Summary:** Nosok public campaigns and requirements were connected to a governed runtime controller that uses `NosokPublicWrapperRpcAdapter` and public RPC wrappers only. `/services/nosok` now exposes a citizen-safe campaigns runtime panel, and `/services/nosok/requirements` now exposes runtime requirements with safe fallback when live RPC is unavailable.

**Status:** `staging-stable / public-campaigns-requirements-runtime-adapter-integrated / network-rpc-evidence-closure-pack-prepared / production-gate-redecision-deferred / submit-track-privacy-pending / role-scope-negative-pending / no-public-base-table-creation / no-waqf-assets-mutation`

**Rules preserved:** public remains wrappers-only, no direct public Flutter read from `nosok.*` for the updated surfaces, no `service_role`, no DDL/DML/GRANT/REVOKE, no public base table creation, and no mutation on `waqf_assets`, `waqf`, or `awqaf_system`.

**Next:** `Nosok v38 — Submit/Track Privacy Network Evidence + Role/Scope Negative UAT Closure + Final Production Gate Re-decision`.


---

## Nosok v38 — Submit/Track Privacy + Negative UAT Final Gate Addendum — 2026-06-09

Decision: `SUBMIT_TRACK_PRIVACY_HARDENED_NEGATIVE_UAT_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_PENDING_ACTUAL_BROWSER_EVIDENCE`.

Applied as a pre-join Nosok hardening batch under PalWakf governance:

- Public submit is constrained to `public.rpc_nosok_public_submit_application_v1` through Supabase RPC only.
- Public track is constrained to `public.rpc_nosok_public_application_status_by_token_v1` through Supabase RPC only.
- Direct citizen-surface fallback to `nosok.applications` and direct DML fallback into `nosok.*` were removed from `NosokSupabaseRepository`.
- Final v38 gate page added: `/admin/systems/nosok/v38-final-production-gate`.
- Production remains blocked pending actual local Browser/Network evidence and Flutter retest.
- No SQL production apply, no DDL/DML/GRANT/REVOKE, no service_role, no platformHosted switch, and no `waqf_assets` mutation.


---

## Nosok v39 — Tawaf Public Reality Gap Adapter — 2026-09-16

**Decision:** `TAWAF_PUBLIC_REALITY_GAP_ADAPTER_AND_EVIDENCE_MATRIX_PREPARED_PRODUCTION_NOT_APPROVED_NO_EXTERNAL_INTEGRATION`

**Summary:** Public observations from the Tawaf/Nosok official public site were converted into a governed Nosok v39 contract and admin evidence matrix. The new route is `/admin/systems/nosok/v39-tawaf-reality-gap` and is protected by `NosokPermissionKeys.redecideNosokProductionGate`.

**Scope:** civil registry/address authority, identity types and Jerusalem ID attachment, OTP/SMS, bank/eSadad payment reconciliation, company directory import/versioning, company Captcha/session controls, and lottery result evidence.

**Status:** `staging-stable / v39-reality-gap-adapter-integrated-contract-only / authority-provider-integrations-not-executed / production-not-approved / local-flutter-retest-required / no-external-integration / no-waqf-assets-mutation`

**Rules preserved:** no scraping, no Captcha bypass, no private citizen data extraction, no third-party credentials/sessions, no DDL/DML/GRANT/REVOKE, no service_role, no platformHosted switch, no direct citizen Flutter read from `nosok.*`, no public base table creation, and no mutation on `waqf_assets`, `waqf`, or `awqaf_system`.

**Next:** `Nosok v39 — Local Flutter Analyzer + Browser Route Evidence + Negative Role/Network No-External-Call Evidence Intake`.
