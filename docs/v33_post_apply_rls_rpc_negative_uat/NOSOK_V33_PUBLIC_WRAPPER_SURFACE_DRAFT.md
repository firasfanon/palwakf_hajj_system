# Nosok v33 — Public Wrapper Surface Draft

This is a draft-only design. It is not an authorization to apply SQL.

| surface | type | owner source | status |
|---|---|---|---|
| `public.v_nosok_campaigns_public_v1` | view | `nosok.campaigns` | draft-not-applied |
| `public.rpc_nosok_campaigns_public_list_v1` | rpc | `nosok.campaigns` | draft-not-applied |
| `public.rpc_nosok_application_submit_v1` | rpc | `nosok.applications`, `nosok.workflow_events`, `nosok.audit_events` | draft-not-applied |
| `public.rpc_nosok_application_track_v1` | rpc | `nosok.applications` | draft-not-applied |
| `public.v_nosok_requirements_public_v1` | view | `nosok.eligibility_rules`, `nosok.quota_rules` | draft-not-applied |
| `public.rpc_nosok_requirements_public_list_v1` | rpc | `nosok.eligibility_rules`, `nosok.quota_rules` | draft-not-applied |

Rules:

- No `CREATE TABLE public.*`.
- No direct Flutter writes to `nosok.*`.
- No `service_role` in Flutter.
- Public output must be privacy-filtered.
