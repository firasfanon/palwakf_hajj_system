-- Nosok v25 full PalWakf merge evidence read-only helper.
-- Intended for SQL Editor after applying authorized platform registry/RBAC scripts.

select
  'nosok_v25_full_merge_evidence' as section,
  'manual_merge_evidence_required' as check_key,
  false as passed,
  'This query is read-only. Attach full PalWakf merge apply logs, analyzer result, browser screenshots, role UAT, and SQL UAT outputs.' as note;
