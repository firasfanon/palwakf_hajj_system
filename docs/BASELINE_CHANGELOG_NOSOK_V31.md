# Baseline Changelog — Nosok v31

## Batch
`Nosok v31 — Owner Authorization Token Evidence Intake + Controlled Staging DDL Apply Result Certification + Post-Apply RLS/RPC Negative UAT Closure`

## Decision
`V31_OWNER_AUTHORIZATION_TOKEN_EVIDENCE_INTAKE_PREPARED_APPLY_NOT_CERTIFIED`

## Summary
- Accepted the user's v31 authorization message as authorization intent evidence.
- Added V31 admin surfaces for authorization evidence, controlled apply certification, and post-apply RLS/RPC negative UAT closure.
- Added a read-only v31 certification SQL probe.
- Added guarded/operator-only SQL templates for controlled staging apply and rollback.
- Did **not** execute DDL/DML.
- Did **not** create `nosok` schema or `nosok.*` tables.
- Did **not** create any `public.*` base tables.
- Preserved `waqf`, `waqf_assets`, and `awqaf_system` boundaries.

## Current State
`staging-stable / v31-authorization-intent-accepted / controlled-apply-not-certified / post-apply-uat-blocked-until-sql-output / production-not-approved / no-waqf-assets-mutation`
