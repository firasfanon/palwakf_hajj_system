# BASELINE CHANGELOG — Nosok v29

**Batch:** Nosok v29 — PalWakf Merge Readiness Consolidation + Nosok Schema Design Finalization + Platform Registry/RBAC Binding Plan + Frontend Runtime Completion + Pre-Database Integration Pack  
**Date:** 2026-05-20  
**Base:** `nosok_v28b_sql_apply_evidence_binding_redecision_2026_05_20.zip`  
**Type:** Large batch / pre-platform-merge consolidation / no production SQL

## Executive decision

v29 corrects the development sequence: Nosok database tables are intentionally not created yet. The project is waiting for full PalWakf merge first, then creation of a dedicated `nosok` schema in Supabase.

Therefore:

- No actual SQL apply is requested in v29.
- No readiness RPC result is required yet.
- No backend repository binding is enabled yet.
- SQL/RPC remain draft/contracts/readiness only.
- Frontend and merge contracts continue to develop.

## Applied changes

### Flutter / Frontend

- Added v29 merge readiness model:
  - `lib/features/nosok_system/domain/models/nosok_merge_readiness_contract.dart`
- Added v29 controller/provider:
  - `lib/features/nosok_system/application/nosok_v29_merge_readiness_controller.dart`
- Added v29 admin readiness page:
  - `lib/features/nosok_system/presentation/pages/admin/nosok_admin_v29_merge_readiness_page.dart`
- Added admin route:
  - `/admin/systems/nosok/v29-merge-readiness`
- Added sidebar/navigation entry:
  - `جاهزية الدمج v29`
- Updated system manifest with:
  - `databaseSchemaCreated = false`
  - `databaseSchemaCreationState = deferred-until-palwakf-merge`

### Pre-database integration pack

Added:

- `pre_database_integration_pack/NOSOK_V29_SCHEMA_DESIGN_FINALIZATION.md`
- `pre_database_integration_pack/NOSOK_V29_PLATFORM_REGISTRY_RBAC_BINDING_PLAN.md`
- `pre_database_integration_pack/NOSOK_V29_FRONTEND_RUNTIME_COMPLETION.md`

### SQL

Added read-only/design marker:

- `sql/31_nosok_v29_pre_database_schema_contract_readiness.sql`

This file is intentionally non-mutating and contains no schema creation.

## Production decision

```text
production-not-approved
```

## Database decision

```text
nosok-schema-not-created-by-design / create-after-palwakf-merge
```

## Sovereign boundary

No changes to:

- `waqf_assets`
- schema `waqf`
- `awqaf_system`
- production SQL
