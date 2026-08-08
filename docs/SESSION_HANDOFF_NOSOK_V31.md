# Session Handoff — Nosok v31

## Latest Baseline
`nosok_platform_integration_patch_v31_authorization_token_apply_certification_uat_closure_under_platform.zip`

## Governing Result
User authorized v31 as a development/governance batch. The batch records the authorization intent, but database execution still requires an operator-controlled staging session with backup evidence and SQL output.

## Added Routes
- `/admin/systems/nosok/v31-authorization-token-evidence`
- `/admin/systems/nosok/v31-controlled-staging-apply-certification`
- `/admin/systems/nosok/v31-post-apply-rls-rpc-negative-uat-closure`

## SQL Files
- `sql/29_nosok_v31_authorization_apply_certification_read_only.sql`
- `sql/guarded_not_applied/nosok_v31/01_nosok_owner_schema_controlled_staging_apply_OPERATOR_ONLY_NOT_RUN.sql`
- `sql/guarded_not_applied/nosok_v31/02_nosok_v31_post_apply_rls_rpc_negative_uat_READ_ONLY.sql`
- `sql/guarded_not_applied/nosok_v31/03_nosok_v31_controlled_rollback_DRAFT_NOT_RUN.sql`

## Blockers
- No post-apply SQL output has been supplied.
- `nosok_present=false` remains the last accepted database state until the user supplies new post-apply evidence.
- RLS/RPC/Negative UAT cannot close before controlled apply evidence.
- Production remains not approved.
