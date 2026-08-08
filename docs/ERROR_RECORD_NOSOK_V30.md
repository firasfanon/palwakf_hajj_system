# Nosok v30 — Error / Risk Record

## Primary blocker

`owner_authorization_id` was not supplied.

## Decision

`V30_CONTROLLED_APPLY_RESULT_INTAKE_PREPARED_APPLY_NOT_AUTHORIZED`

## Current risk posture

| risk | status | handling |
|---|---|---|
| Running DDL without authorization | blocked | apply stays guarded/not run |
| Creating public base tables | blocked | public remains wrappers only |
| Creating schema before backup | blocked | backup evidence required |
| Running negative UAT before schema exists | blocked | UAT gate waits for staging apply |
| Touching waqf/awqaf_system | blocked | out of scope |
| Production enablement | blocked | production not approved |

## Required closure evidence

- owner_authorization_id
- staging target confirmation
- backup/snapshot evidence
- full SQL apply output
- schema/table existence proof
- RLS enabled proof
- RPC/view surface proof
- negative UAT output
- rollback readiness proof
