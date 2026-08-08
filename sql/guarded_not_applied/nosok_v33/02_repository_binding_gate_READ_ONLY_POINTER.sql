
-- Nosok v33 — Repository Binding Gate Pointer
-- Run sql/31_nosok_v33_post_apply_rls_rpc_negative_uat_read_only.sql and paste full output.
select
  'NOSOK_V33_REPOSITORY_BINDING_GATE_POINTER' as decision,
  'Repository binding remains blocked until wrappers/RPCs are applied in staging and browser/role/scope negative UAT evidence is accepted.' as instruction,
  true as read_only,
  false as production_approved;
