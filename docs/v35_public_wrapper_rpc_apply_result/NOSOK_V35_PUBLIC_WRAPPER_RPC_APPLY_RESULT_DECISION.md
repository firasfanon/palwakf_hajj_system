# Nosok v35 — Public Wrapper/RPC Apply Result Decision

## Decision

```text
V35_WRAPPER_RPC_CONTROLLED_APPLY_AUTHORIZED_RESULT_PENDING
```

## Context

- `nosok.*` owner schema exists from controlled staging apply.
- Initial 8 owner tables exist.
- RLS is enabled on the initial owner tables.
- v34.1 proved that public wrappers/RPCs are not yet created.
- User authorized v35 public wrapper/RPC controlled staging apply.

## Authorized scope

Allowed only on staging:

- `public.v_nosok_campaigns_public_v1`
- `public.v_nosok_requirements_public_v1`
- `public.rpc_nosok_campaigns_public_list_v1()`
- `public.rpc_nosok_requirements_public_list_v1(text)`
- `public.rpc_nosok_application_submit_v1(text, text, uuid, uuid, uuid, jsonb)`
- `public.rpc_nosok_application_track_v1(text)`

## Explicitly blocked

- Production approval.
- `CREATE TABLE public.*`.
- Direct Flutter access to `nosok.*`.
- Any mutation to `waqf`, `waqf_assets`, or `awqaf_system`.
- Repository binding before post-apply evidence and Browser/Role/Network UAT.
