Nosok v38 — Actual Browser/Network Evidence Intake + Final Production Approval/Deferral Decision

Use the latest baseline produced by:
Nosok v38 — Submit/Track Privacy Network Evidence + Role/Scope Negative UAT Closure + Final Production Gate Re-decision.

Evidence to intake:
1. dart format result.
2. flutter analyze result.
3. flutter run -d chrome result.
4. Network evidence for `/services/nosok` campaigns RPC.
5. Network evidence for `/services/nosok/requirements` requirements RPC.
6. Network evidence for `/services/nosok/apply` submit RPC, proving no direct REST `/nosok/applications` fallback.
7. Network evidence for `/services/nosok/track` track RPC, proving public-safe response shape.
8. Negative UAT screenshots/logs for anonymous/no-role/wrong-scope on v38 admin evidence/gate/unit queues.

Do not approve production unless all evidence is present and no unsafe direct table access or sensitive public tracking response is observed.
