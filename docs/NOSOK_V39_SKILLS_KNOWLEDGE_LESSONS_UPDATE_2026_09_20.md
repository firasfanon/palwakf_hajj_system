# Nosok v39 — Skills, Knowledge, and Lessons Update

Date: 2026-09-20
Scope: Unit/LGU authority, public-runtime reality reconciliation, evidence governance, and controlled DB gates.

## Skills promoted

1. **Fresh Sovereign Reconciliation**
   - Always reconcile GitHub code truth + Workspace Drive sovereign state + live Supabase reality before mutation.
   - Lock branch, exact HEAD, main HEAD, DB migration state, policy row count, and worktree cleanliness.

2. **Canonical Administrative Identity Resolution**
   - Authorize by `core.org_units.id`, never by `unitSlug`.
   - Treat slugs/names as display/navigation aliases only.
   - Detect organizational label drift without mutating canonical UUID identity.

3. **Current Administrative Geography Resolution**
   - Use `core.core_governorates` and `core.core_lgus` for current operational geography.
   - Treat `core.core_communities` as historical/reference-only for Nosok authorization.
   - Cross-check current LGUs against `gis.lgus_boundary`.

4. **Fail-Closed Multi-Directorate Scope Review**
   - A governorate may contain multiple Awqaf directorates.
   - Never infer all LGUs in the governorate into one directorate.
   - Missing Unit→LGU mapping must deny scope rather than broaden it.
5. **Evidence-Graded Jurisdiction Review**
   - Separate direct Awqaf/Hajj jurisdiction evidence from supporting regional evidence.
   - Use explicit states: `AUTHORITY_VERIFIED`, `SUPPORTING_EVIDENCE_ONLY`, `UNRESOLVED_FAIL_CLOSED`.
   - Reject service/health/agriculture boundaries as substitutes for Awqaf jurisdiction.

6. **Authority Review Pack Construction**
   - Review canonical LGU UUIDs, not free-text geography.
   - Limit directorate choices to live canonical Core UUIDs.
   - Require decision/reference/effective-date/reviewer metadata for approved rows.

7. **Approved-Only Load Dataset Generation**
   - Generate a separate dataset containing only organizationally approved mappings.
   - Validate duplicate IDs, invalid unit UUIDs, cross-governorate assignments, and ambiguous approvals.
   - SHA-lock both reviewed master and load-only dataset before any DB authorization.

8. **Controlled Migration / Data-Load Separation**
   - Schema migration authority is not data-load authority.
   - Migration 45 created the policy structure only; authority data remains separately gated.
   - No DB insert occurs merely because a reviewed dataset exists.

## Knowledge promoted

```text
CURRENT_ADMIN_GEOGRAPHY = core.core_lgus
HISTORICAL_REFERENCE = core.core_communities
UNIT_AUTHORIZATION_KEY = core.org_units.id
LGU_AUTHORIZATION_KEY = core.core_lgus.id
UNIT_SLUG_AUTHORIZATION = FORBIDDEN
COMMUNITY_AUTHORIZATION = FORBIDDEN
```
Current West Bank operational LGU census used by Nosok:
- 722 active LGU rows in governorates 1–11.
- 722/722 matched to `gis.lgus_boundary`.
- External geographic registry is not required for Nosok scope.

Hebron canonical directorate UUIDs:
- North Hebron / Halhul: `04f19f65-5e0c-47df-b897-9dd88152ea6c`
- South Hebron / Dura: `7270d37a-6eca-4fd4-8abe-0164022f9a80`
- Yatta: `7e391f77-ded8-4ea8-b0eb-d518507ff194`
- Hebron: `8e0238db-2e20-49d4-8cf2-db7c376d512b`

Migration 45:
- Table: `nosok.administrative_unit_lgu_scope_policy`
- Resolver: `public.rpc_nosok_unit_lgu_scope_resolve_v1(uuid,uuid)`
- Validator trigger rejects invalid/inactive/cross-governorate mappings.
- Direct table access for anon/authenticated is denied.
- Current policy rows: 0.

Authorized organizational review result:
- Current operational Hebron rows: 132.
- APPROVED: 12.
- NEEDS_REVIEW: 120.
- EXCLUDED: 0.
- Approved-only load rows: 12.
## Lessons learned from errors

### L1 — Slug assumptions are unsafe
The earlier synthetic assumption `bethlehem` was wrong; the live canonical Bethlehem slug is `bth`.
**Rule:** UUID first; slug never authorizes.

### L2 — Governorate inheritance can over-authorize
Hebron contains four active Awqaf directorates.
**Rule:** same governorate is only an integrity check, never sufficient jurisdiction proof.

### L3 — Historical communities are not current administrative scope
`core.core_communities` represents the older community layer.
**Rule:** current Nosok administrative authorization uses `core.core_lgus`.

### L4 — Service-region geography is not Awqaf jurisdiction
Tarqumiya appeared in a North-Hebron service-region grouping, while direct 2022 Awqaf evidence tied operational Awqaf control in Tarqumiya to Hebron Directorate.
**Rule:** SERVICE_REGION_BOUNDARY != AWQAF_JURISDICTION.

### L5 — Public organizational labels can drift
Public material uses North/South Hebron while Core has Halhul/Dura canonical rows.
**Rule:** preserve UUID identity; treat label changes as lineage/display drift until separately reconciled.

### L6 — Alias matching must not be guessed
Source label `خربة سلامة` was not automatically equated to Core `سلامه`.
**Rule:** no authorization from probable name equivalence without a canonical alias/crosswalk.
### L7 — Supporting evidence is not approval
Municipal visits, regional service lists, school visits, and other ministry boundaries may support research but do not establish jurisdiction.
**Rule:** promote only direct, defensible Awqaf/Hajj evidence.

### L8 — No synthetic DB authority identity
Migration 45 requires `approved_by uuid` + `approved_at` for approved policy rows.
The review label `PALWAKF_NOSOK_AUTHORIZED_ORGANIZATIONAL_REVIEW_V1` is not a UUID.
**Rule:** separate DATA LOAD authorization must provide/bind a valid active administrative UUID; never fabricate or infer one.

### L9 — Schema apply and authority-data load are separate gates
Migration 45 is applied, but policy rows remain 0.
**Rule:** schema readiness does not imply data authorization.

### L10 — Public runtime contracts must follow live DB reality
The live Nosok backend is campaign-based; old season/program RPC assumptions caused 404s.
**Rule:** reconcile runtime contracts from live schema/RPCs before UI evidence.

### L11 — Browser evidence must be fresh
Cached builds can invalidate negative/positive UAT.
**Rule:** rebuild with exact dart-define, use fresh Chrome profile/cache-disabled evidence, and capture route/network/AX proof.

### L12 — Production evidence is stricter than code success
Analyze/build/test PASS is insufficient while authority mapping, privacy contracts, submit success, or external integrations remain unresolved.
**Rule:** maintain separate gates for task branch, DB mutation, main merge, baseline promotion, and production.
