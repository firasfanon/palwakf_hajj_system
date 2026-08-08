# UAT Matrix — Nosok v29

| Test | Expected |
|---|---|
| v29 DDL authorization page renders | Page opens under admin route |
| v29 staging apply gate renders | Shows read-only allowed and guarded DDL blocked |
| v29 RLS/RPC preflight page renders | Shows required negative UAT cases |
| public base table check | No public.nosok_* base tables |
| no waqf mutation | No writes to waqf/awqaf_system |
| negative wrong unit | denied after apply |
| anonymous admin | denied after apply |
| reviewer writes rules | denied after apply |
