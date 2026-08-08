# Nosok v32.1 — Controlled Staging DDL Apply Evidence Intake + Post-Apply RLS Result Closure

**Project:** PalWakf / Nosok للحج والعمرة  
**Date:** 2026-06-05  
**Mode:** Evidence intake / staging certification / production gate remains blocked  

## 1. Operator result received

The submitted post-apply read-only result confirms that the controlled staging DDL apply has created the Nosok owner schema and the approved initial table set.

## 2. Accepted facts

| Check | Result |
|---|---|
| `nosok` schema | present |
| Approved `nosok.*` base tables | 8/8 present |
| RLS | enabled on 8/8 candidate tables |
| New `public.nosok*` / `public.hajj*` / `public.umrah*` base tables | not detected |
| Production approval | false |
| DML by certification script | false |
| `waqf_assets` mutation | false |

## 3. Tables detected

- `nosok.campaigns`
- `nosok.applications`
- `nosok.application_documents`
- `nosok.eligibility_rules`
- `nosok.quota_rules`
- `nosok.lgu_quotas`
- `nosok.workflow_events`
- `nosok.audit_events`

## 4. RLS result

RLS is detected as enabled on all eight initial owner-schema tables. `force_rls=false` is accepted for staging certification but must be re-evaluated before production candidate approval.

## 5. Gate decision

```text
NOSOK_V32_1_CONTROLLED_STAGING_DDL_APPLY_DETECTED_RLS_ENABLED_NEGATIVE_UAT_REQUIRED
```

## 6. What remains blocked

- Production approval.
- Public base table creation.
- Lottery production execution.
- Payment production execution.
- Any mutation to `waqf`, `waqf_assets`, or `awqaf_system`.
- Any write/review/decision flow before RLS/RPC negative UAT evidence is completed.

## 7. Required next evidence

The next gate must prove fail-closed behavior for:

1. anonymous direct table access denied;
2. authenticated user without Nosok role denied;
3. wrong unit/LGU scope denied;
4. allowed scoped actor receives only allowed rows or approved RPC surfaces;
5. public tracking does not expose internal payload;
6. no Flutter `service_role` usage;
7. no new base table in `public`;
8. no write path from the browser except explicitly approved RPC/service surfaces.

## 8. Status

```text
staging-stable /
controlled-staging-ddl-apply-detected /
nosok-owner-schema-created /
initial-nosok-tables-present /
rls-enabled-on-initial-owner-tables /
negative-uat-required /
production-not-approved /
no-public-base-table-created /
no-waqf-assets-mutation
```
