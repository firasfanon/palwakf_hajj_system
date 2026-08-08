# UAT_MATRIX_NOSOK_V27

| Area | Route / Script | Expected | Status |
|---|---|---|---|
| Schema census page | `/admin/systems/nosok/v27-schema-census-result` | renders census facts | retest required |
| Reconciliation page | `/admin/systems/nosok/v27-existing-object-reconciliation` | renders matrix | retest required |
| Diff plan page | `/admin/systems/nosok/v27-owner-schema-diff-plan` | renders candidate/reject list | retest required |
| Safe SQL gate | `/admin/systems/nosok/v27-safe-sql-execution-gate` | shows execution blocked | retest required |
| SQL read-only | `sql/25_nosok_v27_schema_census_owner_diff_safe_gate_read_only.sql` | one result table, no writes | pending Supabase run |
| Public scan | no `CREATE TABLE public.*` | must pass | pending scan |
| Sovereign boundary | no waqf/awqaf mutation | must pass | pending scan |
