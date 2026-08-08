-- Nosok v35.1 — Wrapper/RPC Browser and Role UAT Read-Only Probe
-- Execution mode: READ ONLY
-- Purpose: verify wrapper/RPC presence and keep repository binding blocked until browser/role/scope evidence is supplied.

select '01_wrapper_status' as section,
       jsonb_agg(jsonb_build_object(
         'object_name', object_name,
         'object_kind', object_kind,
         'present', present
       ) order by object_kind, object_name) as payload
from (
  select 'rpc_nosok_application_submit_v1' as object_name, 'function' as object_kind,
         exists (select 1 from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname='public' and p.proname='rpc_nosok_application_submit_v1') as present
  union all select 'rpc_nosok_application_track_v1', 'function',
         exists (select 1 from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname='public' and p.proname='rpc_nosok_application_track_v1')
  union all select 'rpc_nosok_campaigns_public_list_v1', 'function',
         exists (select 1 from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname='public' and p.proname='rpc_nosok_campaigns_public_list_v1')
  union all select 'rpc_nosok_requirements_public_list_v1', 'function',
         exists (select 1 from pg_proc p join pg_namespace n on n.oid = p.pronamespace where n.nspname='public' and p.proname='rpc_nosok_requirements_public_list_v1')
  union all select 'v_nosok_campaigns_public_v1', 'view',
         exists (select 1 from information_schema.views where table_schema='public' and table_name='v_nosok_campaigns_public_v1')
  union all select 'v_nosok_requirements_public_v1', 'view',
         exists (select 1 from information_schema.views where table_schema='public' and table_name='v_nosok_requirements_public_v1')
) s;

select '02_final_gate' as section,
       jsonb_build_object(
         'decision', 'NOSOK_V35_1_WRAPPER_RPC_PRESENT_REPOSITORY_BINDING_REQUIRES_BROWSER_ROLE_SCOPE_UAT',
         'read_only', true,
         'production_approved', false,
         'repository_binding_certified_by_this_script', false,
         'create_table_public_authorized', false,
         'waqf_assets_mutation_authorized', false
       ) as payload;
