# UAT MATRIX — Nosok v28A

| Gate | Evidence | Result | Notes |
|---|---|---:|---|
| dart format | Uploaded local log | passed | 187 files formatted; 151 changed. |
| flutter analyze | Uploaded local log | passed | `No issues found`. |
| Chrome startup | Uploaded local log | passed | Debug Service reached. |
| Sandbox SQL apply | Not attached | pending | No SQL apply output was provided. |
| Readiness RPC | Not attached | pending | Requires sandbox schema/RPC apply first. |
| RLS/RPC security review | Decision recorded | decision-only | No database proof yet. |
| Backend binding | v28A decision | deferred | Must wait for SQL evidence. |
| Production gate | v28A decision | blocked | No production approval. |
| waqf_assets mutation | File scope | passed | No waqf/waqf_assets mutation. |
