# PalWakf Comprehensive Guide Appendix — Nosok v11

Nosok remains a semi-independent system under PalWakf. It may run as standalone preview for development, but production execution must run under PalWakf shell, AccessProfile, RBAC, GoRouter, platform registry, and billing governance.

## v11 production-runtime surfaces
- Operations center
- Payment/Billing bridge
- Role UAT matrix
- Notification templates

## Rules
- No independent user table in Nosok.
- No direct card/payment data storage in Nosok.
- No public route conflict with `/:unitSlug`; use `/systems/nosok` and `/switch/nosok`.
- No `waqf_assets` mutation.
