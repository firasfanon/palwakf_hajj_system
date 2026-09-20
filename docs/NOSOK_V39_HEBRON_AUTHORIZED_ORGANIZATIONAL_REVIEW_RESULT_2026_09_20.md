# Nosok v39 — Hebron Authorized Organizational Review Result

Date: 2026-09-20

## Authorization

Authorization received:
`AUTHORIZED_ORGANIZATIONAL_REVIEW_OF_HEBRON_120_ROW_PACK`

This authorization permits organizational review and decisioning, but does not authorize database mutation.

## Review rule

Only rows with direct, defensible Awqaf/Hajj evidence were approved.

All other current rows remain `NEEDS_REVIEW` and therefore fail-closed.

No row was marked `EXCLUDED` without explicit exclusion evidence.

## Result

```text
CURRENT_OPERATIONAL_ROWS=132
APPROVED_ROWS=12
NEEDS_REVIEW_ROWS=120
EXCLUDED_ROWS=0

APPROVED_LOAD_ROWS=12
DUPLICATE_LGU_IDS=0
AMBIGUOUS_APPROVED_ROWS=0
INVALID_APPROVED_UUIDS=0
```
## Approved canonical assignments

The approved rows use only live canonical Core UUIDs:

- North Hebron / Halhul UUID: `04f19f65-5e0c-47df-b897-9dd88152ea6c`
- Hebron UUID: `8e0238db-2e20-49d4-8cf2-db7c376d512b`
- Yatta UUID: `7e391f77-ded8-4ea8-b0eb-d518507ff194`
- South Hebron / Dura UUID: `7270d37a-6eca-4fd4-8abe-0164022f9a80`

Approved LGUs are exactly the 12 rows previously classified as `AUTHORITY_VERIFIED` in the evidence matrix.

## Live database preflight

Read-only live preflight returned:

```text
ROWS=12
VALID_UNITS=12
VALID_LGUS=12
SAME_GOVERNORATE=12
PREEXISTING_POLICY_ROWS=0
```

No policy row currently exists for any approved mapping.
## Files

Reviewed master:
`evidence/NOSOK_V39_HEBRON_LGU_AUTHORITY_REVIEWED_MASTER_2026_09_20.csv`

APPROVED-only load dataset:
`evidence/NOSOK_V39_HEBRON_LGU_APPROVED_LOAD_DATASET_2026_09_20.csv`

Read-only DB preflight:
`sql/53_nosok_v39_hebron_approved_load_preflight_read_only.sql`

## Database approval identity requirement

Migration 45 requires `approved_by uuid` and `approved_at` for every approved policy row.

The organizational review has a stable review label:
`PALWAKF_NOSOK_AUTHORIZED_ORGANIZATIONAL_REVIEW_V1`

However, this label is not a database UUID.

Therefore the separate DATA LOAD authorization must provide or bind a valid active administrative UUID to `approved_by`.

No UUID will be fabricated or inferred.

## Gate

```text
AUTHORITY_REVIEW=COMPLETE
APPROVED_ONLY_DATASET=READY
ZERO_AMBIGUOUS_APPROVED_ROWS=PASS
DATABASE_DATA_LOAD=NO
POLICY_ROWS=0
SEPARATE_DATA_LOAD_AUTHORIZATION=REQUIRED
```
