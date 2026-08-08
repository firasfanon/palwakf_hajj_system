# SESSION HANDOFF — Nosok v38I-1

## نقطة البداية
آخر baseline مستقر قبل هذه الدفعة:

```text
nosok_v38i_standalone_real_supabase_development_binding_2026_05_21.zip
```

## نطاق الدفعة
أُضيفت طبقة تشخيص اتصال Supabase من ملف `.env` داخل مشروع نسك standalone، دون تطبيق أي SQL أو إنشاء schema.

## طريقة التشغيل المقترحة

1. انسخ `.env` في جذر المشروع المحلي.
2. ضع:

```env
NOSOK_DATA_MODE=standaloneSupabaseDevelopment
SUPABASE_URL=https://...
SUPABASE_ANON_KEY=...
```

3. شغّل:

```bash
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

4. افتح:

```text
/admin/systems/nosok/supabase-connection-diagnostics
```

## القرار التالي
إذا أثبتت صفحة التشخيص وجود client وتأكدت نتائج shape discovery، يتم تعديل/تشغيل schema creation pack في بيئة تطوير فقط. قبل ذلك تبقى schema apply متوقفة.
