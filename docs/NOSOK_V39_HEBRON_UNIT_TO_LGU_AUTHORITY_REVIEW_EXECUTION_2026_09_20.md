# Nosok v39 — Hebron Unit→LGU Authority Review Execution

Date: 2026-09-20

## Scope

This execution reviews the prepared 120-row authority pack up to, but not including, policy data load.

Fresh reconciliation:

```text
TASK_BRANCH=task/NOSOK-V39-RUNTIME-EVIDENCE-RESTORE-V1
TASK_HEAD=06f43133d1444398b40e25d87daa8040bcfebb64
ORIGIN_MAIN=644ba350a73b413b7ccbe7a46369fa149543d6ce
WORKTREE=CLEAN
MIGRATION_45=APPLIED
POLICY_ROWS=0
INPUT_PACK_SHA256=6B923B9466017C5115945720C772F87EA61C2A7E3F628E6F3A5C5EBC3F26A6F1
```

## Canonical directorates

All four allowed authority UUIDs were read back live from `core.org_units`; each is active, type `directorate`, and belongs to Hebron governorate.
- Hebron: `8e0238db-2e20-49d4-8cf2-db7c376d512b`
- South Hebron / Dura lineage: `7270d37a-6eca-4fd4-8abe-0164022f9a80`
- Yatta: `7e391f77-ded8-4ea8-b0eb-d518507ff194`
- North Hebron / Halhul lineage: `04f19f65-5e0c-47df-b897-9dd88152ea6c`

## Technical pre-review result

Output:
`evidence/NOSOK_V39_HEBRON_LGU_TECHNICAL_PRE_REVIEW_2026_09_20.csv`

```text
REVIEW_ROWS=120
DUPLICATE_LGU_IDS=0
INVALID_CANDIDATE_UUIDS=0
CANDIDATE_UUID_RESOLVED=17
NO_CANONICAL_DIRECTORATE_CANDIDATE=103
AUTHORITY_DECISION_NEEDS_REVIEW=120
APPROVED_ROWS=0
AMBIGUOUS_APPROVED_ROWS=0
LOAD_ELIGIBLE_ROWS=0
```

The 17 existing supporting candidates were translated to exact canonical Core UUIDs in a separate technical-candidate field. No candidate was written into an authority-approval field.
## Governance result

The pack cannot be truthfully converted into an authority-approved dataset by software review alone.

The existing evidence matrix contains technical/research evidence. It does not contain an authorized organizational decision for the remaining 120 current LGUs.

Therefore:

```text
AUTHORITY_REVIEW_TECHNICAL_PRECHECK=PASS
AUTHORITY_DECISION=NOT_PRESENT
ZERO_AMBIGUOUS_APPROVED_ROWS=PASS
ZERO_UNRESOLVED_ROWS=NO
LOAD_READY_APPROVED_ROWS=0
REVIEWED_AUTHORITY_DATASET_READY=NO
SEPARATE_DATA_LOAD_AUTHORIZATION_READY=NO
DATABASE_POLICY_INSERT=NO
```

No software agent, candidate slug, service-region boundary, or research inference may substitute for the missing authority decision.

## Required authority action

An authorized organizational reviewer must complete the 120-row pack using only the canonical UUIDs above and one of:

- `APPROVED`
- `EXCLUDED`
- `NEEDS_REVIEW`

Every APPROVED row must include authority reference, effective date, reviewer identity, and reviewed timestamp.
## Next gate

After receipt of the authority-completed file:

1. validate all 120 decisions;
2. reject duplicate/cross-governorate/free-text assignments;
3. require zero ambiguous APPROVED rows;
4. generate an exact load-only dataset containing APPROVED rows only;
5. calculate reviewed-file and load-dataset SHA256;
6. request separate DATA LOAD authorization locked to both hashes;
7. only then perform controlled policy insert.

Current production decision remains deferred.
