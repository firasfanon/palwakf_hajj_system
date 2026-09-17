# Nosok v39 — Production Gate Re-decision

Date: 2026-09-17

## Decision

`NOSOK_V39_PRODUCTION_DEFERRED_ADMIN_UNIT_SCOPE_RECONCILED_LGU_MAPPING_REQUIRED`

## Passed evidence

- Full repository `flutter analyze --no-pub`: PASS / no issues.
- `git diff --check`: PASS.
- Public campaigns RPC: POST 200.
- Public requirements RPC: POST 200.
- Public track RPC `rpc_nosok_application_track_v1`: POST 200.
- Direct public REST access to `nosok.applications`: 0.
- Tawaf / Civil Registry / SMS / payment external runtime calls: 0.
- RBAC browser UAT: anonymous DENY, no-role DENY, wrong-permission DENY.
- Positive control with `redecideNosokProductionGate`: ALLOW.
## Administrative unit scope evidence

- Authorization identity is canonical `core.org_units.id`.
- `unitSlug` is display/navigation alias only and grants no access.
- Bethlehem canonical unit: `1b39cc65-dc74-401f-a431-1fbf78cfbd0e`, slug `bth`.
- Hebron canonical unit: `8e0238db-2e20-49d4-8cf2-db7c376d512b`.
- Wrong-scope profile bound to Bethlehem: Bethlehem ALLOW; Hebron DENY.
- Governorate is derived from `core.org_units.governorate_id`.
- LGU scope MUST NOT expand from governorate alone because some governorates contain multiple directorates.
- No authoritative Unit→LGU mapping currently exists in the live database.
- Current LGU authorization rule: `EXPLICIT_ALLOWED_LGU_IDS_OR_FAIL_CLOSED`.

## Remaining blockers

- Authoritative Nosok policy mapping `org_unit_id ↔ lgu_id` is absent.
- Operational unit queue backend RPC is not certified.
- Successful public submit is not evidenced because no published/open campaign exists.
- PII storage contract for submit metadata is not production-approved.
- Civil Registry, OTP/SMS, payment/eSadad, company auth/Captcha and official lottery integrations are not implemented.

No database DDL/DML, main merge, baseline promotion or production mutation was authorized or executed in this closure.
