# PALWAKF PLATFORM GUIDE APPENDIX — NOSOK V19.1

## Governance note
V19.1 is a compile blocker hotfix, not a new product capability batch. It preserves the architectural contract:

- PalWakf is the sovereign platform.
- Nosok is a semi-independent system under PalWakf.
- Platform RBAC/AccessProfile remains the authority for users, roles, and permissions.
- Nosok must not create an independent user authority.
- Public tracking remains privacy-limited.
- Financial execution remains through platform/billing contracts, not an independent payment engine inside Nosok.

## New rule added
Avoid naming custom `AsyncNotifier` methods as `update`, because Riverpod exposes `AsyncNotifierBase.update`. Use domain-specific names such as:

- `updateFollowupInboxItem`
- `transitionApplicationLifecycle`
- `verifyPayment`

## Local gate
V19.1 remains `production-not-approved` until local analyzer and browser UAT are clean.
