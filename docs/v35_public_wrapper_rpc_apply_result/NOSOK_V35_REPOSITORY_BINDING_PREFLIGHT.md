# Nosok v35 — Repository Binding Preflight

## Current decision

```text
REPOSITORY_BINDING_BLOCKED_PENDING_WRAPPER_POST_APPLY_AND_BROWSER_ROLE_EVIDENCE
```

## Binding modes

| mode | decision | reason |
|---|---|---|
| preview | allowed | لا يعتمد على DB. |
| standaloneSupabaseDevelopment | candidate after evidence | يتطلب wrappers/RPCs موجودة + grants + Network evidence. |
| platformHosted | blocked | يتطلب Platform Access Gateway + RBAC/scope evidence + production decision. |

## Required evidence before binding

1. SQL `33_nosok_v35_public_wrapper_rpc_apply_result_read_only.sql` after apply.
2. Browser Network evidence for RPCs.
3. Anonymous public read/submit/track behavior.
4. Authenticated-without-role admin forbidden evidence.
5. Console clean evidence.
6. No public base table creation proof.
