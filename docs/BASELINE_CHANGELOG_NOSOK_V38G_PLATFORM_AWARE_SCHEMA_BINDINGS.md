# BASELINE CHANGELOG — Nosok v38G Platform-Aware Schema + Data Bindings

## Status

`staging-stable / development-preparation-only / platform-aware-schema-contracts-added / no-sql-apply / production-not-approved / no-waqf-assets-mutation`

## Added

- `NosokV38GPlatformSchemaBindingContract`.
- Provider for platform-aware schema/data binding readiness.
- Admin page: `/admin/systems/nosok/platform-schema-bindings`.
- Evidence page alias: `/admin/systems/nosok/v38g-platform-schema-binding`.
- SQL draft: `sql/36_nosok_v38g_platform_aware_schema_data_bindings_contract.sql`.
- Platform data binding pack documenting actual PalWakf sources observed from files.

## Key Decisions

- Build schema design using PalWakf sources already inspected from v39 attempt.
- Do not apply SQL before hosting inside PalWakf.
- Do not duplicate `admin_users` or org units inside Nosok.
- Use snapshots for LGU/governorates during lottery season.
- Homepage sections and dynamic pages become schema-ready contracts, not runtime DB tools yet.
