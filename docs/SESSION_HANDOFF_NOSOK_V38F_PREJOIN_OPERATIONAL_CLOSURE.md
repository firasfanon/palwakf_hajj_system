# Session Handoff — Nosok v38F

## آخر baseline
Nosok v38F — Pre-Join Operational Admin Tooling Completion.

## نقطة البداية القادمة
ابدأ من baseline v38F، وليس من v39. v39 يبقى مسار منصة PalWakf وليس مسار تطوير نسك.

## الحالة

- نسك في مسار Development / Preparation Only.
- القانون 15/2025 مستوعب في v38E.
- v38F أضاف إغلاقًا تحضيريًا للأدوات الإدارية ومحاكاة الخوارزمية وبوابة الشركات ومصفوفة UAT.
- لا schema ولا SQL ولا backend binding.

## الفحص المطلوب

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

- /admin/systems/nosok/v38f-prejoin-operational-closure
- /admin/systems/nosok/legal-algorithm-simulation
- /admin/systems/nosok/company-workspace-closure
- /admin/systems/nosok/public-responsive-uat
- /services/nosok
- /services/nosok/apply
