# NOSOK_RPC_VIEW_SURFACE_PLAN_V27

**Mode:** planning only / no SQL apply

## Public surfaces allowed later

`public` is permitted only as a compatibility/read/RPC surface. The following are candidates, not applied objects:

| Surface | Depends on | Exposure | Gate |
|---|---|---|---|
| `public.v_nosok_campaigns_public_v1` | `nosok.campaigns` | public read | after RLS + publication approval |
| `public.v_nosok_requirements_public_v1` | `nosok.eligibility_rules` | public read | after ministry approval |
| `public.rpc_nosok_application_track_v1` | `nosok.applications`, `nosok.tracking_events` | limited public tracking | privacy UAT required |
| `public.rpc_nosok_application_submit_v1` | `nosok.applications`, `nosok.application_documents` | guarded public submit | not before staging write authorization |
| `public.rpc_nosok_lgu_quota_lookup_v1` | `nosok.lgu_quotas`, `core.v_lgus` | public/administrative lookup | legal quota approval required |

## Blocked surfaces

```text
public.nosok_applications as base table
public.nosok_lottery_runs as base table
public.nosok_documents as base table
public payment/card tables
```

## Function security requirements

- Lock `search_path`.
- No `service_role` from Flutter.
- Public RPCs return minimal payloads.
- Administrative RPCs require auth + platform RBAC + scope.
- Every write-like RPC requires audit evidence and rollback/disable path.
