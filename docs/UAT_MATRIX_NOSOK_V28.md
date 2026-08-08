# UAT Matrix — Nosok v28

| Area | Check | Expected |
|---|---|---|
| Flutter analyzer | `flutter analyze` | No issues found |
| Chrome startup | `flutter run -d chrome` | Debug service starts |
| Owner schema page | `/admin/systems/nosok/v28-owner-schema-design` | Shows design tables |
| Guarded DDL page | `/admin/systems/nosok/v28-guarded-ddl-draft` | Shows DDL draft not applied |
| RLS/RPC matrix page | `/admin/systems/nosok/v28-rls-rpc-matrix` | Shows RLS/RPC matrices |
| Execution gate page | `/admin/systems/nosok/v28-execution-authorization-gate` | Shows DDL blocked |
| SQL read-only | `sql/26_nosok_v28_owner_schema_design_read_only.sql` | SELECT output only |
| Guarded DDL | DDL draft file | Must abort by default |
| Public table rule | Scan SQL | No public base table apply authorized |
