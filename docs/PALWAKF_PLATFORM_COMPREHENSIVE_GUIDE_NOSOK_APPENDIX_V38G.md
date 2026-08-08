# PalWakf Comprehensive Guide — Nosok Appendix v38G

Nosok v38G records that platform files from the revoked v39 attempt can be used as a reference for preparing Nosok schema and data bindings. This does not authorize executing the join or applying SQL.

## Platform sources for Nosok

- Identity: `public.admin_users` with `auth.users` alignment.
- Dynamic RBAC: `platform.system_user_roles`, `platform.system_user_permissions`.
- Org units: `core.org_units`, `core.org_unit_profiles`, `public.org_units` compatibility view.
- Org unit wrappers: `pwf_resolve_unit_id`, `pwf_list_units_with_profiles`, `pwf_get_unit_with_profile_by_slug`.
- GIS LGU/governorates: shape discovery required before schema apply.

## Nosok tables prepared

- `nosok.seasons`
- `nosok.governorate_reference_snapshots`
- `nosok.lgu_reference_snapshots`
- `nosok.user_unit_scope_assignments`
- `nosok.homepage_sections`
- `nosok.page_registry`
- `nosok.page_sections`
- `nosok.platform_binding_sources`

## Governance

No SQL apply before PalWakf hosting. No direct mutation to `waqf_assets`, `waqf`, or `awqaf_system`.
