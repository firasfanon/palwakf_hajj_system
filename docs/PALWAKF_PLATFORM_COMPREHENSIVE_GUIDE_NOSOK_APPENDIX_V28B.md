# PalWakf Guide Appendix — Nosok v28B

v28B confirms a core platform rule: frontend success is not backend readiness.

For Nosok lottery backend:

1. Storage belongs to `nosok` schema.
2. `public` is only for RPC wrappers.
3. Direct public table exposure is forbidden.
4. Citizen result lookup must return one request only.
5. Committee decisions require reason/evidence and audit trail.
6. Backend binding must be disabled until SQL sandbox, readiness RPC, and role UAT evidence are attached.
7. No production approval is implied by Flutter clean state.
8. No mutation may touch `waqf_assets`, `waqf`, or `awqaf_system`.
