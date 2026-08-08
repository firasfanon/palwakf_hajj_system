# NOSOK_OWNER_SCHEMA_DIFF_PLAN_V27

**Project:** PalWakf / Nosok للحج والعمرة  
**Batch:** Nosok v27  
**Mode:** Owner review / guarded-not-applied / no DDL / no DML

## Decision

```text
NOSOK_V27_OWNER_SCHEMA_DIFF_PREPARED_SQL_EXECUTION_BLOCKED
```

## Census inputs

The user-provided light census confirms:

- `nosok` schema is not detected in the current light census.
- `core` is present and remains the sovereign reference source for `org_units`, `LGU`, `governorates`, and unit slugs.
- `public` has existing base tables, but new public base table creation is blocked.
- `billing_system` exists and must be used as payment bridge owner instead of duplicating e-payment tables.
- `platform_access` exists and remains access/RBAC owner.
- `waqf` and `awqaf_system` exist and remain outside Nosok mutation scope.

## Diff summary

| Object | Action | Gate |
|---|---|---|
| `nosok` schema | create-after-authorization | Explicit SQL authorization required |
| `nosok.campaigns` | create-candidate | RLS/RPC/UAT/rollback required |
| `nosok.applications` | create-candidate | Privacy + RLS + storage UAT required |
| `nosok.application_documents` | create-candidate | Metadata only + storage policy required |
| `nosok.eligibility_rules` | create-candidate | Ministry approval workflow required |
| `nosok.lgu_quotas` | create-candidate | LGU must reference core |
| `nosok.lottery_runs` / `nosok.lottery_entries` | defer-create | Legal algorithm/audit approval required |
| `public.* base table` | reject | Permanently blocked |

## Non-negotiable constraints

```text
No CREATE TABLE public.*
No duplication of core org_units/governorates/LGU as source of truth
No service_role in Flutter
No production lottery
No production payment
No write to core/platform/public/waqf/awqaf_system
```
