# ERROR RECORD — Nosok v37G

## الخطأ

```text
RenderFlex children have non-zero flex but incoming height constraints are unbounded.
The relevant error-causing widget was: Stepper
lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart:134
```

## السبب

`StepperType.horizontal` يستخدم داخليًا Column/Expanded ويحتاج ارتفاعًا محدودًا. الصفحة العامة داخل scrollable/sliver، لذلك وصلت قيود ارتفاع غير محدودة.

## الملفات المتأثرة

```text
lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart
```

## الحل

تغليف Stepper بـ `SizedBox` في الشاشات الواسعة:

```dart
height: MediaQuery.of(context).size.width < 820 ? null : 760
```

## الحكم

تصحيح موضعي آمن. لا SQL، لا Backend، لا waqf_assets mutation.
