# Nosok v28 — RPC/View Surface Plan Draft

`public` remains a compatibility/read/RPC surface only. No base table is proposed in `public`.

| Surface | Type | Exposure | Owner source | Status |
|---|---|---|---|---|
| `public.v_nosok_campaigns_public_v1` | View | Public read | `nosok.campaigns` | Later after DDL + RLS |
| `public.v_nosok_requirements_public_v1` | View | Public read | `nosok.eligibility_rules` | Later after DDL + RLS |
| `public.rpc_nosok_application_submit_v1` | RPC | Public guarded write | `nosok.applications` | Deferred until privacy/RLS UAT |
| `public.rpc_nosok_application_track_v1` | RPC | Public minimal lookup | `nosok.applications`, `nosok.tracking_events` | Later after RLS |
| `public.rpc_nosok_admin_queue_v1` | RPC | Authenticated RBAC | `nosok.applications` | Later after Platform Access binding |
