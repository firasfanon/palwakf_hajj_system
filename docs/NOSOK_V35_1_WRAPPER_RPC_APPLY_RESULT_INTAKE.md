# Nosok v35.1 — Public Wrapper/RPC Apply Result Intake

## Input evidence

The operator reported:

```text
Success. No rows returned
```

The post-apply read-only result reported:

```text
NOSOK_V35_PUBLIC_WRAPPER_RPC_APPLY_RESULT_READ_ONLY
```

## Accepted facts

| Check | Result |
|---|---|
| `nosok` schema | present |
| `public` schema | present |
| `billing_system` schema | present |
| `platform_access` schema | present |
| Wrapper apply result | detected |
| Production approval | false |
| Waqf assets mutation | false |

## Wrapper objects detected

| Object | Kind | Present |
|---|---:|---:|
| `public.rpc_nosok_application_submit_v1` | function | true |
| `public.rpc_nosok_application_track_v1` | function | true |
| `public.rpc_nosok_campaigns_public_list_v1` | function | true |
| `public.rpc_nosok_requirements_public_list_v1` | function | true |
| `public.v_nosok_campaigns_public_v1` | view | true |
| `public.v_nosok_requirements_public_v1` | view | true |

## Function security evidence

| Function | Security definer | Function config |
|---|---:|---|
| `rpc_nosok_application_submit_v1` | true | `search_path=public, nosok, pg_temp` |
| `rpc_nosok_application_track_v1` | true | `search_path=public, nosok, pg_temp` |
| `rpc_nosok_campaigns_public_list_v1` | true | `search_path=public, nosok, pg_temp` |
| `rpc_nosok_requirements_public_list_v1` | true | `search_path=public, nosok, pg_temp` |

## Grants detected

The read-only output reports `EXECUTE` grants for both `anon` and `authenticated` on all four wrapper RPCs.

## Guard result

```text
PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY
```

No new service base table was detected in `public`.

## Final gate from evidence

```text
NOSOK_V35_WRAPPER_RPC_APPLY_DETECTED_REPOSITORY_BINDING_PREFLIGHT_PENDING_BROWSER_UAT
```
