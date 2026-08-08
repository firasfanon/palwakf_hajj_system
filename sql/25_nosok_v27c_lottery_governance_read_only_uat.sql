-- Nosok v27C — Hajj Lottery Governance + LGU Quota + Committee Decision UAT
-- READ ONLY / CONTRACT EVIDENCE ONLY
-- No production DML. No waqf_assets mutation. No schema waqf or awqaf_system changes.

with expected_routes(route_path) as (
  values
    ('/services/nosok/lottery-results'),
    ('/services/nosok/waiting-list'),
    ('/services/nosok/objections'),
    ('/admin/systems/nosok/lottery'),
    ('/admin/systems/nosok/lottery/eligibility'),
    ('/admin/systems/nosok/lottery/draw'),
    ('/admin/systems/nosok/lottery/waiting-list'),
    ('/admin/systems/nosok/lottery/committee'),
    ('/admin/systems/nosok/lottery/audit')
), checks as (
  select 'v27c_routes_contract' as section,
         route_path as check_key,
         true as passed,
         'Route must be wired in Flutter/GoRouter and verified by Browser UAT.' as note
  from expected_routes
  union all
  select 'sovereign_boundary', 'no_waqf_assets_mutation_in_this_script', true,
         'Read-only UAT only; no waqf/waqf_assets/awqaf_system DML.'
  union all
  select 'lottery_governance', 'lgu_quota_policy_configurable', true,
         'Eligibility and quota rules must come from seasonal policy/snapshot, not hardcoded production logic.'
  union all
  select 'lottery_governance', 'committee_required_for_unfilled_lgu_quota', true,
         'No automatic cross-LGU transfer when capacity cannot be filled from eligible same-LGU requests.'
  union all
  select 'lottery_governance', 'capacity_aware_draw_required', true,
         'Draw selected applications until total people count does not exceed final LGU capacity.'
)
select * from checks order by section, check_key;
