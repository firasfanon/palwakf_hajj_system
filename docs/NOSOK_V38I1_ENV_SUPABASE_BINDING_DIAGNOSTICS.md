# Nosok v38I-1 — Env-Based Supabase Binding Diagnostics

## القرار
هذه الدفعة تضيف تشخيص اتصال Supabase لنسك كبيئة تطوير Standalone Real-DB، دون إنشاء schema ودون تطبيق SQL تنفيذي.

## التشغيل المحلي
يجب نسخ ملف `.env` في جذر المشروع، بقيم محلية لا تُرفع إلى Git:

```env
NOSOK_DATA_MODE=standaloneSupabaseDevelopment
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

لا يجوز وضع `SUPABASE_SERVICE_ROLE_KEY` داخل Flutter Web.

## صفحة التشخيص

```text
/admin/systems/nosok/supabase-connection-diagnostics
```

تعرض الصفحة:

- وضع التشغيل الفعلي.
- وجود `SUPABASE_URL`.
- وجود `SUPABASE_ANON_KEY` دون كشفه كاملًا.
- هل تم تهيئة `Supabase.instance.client`.
- حالة `nosok.homepage_sections` إن كانت schema مطبقة.
- حالة RPC العامة لأقسام الصفحة الرئيسية.
- حالة RPC فحص core المرجعي.

## القواعد

- `core` مصدر سيادي للمحافظات و LGUs والوحدات.
- `public` سطح wrappers فقط.
- `nosok` مالك بيانات نسك التشغيلية.
- لا cross-schema mutation.
- لا schema apply قبل shape discovery.
- لا production approval.
