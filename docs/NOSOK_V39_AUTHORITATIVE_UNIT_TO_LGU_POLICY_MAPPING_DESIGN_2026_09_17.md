# Nosok v39 — Authoritative Unit→LGU Policy Mapping Design

Date: 2026-09-17
Status: DESIGN_REVIEWED_DB_AUTHORIZATION_REQUIRED

## Governing decision

`core.org_units.id` remains the canonical administrative-unit identity.
`core.core_lgus.id` remains the canonical LGU identity.
Nosok may own only the policy relation between those two canonical entities.
Nosok must not duplicate unit or LGU names/slugs as a source of truth.

## Why a dedicated policy relation is required

- No live table currently maps administrative units/directorates to LGUs.
- `nosok.applications(unit_id,lgu_id)` is transactional data, not authority data.
- Governorate membership is necessary but not sufficient for scope authorization.
- Hebron governorate contains multiple directorates, so governorate→all-LGUs would over-authorize.
- `unitSlug` is navigation/display compatibility only and MUST NOT grant access.
## Proposed owner object

`nosok.administrative_unit_lgu_scope_policy`

Canonical columns:

- `unit_id uuid` → FK `core.org_units(id)`.
- `lgu_id uuid` → FK `core.core_lgus(id)`.
- `campaign_id uuid NULL` → optional campaign-specific override.
- `status` = `draft | approved | revoked`.
- `is_active boolean`.
- validity window (`valid_from`, `valid_until`).
- source/evidence fields (`source_authority`, `source_reference`, `basis_note`).
- audit fields (`created_by/at`, `approved_by/at`, `updated_at`).

No `unit_slug`, governorate name, or LGU name is persisted as authority data.
Display labels are resolved from Core at read time.
## Integrity rules

1. `unit_id` must reference an active `core.org_units` row with geographic scope.
2. `lgu_id` must reference an active `core.core_lgus` row.
3. The unit governorate and LGU governorate must match.
4. Matching governorate is only an integrity constraint; it does not auto-authorize every LGU in that governorate.
5. Duplicate active default mappings are forbidden.
6. Duplicate active campaign mappings are forbidden.
7. `approved` rows require approval metadata.
8. Expired/revoked/inactive rows never authorize access.
9. Missing mapping means deny/fail-closed.
10. Campaign-specific mappings override defaults only when campaign-specific rows exist for that unit.

## Security model

- RLS enabled on the policy table.
- No direct table grants to `anon` or `authenticated`.
- Public/client code reads through a SECURITY DEFINER resolver RPC only.
- The resolver returns approved scope rows only; no draft/revoked policy is exposed.
- No generic write RPC is added in this design migration.
- Initial/changed mappings require separate controlled authority data approval.
## Campaign semantics

- `campaign_id IS NULL` means the default administrative Unit→LGU policy.
- When a campaign ID is supplied and approved campaign-specific mappings exist for that unit, only those campaign-specific rows are effective.
- If no approved campaign-specific mapping exists, the resolver falls back to approved default rows.
- This keeps Hajj/Umrah season overrides explicit without changing Core administrative truth.

## Migration split

Phase A — schema/control plane:
- create policy table and integrity trigger;
- create indexes;
- enable RLS and revoke direct client access;
- create read-only resolver RPC;
- no mapping rows inserted.

Phase B — authority data:
- separately review the official Unit→LGU assignment dataset;
- insert/approve mappings only after independent authorization;
- preserve source reference and approval evidence.

No automatic population from governorate, slug, application history, or Awqaf legacy data is permitted.
