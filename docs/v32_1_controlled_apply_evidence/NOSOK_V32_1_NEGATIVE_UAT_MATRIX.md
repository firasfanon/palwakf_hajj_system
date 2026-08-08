# Nosok v32.1 Negative UAT Matrix

| Actor / Check | Expected result | Status |
|---|---|---|
| anonymous reads `nosok.applications` directly | denied | pending |
| authenticated user without Nosok role reads admin surface | denied / forbidden | pending |
| wrong unit actor reads other unit rows | denied / empty scoped result | pending |
| scoped reviewer reads assigned queue | allowed only through approved surface | pending |
| public applicant tracking | limited payload only | pending |
| insert/update/delete direct from Flutter | blocked | pending |
| `public.*` new base tables | zero | pending recheck |
| `waqf_assets` mutation | zero | pending recheck |

## Required output

Run the read-only UAT script added in this package after any policy/RPC binding updates and paste the full result.
