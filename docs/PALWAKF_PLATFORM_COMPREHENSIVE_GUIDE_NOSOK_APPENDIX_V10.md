# PalWakf Comprehensive Guide — Nosok Appendix v10

## القاعدة المعتمدة
نسك نظام شبه مستقل تحت PalWakf. المنصة هي الأساس، ونسك لا يملك هوية أو مستخدمين أو RBAC مستقل.

## تشغيل شبه مستقل
v10 أضافت host معاينة لتسهيل التطوير:
- `pubspec.yaml`
- `lib/main.dart`
- `NosokInMemoryRepository`

هذا لا يحول نسك إلى منصة مستقلة، بل يوفّر بيئة تشغيل مؤقتة للمعاينة والتطوير.

## الصلاحيات
- `nosokAccessProfileProvider` يجب أن يُربط من PalWakf AccessProfile.
- Superuser/platformAdmin له override.
- سايدبار نسك لا يعرض إلا ما يسمح به AccessProfile.

## الوحدات
- `core.org_units` مصدر الوحدات.
- `nosok.unit_service_scopes` يخزن سطح خدمة نسك فقط.
- لا تنشئ نسك مصدر وحدات بديل.

## الإنتاج
لا production-ready قبل UAT كامل وربط المنصة الحقيقي.
