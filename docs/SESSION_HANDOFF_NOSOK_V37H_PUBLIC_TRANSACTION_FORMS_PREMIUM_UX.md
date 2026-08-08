# SESSION HANDOFF — Nosok v37H Public Transaction Forms Premium UX

## نقطة البداية

تم تنفيذ هذه الدفعة فوق `v37G` بعد أن أثبتت اللقطات والسجل أن صفحة `/services/nosok/apply` أصبحت مرئية بعد إغلاق runtime blocker، لكنها بقيت بحاجة إلى صقل بصري وتجربة مواطن.

## ما تم إغلاقه

- إزالة `Stepper` الافتراضي من صفحة التقديم العامة.
- إضافة شريط تقدم مواطن responsive.
- تحسين حقول الإدخال والاختيار.
- تحسين أزرار الخطوات.
- تحسين صفحة متابعة الطلب.
- إضافة lookup panels عامة للنتائج وقائمة الانتظار والاعتراضات.
- تثبيت عدم استخدام الزهري/الوردي في عناصر الصفحات العامة.

## الملفات الرئيسية المعدلة

```text
lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_application_status_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_lottery_results_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_waiting_list_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_lottery_objections_page.dart
lib/features/nosok_system/presentation/widgets/pwf_sis_nosok_components.dart
```

## الحالة

```text
staging-stable /
public-transaction-forms-polished /
local-runtime-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## المطلوب في بداية التحقق التالي

1. تشغيل `dart format .`.
2. تشغيل `flutter analyze`.
3. تشغيل `flutter run -d chrome`.
4. فتح صفحة التقديم والتأكد من عدم ظهور `RenderFlex unbounded height`.
5. فحص mobile width للخطوات والأزرار.
