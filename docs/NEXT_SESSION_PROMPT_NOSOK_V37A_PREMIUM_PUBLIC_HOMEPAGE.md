# NEXT SESSION PROMPT — Nosok v37A

ابدأ من:

```text
nosok_v37a_premium_public_homepage_visual_upgrade_2026_05_20.zip
```

## الحالة

```text
staging-stable /
nosok-v37a-premium-public-homepage-upgrade-applied /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## نفّذ أولًا

```bash
dart format .
flutter analyze
flutter run -d chrome
```

## اختبر

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
/admin/systems/nosok
```

## لا تنفذ

- SQL apply.
- إنشاء schema.
- Backend binding.
- أي تعديل على waqf_assets.

## التالي المقترح

بعد نجاح UAT البصري:

```text
Nosok v37B — Public Homepage Browser/Responsive UAT Intake + Final Visual Polish
```
