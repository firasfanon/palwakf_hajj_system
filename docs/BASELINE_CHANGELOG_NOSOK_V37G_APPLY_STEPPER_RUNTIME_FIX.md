# BASELINE CHANGELOG — Nosok v37G

**التاريخ:** 2026-05-20  
**العنوان:** Apply Page Stepper Runtime Layout Fix + RenderBox Closure

## السبب

بعد v37F أظهر التشغيل المحلي أن:

- `dart format .` نجح.
- `flutter analyze` عاد `No issues found`.
- `flutter run -d chrome` أقلع ووصل إلى Debug Service.
- عند فتح `/services/nosok/apply` ظهرت صفحة فارغة مع خطأ runtime:
  `RenderFlex children have non-zero flex but incoming height constraints are unbounded`.

الجذر كان استخدام `StepperType.horizontal` داخل صفحة عامة موضوعة ضمن scrollable/sliver، حيث يعتمد Stepper الأفقي داخليًا على Column/Expanded يحتاج ارتفاعًا محدودًا.

## التغيير المطبق

تم تعديل:

```text
lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart
```

وذلك بتغليف `Stepper` داخل `SizedBox` بارتفاع محدود على شاشات desktop/tablet الواسعة فقط:

```dart
height: MediaQuery.of(context).size.width < 820 ? null : 760
```

وبذلك يبقى السلوك كالتالي:

- الشاشات الواسعة: Stepper أفقي بارتفاع محدود، دون قيود unbounded.
- الشاشات الصغيرة: Stepper عمودي، دون فرض ارتفاع ثابت.

## ما لم يتغير

- لا SQL.
- لا Backend.
- لا إنشاء schema.
- لا تعديل على `waqf_assets`.
- لا كسر لمسارات الجمهور أو الإدارة.
- لا عودة لأي لون زهري/وردي.

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
