# BASELINE CHANGELOG — Nosok v38I-1

## العنوان
Env-Based Supabase Binding Diagnostics + Repository Mode Verification + No Schema Apply

## الحكم

```text
staging-stable /
nosok-v38i1-env-supabase-binding-diagnostics-applied /
flutter-dotenv-runtime-load-added /
repository-mode-verification-added /
supabase-client-health-check-added /
real-db-schema-apply-paused /
production-not-approved /
no-waqf-assets-mutation
```

## التغييرات

- إضافة تحميل `.env` في `main.dart` عبر `flutter_dotenv` مع fallback آمن.
- إضافة `NosokRuntimeEnvironment` لتوحيد قراءة `NOSOK_DATA_MODE`, `SUPABASE_URL`, `SUPABASE_ANON_KEY`.
- تعديل `NosokSupabaseRepository` ليقرأ وضع التشغيل من البيئة runtime بدل `String.fromEnvironment` فقط.
- إضافة صفحة تشخيص:
  - `/admin/systems/nosok/supabase-connection-diagnostics`
- إضافة فحوصات runtime:
  - mode.
  - URL present/masked.
  - anon key present/masked.
  - Supabase client initialized.
  - nosok schema / homepage_sections probe.
  - public homepage RPC probe.
  - core reference readiness RPC probe.
- إضافة SQL read-only diagnostics pack.
- إضافة `.env.example` و `.env` placeholder فارغ آمن.

## ما لم يتم

- لا إنشاء schema.
- لا SQL apply.
- لا DML.
- لا backend binding إنتاجي.
- لا service_role داخل Flutter.
- لا waqf_assets mutation.
