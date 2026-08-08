# UAT MATRIX — Nosok v28B

| Gate | Status | Evidence | Decision |
|---|---:|---|---|
| dart format | passed | User local log | accepted |
| flutter analyze | passed | `No issues found` in user local log | accepted |
| Chrome startup | passed | Debug Service reached | accepted |
| Sandbox SQL apply | pending | No apply output attached | blocks backend binding |
| v28B read-only SQL intake | ready | `sql/30_nosok_v28b_actual_sandbox_apply_readiness_result_intake.sql` | must be run after sandbox apply |
| Readiness RPC output | pending | No output attached | blocks backend binding |
| RLS enabled | pending | requires SQL UAT result | blocks backend binding |
| Public table exposure guard | pending | requires SQL UAT result | blocks backend binding |
| Role UAT | pending | not run after backend | blocks production |
| Production Gate | not approved | expected | closed |
| Sovereign boundary | passed by script scope | SQL file read-only, no waqf touch | preserved |
