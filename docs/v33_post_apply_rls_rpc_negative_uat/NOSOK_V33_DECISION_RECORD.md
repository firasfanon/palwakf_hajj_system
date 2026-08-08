# Nosok v33 — Decision Record

**Decision:** `V33_POST_APPLY_RLS_PRESENT_PUBLIC_WRAPPER_DRAFT_PREPARED_REPOSITORY_BINDING_BLOCKED_PENDING_UAT`

## Accepted evidence

- `nosok` schema exists.
- 8 initial `nosok.*` owner tables are present.
- RLS is enabled on all 8 initial owner tables.
- Anonymous direct-access deny policies are present.
- No new `public.nosok*`, `public.hajj*`, or `public.umrah*` base tables were detected.

## Still blocked

- Browser/role/scope negative UAT is still required.
- Public wrapper/RPC surfaces are draft-only and not applied.
- Flutter repository binding to real Supabase remains blocked except preview mode.
- Production remains blocked.

## Sovereign boundaries

No mutation is authorized for `waqf`, `waqf_assets`, `awqaf_system`, `core`, `platform`, or `public` base tables.
