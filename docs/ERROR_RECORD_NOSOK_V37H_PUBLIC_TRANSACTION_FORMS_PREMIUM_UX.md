# ERROR RECORD — Nosok v37H

## الخطأ السابق

```text
RenderFlex children have non-zero flex but incoming height constraints are unbounded
Relevant widget: Stepper
File: nosok_apply_page.dart
```

## السبب

استخدام `Stepper` الافتراضي داخل سياق scrollable بارتفاع غير محدود. حتى بعد محاولة تحديد ارتفاع، بقي الشكل بصريًا أقرب إلى Material الإداري ولم يخدم تجربة المواطن.

## الحل

- إزالة `Stepper` من صفحة التقديم.
- بناء `CitizenProgressBar` مخصص.
- عرض خطوة واحدة عبر `AnimatedSwitcher`.
- التحكم الكامل في قيود الارتفاع والتخطيط.

## أثر التصحيح

- لا يعتمد نموذج التقديم على Stepper الافتراضي.
- انخفاض احتمالية تكرار خطأ unbounded height.
- تجربة Mobile/RTL أوضح.
