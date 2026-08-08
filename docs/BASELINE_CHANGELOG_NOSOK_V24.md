# BASELINE_CHANGELOG — Nosok v24

## العنوان
Mega Batch Nosok v24 — Browser Role Responsive UAT Evidence + PalWakf Merge Readiness Closure + Supabase Runtime UAT Pack + Production Gate Re-decision

## الأساس
مبني فوق v23.2 بعد نجاح التشغيل المحلي: الصفحات تعمل، `flutter analyze` clean، وChrome startup passed حسب سجل المستخدم.

## التغييرات
- إضافة نموذج بيانات `NosokV24UatPack` و`NosokV24EvidenceGroup` و`NosokV24CheckItem`.
- إضافة `nosokV24UatPackProvider` عبر `flutter_riverpod.dart`.
- إضافة صفحات إدارية جديدة:
  - `/admin/systems/nosok/v24-uat-evidence`
  - `/admin/systems/nosok/v24-responsive-uat`
  - `/admin/systems/nosok/v24-merge-readiness-closure`
  - `/admin/systems/nosok/v24-supabase-runtime-uat`
  - `/admin/systems/nosok/v24-production-redecision`
- تحديث `system_routes.dart` و`system_navigation.dart` و`system_permissions.dart` و`nosok_routes.dart`.
- إضافة SQL read-only UAT pack: `sql/22_nosok_v24_read_only_uat_pack.sql`.
- تحديث ملفات التوريث والحكم.

## SQL
لا يوجد SQL إنتاجي ولا DDL/DML. الملف الجديد read-only فقط.

## الحكم
`staging-stable / browser-role-responsive-uat-pack-added / palwakf-merge-readiness-closure-added / supabase-runtime-read-only-uat-pack-added / production-not-approved / no-waqf-assets-mutation`
