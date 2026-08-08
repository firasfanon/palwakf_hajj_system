# UAT MATRIX — Nosok v38I-3

| Area | Check | Status | Notes |
|---|---|---:|---|
| Missing SQL | `sql/38A_nosok_real_database_environment_census_read_only.sql` exists | ready | Added in this batch. |
| Read-only guard | No DDL/DML statements | ready | Script is SELECT-only. |
| Core source | Discovers core reference candidates | ready | Governorates/LGUs/org units/profiles. |
| Public role | Inspects public wrapper/RPC surface | ready | Does not treat public as sovereign source. |
| Existing Nosok | Detects existing `nosok` schema objects | ready | Blocks blind apply if objects exist. |
| RLS/policies | Inventories RLS and policies | ready | Relevant schemas only. |
| RPC collision | Detects `public.rpc_nosok%` collisions | ready | Must be reviewed before apply. |
| Schema apply | Create pack remains paused | pending | Await census results. |
| Production | Approval | not approved | Development/staging only. |
