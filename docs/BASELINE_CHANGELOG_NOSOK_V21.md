# BASELINE_CHANGELOG_NOSOK_V21

## Nosok v21 — Real Platform Merge Pack + RBAC Provider Override + SQL UAT Result Intake

الحالة: `staging-ready / real-platform-merge-pack-added / rbac-provider-override-contract-ready / sql-uat-intake-enabled / production-not-approved / no-waqf-assets-mutation`.

## الأساس السابق
- v20 أثبت حزمة UAT وعمليات الطلبات وجاهزية الدمج.
- سجل التشغيل المحلي بعد v19.3 أثبت `flutter analyze: No issues found` ونجاح `flutter run -d chrome`.

## التغييرات الرئيسية
1. إضافة صفحة إدارية: `/admin/systems/nosok/real-platform-merge`.
2. إضافة صفحة إدارية: `/admin/systems/nosok/rbac-provider-override`.
3. إضافة صفحة إدارية: `/admin/systems/nosok/sql-uat-intake`.
4. إضافة صلاحيات جديدة: `manageNosokRealPlatformMerge`, `manageNosokRbacProviderOverride`, `intakeNosokSqlUatResults`.
5. إضافة SQL v21: `sql/19_nosok_v21_real_platform_merge_rbac_sql_uat_intake.sql`.
6. إضافة مجلد `platform_real_merge_pack` للدمج داخل ريبو PalWakf الكامل.
7. تحديث `analysis_options.yaml` لاستبعاد `platform_real_merge_pack/**` من standalone analysis.

## حدود سيادية
- لا تعديل على `waqf_assets`.
- لا تعديل على schema `waqf`.
- لا تعديل على `awqaf_system`.
- لا users/RBAC محلي داخل نسك.
