# BASELINE CHANGELOG — Nosok v38I-3

**Batch:** Nosok v38I-3 — Real Database Environment Census SQL Hotfix  
**Date:** 2026-05-21  
**Scope:** Development / Preparation Only  

## Reason

The referenced file `sql/38A_nosok_real_database_environment_census_read_only.sql` was mentioned as the correct next step but was missing from the baseline.

## Applied Change

Added the missing read-only SQL census file:

```text
sql/38A_nosok_real_database_environment_census_read_only.sql
```

The script performs SELECT-only environment discovery before any Nosok schema apply. It inspects:

- Existing schemas: `core`, `platform`, `public`, `gis`, `auth`, `storage`, `nosok`.
- Core reference candidates for `governorates`, `LGUs`, `org_units`, and `unit profiles`.
- Platform RBAC/system registry candidate shapes.
- Public wrapper/view/RPC surface.
- Existing `nosok` schema objects if any.
- RLS status and policies.
- Function/RPC collision risks for `public.rpc_nosok%`.
- Safe apply decision helper.

## Not Applied

```text
No schema creation
No SQL DDL/DML
No backend binding
No production approval
No PalWakf join execution
No waqf_assets mutation
```

## Decision

`sql/39_nosok_v38i_standalone_development_schema_creation_pack.sql` remains paused until the output of the real database census is reviewed.
