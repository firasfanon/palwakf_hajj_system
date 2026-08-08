# SESSION HANDOFF — Nosok v37A Premium Public Homepage Visual Upgrade

## نقطة البداية

بدأت هذه الدفعة فوق baseline:

```text
nosok_v37_modern_public_homepage_redesign_2026_05_20.zip
```

## سبب الدفعة

أظهرت مراجعة الصفحة العامة أن واجهة `/services/nosok` أصبحت منظمة وخدمية، لكنها بقيت عصرية جزئيًا فقط وتميل إلى طابع “نظام نظيف” أكثر من تجربة خدمة وطنية جذابة. بناءً على ذلك تم تنفيذ v37A لتحويلها إلى صفحة عامة أكثر حداثة وقوة بصريًا.

## ما تم إنجازه

- Hero أقوى وأكبر وأوضح.
- CTA رئيسي لتقديم الطلب.
- تبسيط Navigation.
- قائمة “المزيد” للخدمات الثانوية.
- Seasonal Status Banner.
- هرمية واضحة للبطاقات.
- صياغة موجهة للمواطن.
- تقليل الحوكمة في الصفحة العامة.
- تحسين mobile stacking وتقليل احتمالات overflow.

## الملفات الأساسية المعدلة

```text
lib/features/nosok_system/presentation/pages/public/nosok_public_home_page.dart
lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart
docs/NOSOK_COMPREHENSIVE_GUIDE_V36_ALL_PHASES_2026_05_20.md
```

## المطلوب محليًا

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم فتح:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
/admin/systems/nosok
```

## حالة الإنتاج

```text
production-not-approved
```

السبب: نسك ما زال قبل الدمج الفعلي داخل PalWakf، وقاعدة بيانات نسك لم تُنشأ عمدًا حتى إتمام الدمج.
