# BASELINE CHANGELOG — NOSOK V22

## الدفعة
Nosok v22 — Apply Real Merge Pack on Full PalWakf Repo + Browser Role Evidence Intake + Production Gate Decision.

## طبيعة الدفعة
دفعة كبيرة جدًا موجهة للانتقال من preview/staging إلى حزمة دمج حقيقية قابلة للتنفيذ داخل PalWakf، مع منع إعلان الإنتاجية قبل أدلة SQL/Browser/Role UAT.

## إضافات Flutter
- صفحة `browser-role-evidence` لاستيعاب أدلة المتصفح والأدوار.
- صفحة `production-gate-decision` لقرار بوابة الإنتاج.
- صفحة `remaining-work` لعرض ما تبقى حسب P0/P1/P2.
- تحديث routes/navigation/permissions.

## إضافات SQL
- `sql/20_nosok_v22_full_merge_role_evidence_gate_decision.sql`
- سجلات: full platform merge execution، browser role evidence، production gate decisions، remaining work register.
- RPCs v22 للفحص والاستيعاب والقرار.

## إضافات Merge Pack
- `platform_real_merge_pack/FULL_PALWAKF_APPLY_RUNBOOK_V22.md`
- `platform_real_merge_pack/MERGE_EVIDENCE_MATRIX_V22.md`
- `platform_real_merge_pack/sql/04_nosok_v22_apply_evidence.sql`

## الحكم
`staging-ready / v22-large-merge-evidence-pack / production-not-approved / full-repo-apply-pending / sql-uat-pending / browser-role-evidence-pending / no-waqf-assets-mutation`
