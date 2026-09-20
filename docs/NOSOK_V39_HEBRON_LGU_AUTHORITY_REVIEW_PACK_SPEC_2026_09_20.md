# Nosok v39 — Hebron LGU Authority Review Pack Specification

Date: 2026-09-20

## Purpose

Provide an authority-reviewable list of every current Hebron LGU that is not yet directly authority-verified.

Input:
`evidence/NOSOK_V39_HEBRON_LGU_SCOPE_EVIDENCE_MATRIX_2026_09_20.csv`

Review output template:
`evidence/NOSOK_V39_HEBRON_LGU_AUTHORITY_REVIEW_PACK_2026_09_20.csv`

The pack contains only current operational rows requiring a final authority decision:

```text
TOTAL_REVIEW_ROWS=120
SUPPORTING_EVIDENCE_ONLY=17
UNRESOLVED_FAIL_CLOSED=103
```

No database load is implied by completion of this file.
## Allowed canonical directorate identities

Authority reviewers must select one of the existing canonical Core UUIDs:

- Hebron: `8e0238db-2e20-49d4-8cf2-db7c376d512b`
- South Hebron / Dura lineage: `7270d37a-6eca-4fd4-8abe-0164022f9a80`
- Yatta: `7e391f77-ded8-4ea8-b0eb-d518507ff194`
- North Hebron / Halhul lineage: `04f19f65-5e0c-47df-b897-9dd88152ea6c`

Names and slugs are descriptive only. The UUID is the authority key.

## Required review fields

For every row, the authority reviewer must provide:

```text
authority_directorate_uuid
authority_directorate_label
authority_decision
authority_reference
authority_effective_date
authority_reviewer
authority_reviewed_at
authority_note
```
## Allowed authority decisions

- `APPROVED` — the LGU is currently within the selected directorate's jurisdiction.
- `EXCLUDED` — the LGU must not be in Nosok operational scope.
- `NEEDS_REVIEW` — jurisdiction cannot yet be determined.

Blank values are treated as `NEEDS_REVIEW`.

## Acceptance gates before any policy insert

A completed pack is load-eligible only if:

1. every current LGU row has exactly one decision;
2. every `APPROVED` row references one canonical directorate UUID;
3. no free-text directorate identity is accepted without its UUID;
4. every `APPROVED` row has an authority reference and effective date;
5. reviewer identity and review timestamp are present;
6. duplicate LGU assignments are zero;
7. cross-governorate assignments are zero;
8. all unresolved/ambiguous rows are explicitly retained as non-loadable;
9. the reviewed file hash is captured before authorization;
10. a separate DATA LOAD authorization is issued for the exact reviewed hash.

## Explicit exclusions

The following cannot authorize a row by themselves:

- service-council geography;
- education/health/agriculture regional boundaries;
- geographic proximity;
- historical community grouping;
- `unitSlug`;
- news activity that does not establish jurisdiction.

## Current gate

```text
AUTHORITY_REVIEW_PACK=PREPARED
DATABASE_DATA_LOAD=NO
POLICY_LOAD_READY=NO
PRODUCTION=NO
```
