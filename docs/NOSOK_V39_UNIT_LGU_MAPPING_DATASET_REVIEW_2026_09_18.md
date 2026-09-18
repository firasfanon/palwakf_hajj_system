# Nosok v39 — Authoritative Unit→LGU Mapping Dataset Review

Date: 2026-09-18

## Decision

`NOSOK_V39_UNIT_LGU_DATASET_REVIEW_PARTIAL_AUTHORITY_GAP_BLOCKS_DATA_LOAD`

## Canonical identities

- Administrative-unit identity: `core.org_units.id`.
- LGU identity: `core.core_lgus.id`.
- `unitSlug` and LGU names/codes are aliases only; they never authorize.
- Nosok owns only the policy relation created by Migration 45.

## Source hierarchy

1. Palestinian Ministry of Awqaf and Religious Affairs is the authority for which Awqaf directorate a Hajj address belongs to.
2. Palestinian Ministry of Local Government is the external public authority for local-government entities / governorate context.
3. PalWakf `core.org_units` and `core.core_lgus` remain the canonical internal IDs consumed by Nosok.
4. Legacy `awqaf_system.user_unit_scopes` is not authority; it currently contains zero rows and uses obsolete `unit_slug + lgu_code` semantics.

## Current official evidence

The current official Hajj page states that registration uses the identity-card address and that a citizen whose actual address is not present must review the Awqaf directorate to which the address belongs.

Official public reference:
- https://nosok.pal-wakf.ps/pilgrimage.php

The Ministry's public organizational page states that directorates and branches are part of the ministry structure and that the ministry prepared an organizational guide, but the public site does not expose a complete current Directorate→LGU crosswalk.

Official public reference:
- https://pal-wakf.ps/about-ministry

Ministry of Local Government public reference:
- https://www.molg.pna.ps/ar/Locales

## Historical supporting evidence

A 2018 Hajj-registration announcement attributed to the Ministry of Awqaf explicitly grouped localities under Hebron, Dura, Yatta, and Halhul areas. It is useful evidence of the historical jurisdiction model, but it is not accepted as a current production crosswalk because it is old and was issued for a partial-registration window.

## Census result

Within active LGUs assigned to governorates 1–11:

- Total active LGU records: **722**.
- Active Awqaf directorates: **14**.
- LGUs in governorates with exactly one active directorate: **569**.
- LGUs in Hebron governorate, which has four active directorates: **153**.

The 569 rows are deterministic **candidates**, not production-approved mappings. The 153 Hebron rows remain unresolved until a current Ministry of Awqaf jurisdiction roster/export is obtained.

## Safety classification

`DETERMINISTIC_SINGLE_DIRECTORATE_CANDIDATE` means the canonical unit and LGU share the same canonical governorate and there is exactly one active directorate in that governorate.

`NEEDS_CURRENT_AWQAF_JURISDICTION_ROSTER` means the governorate has multiple active directorates, so governorate inheritance would over-authorize.

No candidate is promoted to `AUTHORITY_VERIFIED` merely because it is deterministic.

## Data-load gate

Data load is not authorized and is not yet ready.

Required before any insert:

- current Ministry of Awqaf Directorate→address/LGU roster or controlled export;
- row-by-row reconciliation to canonical `core.core_lgus.id`;
- zero ambiguous/unmatched rows;
- explicit source reference and authority version/date;
- separate data-load authorization.

Current state:

```text
DATASET_REVIEW=PARTIAL_PASS
AUTHORITY_SOURCE_IDENTIFIED=YES
CURRENT_COMPLETE_CROSSWALK_AVAILABLE=NO
CANDIDATE_ROWS=722
DETERMINISTIC_CANDIDATES=569
UNRESOLVED_HEBRON_ROWS=153
LOAD_READY_ROWS=0
AUTHORITY_DATA_LOAD=NO
PRODUCTION=NO
```
