-- Nosok v28 — Owner Schema Design Read-only Validation
-- Purpose: publish design/gate status only. This file performs SELECT only.
-- No DDL, no DML, no CREATE SCHEMA, no CREATE TABLE, no GRANT.

with rows(section, payload) as (
  values
    ('01_decision', jsonb_build_object(
      'decision', 'NOSOK_V28_OWNER_SCHEMA_DESIGN_PREPARED_GUARDED_NOT_APPLIED',
      'read_only', true,
      'ddl_executed_by_this_script', false,
      'dml_executed_by_this_script', false,
      'create_schema_nosok_executed', false,
      'create_table_public_allowed', false,
      'production_approved', false
    )),
    ('02_owner_schema_contract', jsonb_build_object(
      'owner_schema', 'nosok',
      'public_role', 'views_or_rpc_wrappers_only',
      'core_role', 'sovereign_reference_reuse_required',
      'billing_role', 'payment_bridge_owner',
      'platform_access_role', 'access_rbac_owner'
    )),
    ('03_create_candidates', jsonb_build_object(
      'candidate_tables', jsonb_build_array(
        'nosok.campaigns',
        'nosok.applications',
        'nosok.application_documents',
        'nosok.eligibility_rules',
        'nosok.quota_rules',
        'nosok.lgu_quotas',
        'nosok.workflow_events',
        'nosok.audit_events'
      ),
      'deferred_tables', jsonb_build_array('nosok.lottery_runs', 'nosok.lottery_entries'),
      'forbidden_targets', jsonb_build_array('public.* base tables', 'core duplicates', 'waqf/awqaf_system mutation')
    )),
    ('04_next_authorization_gate', jsonb_build_object(
      'execution_allowed_now', false,
      'required_authorization', 'explicit owner authorization to create nosok schema and selected staging tables only',
      'required_before_apply', jsonb_build_array('RLS matrix approval', 'RPC/view surface approval', 'rollback plan approval', 'negative UAT plan approval')
    ))
)
select section, payload
from rows
order by section;
