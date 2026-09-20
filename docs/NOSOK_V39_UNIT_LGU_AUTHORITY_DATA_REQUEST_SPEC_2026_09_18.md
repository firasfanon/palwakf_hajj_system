# Nosok v39 — Unit→LGU Authority Data Request Specification

Date: 2026-09-18

## Purpose

Request a current Ministry of Awqaf and Religious Affairs jurisdiction roster/export that identifies which Awqaf directorate serves each registration address/locality used for Hajj.

This is an authority-data request, not a request to change `core.org_units` or `core.core_lgus`.

## Minimum required source metadata

- issuing authority / department;
- export or document title;
- effective date / season;
- generation timestamp;
- source reference number or URL where applicable;
- named approver or accountable organizational unit;
- whether the mapping is general-purpose or Hajj-season-specific.

## Required row fields

Each row must contain enough information to resolve both sides without guessing:
- directorate official name;
- directorate code or internal identifier if available;
- governorate;
- address / locality / LGU official name;
- LGU/locality official code or registry identifier if available;
- effective-from date;
- effective-until date if temporary;
- status (active / superseded / exceptional);
- source note / administrative decision reference;
- optional Hajj campaign/season restriction.

## PalWakf reconciliation output

The intake process must resolve every source row to:

```text
source_directorate → core.org_units.id
source_locality/LGU → core.core_lgus.id
```

Names and slugs are reconciliation aids only; UUIDs become the Nosok policy keys.

## Acceptance gates

The dataset may be marked `AUTHORITY_VERIFIED` only when:
- every source directorate resolves to exactly one active `core.org_units` directorate;
- every source locality/LGU resolves to exactly one active `core.core_lgus` row;
- governorate integrity matches;
- there are zero unresolved source rows;
- there are zero ambiguous multi-match rows;
- duplicate mappings are reconciled explicitly;
- validity windows do not conflict;
- all 153 currently unresolved Hebron LGUs are explicitly addressed or explicitly excluded by the authority source;
- reviewer and approval evidence are captured.

## Reject conditions

Reject the dataset for production if it is:
- inferred only from governorate membership;
- based only on `unitSlug` or LGU display names;
- copied from legacy `awqaf_system.user_unit_scopes`;
- derived solely from historical Hajj announcements;
- missing effective date / authority provenance;
- incomplete for a multi-directorate governorate.

## Current gate

```text
AUTHORITY_VERIFIED_ROWS=0
DATA_LOAD_AUTHORIZATION_READINESS=BLOCKED
NEXT_INPUT=CURRENT_MINISTRY_OF_AWQAF_DIRECTORATE_TO_ADDRESS_LGU_ROSTER_OR_CONTROLLED_EXPORT
```

## Supersession note — 2026-09-20

The request for an external geographic roster is superseded in part.

Current administrative geography is already canonical in PalWakf Core:

- `core.core_governorates` — current governorate authority;
- `core.core_lgus` — current local-authority / administrative-division authority;
- all 722 active LGUs in governorates 1–11 match `gis.lgus_boundary` 1:1 by `lgus_no ↔ lgusb_no`.

Therefore no external list of governorates, communities, or LGUs is required for Nosok.

The only unresolved evidence is organizational jurisdiction where multiple Awqaf directorates exist in the same governorate, currently Hebron. Any future external evidence request must be limited to the current directorate jurisdiction boundary / Unit→LGU allocation, not the geographic registry itself.
