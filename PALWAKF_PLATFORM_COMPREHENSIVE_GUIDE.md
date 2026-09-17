# PALWAKF HAJJ / NOSOK COMPREHENSIVE GUIDE

## 2026-09-17 — Repository Contamination Cleanup

Foreign Awqaf implementation fragments were removed from this repository. awqaf_system and waqf_assets remain external PalWakf authorities/dependencies and are not embedded Hajj/Nosok feature roots. Read-only schema census evidence that references those authorities is intentionally preserved.

Verification after cleanup: whole-repository Flutter analyzer PASS, Web debug build PASS, deleted-path reference scan PASS.

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

---

## Nosok v39 — Administrative Unit Scope Reconciliation — 2026-09-17

**Decision:** `NOSOK_V39_ADMINISTRATIVE_UNIT_SCOPE_RECONCILED_PRODUCTION_DEFERRED`

Nosok administrative-unit authorization now uses canonical `core.org_units.id` through the safe public lookup RPC. `unitSlug` is not an authority key and remains only a navigation/display alias. The previous standalone value `bethlehem` was corrected against live data to canonical slug `bth` for org unit `1b39cc65-dc74-401f-a431-1fbf78cfbd0e`.

Governorate scope may be derived from the canonical org unit. LGU scope may not be expanded from governorate alone; where no explicit Unit→LGU mapping exists, Nosok fails closed. This prevents over-authorization in governorates such as Hebron where multiple directorates coexist.

Browser UAT proved Bethlehem canonical UUID ALLOW and Hebron canonical UUID DENY. Production remains deferred pending explicit LGU mapping, operational unit-queue backend, successful submit evidence/PII contract, and external authority/provider integrations.
