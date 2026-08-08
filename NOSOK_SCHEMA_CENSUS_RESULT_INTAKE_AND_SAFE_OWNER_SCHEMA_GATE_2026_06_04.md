# Nosok Global Schema Census Result Intake + Safe Owner Schema Gate

**Project:** PalWakf / Nosok للحج والعمرة  
**Date:** 2026-06-04  
**Batch candidate:** Nosok v27 Gate  
**Source:** user-provided light global database schema census  
**Execution mode:** read-only intake / no DDL / no DML

---

## 1. Executive decision

```text
NOSOK_SCHEMA_BUILD_REQUIRES_EXISTING_OBJECT_RECONCILIATION_BEFORE_ANY_DDL
```

The census is accepted as a **read-only global schema census**. It does **not** authorize schema creation, table creation, table alteration, data insertion, production use, lottery execution, payment activation, or any write into platform/owner schemas.

### Current gate result

```text
LIGHT_GLOBAL_SCHEMA_CENSUS_COMPLETED_READ_ONLY
```

Operational flags:

| Gate | Value |
|---|---:|
| read_only | `True` |
| write_review_apply_authorized | `False` |
| waqf_assets_mutation_authorized | `False` |
| public_base_table_creation_allowed | `False` |
| new_table_build_allowed_before_owner_review | `False` |
| public_allowed_only_for_views_or_rpc_wrappers | `True` |
| use_existing_core_objects_before_building_duplicates | `True` |

---

## 2. Critical findings

| Finding | Result | Operational impact |
|---|---:|---|
| `nosok` schema present in census | `false` | If absent, a guarded `create schema nosok` can be proposed only after owner review and explicit authorization. |
| `core` present | `true` | Core remains sovereign/reference source for org units, governorates, LGUs, and related hierarchy. |
| `public` has base tables | `9` | Existing only. No new public base tables. |
| `public` views count | `159` | Public can remain compatibility/RPC/view surface only. |
| `billing_system` present | `true` | Nosok payment bridge should integrate via billing contracts, not duplicate provider/payment tables blindly. |
| `platform_access` present | `true` | Nosok RBAC must bind to platform access contracts, not invent independent auth. |
| `waqf` / `awqaf_system` present | `true` | Do not touch or mutate; explicitly out of Nosok scope. |

---

## 3. Schema summary relevant to Nosok

| Schema | Base tables | Views | Role for Nosok |
|---|---:|---:|---|
| core | 37 | 22 | Sovereign/reference data. Read only via safe wrappers/adapters. |
| public | 9 | 159 | Compatibility view/RPC surface only. No owner tables. |
| billing_system | 4 | 0 | Payment/billing integration owner. Nosok should bridge, not duplicate. |
| platform_access | 9 | 0 | RBAC/access source. Nosok admin routes must pass platform access. |
| waqf | 37 | 2 | Sovereign/operational waqf registry. Not part of Nosok build. |
| awqaf_system | 32 | 2 | Separate owner system. Not part of Nosok build. |

---

## 4. Public base-table rule

The census confirms:

```text
PUBLIC_HAS_BASE_TABLES_EXISTING_ONLY_DO_NOT_ADD_NEW_PUBLIC_TABLES
```

Existing public base table samples:

- `assistant_conversations`
- `assistant_messages`
- `chatbot_conversations`
- `chatbot_intents`
- `chatbot_messages`
- `chatbot_retention_policies`
- `locations`
- `org_units_cache`
- `pwf_org_units_cache`

Decision:

```text
NOSOK_PUBLIC_BASE_TABLE_CREATION_BLOCKED_OWNER_SCHEMA_REQUIRED
```

Allowed public surfaces for Nosok, after review only:

```text
public.v_nosok_* views
public.rpc_nosok_* wrappers
```

Blocked:

```text
create table public.nosok_*
create table public.hajj_*
create table public.umrah_*
create table public.lottery_*
```

---

## 5. Core reference strategy

The census lists core objects for units, governorates, LGUs, communities, and reference hierarchy. Nosok must **not duplicate** these as source-of-truth tables.

Priority read/reference candidates include:

```text
core.org_units
core.core_governorates
core.core_lgus
core.v_org_units
core.v_governorates
core.v_lgus
core.v_home_units
core.org_unit_profiles
```

Nosok tables may store foreign keys or immutable audit snapshots where justified, for example:

```text
org_unit_id
lgu_id
governorate_id
unit_slug_snapshot
lgu_name_snapshot
```

They must not become sovereign replacements for core.

---

## 6. Duplicate-name risks

The census found relevant duplicate object names across schemas. These require owner resolution before any Nosok dependency uses them.

Examples:

- `assettypes` across `public, waqf`
- `awqaf_community_document_evidence_links` across `core, public`
- `awqaf_reference_waqf_links` across `public, waqf`
- `awqaf_system_unit_pages` across `awqaf_system, public`
- `historical_admin_units` across `hist, public`
- `org_unit_profiles` across `core, public`
- `org_units` across `core, public`
- `org_units_cache` across `core, public`
- `pwf_org_units_cache` across `core, public`
- `user_scope_assignment_units` across `platform_access, public`
- `waqf_asset_source_records` across `awqaf_system, waqf`
- `waqf_community_lineage` across `public, topology`
- `waqf_lands` across `public, waqf`

Decision:

```text
PUBLIC_COMPAT_OBJECTS_MUST_NOT_BE_TREATED_AS_OWNER_SOURCE_OF_TRUTH
```

---

## 7. Nosok proposed owner-schema path after census

### Step A — Design-only artifacts

Before any DDL/DML, prepare:

```text
NOSOK_OWNER_SCHEMA_DESIGN.md
NOSOK_TABLE_OWNERSHIP_MATRIX.csv
NOSOK_EXISTING_OBJECT_RECONCILIATION_MATRIX.csv
NOSOK_CORE_REFERENCE_WRAPPER_PLAN.md
NOSOK_RLS_POLICY_MATRIX.md
NOSOK_RPC_VIEW_SURFACE_PLAN.md
NOSOK_ROLLBACK_AND_DISABLE_PLAN.md
```

### Step B — SQL preflight only

Prepare read-only SQL:

```text
01_nosok_schema_preflight_read_only.sql
02_nosok_existing_object_name_conflict_check_read_only.sql
03_nosok_public_base_table_proof_read_only.sql
04_nosok_core_reference_availability_read_only.sql
05_nosok_payment_billing_bridge_preflight_read_only.sql
```

### Step C — Guarded apply only after explicit authorization

Only after owner review:

```text
create schema if not exists nosok;
create nosok-owned operational tables only if absent;
enable RLS before exposure;
create public RPC/view wrappers only when required;
no production activation;
```

---

## 8. Proposed Nosok v27 title

```text
Nosok v27 — Database Schema Census Result Intake
+ Existing Object Reconciliation Matrix
+ Owner Schema Diff Plan
+ Safe SQL Execution Gate
```

Expected v27 output:

| Artifact | Type | Purpose |
|---|---|---|
| `NOSOK_SCHEMA_CENSUS_RESULT_INTAKE.md` | Decision doc | Accept this census formally. |
| `NOSOK_EXISTING_OBJECT_RECONCILIATION_MATRIX.csv` | Matrix | Prevent duplicate table builds. |
| `NOSOK_OWNER_SCHEMA_DIFF_PLAN.md` | Design doc | Identify create/reuse/block decisions. |
| `NOSOK_NO_PUBLIC_BASE_TABLE_PROOF.sql` | Read-only SQL | Prove no public table build. |
| `NOSOK_CORE_REFERENCE_WRAPPER_PLAN.md` | Design doc | Bind LGU/governorate/unit references safely. |
| `NOSOK_SQL_EXECUTION_GATE.md` | Gate doc | Define authorization conditions before DDL. |

---

## 9. Final decision

```text
schema-census-accepted /
nosok-owner-schema-not-yet-built-or-not-detected /
owner-review-required-before-any-table-build /
public-base-table-creation-blocked /
core-reference-reuse-required /
billing-system-bridge-required-for-payment /
production-not-approved /
no-waqf-assets-mutation
```
