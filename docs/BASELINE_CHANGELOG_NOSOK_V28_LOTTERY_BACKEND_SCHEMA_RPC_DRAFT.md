# BASELINE CHANGELOG — Nosok v28 Lottery Backend Schema/RPC Draft

**Date:** 2026-05-20  
**Baseline source:** `nosok_v27d1_admin_dashboard_entry_fix_2026_05_20.zip`  
**Batch:** `Nosok v28 — Lottery Backend Schema/RPC Draft + SQL UAT + Real Supabase Integration Plan`  
**Type:** Backend draft + SQL UAT + integration readiness; no production SQL apply.

## Operating judgement

```text
staging-stable /
nosok-v28-lottery-backend-schema-rpc-draft-applied /
sql-uat-read-only-pack-added /
real-supabase-integration-plan-documented /
production-not-approved /
no-waqf-assets-mutation
```

## What changed

### Flutter/Dart readiness surface

Added a backend contract surface for lottery backend readiness:

- `lib/features/nosok_system/domain/models/nosok_lottery_backend_contract.dart`
- `lib/features/nosok_system/application/nosok_lottery_backend_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v28_lottery_backend_readiness_page.dart`

The page exposes:

- proposed `nosok` lottery tables,
- public/admin RPC wrappers,
- RLS/privacy contracts,
- SQL UAT checks,
- real Supabase integration milestones,
- production blockers.

### Routing/navigation

Added:

```text
/admin/systems/nosok/v28-lottery-backend-readiness
```

Updated:

- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart`
- `lib/features/nosok_system/system_navigation.dart`

### SQL

Added two SQL files:

1. `sql/27_nosok_v28_lottery_backend_schema_rpc_draft.sql`
   - DDL/RPC draft inside transaction.
   - Ends with `ROLLBACK` by default.
   - Must not be applied to production.

2. `sql/28_nosok_v28_lottery_backend_read_only_uat.sql`
   - read-only checks only.
   - Verifies schema/tables/RPC/RLS surfaces after sandbox apply.
   - No DML, no DDL, no `waqf_assets` mutation.

## Backend contracts introduced

### Proposed tables

- `nosok.lottery_policies`
- `nosok.lgu_quota_snapshots`
- `nosok.lottery_eligibility_snapshots`
- `nosok.lottery_draw_runs`
- `nosok.lottery_draw_results`
- `nosok.lottery_committee_decisions`
- `nosok.lottery_objections`
- `nosok.lottery_audit_events`

### Proposed RPCs

- `public.rpc_nosok_lottery_public_result_v1`
- `public.rpc_nosok_lottery_submit_objection_v1`
- `public.rpc_nosok_lottery_admin_policy_snapshot_v1`
- `public.rpc_nosok_lottery_admin_freeze_eligibility_v1`
- `public.rpc_nosok_lottery_admin_execute_draw_v1`
- `public.rpc_nosok_lottery_committee_decision_v1`
- `public.rpc_nosok_v28_lottery_backend_readiness_v1`

## Boundaries preserved

- No production SQL was executed.
- No DML seed data was added.
- No `waqf_assets` mutation.
- No schema `waqf` change.
- No `awqaf_system` change.
- Public result RPC contract remains single-request safe.
- Committee decision remains required for underfilled LGU quota.
