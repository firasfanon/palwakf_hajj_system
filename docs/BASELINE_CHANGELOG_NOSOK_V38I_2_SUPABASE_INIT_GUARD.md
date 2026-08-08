# Nosok v38I-2 — Supabase Initialization Guard Fix

## القرار

تم استيعاب نتيجة التشخيص:

```text
env-url-and-anon-present /
data-mode-still-preview /
supabase-client-not-initialized /
repository-still-inmemory /
schema-apply-paused /
production-not-approved /
no-waqf-assets-mutation
```

## التعديل

- إضافة ترقية تلقائية لوضع التشغيل إلى `standaloneSupabaseDevelopment` عند وجود `SUPABASE_URL` و`SUPABASE_ANON_KEY`.
- عدم الاعتماد على placeholder قديم بقيمة `NOSOK_DATA_MODE=preview` إذا كانت بيانات الاتصال الحقيقية موجودة.
- تقوية صفحة التشخيص حتى لا تستدعي `Supabase.instance.client` إلا عندما يكون مطلوبًا تهيئة Supabase.
- تحديث `.env` و`.env.example`.

## الحدود

لا schema apply، لا SQL تنفيذي، لا production approval، لا service_role داخل Flutter، ولا تعديل على `waqf_assets`.
