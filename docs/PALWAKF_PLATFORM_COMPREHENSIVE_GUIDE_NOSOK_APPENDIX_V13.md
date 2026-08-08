# PalWakf Comprehensive Guide Appendix — Nosok v13

## Rule added by v13

Public tracking surfaces must never expose direct personal data or document/payment file links. `tracking_token` is a public lookup key, not a permission to reveal the full application record.

## Billing adapter rule

Nosok may request payment through a bridge, but billing/provider execution belongs to the platform billing layer. Every provider adapter must document:

- provider key
- adapter mode
- signature requirement
- idempotency policy
- callback path
- health status
- reconciliation readiness

## Production evidence rule

Production readiness is not a narrative statement. It must be supported by runtime evidence rows covering:

- Browser UAT
- SQL UAT
- Role UAT
- Console review
- Billing adapter health
- Public tracking privacy

## No sovereign mutation

v13 does not mutate `waqf`, `waqf_assets`, or `awqaf_system`.
