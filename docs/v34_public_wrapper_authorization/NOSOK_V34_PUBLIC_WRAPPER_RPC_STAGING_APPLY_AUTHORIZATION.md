# Nosok v34 — Public Wrapper/RPC Staging Apply Authorization Pack

## Nature

This is **controlled development**, not مجرد حوكمة. It adds Flutter admin surfaces, SQL wrapper/RPC scripts, read-only gates, and a repository binding decision model. Execution remains operator-only because public wrappers affect runtime API surfaces.

## Accepted evidence from v33

- `nosok` schema exists.
- 8 initial owner tables exist.
- RLS is enabled on the 8 tables.
- anonymous deny policies are present.
- no new `public.nosok*`, `public.hajj*`, or `public.umrah*` base tables were detected.
- production remains blocked.

## v34 scope

Prepared public surfaces:

- `public.v_nosok_campaigns_public_v1`
- `public.rpc_nosok_campaigns_public_list_v1()`
- `public.v_nosok_requirements_public_v1`
- `public.rpc_nosok_requirements_public_list_v1(text)`
- `public.rpc_nosok_application_submit_v1(...)`
- `public.rpc_nosok_application_track_v1(text)`

## Still blocked

- Production approval.
- Flutter direct table writes to `nosok.*`.
- Any public base table.
- Lottery execution.
- Payment production flow.
- Any mutation to `waqf`, `waqf_assets`, `awqaf_system`, `core`, or `platform_access`.
