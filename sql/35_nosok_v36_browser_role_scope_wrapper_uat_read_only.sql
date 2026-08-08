-- Nosok v36 — Browser/Role/Scope Wrapper RPC UAT Evidence Read-Only Gate
-- طبيعة المهمة: تحقق read-only بعد تطبيق public wrappers/RPCs وقبل repository binding.
-- لا ينفذ DDL/DML ولا ينشئ public base tables ولا يلمس waqf/awqaf_system.

with schema_presence as (
  select jsonb_build_object(
    'decision', 'NOSOK_V36_BROWSER_ROLE_SCOPE_WRAPPER_UAT_READ_ONLY',
    'read_only', true,
    'core_present', exists(select 1 from information_schema.schemata where schema_name = 'core'),
    'nosok_present', exists(select 1 from information_schema.schemata where schema_name = 'nosok'),
    'public_present', exists(select 1 from information_schema.schemata where schema_name = 'public'),
    'billing_system_present', exists(select 1 from information_schema.schemata where schema_name = 'billing_system'),
    'platform_access_present', exists(select 1 from information_schema.schemata where schema_name = 'platform_access')
  ) as payload
), wrapper_status as (
  select jsonb_agg(jsonb_build_object('object_name', object_name, 'object_kind', object_kind, 'present', present) order by object_kind, object_name) as payload
  from (
    select 'function' object_kind, 'rpc_nosok_application_submit_v1' object_name,
      to_regprocedure('public.rpc_nosok_application_submit_v1(jsonb)') is not null as present
    union all select 'function', 'rpc_nosok_application_track_v1',
      to_regprocedure('public.rpc_nosok_application_track_v1(text)') is not null
    union all select 'function', 'rpc_nosok_campaigns_public_list_v1',
      exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname='rpc_nosok_campaigns_public_list_v1')
    union all select 'function', 'rpc_nosok_requirements_public_list_v1',
      exists(select 1 from pg_proc p join pg_namespace n on n.oid=p.pronamespace where n.nspname='public' and p.proname='rpc_nosok_requirements_public_list_v1')
    union all select 'view', 'v_nosok_campaigns_public_v1',
      to_regclass('public.v_nosok_campaigns_public_v1') is not null
    union all select 'view', 'v_nosok_requirements_public_v1',
      to_regclass('public.v_nosok_requirements_public_v1') is not null
  ) s
), function_security as (
  select coalesce(jsonb_agg(jsonb_build_object(
    'function_name', p.proname,
    'security_definer', p.prosecdef,
    'function_config', array_to_string(p.proconfig, ', ')
  ) order by p.proname), '[]'::jsonb) as payload
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
), uat_matrix as (
  select jsonb_build_array(
    jsonb_build_object('case_key','public_campaigns_list','actor','anonymous','surface','/services/nosok','required_evidence','Network 200/empty-safe + console clean'),
    jsonb_build_object('case_key','public_requirements_list','actor','anonymous','surface','/services/nosok/requirements','required_evidence','Network 200/empty-safe + published-only requirements'),
    jsonb_build_object('case_key','public_submit_staging','actor','anonymous/public applicant','surface','/services/nosok/apply','required_evidence','safe response + no raw backend error'),
    jsonb_build_object('case_key','public_track_privacy','actor','anonymous/public applicant','surface','/services/nosok/track','required_evidence','no PII/no documents/no audit payload'),
    jsonb_build_object('case_key','authenticated_no_role','actor','authenticated without Nosok role','surface','/admin/systems/nosok','required_evidence','Arabic forbidden or hidden admin route'),
    jsonb_build_object('case_key','wrong_unit_scope','actor','unit user wrong scope','surface','admin unit-scoped surfaces','required_evidence','scope denied')
  ) as payload
), final_gate as (
  select jsonb_build_object(
    'decision', 'NOSOK_V36_WRAPPER_RPC_PRESENT_REPOSITORY_BINDING_ADAPTER_PREPARED_BROWSER_ROLE_SCOPE_UAT_REQUIRED',
    'read_only', true,
    'production_approved', false,
    'ddl_executed_by_this_script', false,
    'dml_executed_by_this_script', false,
    'repository_binding_certified_by_this_script', false,
    'platform_hosted_binding_authorized', false,
    'create_table_public_authorized', false,
    'waqf_assets_mutation_authorized', false
  ) as payload
)
select '01_schema_presence' as section, payload from schema_presence
union all select '02_wrapper_status', payload from wrapper_status
union all select '03_function_security', payload from function_security
union all select '04_grant_summary', payload from grant_summary
union all select '05_public_base_table_guard', payload from public_base_table_guard
union all select '06_browser_role_scope_uat_matrix', payload from uat_matrix
union all select '07_final_gate', payload from final_gate;
