# SESSION HANDOFF — Nosok v37G

## آخر baseline

```text
nosok_v37g_apply_stepper_runtime_layout_fix_2026_05_20.zip
```

## حالة البداية

تمت الدفعة فوق v37F بعد أن أثبت السجل المحلي أن التحليل نظيف لكن صفحة `/services/nosok/apply` تفشل في runtime بسبب Stepper أفقي داخل قيود ارتفاع غير محدودة.

## ما تم إصلاحه

تم إغلاق خطأ RenderBox/RenderFlex في صفحة التقديم العامة. الخطأ كان ناتجًا عن `StepperType.horizontal` داخل scrollable بدون ارتفاع محدود. تم تغليف Stepper بـ `SizedBox` بارتفاع desktop محدود مع الإبقاء على vertical behavior للموبايل.

## الملفات المعدلة

```text
lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart
docs/BASELINE_CHANGELOG_NOSOK_V37G_APPLY_STEPPER_RUNTIME_FIX.md
docs/SESSION_HANDOFF_NOSOK_V37G_APPLY_STEPPER_RUNTIME_FIX.md
docs/UAT_MATRIX_NOSOK_V37G_APPLY_STEPPER_RUNTIME_FIX.md
docs/ERROR_RECORD_NOSOK_V37G_APPLY_STEPPER_RUNTIME_FIX.md
docs/ROUTES_SUMMARY_NOSOK_V37G_APPLY_STEPPER_RUNTIME_FIX.md
docs/MODIFIED_FILES_NOSOK_V37G_APPLY_STEPPER_RUNTIME_FIX.md
docs/NEXT_SESSION_PROMPT_NOSOK_V37G_APPLY_STEPPER_RUNTIME_FIX.md
```

## الحكم

```text
staging-stable /
nosok-v37g-apply-stepper-runtime-layout-fix-applied /
analyzer-clean-prior-to-runtime-fix /
chrome-startup-passed-prior-to-runtime-fix /
apply-page-renderbox-unbounded-stepper-fixed /
local-runtime-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## المطلوب محليًا الآن

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم فتح المسارات:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
```

يجب التأكد من أن `/services/nosok/apply` لا يظهر صفحة فارغة ولا يسجل RenderFlex/RenderBox errors.
