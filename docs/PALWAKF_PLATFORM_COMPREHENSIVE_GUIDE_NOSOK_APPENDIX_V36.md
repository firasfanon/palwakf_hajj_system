# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok Appendix v36

## Rule added by v36

Nosok seasonal enhancements must be delivered as platform-aligned bridges/contracts until the system is merged into PalWakf and `nosok` schema is created.

## Seasonal operations policy

- Advanced reports are aggregate-first and privacy-first.
- Payment integration goes through `billing_system`, not a standalone Nosok payment engine.
- Document intelligence is advisory only; no automatic rejection/approval.
- Assistant answers must be grounded in public/internal scoped knowledge and ministry policy snapshots.
- Company and campaign operations must respect company scope and RBAC.
- All seasonal rules remain configurable by ministry policy and policy version.

## Forbidden before PalWakf merge

- Creating Nosok production schema.
- Enabling backend binding to non-existent RPCs.
- Claiming production readiness.
- Exporting sensitive reports.
- Mutating `waqf_assets`, schema `waqf`, or `awqaf_system`.
