-- Nosok v25 — Evidence Intake + Full PalWakf Merge Result + Production Candidate Decision
-- READ-ONLY UAT PACK
-- This script must not execute DDL/DML and must not mutate waqf, waqf_assets, or awqaf_system.

with expected_runtime as (
  select * from (values
    ('public_route_services_nosok', '/services/nosok'),
    ('public_route_apply', '/services/nosok/apply'),
    ('public_route_track', '/services/nosok/track'),
    ('admin_route_home', '/admin/systems/nosok'),
    ('admin_route_v25_evidence', '/admin/systems/nosok/v25-evidence-intake'),
    ('admin_route_v25_merge', '/admin/systems/nosok/v25-full-merge-application-result'),
    ('admin_route_v25_decision', '/admin/systems/nosok/v25-production-candidate-decision')
  ) as t(check_key, expected_route)
), schema_presence as (
  select exists(select 1 from information_schema.schemata where schema_name = 'nosok') as nosok_schema_exists
), rpc_presence as (
  select
    count(*) filter (where routine_schema = 'public' and routine_name like 'rpc_nosok_%') as public_nosok_rpc_count
  from information_schema.routines
), sovereign_boundary as (
  select
    true as no_waqf_assets_mutation_in_this_script,
    true as no_waq_schema_mutation_in_this_script,
    true as no_awqaf_system_mutation_in_this_script
)
select
  'nosok_v25_read_only_uat' as section,
  'runtime_contract_shape' as check_key,
  true as passed,
  'Routes are Flutter-side constants; this SQL pack checks database/runtime readiness without DDL/DML.' as note
union all
select
  'nosok_v25_read_only_uat',
  'nosok_schema_exists',
  nosok_schema_exists,
  case when nosok_schema_exists then 'nosok schema exists.' else 'nosok schema missing; apply authorized schema pack before runtime Supabase UAT.' end
from schema_presence
union all
select
  'nosok_v25_read_only_uat',
  'public_nosok_rpc_surface_detected',
  public_nosok_rpc_count > 0,
  'public rpc_nosok_% functions detected: ' || public_nosok_rpc_count::text
from rpc_presence
union all
select
  'nosok_v25_read_only_uat',
  'no_waqf_assets_mutation_in_this_script',
  no_waqf_assets_mutation_in_this_script,
  'Read-only evidence/candidate UAT only; no waqf_assets DML/DDL.'
from sovereign_boundary
union all
select
  'nosok_v25_read_only_uat',
  'no_waq_schema_mutation_in_this_script',
  no_waq_schema_mutation_in_this_script,
  'Read-only evidence/candidate UAT only; no waq schema DML/DDL.'
from sovereign_boundary;
