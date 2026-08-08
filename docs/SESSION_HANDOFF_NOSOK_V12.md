# SESSION HANDOFF — Nosok v12

## آخر baseline
`nosok_platform_integration_patch_v12_billing_unit_queues_role_uat_under_platform.zip`

## حالة النظام
`staging-ready / billing-bridge-execution-contract / unit-scoped-queues-enabled / role-uat-evidence-intake-enabled / production-not-approved / no-waqf-assets-mutation`

## ما تم تنفيذه
1. جسر الدفع:
   - إنشاء bridge request موجود من v11.
   - v12 أضاف execute/sync لتوليد `billing_reference` واستيعاب `provider_reference`.
   - لا يتم تخزين بيانات بطاقات.

2. طوابير الوحدات:
   - صفحة `/admin/systems/nosok/unit-queues`.
   - فلترة حسب `unitSlug` وحالة الطلب.
   - فتح الطلب مباشرة في صفحة التفاصيل.

3. Role UAT Evidence:
   - إدخال دليل لكل حالة اختبار.
   - حفظ actual access/result/status/evidence URL/notes.
   - تحديث Matrix عند حفظ الدليل.

## ملفات مهمة
- `sql/11_nosok_billing_unit_queues_role_uat_execution.sql`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_unit_queues_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_payment_bridge_page.dart`
- `lib/features/nosok_system/presentation/pages/admin/nosok_admin_role_uat_page.dart`
- `lib/features/nosok_system/application/nosok_unit_queue_controller.dart`
- `lib/features/nosok_system/application/nosok_role_uat_evidence_controller.dart`

## الاختبار المطلوب
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## Browser UAT
- `/admin/systems/nosok/payment-bridge`
- `/admin/systems/nosok/unit-queues`
- `/admin/systems/nosok/role-uat`

## التالي
Nosok v13 — Billing Provider Adapter Hardening + Public Tracking Privacy Review + Production Readiness Evidence Closure.
