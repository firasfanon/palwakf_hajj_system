-- Nosok v38H — Supabase Binding Contract Discovery + Shape Discovery SQL Readiness
-- Scope: READINESS / SHAPE DISCOVERY ONLY. No schema creation, no DML, no SQL apply.
-- This script is intentionally read-only and should be used inside PalWakf DB only after platform hosting starts.

-- Guardrail summary:
-- 1) Nosok must use PalWakf SupabaseService/SupabaseClient; no independent client.
-- 2) Nosok UI must use public RPC wrappers, not direct nosok/core/gis table reads.
-- 3) Shape discovery must run before creating nosok schema/FKs/mappings.
-- 4) No waqf_assets / waqf / awqaf_system mutation.

with expected_sources as (
  select * from (values
    ('public.admin_users', 'identity/admin users', 'required for employee/company/admin identity'),
    ('auth.users', 'auth identity', 'required through Supabase auth context'),
    ('platform.system_user_roles', 'dynamic RBAC roles', 'required if platform RBAC tables exist'),
    ('platform.system_user_permissions', 'dynamic RBAC permissions', 'required if platform RBAC tables exist'),
    ('core.org_units', 'sovereign org units', 'required for unitSlug/directorate scope'),
    ('public.org_units', 'compatibility org units view/table', 'optional wrapper/compatibility surface')
  ) as t(object_name, purpose, decision)
), split_names as (
  select
    object_name,
    split_part(object_name, '.', 1) as source_schema,
    split_part(object_name, '.', 2) as object_name_only,
    purpose,
    decision
  from expected_sources
)
select
  'nosok_v38h_shape_discovery_sources' as section,
  object_name,
  purpose,
  exists (
    select 1
    from information_schema.tables t
    where t.table_schema = split_names.source_schema
      and t.table_name = split_names.object_name_only
  ) or exists (
    select 1
    from information_schema.views v
    where v.table_schema = split_names.source_schema
      and v.table_name = split_names.object_name_only
  ) as present,
  decision
from split_names
order by object_name;

select
  'nosok_v38h_required_public_rpcs_draft' as section,
  unnest(array[
    'public.rpc_nosok_homepage_sections_public_v1',
    'public.rpc_nosok_public_application_submit_v1',
    'public.rpc_nosok_public_application_track_v1',
    'public.rpc_nosok_public_lottery_result_get_v1',
    'public.rpc_nosok_public_objection_submit_v1',
    'public.rpc_nosok_admin_applications_queue_v1',
    'public.rpc_nosok_admin_homepage_sections_upsert_v1',
    'public.rpc_nosok_admin_dynamic_page_publish_v1',
    'public.rpc_nosok_admin_legal_lottery_simulate_v1',
    'public.rpc_nosok_admin_lottery_draw_execute_v1'
  ]) as rpc_contract,
  'draft_not_installed' as decision;

select
  'nosok_v38h_sovereign_boundary' as section,
  'no_waq_assets_mutation_in_this_script' as check_key,
  true as passed,
  'This file is read-only discovery/readiness; it contains no DDL/DML and no waqf/waqf_assets/awqaf_system mutation.' as note;
