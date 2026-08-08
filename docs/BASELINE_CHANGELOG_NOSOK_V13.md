# Nosok v13 — Billing Provider Adapter Hardening + Public Tracking Privacy Review + Production Readiness Evidence Closure

**Date:** 2026-05-17  
**Base:** `nosok_platform_integration_patch_v12_billing_unit_queues_role_uat_under_platform.zip`  
**Status:** `staging-ready / v13-hardening-applied / production-not-approved / no-waqf-assets-mutation`

## Scope

This batch hardens Nosok as a semi-independent system under PalWakf by adding:

1. Billing Provider Adapter contracts and health checks.
2. Public tracking privacy review matrix.
3. Production readiness evidence closure register.
4. Secure override for the public tracking RPC to suppress personal fields.

## Added Flutter surfaces

- `/admin/systems/nosok/billing-adapters`
- `/admin/systems/nosok/tracking-privacy`
- `/admin/systems/nosok/readiness-evidence`

## Added/updated Dart files

- `lib/features/nosok_system/domain/models/nosok_billing_provider_adapter.dart`
- `lib/features/nosok_system/domain/models/nosok_public_tracking_privacy_check.dart`
- `lib/features/nosok_system/domain/models/nosok_production_readiness_evidence.dart`
- `lib/features/nosok_system/application/nosok_billing_adapters_controller.dart`
- `lib/features/nosok_system/application/nosok_tracking_privacy_controller.dart`
- `lib/features/nosok_system/application/nosok_readiness_evidence_controller.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_billing_adapters_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_tracking_privacy_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_readiness_evidence_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_application_status_page.dart`
- `lib/features/nosok_system/data/repositories/*`
- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/system_navigation.dart`
- `lib/features/nosok_system/system_permissions.dart`

## Added SQL

- `sql/12_nosok_v13_billing_privacy_readiness_closure.sql`

Main database additions:

- `nosok.billing_provider_adapters`
- `nosok.billing_adapter_health_events`
- `nosok.public_tracking_privacy_checks`
- `nosok.production_readiness_evidence`

Main RPC additions:

- `public.rpc_nosok_admin_billing_provider_adapters_v1`
- `public.rpc_nosok_admin_billing_provider_adapter_health_check_v1`
- `public.rpc_nosok_admin_public_tracking_privacy_checks_v1`
- `public.rpc_nosok_admin_public_tracking_privacy_review_upsert_v1`
- `public.rpc_nosok_admin_production_readiness_evidence_v1`
- `public.rpc_nosok_admin_production_readiness_evidence_upsert_v1`
- `public.rpc_nosok_v13_runtime_contract_uat_v1`

## Security/privacy change

`public.rpc_nosok_public_application_status_by_token_v1` is overridden in v13 to return `NULL` for public personal fields:

- `applicant_full_name`
- `national_id`
- `phone`
- `mobile`
- `email`

The public tracking page now shows a clear privacy note instead of the applicant name.

## Production decision

Production remains **not approved** until actual evidence is submitted for:

- Browser UAT
- Role UAT
- SQL UAT
- Console review
- Tracking privacy review
- Billing adapter health evidence

## Sovereign boundary

No mutation to:

- `waqf`
- `waqf_assets`
- `awqaf_system`
