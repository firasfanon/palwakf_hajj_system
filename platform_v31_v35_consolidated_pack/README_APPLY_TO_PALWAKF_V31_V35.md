# Nosok v31-v35 — Consolidated Apply Pack

هذه الحزمة تجمع مراحل:

- v31 — PalWakf Merge Execution
- v32 — Nosok Schema/RPC/RLS Creation Preparation
- v33 — Backend Runtime Binding Candidate
- v34 — Browser/Role/Responsive UAT Closure Pack
- v35 — Production Candidate Decision Pack

## القرار الحاكم

لا يتم إنشاء `nosok` schema ولا تشغيل SQL إنتاجي داخل هذه الحزمة. يتم ذلك فقط بعد الدمج داخل ريبو PalWakf الرسمي، ثم sandbox SQL apply، ثم RLS/RPC UAT.

## خطوات التطبيق داخل PalWakf

1. نقل `lib/features/nosok_system` إلى ريبو PalWakf.
2. تسجيل `NosokRoutes.publicRoutes` و`NosokRoutes.adminRoutes` داخل GoRouter.
3. إضافة `system_key=nosok` إلى Dynamic System Registry.
4. إضافة sections: dashboard, requests, review, lottery, companies, campaigns, documents, messages, reports, settings.
5. ربط AccessProfile Override الحقيقي بدل preview provider.
6. تشغيل `dart format .`, `flutter analyze`, `flutter run -d chrome` داخل PalWakf.
7. تنفيذ Browser/Role/Responsive UAT.
8. بعد نجاح الدمج فقط: تجهيز `nosok` schema في sandbox.

## موانع الإنتاج

- لا يوجد SQL apply فعلي بعد.
- لا يوجد backend binding حقيقي بعد.
- لا يوجد Role/Responsive UAT داخل PalWakf بعد.
- لا يوجد قرار production-ready.
- لا تعديل على `waqf_assets`.
