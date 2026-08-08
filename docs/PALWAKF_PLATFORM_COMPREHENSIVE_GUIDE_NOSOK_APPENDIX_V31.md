# PalWakf Guide Appendix — Nosok v31

Nosok v31 introduces an authorization evidence and controlled staging DDL certification gate.

Rules:
- Authorization intent is accepted, but DDL execution is not certified without database output.
- `public` remains a compatibility layer only; no base tables.
- `core` remains the sovereign source for LGU/governorates/org_units.
- `billing_system` remains the payment integration target.
- `waqf`, `waqf_assets`, and `awqaf_system` are out of scope.
- Production remains blocked.
