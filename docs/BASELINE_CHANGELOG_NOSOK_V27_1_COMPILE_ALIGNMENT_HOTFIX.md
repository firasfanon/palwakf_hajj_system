# Nosok v27.1 — Route/Permission Compile Alignment Hotfix

**Date:** 2026-06-04  
**Scope:** PalWakf / Nosok Hajj & Umrah  
**Base:** Nosok v27 — Schema Census Result Intake + Owner Diff + Safe SQL Gate  
**Decision:** `NOSOK_V27_1_ROUTE_PERMISSION_ALIGNMENT_HOTFIX_APPLIED`

## Intake

The operator retest after v27 supplied:

- SQL/schema census gate output confirming `nosok_present=false`, `core_present=true`, `public_present=true`, `billing_system_present=true`, and `platform_access_present=true`.
- `public` base table creation remains blocked.
- Flutter retest produced 67 analyzer/compile issues, all concentrated in missing route constants and missing permission keys referenced by existing Nosok UI/access surfaces.
- `flutter run -d chrome` failed to compile due to the same missing members.

## Root Cause

v27 added/reconciled route and gate surfaces but did not preserve all historical/pre-join route constants and RBAC keys still referenced by existing Nosok pages and access-profile logic.

Affected families:

- Public route constants: lottery results, waiting list, objections, contact, company login, legal regulation.
- Admin route constants: homepage sections, dynamic pages, unit scope access, registration governance, legal compliance, algorithm simulation, company workspace closure, responsive UAT, Supabase/platform binding diagnostics.
- Permission constants: homepage/dynamic page management, unit scope access, registration governance, legal compliance, lottery audit/draw, Supabase binding, platform schema binding.

## Applied Fix

Updated:

- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/system_permissions.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart` in the full baseline only, adding safe redirects for compatibility routes.

No database changes were made.

## Safety Boundary

- No DDL.
- No DML.
- No `CREATE TABLE public.*`.
- No `CREATE SCHEMA nosok`.
- No `waqf`, `waqf_assets`, or `awqaf_system` mutation.
- Production remains blocked.
