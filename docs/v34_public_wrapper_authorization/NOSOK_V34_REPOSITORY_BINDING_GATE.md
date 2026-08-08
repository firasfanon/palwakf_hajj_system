# Nosok v34 — Repository Binding Gate

## Decision

`standaloneSupabaseDevelopment` and `platformHosted` remain blocked until wrapper apply evidence and Browser/Role UAT are accepted.

## Binding rule

Flutter may call public RPC wrappers only. It must not perform direct `.from('applications')` writes to `nosok.*` owner tables.

## Required evidence for binding

- Post-wrapper SQL result from `02_post_apply_wrapper_rpc_negative_uat_READ_ONLY.sql`.
- Browser/Network evidence for campaign list, requirements, submit, track.
- Negative role evidence for authenticated user without Nosok role.
- No raw PostgREST/internal payload exposure.
