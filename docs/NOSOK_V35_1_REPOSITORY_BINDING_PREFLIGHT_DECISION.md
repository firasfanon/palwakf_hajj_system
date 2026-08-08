# Nosok v35.1 — Repository Binding Preflight Decision

## Decision

```text
REPOSITORY_BINDING_NOT_YET_CERTIFIED_BROWSER_ROLE_SCOPE_UAT_REQUIRED
```

## Rationale

The public wrapper/RPC surface now exists in staging, but repository binding must not be switched from preview/design mode to live RPC mode until Browser/Role/Scope UAT verifies safe behavior.

## Binding remains blocked until these checks pass

1. Public campaigns page loads through `rpc_nosok_campaigns_public_list_v1` or `v_nosok_campaigns_public_v1` without exposing private fields.
2. Public requirements page loads through `rpc_nosok_requirements_public_list_v1` or `v_nosok_requirements_public_v1`.
3. Anonymous application submit is accepted only through the public RPC and does not directly access `nosok.applications`.
4. Tracking RPC does not expose sensitive applicant data.
5. Authenticated user without Nosok role cannot access internal admin data.
6. Wrong-unit scope is rejected by the platform access layer.
7. Browser Console is clean except known Flutter/web non-blockers.
8. Network tab confirms expected RPC calls and no direct table access from Flutter.

## Binding rule

Repository binding can be prepared in a future batch as a controlled feature flag, but default production routing remains blocked.
