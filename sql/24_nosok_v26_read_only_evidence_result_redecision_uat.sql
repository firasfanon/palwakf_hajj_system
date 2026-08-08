-- Nosok v26 — Read-only Evidence Result + Production Candidate Re-decision UAT
-- Scope: read-only validation/intake status only.
-- No DDL, no DML, no waqf/waqf_assets/awqaf_system mutation.

select * from (
  values
    ('runtime', 'flutter_analyze_warning_closed', true, 'v26 closes the unused _V25EvidenceSectionPanel warning in the preview package.'),
    ('runtime', 'chrome_startup_evidence_intaken', true, 'User log confirms Chrome startup reached Debug Service before v26.'),
    ('browser', 'browser_pages_reported_working', true, 'User previously reported all pages working; console evidence still pending.'),
    ('role', 'real_rbac_evidence_pending', false, 'Role UAT requires PalWakf AccessProfile override in full repo.'),
    ('responsive', 'responsive_evidence_pending', false, 'Responsive desktop/tablet/mobile screenshots are still pending.'),
    ('merge', 'full_palwakf_merge_pending', false, 'Full platform merge result is not yet attached.'),
    ('supabase', 'sql_uat_pending', false, 'Supabase SQL UAT must be run in SQL Editor.'),
    ('sovereign_boundary', 'no_waq_assets_mutation', true, 'This read-only UAT does not touch waqf_assets, waqf, or awqaf_system.')
) as v(section, check_key, passed, note);
