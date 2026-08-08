# Nosok v22 — Full PalWakf Apply Runbook

هذا الملف يوضح تطبيق حزمة نسك داخل ريبو PalWakf الكامل. لا يُستخدم داخل preview host.

## الخطوات

1. انسخ `lib/features/nosok_system` إلى ريبو PalWakf الكامل.
2. لا تنسخ `lib/main.dart` ولا `pubspec.yaml` الخاصة بالمعاينة إلا إذا كانت dependencies ناقصة فقط.
3. أضف imports لـ `NosokRoutes.publicRoutes` و`NosokRoutes.adminRoutes` في route groups الحقيقية.
4. طبّق `nosok_access_profile_override.dart` على ProviderScope الحقيقي للمنصة.
5. شغّل SQL بالترتيب من `sql/00...` حتى `sql/20...`.
6. شغّل Browser/Role UAT وسجل الأدلة عبر v22 RPCs.
7. لا تعتمد production إلا بعد إغلاق `public.rpc_nosok_v22_production_gate_decision_v1`.

## قواعد حاكمة

- PalWakf هي منصة الأساس.
- نسك نظام شبه مستقل تحتها.
- Auth/RBAC/core.org_units/billing/notifications مصادر منصة لا مصادر نسك.
- لا تعديل على `waqf`, `waqf_assets`, `awqaf_system`.
