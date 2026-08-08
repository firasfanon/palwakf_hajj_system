# SESSION HANDOFF — Nosok v37D

## نقطة البداية التالية

ابدأ من baseline:

```text
nosok_v37d_public_pages_full_visual_sweep_2026_05_20.zip
```

## الحالة

```text
staging-stable /
nosok-v37d-public-pages-full-visual-sweep-applied /
no-pink-palette-enforced /
public-subpages-premium-alignment-applied /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## ما تم إغلاقه

- منع اللون الزهري ومشتقاته في Palette الخاصة بواجهات الجمهور.
- استبدال نبرة التحذير بالذهبي الوقفي.
- استبدال خلفيات الخطأ الوردية المحتملة بسطح محايد وحد أحمر ملكي.
- توحيد الصفحات التي تستخدم `PwfSisServiceHero` عبر النمط Premium.
- ترقية الصفحات التي تستخدم `NosokPageScaffold` و`NosokSectionCard` إلى نمط عام أكثر عصرية.
- ترقية دليل الخدمات العام.

## المطلوب محليًا

```bash
dart format .
flutter analyze
flutter run -d chrome
```

## مسارات UAT العامة

```text
/services/nosok
/services/nosok/hajj
/services/nosok/umrah
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/companies
/services/nosok/company-login
/services/nosok/contact
/services/nosok/complaints
/services/nosok/faq
/services/nosok/service-guide
/services/nosok/citizen-journey
/services/nosok/follow-up
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
```

## قاعدة اللون الحاكمة

```text
لا وردي ولا زهري ولا مشتقات وردية في الواجهة العامة.
warning = gold
info = sovereign blue
success = calm green
error = neutral surface + royal red border/text only
```

