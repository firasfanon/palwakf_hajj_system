# Nosok v39 — Unit→LGU Scope UAT Matrix

Date: 2026-09-17
Status: PREPARED_NOT_EXECUTED_PENDING_DB_AUTHORIZATION_AND_AUTHORITY_DATA

## Preconditions

- Migration 45 applied under separate DB authorization.
- Authoritative Unit→LGU rows independently reviewed and approved.
- No governorate-derived auto-expansion.
- Test identity/profile is bound to a canonical `core.org_units.id`.

## Positive cases

1. Same-unit / mapped-LGU: ALLOW.
2. Same-unit / mapped-LGU / active campaign override: ALLOW.
3. Default mapping fallback when no campaign override exists: ALLOW.
4. Canonical slug mismatch in client input must not change authorization outcome.

## Negative cases

1. Same unit / unmapped LGU: DENY.
2. Different unit / mapped LGU: DENY.
3. Revoked mapping: DENY.
4. Expired mapping: DENY.
5. Draft mapping: DENY.
6. Campaign-specific mapping exists but requested LGU is only in default scope: DENY for that campaign.
7. Anonymous resolver call: DENY / no EXECUTE.
8. Authenticated user outside target unit: empty/denied resolver result.
9. Direct REST access to policy table: DENY.
10. Cross-governorate mapping insert attempt: DB rejection.
11. Geographic mapping for non-directorate unit: DB rejection.
12. Approved row without approval metadata: DB rejection.

## Evidence required

- Resolver Network/RPC response with canonical UUIDs only.
- Browser role/scope evidence for mapped and unmapped LGU.
- Post-apply census shows zero cross-governorate mismatches.
- `anon` has no resolver EXECUTE and no direct table privileges.
- `authenticated` has resolver EXECUTE but no direct table privileges.
- No use of `unitSlug` as an authorization input.

## Production rule

`LGU_SCOPE_GATE = PASS` only when positive and negative cases pass using reviewed authority data.
Until then: `LGU_SCOPE = FAIL_CLOSED` and `PRODUCTION = DEFERRED`.
