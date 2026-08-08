# Session Handoff — Nosok v35

## Current state

```text
staging-stable / v35-wrapper-rpc-apply-authorized-result-pending / operator-staging-apply-required / repository-binding-blocked / production-not-approved / no-public-base-table-created / no-waqf-assets-mutation
```

## Next operator step

1. Confirm staging database and backup/restore point.
2. Run `sql/guarded_not_applied/nosok_v35/01_public_wrapper_rpc_surface_AUTHORIZED_STAGING_ONLY.sql`.
3. Run `sql/33_nosok_v35_public_wrapper_rpc_apply_result_read_only.sql`.
4. Paste full SQL output.

## Next batch after evidence

```text
Nosok v36 — Public Wrapper/RPC Post-Apply Evidence Intake + Repository Binding Controlled Implementation Pack
```
