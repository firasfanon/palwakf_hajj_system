-- Nosok v37 — Public Repository Binding Runtime Switch Candidate + Browser Evidence Result Intake Read-Only Gate
-- طبيعة المهمة: تحقق read-only يقرأ حالة wrappers والدوال بشكل signature-aware، ويثبت أن runtime switch ما زال candidate وليس production.
-- لا ينفذ DDL/DML ولا ينشئ public base tables ولا يلمس waqf/awqaf_system.

with schema_presence as (
  select jsonb_build_object(
    'decision', 'NOSOK_V37_RUNTIME_BINDING_BROWSER_EVIDENCE_READ_ONLY',
    'read_only', true,
    'core_present', exists(select 1 from information_schema.schemata where schema_name = 'core'),
    'nosok_present', exists(select 1 from information_schema.schemata where schema_name = 'nosok'),
    'public_present', exists(select 1 from information_schema.schemata where schema_name = 'public'),
    'billing_system_present', exists(select 1 from information_schema.schemata where schema_name = 'billing_system'),
    'platform_access_present', exists(select 1 from information_schema.schemata where schema_name = 'platform_access')
  ) as payload
), expected_wrappers as (
  select * from (values
    ('function','rpc_nosok_application_submit_v1'),
    ('function','rpc_nosok_application_track_v1'),
    ('function','rpc_nosok_campaigns_public_list_v1'),
    ('function','rpc_nosok_requirements_public_list_v1'),
    ('view','v_nosok_campaigns_public_v1'),
    ('view','v_nosok_requirements_public_v1')
  ) as t(object_kind, object_name)
), signature_aware_wrapper_status as (
  select jsonb_agg(jsonb_build_object(
    'object_kind', e.object_kind,
    'object_name', e.object_name,
    'present_by_name', case
      when e.object_kind = 'function' then exists(
        select 1 from pg_proc p join pg_namespace n on n.oid = p.pronamespace
        where n.nspname = 'public' and p.proname = e.object_name
      )
      else to_regclass('public.' || e.object_name) is not null
    end,
    'exact_signature_known', case
      when e.object_name = 'rpc_nosok_application_track_v1' then to_regprocedure('public.rpc_nosok_application_track_v1(text)') is not null
      when e.object_name = 'rpc_nosok_application_submit_v1' then to_regprocedure('public.rpc_nosok_application_submit_v1(jsonb)') is not null
      else null
    end,
    'note', case
      when e.object_name = 'rpc_nosok_application_submit_v1' then 'signature-aware check: if present_by_name=true and exact_signature_known=false, use pg_get_function_arguments before declaring absence'
      else 'signature-aware name check'
    end
  ) order by e.object_kind, e.object_name) as payload
  from expected_wrappers e
), function_signature_security as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'function_name', p.proname,
    'identity_arguments', pg_get_function_identity_arguments(p.oid),
    'security_definer', p.prosecdef,
    'function_config', array_to_string(p.proconfig, ', ')
  ) order by p.proname, pg_get_function_identity_arguments(p.oid)), '[]'::jsonb) as payload
  from pg_proc p
  join pg_namespace n on n.oid = p.pronamespace
  where n.nspname = 'public'
    and p.proname in (
      'rpc_nosok_application_submit_v1',
      'rpc_nosok_application_track_v1',
      'rpc_nosok_campaigns_public_list_v1',
      'rpc_nosok_requirements_public_list_v1'
    )
), grant_summary as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'routine_schema', routine_schema,
    'routine_name', routine_name,
    'grantee', grantee,
    'privilege_type', privilege_type
  ) order by routine_name, grantee), '[]'::jsonb) as payload
  from information_schema.routine_privileges
  where routine_schema = 'public'
    and routine_name in (
      'rpc_nosok_application_submit_v1',
      'rpc_nosok_application_track_v1',
      'rpc_nosok_campaigns_public_list_v1',
      'rpc_nosok_requirements_public_list_v1'
    )
    and grantee in ('anon', 'authenticated')
), public_base_table_guard as (
  select jsonb_build_object(
    'decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY',
    'new_public_service_base_table_count', count(*),
    'new_public_service_base_tables_detected', count(*) > 0,
    'public_base_table_creation_authorized', false
  ) as payload
  from information_schema.tables
  where table_schema = 'public'
    and table_type = 'BASE TABLE'
    and (table_name ilike 'nosok%' or table_name ilike 'hajj%' or table_name ilike 'umrah%')
), browser_evidence_intake as (
  select jsonb_build_array(
    jsonb_build_object('case_key','public_home_render','surface','/services/nosok','status','accepted','evidence','screenshot supplied; console startup clean; Supabase init completed'),
    jsonb_build_object('case_key','admin_home_render','surface','/admin/systems/nosok','status','accepted','evidence','screenshot supplied; internal dashboard rendered'),
    jsonb_build_object('case_key','users_roles_render','surface','/admin/systems/nosok/users-roles','status','accepted','evidence','screenshot supplied; platform_access remains RBAC owner'),
    jsonb_build_object('case_key','network_rpc_runtime_switch','surface','Network tab','status','pending','evidence','current network screenshot does not show RPC calls; only favicon/startup assets visible'),
    jsonb_build_object('case_key','no_role_negative','surface','admin without Nosok role','status','pending','evidence','negative actor evidence still required'),
    jsonb_build_object('case_key','wrong_scope_negative','surface','unit scoped admin routes','status','pending','evidence','wrong-unit scope evidence still required')
  ) as payload
), repository_binding_candidate as (
  select jsonb_build_object(
    'decision', 'PUBLIC_REPOSITORY_BINDING_RUNTIME_SWITCH_CANDIDATE_ONLY',
    'campaigns_requirements_read_candidate', true,
    'submit_track_switch_authorized', false,
    'admin_repository_binding_authorized', false,
    'platform_hosted_binding_authorized', false,
    'requires_network_rpc_evidence', true,
    'requires_negative_role_scope_evidence', true
  ) as payload
), final_gate as (
  select jsonb_build_object(
    'decision', 'NOSOK_V37_RUNTIME_SWITCH_CANDIDATE_PREPARED_BROWSER_EVIDENCE_PARTIAL_PRODUCTION_DEFERRED',
    'read_only', true,
    'production_approved', false,
    'ddl_executed_by_this_script', false,
    'dml_executed_by_this_script', false,
    'create_table_public_authorized', false,
    'waqf_assets_mutation_authorized', false,
    'repository_binding_certified_by_this_script', false,
    'runtime_switch_certified_by_this_script', false
  ) as payload
)
select '01_schema_presence' as section, payload from schema_presence
union all select '02_signature_aware_wrapper_status', payload from signature_aware_wrapper_status
union all select '03_function_signature_security', payload from function_signature_security
union all select '04_grant_summary', payload from grant_summary
union all select '05_public_base_table_guard', payload from public_base_table_guard
union all select '06_browser_evidence_intake', payload from browser_evidence_intake
union all select '07_repository_binding_candidate', payload from repository_binding_candidate
union all select '08_final_gate', payload from final_gate;
