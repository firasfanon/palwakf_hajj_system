# Nosok v28 — Owner Schema Design

**Decision:** `NOSOK_V28_OWNER_SCHEMA_DESIGN_PREPARED_GUARDED_NOT_APPLIED`  
**Scope:** design + guarded DDL draft only.  
**Execution:** not authorized.  

## Accepted inputs

- v27 SQL census gate confirmed `nosok_present=false`, `public` existing base tables only, and `SQL_EXECUTION_BLOCKED_OWNER_REVIEW_AND_EXPLICIT_AUTHORIZATION_REQUIRED`.
- v27.1 runtime retest confirmed analyzer clean and Chrome startup after route/permission hotfix.

## Ownership rules

| Domain | Owner | Nosok usage |
|---|---|---|
| Operational Hajj/Umrah data | `nosok.*` | Proposed owner schema only after authorization |
| LGU/governorates/org_units | `core.*` | Read-only references/wrappers; no duplication as truth |
| Access/RBAC | `platform_access.*` | Provider override / gateway only |
| Payments | `billing_system.*` | Bridge only; no duplicated payment owner |
| Public API | `public` | Views/RPC wrappers only; no base tables |
| Waqf/Awqaf System | `waqf`, `awqaf_system` | Out of Nosok mutation scope |

## Owner tables proposed after authorization

| Object | State | Notes |
|---|---|---|
| `nosok.campaigns` | draft-create-candidate | Campaign/season owner table |
| `nosok.applications` | draft-create-candidate | Application owner table with tracking code |
| `nosok.application_documents` | draft-create-candidate | Metadata only; Storage owns binary files |
| `nosok.eligibility_rules` | draft-create-candidate | Published requirements and eligibility rules |
| `nosok.quota_rules` | draft-create-candidate | Legal quota formula/rule payload |
| `nosok.lgu_quotas` | draft-create-candidate | LGU quota values referencing core LGU |
| `nosok.workflow_events` | draft-create-candidate | Application lifecycle events |
| `nosok.audit_events` | draft-create-candidate | Internal audit events |
| `nosok.lottery_runs` | deferred | Blocked until legal algorithm approval |
| `nosok.lottery_entries` | deferred | Blocked until legal algorithm approval |

## Rejected targets

- `public.*` base tables.
- Duplicated `core` reference tables.
- Any mutation to `waqf`, `waqf_assets`, or `awqaf_system`.
- Any Flutter `service_role` use.

## Current gate

`GUARDED_DDL_DRAFT_PREPARED_NOT_APPLIED`.
