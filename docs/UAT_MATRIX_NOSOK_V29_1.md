# UAT Matrix — Nosok v29.1

| Area | Evidence | Result |
|---|---|---|
| SQL preflight | `sql/27_nosok_v29_authorization_preflight_read_only.sql` result | passed read-only |
| `nosok` schema presence | `nosok_present=false` | accepted; not created |
| Public base tables | `PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY` | passed |
| Candidate conflicts | `[]` | passed |
| DDL/DML safety | `ddl_executed=false`, `dml_executed=false` | passed |
| Waqf boundary | `waqf_assets_mutation_authorized=false` | passed |
| Flutter analyzer | `No issues found!` | passed |
| Chrome startup | Debug service reached | passed |
| Supabase client | `Supabase init completed` | passed |
| Guarded staging apply | not run | pending authorization |
| RLS/RPC negative UAT | not run | pending staging apply |
