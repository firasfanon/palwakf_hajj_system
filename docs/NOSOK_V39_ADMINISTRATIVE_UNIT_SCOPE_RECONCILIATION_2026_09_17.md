# Nosok v39 â€” Administrative Unit Scope Reconciliation

Date: 2026-09-17

## Decision

`NOSOK_V39_ADMINISTRATIVE_UNIT_SCOPE_RECONCILED_PRODUCTION_DEFERRED`

## Canonical authority

- Administrative units are owned by `core.org_units`.
- Flutter consumes them through `public.rpc_org_units_core_lookup_v1`.
- `org_unit_id` is the authorization key.
- `slug` is an alias for navigation/display only and MUST NOT grant access.
- Nosok does not own a duplicate administrative-unit dictionary.

## Proven correction

The earlier standalone assumption `unitSlug=bethlehem` was invalid. The live canonical Bethlehem Directorate is:

- orgUnitId: `1b39cc65-dc74-401f-a431-1fbf78cfbd0e`
- canonical slug: `bth`
- governorateId: `17b45c86-a439-47a0-9ca7-085a1f5e75d4`
## Scope derivation

Governorate scope is derived from the canonical administrative unit's `governorate_id`.

LGU scope is **not** inferred from governorate. The database currently has no authoritative Unit→LGU assignment relation, and Hebron governorate contains multiple directorates (`hebron`, `dura`, `halhul`, `yatta`). Therefore automatic governorate→all-LGUs expansion would over-authorize.

Current rule:

`LGU_SCOPE = EXPLICIT_ALLOWED_LGU_IDS_OR_FAIL_CLOSED`

## Browser evidence

Using `NOSOK_UAT_ACCESS_PROFILE=wrong_scope` with a fresh Chrome profile:

- `/admin/systems/nosok/units` reads administrative units through the core lookup RPC; legacy unit-scope network calls were absent.
- Bethlehem canonical UUID: ALLOW.
- Hebron canonical UUID `8e0238db-2e20-49d4-8cf2-db7c376d512b`: DENY.
- Bethlehem page resolved `slug=bth` and the canonical governorate ID.
- Positive-control profile holding `redecideNosokProductionGate`: ALLOW on the v39 evidence page.
- LGU scope displayed `fail-closed-explicit-unit-lgu-mapping-required`.
## Verification

- Full repository `flutter analyze --no-pub`: PASS / no issues.
- Web release build with wrong-scope profile: PASS.
- Final evidence build SHA256: `7BAC31AE2EC48F7F56E93B8DEB0772D80E4980AC6C4D9AB79112AB0E78D81D38`.
- No DDL/DML/GRANT/REVOKE was executed.
- No `unit_service_scopes` fallback remains in the live unit repository path.

## Remaining production blockers

- Explicit authoritative Unit→LGU mapping is absent; runtime remains fail-closed for LGU authorization.
- `rpc_nosok_admin_unit_application_queue_v1` is absent in the live Supabase project, so the operational unit queue is not certified.
- Successful public submit remains blocked because no open/published campaign exists and no synthetic citizen mutation was authorized.
- PII storage contract for submit metadata is not production-approved.
- Civil Registry, OTP/SMS, payment/eSadad, company authentication/Captcha, and official lottery integrations remain unimplemented.

No main merge, sovereign baseline promotion, or production approval is implied by this WIP reconciliation.
