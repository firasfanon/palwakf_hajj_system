# Nosok v39 — Current LGU Administrative Scope Reconciliation

Date: 2026-09-20

## Governing correction

For current administrative authorization, Nosok must use `core.core_lgus` as the modern local-authority layer.

`core.core_communities` is retained as a historical/reference layer and MUST NOT authorize current operational scope.

```text
CURRENT_ADMIN_GEOGRAPHY = core.core_lgus
HISTORICAL_REFERENCE = core.core_communities
UNIT_AUTHORITY = core.org_units.id
LGU_AUTHORITY = core.core_lgus.id
COMMUNITY_AUTHORIZATION = FORBIDDEN
UNIT_SLUG_AUTHORIZATION = FORBIDDEN
```

## Fresh reconciliation

- Task branch: `task/NOSOK-V39-RUNTIME-EVIDENCE-RESTORE-V1`
- Starting head: `125769547375bc8a128284ceb624215fb563e918`
- Main remains: `644ba350a73b413b7ccbe7a46369fa149543d6ce`
- Worktree was clean before this batch.
## Current-LGU census

All active `core.core_lgus` rows in governorates 1–11 have a direct `lgus_no ↔ gis.lgus_boundary.lgusb_no` match.

```text
ACTIVE_CORE_LGUS_GOV_1_11 = 722
GIS_MATCHED = 722
GIS_UNMATCHED = 0
```

This establishes the 722-row set as the current operational LGU geography for this Nosok scope review.

## Directorate scope

For governorates with exactly one active Awqaf directorate in `core.org_units`, LGUs can be emitted as deterministic scope candidates by canonical governorate identity.

This yields:

```text
DETERMINISTIC_SINGLE_DIRECTORATE_CANDIDATES = 569
HEBRON_MULTI_DIRECTORATE_UNRESOLVED = 153
```

These are candidates only until the organizational-side scope is reconciled.
## Hebron exception

Hebron governorate currently has four active directorate records in Core:

- `hebron` — Directorate of Awqaf Hebron
- `dura` — Directorate of Awqaf Dura
- `yatta` — Directorate of Awqaf Yatta
- `halhul` — Directorate of Awqaf Halhul

The current Core geography is not ambiguous, but the organizational jurisdiction across those four directorates is not encoded in a canonical Unit→LGU table.

Therefore all 153 Hebron LGUs remain fail-closed.

## Organizational drift warning

Recent public evidence also uses labels such as “North Hebron Awqaf” and “South Hebron Awqaf”.

Those labels do not currently exist as active `core.org_units` rows.

No automatic mapping from those public labels to `halhul/yatta/dura/hebron` is permitted without explicit organizational reconciliation.

## Decision

```text
CURRENT_LGU_GEOGRAPHY = PASS
UNIT_TO_LGU_POLICY_DATA = PARTIAL
HEBRON_SCOPE = FAIL_CLOSED
DATABASE_DATA_LOAD = NO
PRODUCTION = NO
```
