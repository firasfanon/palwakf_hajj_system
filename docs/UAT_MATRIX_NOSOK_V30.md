# Nosok v30 — UAT Matrix

| case | actor | target | expected | status |
|---|---|---|---|---|
| V30_SQL_001 | DBA/operator | `sql/28_nosok_v30_apply_result_intake_read_only.sql` | SELECT-only output | ready |
| V30_AUTH_001 | platform owner | owner authorization | owner_authorization_id supplied | pending |
| V30_AUTH_002 | DBA/operator | staging target | explicit staging only | pending |
| V30_AUTH_003 | DBA/operator | backup/snapshot | evidence supplied | pending |
| V30_APPLY_001 | DBA/operator | controlled DDL | create `nosok` schema only after authorization | blocked |
| V30_APPLY_002 | DBA/operator | public base tables | no `public.nosok_*` base tables | required-after-apply |
| V30_RLS_001 | SQL reviewer | owner tables | RLS enabled | blocked-until-apply |
| V30_NEG_001 | anonymous | admin/internal RPC | denied | blocked-until-apply |
| V30_NEG_002 | unit reviewer | wrong unit/LGU | forbidden/scope denied | blocked-until-apply |
| V30_NEG_003 | reviewer | rule/quota write | denied | blocked-until-apply |
| V30_NEG_004 | public applicant | document enumeration | denied | blocked-until-apply |
| V30_BOUNDARY_001 | SQL reviewer | `waqf/awqaf_system` | no DDL/DML | accepted-static |
