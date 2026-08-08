# SESSION HANDOFF — Nosok v29 PalWakf Merge Readiness

**Date:** 2026-05-20  
**Session:** تطوير نسك للحج والعمرة  
**Latest baseline:** `nosok_v29_palwakf_merge_readiness_pre_database_pack_2026_05_20.zip`  
**Previous baseline:** `nosok_v28b_sql_apply_evidence_binding_redecision_2026_05_20.zip`

## Current operating state

```text
staging-stable /
nosok-v29-palwakf-merge-readiness-applied /
database-schema-not-created-by-design /
sql-apply-not-required-until-platform-merge /
schema-design-finalized /
platform-registry-rbac-binding-plan-ready /
frontend-runtime-completion-applied /
pre-database-integration-pack-added /
production-not-approved /
no-waqf-assets-mutation
```

## Critical correction

The project must not keep asking for SQL apply evidence before the platform merge. The user clarified that Nosok tables are not built yet because Nosok must first be merged with PalWakf, then a dedicated `nosok` schema will be created.

This is now the governing rule:

```text
Before PalWakf merge: SQL/RPC = contracts/design/readiness only.
After PalWakf merge: create nosok schema in sandbox, then SQL/RPC/RLS UAT, then backend binding.
```

## What v29 delivered

1. A v29 readiness page at:

```text
/admin/systems/nosok/v29-merge-readiness
```

2. Schema design finalization for:

- `nosok.seasons`
- `nosok.applications`
- `nosok.applicants`
- `nosok.companions`
- `nosok.documents`
- `nosok.companies`
- `nosok.campaigns`
- `nosok.lottery_policies`
- `nosok.lgu_quota_snapshots`
- `nosok.lottery_draw_runs`
- `nosok.lottery_draw_results`
- `nosok.lottery_committee_decisions`
- `nosok.lottery_objections`
- `nosok.lottery_audit_events`

3. Platform Registry/RBAC binding plan:

- Dynamic System Registry entry
- System Sections binding
- Sidebar/Dashboard visibility
- Health/Maintenance/Error Boundary
- Platform AccessProfile override

4. Frontend runtime completion pack:

- Public service portal surfaces
- Internal operations console surfaces
- Lottery governance surfaces
- Company/Partner workspace surfaces
- v29 merge readiness surface

5. Pre-database integration pack.

## Next correct batch

```text
Nosok v30 — Full PalWakf Merge Pack Application
+ Platform Registry Entry
+ AccessProfile Override Closure
+ Browser/Role Responsive UAT Inside PalWakf
+ Nosok Schema Creation Preparation
```

Do not execute schema SQL until PalWakf merge is accepted.

## Retest required

Run locally:

```bash
dart format .
flutter analyze
flutter run -d chrome
```

Then open:

```text
/admin/systems/nosok/v29-merge-readiness
```

## Production blockers

- Full PalWakf repo merge not confirmed.
- Platform Registry entry not applied.
- AccessProfile override not closed.
- `nosok` schema not created by design.
- SQL/RPC/RLS UAT cannot run yet.
- Browser/Role/Responsive UAT inside PalWakf not attached.
- Production Gate not approved.

## Sovereign boundary

No mutation to `waqf_assets`, schema `waqf`, or `awqaf_system`.
