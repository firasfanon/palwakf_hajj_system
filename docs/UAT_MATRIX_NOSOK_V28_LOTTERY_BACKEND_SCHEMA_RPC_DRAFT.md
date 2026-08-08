# UAT MATRIX — Nosok v28 Lottery Backend Schema/RPC Draft

| Area | Check | Expected | Status |
|---|---|---|---|
| Local baseline | v27D-1 format/analyze/chrome | Passed from user log | accepted |
| SQL safety | Draft script default persistence | `ROLLBACK` by default | ready |
| SQL safety | UAT script mutability | read-only only | ready |
| Schema | `nosok` schema | exists after sandbox apply | pending |
| Tables | 8 lottery tables | exist after sandbox apply | pending |
| RPC | 7 wrapper RPCs | exist after sandbox apply | pending |
| RLS | lottery tables | RLS enabled | pending |
| Public privacy | result RPC | one-request lookup only | pending |
| Committee | underfilled quota | decision/evidence required | pending |
| Integration | repository binding | planned after SQL UAT | pending |
| Production | Production Gate | not approved | blocked |
| Sovereign boundary | `waqf_assets` | no mutation | passed-by-script-scope |
