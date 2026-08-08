# UAT Matrix — Nosok v30.1

| Area | Evidence | Result | Notes |
|---|---|---|---|
| Flutter analyze | user local run | passed | `No issues found` |
| Chrome startup | user local run | passed | debug service available |
| Supabase init | user local run | passed | `Supabase init completed` |
| SQL read-only apply result | user SQL output | passed | read-only, no DDL/DML |
| Nosok schema presence | SQL output | pending | `nosok_present=false` |
| Expected owner tables | SQL output | pending | all expected candidate tables absent |
| Public base table guard | SQL output | passed | no new public nosok base tables detected |
| RLS status | SQL output | pending | empty because owner schema absent |
| Controlled apply | not supplied | blocked | requires authorization |
| Negative UAT | not possible yet | blocked | requires schema/RLS/RPC first |
| Production gate | decision | blocked | not approved |
