# SESSION HANDOFF — Nosok v27D Lottery Operational Hardening

## نقطة البداية

آخر baseline قبل هذه الدفعة:

```text
nosok_v27c1_lottery_compile_fix_2026_05_19.zip
```

## ما تم تنفيذه

تم تنفيذ دفعة كبيرة واحدة لاستكمال تطوير قرعة الحج بعد v27C-1، مع التركيز على جعل نموذج القرعة أقرب للتشغيل الحكومي الواقعي:

- التسجيل مفتوح لكل من تنطبق عليه الشروط.
- دخول القرعة مشروط باستكمال الشروط.
- التجمع/LGU مشتق من عنوان البطاقة الشخصية.
- لكل تجمع حصة قابلة للتعديل حسب سياسة الوزارة.
- الحصة قد تعتمد على السكان أو إدخال يدوي من الوزارة.
- الاختيار capacity-aware على مستوى عدد الأشخاص لا عدد الطلبات.
- عند وجود سعة متبقية يبحث النظام داخل نفس التجمع فقط.
- إذا تعذر الاستكمال، القرار ينتقل إلى لجنة الحج ولا يتم تحويل الحصة تلقائيًا.

## الملفات المحورية المعدلة

```text
lib/features/nosok_system/domain/models/nosok_lottery_policy.dart
lib/features/nosok_system/application/nosok_lottery_controller.dart
lib/features/nosok_system/presentation/pages/admin/nosok_admin_lottery_page.dart
lib/features/nosok_system/presentation/pages/admin/nosok_admin_lottery_eligibility_page.dart
lib/features/nosok_system/presentation/pages/admin/nosok_admin_lottery_draw_page.dart
lib/features/nosok_system/presentation/pages/admin/nosok_admin_lottery_waiting_list_page.dart
lib/features/nosok_system/presentation/pages/admin/nosok_admin_lottery_committee_page.dart
lib/features/nosok_system/presentation/pages/admin/nosok_admin_lottery_audit_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_lottery_results_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_lottery_objections_page.dart
sql/26_nosok_v27d_lottery_operational_hardening_read_only_uat.sql
```

## المسارات المطلوب اختبارها

```text
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
/admin/systems/nosok/lottery
/admin/systems/nosok/lottery/eligibility
/admin/systems/nosok/lottery/draw
/admin/systems/nosok/lottery/waiting-list
/admin/systems/nosok/lottery/committee
/admin/systems/nosok/lottery/audit
```

## أوامر إعادة الاختبار

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## موانع الإنتاج المتبقية

- SQL/RPC إنتاجي للقرعة غير منفذ.
- RLS وسياسات Storage للاعتراضات غير منفذة.
- Role UAT غير مرفق.
- Browser console evidence غير مرفق.
- نتائج القرعة الإنتاجية غير معتمدة.

## الحكم

```text
staging-stable /
nosok-v27d-lottery-operational-hardening-applied /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```
