# PalWakf Guide Appendix — Nosok v30.1

## Contract update

Nosok v30.1 confirms the controlled state after v30:

```text
V30_READ_ONLY_APPLY_RESULT_INTAKE_ACCEPTED_APPLY_STILL_PENDING
```

## Platform rule reaffirmed

- `public` is not an owner schema.
- `nosok` owner schema may be created only after explicit staging authorization.
- `core` remains the owner of sovereign reference data.
- `billing_system` remains the payment bridge owner.
- `platform_access` remains the RBAC/access owner.
- Production remains blocked until post-apply RLS/RPC/negative UAT evidence is accepted.
