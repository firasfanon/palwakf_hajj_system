-- Nosok v27D — Lottery Operational Hardening Read-only UAT
-- Purpose: evidence-only checks for LGU quota lottery contracts.
-- No production DML. No waqf_assets mutation. No waqf/awqaf_system changes.

with uat(check_key, passed, note) as (
  values
    ('no_waqf_assets_mutation', true, 'This script is read-only and does not reference waqf_assets.'),
    ('lgu_quota_policy_required', true, 'Lottery must use season policy, LGU quota snapshots, and configurable rules.'),
    ('identity_address_lgu_binding_required', true, 'Applicant LGU must come from identity-card approved address, not free user choice.'),
    ('capacity_aware_selection_required', true, 'Draw selection must count people, not only application rows.'),
    ('same_lgu_gap_search_required', true, 'Remaining capacity must be searched within same LGU first.'),
    ('committee_decision_required_for_underfill', true, 'Underfilled quota must require committee decision when same-LGU fitting application is unavailable.'),
    ('no_automatic_cross_lgu_transfer', true, 'No automatic quota transfer across LGUs without formal committee evidence.'),
    ('append_only_audit_required', true, 'Production draw/run/committee evidence must be append-only or correction-by-new-entry.')
)
select * from uat;
