# Nosok v30.1 — Apply Result Read-Only Intake + Flutter Runtime Evidence Closure

**Project:** PalWakf / Nosok Hajj & Umrah  
**Date:** 2026-06-04  
**Base:** `nosok_platform_integration_patch_v30_authorization_apply_result_uat_gate_under_platform.zip`  
**Mode:** Evidence intake / baseline update only  

## Decision

```text
V30_READ_ONLY_APPLY_RESULT_INTAKE_ACCEPTED_APPLY_STILL_PENDING
```

## Accepted evidence

The user supplied the result of `sql/28_nosok_v30_apply_result_intake_read_only.sql` and a local Flutter runtime retest.

### SQL result accepted

```text
NOSOK_V30_APPLY_RESULT_INTAKE_READ_ONLY
```

Key points:

- `nosok_present=false`.
- Expected owner objects are not present as base tables:
  - `nosok.application_documents`
  - `nosok.applications`
  - `nosok.audit_events`
  - `nosok.campaigns`
  - `nosok.eligibility_rules`
  - `nosok.lgu_quotas`
  - `nosok.quota_rules`
  - `nosok.workflow_events`
- `new_public_nosok_base_tables_detected=false`.
- `rls_status_if_any=[]` because the schema has not been applied yet.
- `controlled_apply_result_required=true`.

### Flutter result accepted

```text
flutter analyze: No issues found!
flutter run -d chrome: passed
Supabase init completed
```

## What changed in this baseline

Documentation and evidence files only:

- Added runtime evidence capture under `evidence/runtime/nosok_v30_1/`.
- Added session handoff and next prompt for v31.
- Updated the patch summary for the current decision.

## What did not change

No functional Flutter source code was changed in v30.1.

No SQL production change was executed:

- No `CREATE SCHEMA nosok`.
- No `CREATE TABLE nosok.*`.
- No `CREATE TABLE public.*`.
- No `ALTER`, `INSERT`, `UPDATE`, or `DELETE`.
- No mutation to `waqf`, `waqf_assets`, or `awqaf_system`.

## Current status

```text
staging-stable /
v30-read-only-apply-result-intake-accepted /
analyzer-clean /
chrome-startup-passed /
supabase-init-passed /
nosok-schema-not-created /
controlled-apply-result-required /
production-not-approved /
no-waqf-assets-mutation
```
