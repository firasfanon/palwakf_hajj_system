# ERROR RECORD — Nosok v29

## Issue 1 — SQL apply requested too early

**Symptom:** v28A/v28B continued toward Actual Sandbox SQL Apply/Readiness RPC evidence while the user had not created the database schema yet.

**Cause:** The batch sequence assumed the `nosok` schema could be applied before full PalWakf merge.

**Correction:** v29 reclassified SQL/RPC as design/contracts/readiness only until platform merge and schema creation.

**Files:**

- `lib/features/nosok_system/domain/models/nosok_merge_readiness_contract.dart`
- `lib/features/nosok_system/application/nosok_v29_merge_readiness_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v29_merge_readiness_page.dart`
- `sql/31_nosok_v29_pre_database_schema_contract_readiness.sql`

**Current status:** fixed by governance realignment.

## Issue 2 — Production still blocked

**Reason:** No platform merge, no real RBAC override, no schema, no SQL/RPC/RLS UAT inside PalWakf.

**Status:** intentionally blocked.

## Stable baseline

```text
nosok_v29_palwakf_merge_readiness_pre_database_pack_2026_05_20.zip
```
