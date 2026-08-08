# Nosok v33 — Negative UAT Matrix

| case | expected | current status |
|---|---|---|
| anonymous direct table access | denied by RLS/policy | SQL presence accepted; client evidence pending |
| authenticated without Nosok role | Arabic forbidden through Platform Access Gateway | pending |
| wrong unit/LGU scope | denied | pending |
| reviewer within scope | limited rows only | pending |
| public tracking | privacy-filtered response | pending wrapper/RPC apply |
| public base table scan | no new public service base tables | accepted |
| Flutter service_role scan | no service_role in Flutter | pending retest |
