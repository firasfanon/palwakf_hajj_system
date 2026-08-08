# Nosok v33 — Repository Binding Gate

| mode | decision | target | required evidence |
|---|---|---|---|
| `preview` | allowed | in-memory/demo data | none |
| `standaloneSupabaseDevelopment` | blocked | public RPC wrappers only | wrapper apply + negative UAT |
| `platformHosted` | blocked | Platform Access Gateway + scoped RPCs | role/scope/browser evidence + production gate |

Binding to real Supabase remains blocked until public wrapper/RPC surfaces are applied in staging and negative UAT evidence is supplied.
