-- Nosok v30 — RLS/RPC/Negative UAT Read-Only After Apply
-- STATUS: READ_ONLY_AFTER_APPLY
-- Run only after controlled staging apply. This is SELECT-only.
select jsonb_build_object(
  'decision', 'NOSOK_V30_RLS_RPC_NEGATIVE_UAT_AFTER_APPLY_READ_ONLY_TEMPLATE',
  'read_only', true,
  'requires_nosok_schema', true,
  'requires_rls_enabled_proof', true,
  'requires_public_rpc_view_surface_review', true,
  'requires_negative_uat_cases', array[
    'NEG_SQL_PUBLIC_TABLE',
    'NEG_ANON_ADMIN_RPC',
    'NEG_WRONG_UNIT',
    'NEG_REVIEWER_POLICY_WRITE',
    'NEG_PUBLIC_DOC_ENUM',
    'NEG_WAQF_MUTATION'
  ]
) as payload;
