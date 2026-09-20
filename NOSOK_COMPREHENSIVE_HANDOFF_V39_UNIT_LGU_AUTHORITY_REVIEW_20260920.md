# NOSOK Comprehensive Handoff — v39 Unit/LGU Authority Review

Date: 2026-09-20
Purpose: sovereign handoff for a new development session.

## 1. Executive state

```text
PROJECT=NOSOK / MANASAKNA / PALWAKF_HAJJ_SYSTEM
REPOSITORY=firasfanon/palwakf_hajj_system
BRANCH=task/NOSOK-V39-RUNTIME-EVIDENCE-RESTORE-V1

ENGINEERING_HEAD_BEFORE_HANDOFF_DOCS=
5e9844412f4432a3510d6f7f646bedf9c8a3a6ae

MAIN_HEAD=
644ba350a73b413b7ccbe7a46369fa149543d6ce

CLASSIFICATION=BUILT_NOT_INTEGRATED
MAIN_MERGE=NO
SOVEREIGN_BASELINE_PROMOTION=NO
PRODUCTION=NO
```

The handoff/skills documentation commit after this engineering head is documentation-only. New session must perform fresh Git/Drive/DB reconciliation before any mutation.

## 2. Product operating model

- Hajj: government-supervised, coordinated with companies.
- Umrah: company-supervised, coordinated with government.
- Nosok serves the pilgrim/traveler while respecting those authority boundaries.
- Booking/commercial capability remains a bounded/parallel concern where authority differs.
## 3. Sovereign sources

```text
GitHub = code truth
Workspace Drive = sovereign baselines / current state / handoffs / governance
Supabase live DB = execution/data-schema reality
```

Canonical Workspace Drive current-state document:
`HAJJ_SYSTEM_CURRENT_STATE_V1_20260822`

Document ID:
`1r7LgyoteiAFIi0_xH4eI8V4OJZxVe5GUjphf1Te-VEo`

## 4. Administrative geography truth

```text
CURRENT_GOVERNORATE_AUTHORITY=core.core_governorates
CURRENT_ADMIN_GEOGRAPHY_AUTHORITY=core.core_lgus
HISTORICAL_REFERENCE_ONLY=core.core_communities
UNIT_AUTHORIZATION_KEY=core.org_units.id
LGU_AUTHORIZATION_KEY=core.core_lgus.id
UNIT_SLUG_AUTHORIZATION=FORBIDDEN
COMMUNITY_AUTHORIZATION=FORBIDDEN
```

Current operational census:
- 722 active LGUs in governorates 1–11.
- 722/722 match `gis.lgus_boundary` by current LGU numeric identity.
- External geographic registry is not required for Nosok authorization.

Critical rule:
`SERVICE_REGION_BOUNDARY != AWQAF_JURISDICTION`.
## 5. Hebron canonical directorates

Live Core UUID identities:

- North Hebron / Halhul lineage:
  `04f19f65-5e0c-47df-b897-9dd88152ea6c`
- South Hebron / Dura lineage:
  `7270d37a-6eca-4fd4-8abe-0164022f9a80`
- Yatta:
  `7e391f77-ded8-4ea8-b0eb-d518507ff194`
- Hebron:
  `8e0238db-2e20-49d4-8cf2-db7c376d512b`

Names/slugs are descriptive. UUIDs are authority keys.

## 6. Migration 45 status

Authorized and applied migration:

`nosok_v39_authoritative_unit_lgu_policy_mapping_schema_v1`

DB migration version:
`20260918153205`

Original authorized migration SHA256:
`751322312D4D659F5A549D7D12986001F40CE68508F5E7C14A314C58A6D97AB3`

Created:
- `nosok.administrative_unit_lgu_scope_policy`
- `public.rpc_nosok_unit_lgu_scope_resolve_v1(uuid,uuid)`
- validator function + trigger.
Migration behavior:
- canonical FK to `core.org_units.id`;
- canonical FK to `core.core_lgus.id`;
- optional campaign-specific override;
- RLS enabled;
- anon/authenticated direct table access denied;
- resolver available only through DB-side scope checks;
- invalid/inactive/cross-governorate mappings rejected;
- missing mapping = empty/fail-closed.

Current live DB:
```text
MIGRATION_45=APPLIED
POLICY_ROWS=0
AUTHORITY_DATA_SEED=NO
DATABASE_POLICY_DATA_LOAD=NO
```

## 7. Hebron evidence program result

Initial Hebron matrix:
- total Core rows: 153;
- current operational rows: 132;
- removed/displaced excluded: 20;
- status-review-required: 1.

Evidence work progressed through targeted batches without using service-region or proximity inference.

Final evidence matrix before organizational review:
- `AUTHORITY_VERIFIED=12`
- `SUPPORTING_EVIDENCE_ONLY=17`
- `UNRESOLVED_FAIL_CLOSED=103`.
## 8. Authorized organizational review — completed

Authorization received:
`AUTHORIZED_ORGANIZATIONAL_REVIEW_OF_HEBRON_120_ROW_PACK`

Result:
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

Only the 12 previously direct-evidence rows were approved.
No supporting-only or unresolved row was promoted merely because organizational review was authorized.

Reviewed master:
`evidence/NOSOK_V39_HEBRON_LGU_AUTHORITY_REVIEWED_MASTER_2026_09_20.csv`

APPROVED-only dataset:
`evidence/NOSOK_V39_HEBRON_LGU_APPROVED_LOAD_DATASET_2026_09_20.csv`

Read-only preflight:
`sql/53_nosok_v39_hebron_approved_load_preflight_read_only.sql`
## 9. Approved 12 mappings

North Hebron / Halhul:
- بيت أولا
- حلحول
- خاراس
- بيت أمر

Hebron:
- ترقوميا

Yatta:
- يطا

South Hebron / Dura:
- السموع
- دورا
- الظاهرية
- خرسا
- دير رازح
- فقيقيس

These are the only current mappings eligible for the next controlled load dataset.

The remaining 120 current LGUs stay `NEEDS_REVIEW` and fail-closed.

## 10. SHA locks

Reviewed master SHA256:
`AEF12AE43B847BB41061E7BD36BF54A169987C30843D27C94B3E2DCFFE7AEB2A`

Approved-only load dataset SHA256:
`E7F52F9EDCF8F943202A3CA1B51B081F73A694F45796A694E7397F7403FACCFE`
Authorized review result doc SHA256:
`FE4453EF49B07A716BF7502D077934B8BEAC967940FFE571E768F3C93EBD1556`

SQL53 preflight SHA256:
`F12F4134999DD1FFF5C877CAB63504566E2D597C7DD3DA1F5EAE8245B9A9274D`

Relevant result document:
`docs/NOSOK_V39_HEBRON_AUTHORIZED_ORGANIZATIONAL_REVIEW_RESULT_2026_09_20.md`

## 11. Critical blocker before DATA LOAD

Migration 45 requires:

```text
approved_by uuid NOT NULL for approved status
approved_at timestamptz NOT NULL for approved status
```

Organizational review label:
`PALWAKF_NOSOK_AUTHORIZED_ORGANIZATIONAL_REVIEW_V1`

This label is NOT a UUID.

Therefore:
- do not fabricate an `approved_by` UUID;
- do not infer it from reviewer name/label;
- separate DATA LOAD authorization must provide or bind a valid active administrative UUID.
## 12. Exact next gate

```text
SINGLE_NEXT_ACTION=
SEPARATE_DATA_LOAD_AUTHORIZATION_FOR_EXACT_12_ROW_APPROVED_DATASET
WITH_VALID_APPROVED_BY_UUID
```

Before executing that authorization, new session must run:

1. fresh Git branch/head readback;
2. fresh Workspace Drive current-state + handoff readback;
3. live Supabase migration 45 + `policy_rows=0` readback;
4. verify reviewed master SHA256;
5. verify approved load dataset SHA256;
6. verify SQL53 preflight again;
7. verify supplied `approved_by` UUID exists, is active, and is valid administrative identity;
8. prepare exact INSERT plan for the 12 rows only;
9. stop unless separate DATA LOAD authorization is explicit and hash-locked.

After authorized load:
- controlled insert;
- post-load census;
- resolver readback;
- LGU positive/negative UAT;
- production gate re-decision.

## 13. Forbidden next-session shortcuts

Do NOT:
- reopen `unitSlug` as an authorization key;
- use `core.core_communities` for current authorization;
- infer Awqaf scope from governorate, service council, health, education, or agriculture boundaries;
- add the 120 `NEEDS_REVIEW` rows to the load dataset;
- seed synthetic mappings;
- fabricate `approved_by`;
- merge to main;
- promote sovereign baseline;
- approve production.
## 14. Public runtime / production blockers still relevant

Even after Unit→LGU policy load, production re-decision must still consider:

- operational unit queue backend RPC certification;
- no open/published campaign for real submit-success evidence;
- submit PII metadata contract not approved;
- Civil Registry integration absent;
- OTP/SMS integration absent;
- payment/eSadad integration absent;
- company auth/Captcha integration absent;
- official lottery integration absent.

The live public backend is campaign-based, not the old season/program model.

Do not reintroduce absent legacy RPC names.

## 15. Existing v39 runtime evidence

Previously passed:
- campaigns RPC 200;
- requirements RPC 200;
- tracking RPC 200;
- tracking privacy boundary PASS;
- direct public table access absent in latest evidence;
- external authority calls absent;
- anonymous/no-role/wrong-permission denials PASS;
- allowed positive control PASS;
- Bethlehem canonical UUID scope allow PASS;
- Hebron out-of-scope deny PASS;
- `flutter analyze --no-pub` PASS;
- release web build PASS.

Production remained deferred.

## 16. Skills / Knowledge / Lessons

Read first:
`docs/NOSOK_V39_SKILLS_KNOWLEDGE_LESSONS_UPDATE_2026_09_20.md`

This file contains the promoted rules and errors that must not be repeated.
## 17. Session bootstrap for the new chat

Use this exact instruction:

```text
استأنف مشروع NOSOK / PALWAKF_HAJJ_SYSTEM من ملف التوريث:
NOSOK_COMPREHENSIVE_HANDOFF_V39_UNIT_LGU_AUTHORITY_REVIEW_20260920

اقرأ ملف التوريث كاملًا أولًا، ثم اقرأ:
docs/NOSOK_V39_SKILLS_KNOWLEDGE_LESSONS_UPDATE_2026_09_20.md
docs/NOSOK_V39_HEBRON_AUTHORIZED_ORGANIZATIONAL_REVIEW_RESULT_2026_09_20.md

نفذ Fresh Sovereign Reconciliation من:
GitHub code truth
+ Workspace Drive sovereign state
+ live Supabase reality

EXPECTED_BRANCH=
task/NOSOK-V39-RUNTIME-EVIDENCE-RESTORE-V1

ENGINEERING_HEAD_REFERENCE=
5e9844412f4432a3510d6f7f646bedf9c8a3a6ae

EXPECTED_MAIN=
644ba350a73b413b7ccbe7a46369fa149543d6ce

RESUME_FROM=
VERIFY_CURRENT_BRANCH_HEAD
→ VERIFY_POLICY_ROWS_ZERO
→ VERIFY_REVIEWED_MASTER_SHA
→ VERIFY_APPROVED_LOAD_DATASET_SHA
→ RESOLVE_VALID_APPROVED_BY_UUID
→ AWAIT/EXECUTE_SEPARATE_DATA_LOAD_AUTHORIZATION_ONLY_IF_EXPLICIT

NO_MAIN_MERGE
NO_BASELINE_PROMOTION
NO_PRODUCTION
```

## 18. Stop state

```text
AUTHORITY_REVIEW=COMPLETE
APPROVED_ONLY_DATASET=READY
DATA_LOAD=NOT_AUTHORIZED
POLICY_ROWS=0
MAIN_MERGE=NO
BASELINE_PROMOTION=NO
PRODUCTION=NO
```
