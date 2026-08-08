# Session Handoff — Nosok v38I-2

## آخر حالة مستقرة

```text
staging-stable /
nosok-v38i2-supabase-initialization-guard-applied /
env-url-and-anon-auto-promote-data-mode /
schema-apply-paused /
production-not-approved /
no-waqf-assets-mutation
```

## نقطة البداية التالية

1. نسخ `.env` الحقيقي في جذر المشروع.
2. تشغيل:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

3. فتح:

```text
/admin/systems/nosok/supabase-connection-diagnostics
```

## المتوقع

- Data mode يصبح `standaloneSupabaseDevelopment` عند وجود URL/anon key.
- Supabase Client يصبح READY.
- فحوص `nosok.homepage_sections` وRPCs قد تبقى warning/pending حتى تطبيق schema بعد فحص البيئة.

## ممنوعات

لا تطبق `sql/39...` قبل تشغيل census/shape discovery read-only ومراجعة النتائج.
