# PalWakf Platform Comprehensive Guide — Nosok Appendix v28

## New governing rule: lottery backend must be contract-first

Nosok lottery backend must not jump directly from UI preview to production SQL. It must pass through:

1. Schema/RPC draft.
2. Security/RLS review.
3. Sandbox-only apply.
4. Read-only SQL UAT.
5. Role/browser/responsive UAT after repository binding.
6. Explicit Production Gate decision.

## LGU quota lottery backend ownership

Nosok owns:

- lottery policies,
- LGU quota snapshots,
- eligibility snapshots,
- draw runs,
- draw results,
- committee decisions,
- objections,
- lottery audit events.

PalWakf owns:

- RBAC/AccessProfile,
- visual shell/PWF-SIS,
- audit governance expectations,
- system registry and production gate.

## Public safety rule

Public result surfaces must only return one request by secure tracking/identity proof. They must never expose:

- other applicants,
- full LGU lists,
- internal ranking seed,
- operator names,
- internal audit payloads.

## Committee rule

If an LGU quota remains underfilled and no same-LGU eligible application fits the remaining capacity, the backend must set a committee decision requirement. Cross-LGU transfer is forbidden unless there is an explicit committee/ministry decision with evidence and audit.
