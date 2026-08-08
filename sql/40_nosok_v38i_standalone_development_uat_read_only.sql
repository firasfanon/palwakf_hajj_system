-- Nosok v38I — Standalone Real Supabase Development UAT
-- READ ONLY after applying 39_nosok_v38i_standalone_development_schema_creation_pack.sql

select
  'nosok_schema_presence' as section,
  exists(select 1 from information_schema.schemata where schema_name = 'nosok') as nosok_schema_exists,
  true as no_waq_assets_mutation;

select
  'nosok_required_tables' as section,
  count(*) filter (where table_schema = 'nosok' and table_name in (
    'homepage_sections','page_registry','page_sections','registration_governance_windows','applications','applicants','companies','lottery_policies','lgu_quota_snapshots','lottery_draw_runs','lottery_draw_results','lottery_objections','audit_events'
  )) as installed_count,
  13 as expected_count
from information_schema.tables
where table_schema = 'nosok';

select
  'nosok_public_rpc_wrappers' as section,
  routine_name,
  routine_schema
from information_schema.routines
where routine_schema = 'public'
  and routine_name in (
    'rpc_nosok_homepage_sections_public_v1',
    'rpc_nosok_admin_homepage_sections_list_v1',
    'rpc_nosok_admin_homepage_sections_upsert_v1',
    'rpc_nosok_public_application_submit_v1',
    'rpc_nosok_public_application_track_v1',
    'rpc_nosok_core_governorates_lookup_v1',
    'rpc_nosok_core_lgus_lookup_v1'
  )
order by routine_name;

select
  'homepage_sections_runtime_seed' as section,
  count(*) as published_sections
from nosok.homepage_sections
where status = 'published';

select
  'rls_enabled_tables' as section,
  schemaname,
  tablename,
  rowsecurity
from pg_tables
where schemaname = 'nosok'
order by tablename;

select
  'sovereign_boundary' as section,
  'nosok owns nosok schema only; core/platform/gis are read-only references; public is wrappers only; no waqf_assets mutation' as decision;
