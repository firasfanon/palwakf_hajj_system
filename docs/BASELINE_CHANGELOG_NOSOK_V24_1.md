# BASELINE_CHANGELOG — Nosok v24.1

## الحالة
- analyzer-warning-closure فوق v24.
- لا تغييرات وظيفية.
- لا SQL إنتاجي.
- لا DML.
- لا تعديل على waqf / waqf_assets / awqaf_system.

## سبب الدفعة
سجل التشغيل المحلي بعد v24 أثبت نجاح `flutter run -d chrome`، ووجود issue واحد فقط في `flutter analyze`: import غير مستخدم داخل صفحة قرار الإنتاج v24.

## التعديل
إزالة import غير مستخدم من:
`lib/features/nosok_system/presentation/pages/admin/nosok_admin_v24_production_redecision_page.dart`

## الحكم
`hotfix-ready / analyzer-warning-addressed / chrome-startup-passed-from-user-log / local-retest-required / production-not-approved / no-waqf-assets-mutation`
