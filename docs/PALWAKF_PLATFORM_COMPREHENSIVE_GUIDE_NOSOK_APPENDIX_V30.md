# PalWakf Guide Appendix — Nosok v30

Nosok v30 is a controlled intake/gate package. It does not perform DDL.

## Contract update

- `public` remains compatibility views/RPC only.
- `core` remains sovereign reference source.
- `billing_system` remains payment bridge owner.
- `platform_access` remains access/RBAC owner.
- `nosok.*` may only be created after owner authorization.
- `waqf`, `waqf_assets`, and `awqaf_system` remain out of scope.

## Production decision

Production is not approved.
