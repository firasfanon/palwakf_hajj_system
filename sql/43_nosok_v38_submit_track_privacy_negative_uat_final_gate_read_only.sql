-- Nosok v38 — Submit/Track Privacy Network Evidence
-- + Role/Scope Negative UAT Closure
-- + Final Production Gate Re-decision
-- READ ONLY. Do not edit to add DDL/DML/GRANT/REVOKE.

select
  '43_read_me_first' as section,
  'READ_ONLY_EVIDENCE_AND_GATE_ONLY' as execution_mode,
  false as ddl_dml_authorized,
  false as grant_revoke_authorized,
  false as production_approved,
  true as read_only,
  'Run this after local Browser/Network evidence. It only inspects RPC presence, function grants, and high-level metadata; it does not mutate nosok, public, waqf, awqaf_system, or core.' as instruction;

with required_rpc(function_name) as (
  values
    ('rpc_nosok_campaigns_public_list_v1'),
    ('rpc_nosok_requirements_public_list_v1'),
    ('rpc_nosok_public_submit_application_v1'),
    ('rpc_nosok_public_application_status_by_token_v1')
)
select
  '43_required_public_rpc_presence' as section,
  r.function_name,
  p.oid is not null as present,
  coalesce(n.nspname, 'missing') as function_schema,
  false as ddl_dml_authorized,
  false as production_approved,
  true as read_only
from required_rpc r
left join pg_catalog.pg_proc p on p.proname = r.function_name
left join pg_catalog.pg_namespace n on n.oid = p.pronamespace
order by r.function_name;

with required_rpc(function_name) as (
  values
    ('rpc_nosok_campaigns_public_list_v1'),
    ('rpc_nosok_requirements_public_list_v1'),
    ('rpc_nosok_public_submit_application_v1'),
    ('rpc_nosok_public_application_status_by_token_v1')
), rpc_oids as (
  select r.function_name, p.oid, n.nspname
  from required_rpc r
  left join pg_catalog.pg_proc p on p.proname = r.function_name
  left join pg_catalog.pg_namespace n on n.oid = p.pronamespace
)
select
  '43_required_rpc_execute_grant_probe' as section,
  function_name,
  nspname as function_schema,
  case when oid is null then false else has_function_privilege('anon', oid, 'EXECUTE') end as anon_can_execute,
  case when oid is null then false else has_function_privilege('authenticated', oid, 'EXECUTE') end as authenticated_can_execute,
  false as ddl_dml_authorized,
  false as production_approved,
  true as read_only
from rpc_oids
order by function_name;

select
  '43_submit_track_privacy_expected_response_shape' as section,
  'Expected public track response must exclude applicant_full_name,national_id,phone,mobile,email,address_text,document_urls,payment_receipts,internal_review_notes.' as expected_privacy_contract,
  'Verify with Network screenshot and, if available, a controlled sample RPC call.' as evidence_instruction,
  false as production_approved,
  true as read_only;

select
  '43_role_scope_negative_uat_matrix' as section,
  *
from (
  values
    ('N38_NEG_001','anonymous','/admin/systems/nosok/v38-public-runtime-evidence','denied or redirected','browser screenshot required'),
    ('N38_NEG_002','no_role_authenticated','/admin/systems/nosok/v38-final-production-gate','denied by NosokAccessGate','browser screenshot required'),
    ('N38_NEG_003','wrong_role','/admin/systems/nosok/role-uat','denied or limited','browser screenshot required'),
    ('N38_NEG_004','wrong_unit_scope','/admin/systems/nosok/unit-queues','no unsafe data, no unsafe 200 mutation','browser + network evidence required')
) as t(case_key, actor_type, route_path, expected_result, evidence_required);

select
  '43_final_production_gate_redecision' as section,
  'PRODUCTION_NOT_APPROVED_PENDING_ACTUAL_BROWSER_NETWORK_NEGATIVE_EVIDENCE_AND_LOCAL_FLUTTER_RETEST' as decision,
  false as production_approved,
  true as read_only,
  'No production approval is granted by this SQL. It records the final v38 gate state only.' as note;

select
  '43_sovereign_boundary' as section,
  true as no_waqf_assets_mutation,
  true as no_waqf_awqaf_system_mutation,
  true as public_is_wrapper_surface_only,
  false as ddl_dml_authorized,
  false as production_approved,
  true as read_only;
