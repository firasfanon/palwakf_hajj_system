-- Nosok v35 — Public Wrapper/RPC Controlled Apply Result Read-Only
-- Purpose: inspect wrapper/RPC apply status after operator-controlled staging apply.
-- This file is SELECT-only. It performs no DDL/DML/GRANT/REVOKE.

WITH expected_wrappers(object_kind, object_name) AS (
  VALUES
    ('view', 'v_nosok_campaigns_public_v1'),
    ('view', 'v_nosok_requirements_public_v1'),
    ('function', 'rpc_nosok_campaigns_public_list_v1'),
    ('function', 'rpc_nosok_requirements_public_list_v1'),
    ('function', 'rpc_nosok_application_submit_v1'),
    ('function', 'rpc_nosok_application_track_v1')
), wrapper_status AS (
  SELECT
    ew.object_kind,
    ew.object_name,
    CASE
      WHEN ew.object_kind = 'view' THEN to_regclass('public.' || ew.object_name) IS NOT NULL
      ELSE EXISTS (
        SELECT 1
        FROM pg_catalog.pg_proc p
        JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
        WHERE n.nspname = 'public'
          AND p.proname = ew.object_name
      )
    END AS present
  FROM expected_wrappers ew
), function_security AS (
  SELECT
    p.proname AS function_name,
    p.prosecdef AS security_definer,
    COALESCE(array_to_string(p.proconfig, ','), '') AS function_config
  FROM pg_catalog.pg_proc p
  JOIN pg_catalog.pg_namespace n ON n.oid = p.pronamespace
  WHERE n.nspname = 'public'
    AND p.proname IN (
      'rpc_nosok_campaigns_public_list_v1',
      'rpc_nosok_requirements_public_list_v1',
      'rpc_nosok_application_submit_v1',
      'rpc_nosok_application_track_v1'
    )
), grant_summary AS (
  SELECT
    routine_schema,
    routine_name,
    grantee,
    privilege_type
  FROM information_schema.routine_privileges
  WHERE routine_schema = 'public'
    AND routine_name IN (
      'rpc_nosok_campaigns_public_list_v1',
      'rpc_nosok_requirements_public_list_v1',
      'rpc_nosok_application_submit_v1',
      'rpc_nosok_application_track_v1'
    )
    AND grantee IN ('anon', 'authenticated', 'PUBLIC')
), public_base_guard AS (
  SELECT
    COUNT(*) FILTER (WHERE table_name LIKE 'nosok%' OR table_name LIKE 'hajj%' OR table_name LIKE 'umrah%') AS new_public_service_base_table_count
  FROM information_schema.tables
  WHERE table_schema = 'public'
    AND table_type = 'BASE TABLE'
), final_gate AS (
  SELECT
    jsonb_build_object(
      'decision', CASE
        WHEN (SELECT bool_and(present) FROM wrapper_status)
          AND (SELECT COALESCE(bool_and(security_definer), false) FROM function_security)
          AND (SELECT new_public_service_base_table_count FROM public_base_guard) = 0
        THEN 'NOSOK_V35_WRAPPER_RPC_APPLY_DETECTED_REPOSITORY_BINDING_PREFLIGHT_PENDING_BROWSER_UAT'
        ELSE 'NOSOK_V35_WRAPPER_RPC_APPLY_NOT_FULLY_DETECTED_OR_SECURITY_INCOMPLETE'
      END,
      'read_only', true,
      'production_approved', false,
      'ddl_executed_by_this_script', false,
      'dml_executed_by_this_script', false,
      'repository_binding_certified_by_this_script', false,
      'create_table_public_authorized', false,
      'waqf_assets_mutation_authorized', false
    ) AS payload
)
SELECT '01_schema_presence' AS section,
       jsonb_build_object(
         'decision', 'NOSOK_V35_PUBLIC_WRAPPER_RPC_APPLY_RESULT_READ_ONLY',
         'read_only', true,
         'core_present', to_regnamespace('core') IS NOT NULL,
         'nosok_present', to_regnamespace('nosok') IS NOT NULL,
         'public_present', to_regnamespace('public') IS NOT NULL,
         'billing_system_present', to_regnamespace('billing_system') IS NOT NULL,
         'platform_access_present', to_regnamespace('platform_access') IS NOT NULL
       ) AS payload
UNION ALL
SELECT '02_wrapper_status', COALESCE(jsonb_agg(to_jsonb(wrapper_status) ORDER BY object_kind, object_name), '[]'::jsonb) FROM wrapper_status
UNION ALL
SELECT '03_function_security', COALESCE(jsonb_agg(to_jsonb(function_security) ORDER BY function_name), '[]'::jsonb) FROM function_security
UNION ALL
SELECT '04_grant_summary', COALESCE(jsonb_agg(to_jsonb(grant_summary) ORDER BY routine_name, grantee), '[]'::jsonb) FROM grant_summary
UNION ALL
SELECT '05_public_base_table_guard', jsonb_build_object('decision', 'PUBLIC_BASE_TABLE_CREATION_BLOCKED_EXISTING_ONLY', 'new_public_service_base_tables_detected', new_public_service_base_table_count > 0, 'new_public_service_base_table_count', new_public_service_base_table_count) FROM public_base_guard
UNION ALL
SELECT '06_final_gate', payload FROM final_gate;
