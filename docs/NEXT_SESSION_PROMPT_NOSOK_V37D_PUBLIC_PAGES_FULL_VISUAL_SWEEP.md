# NEXT SESSION PROMPT — Nosok after v37D

ابدأ من:

```text
nosok_v37d_public_pages_full_visual_sweep_2026_05_20.zip
```

نفذ أولًا:

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح جميع صفحات الجمهور وتأكد من:

- لا يوجد لون زهري أو وردي أو مشتقاته.
- كل الصفحات العامة تستخدم نمطًا قريبًا من الصفحة الرئيسية.
- لا توجد أخطاء layout/overflow.
- لا تظهر مصطلحات تقنية داخلية للمواطن.
- لا SQL ولا backend binding قبل دمج PalWakf وإنشاء schema نسك.

الحالة:

```text
staging-stable /
public-pages-visual-sweep-applied /
local-retest-required /
production-not-approved /
no-waqf-assets-mutation
```
