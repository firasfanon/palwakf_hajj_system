# Nosok v38H — Supabase Binding Contract Discovery

## الحالة

`Development / Preparation Only` — لا SQL apply، لا إنشاء schema، لا backend binding، ولا انضمام فعلي إلى PalWakf.

## لماذا هذه الدفعة؟

بعد مراجعة ملفات PalWakf في محاولة v39، أصبح واضحًا أن تصميم schema وحده لا يكفي. يجب أن يعرف نسك كيف يتصل فعليًا بقاعدة Supabase عبر المنصة الحاضنة، لا عبر عميل مستقل.

## اكتشافات منصة PalWakf

| المحور | ما تم اكتشافه | أثره على نسك |
|---|---|---|
| Supabase init | `lib/main.dart` يهيئ `Supabase.initialize` مركزيًا باستخدام `AppConstants.baseUrl` و`AppConstants.apiKey` | نسك لا يهيئ Supabase مستقلًا |
| env | `AppConstants` يقرأ `SUPABASE_URL` و`SUPABASE_ANON_KEY` من البيئة | لا مفاتيح داخل نسك |
| service | `SupabaseService` يلف `Supabase.instance.client` ويوفر `from/rpc/auth/storage` | نسك يستخدم خدمة المنصة عند الاستضافة |
| provider | `supabaseServiceProvider` هو حقن Riverpod للخدمة | NosokRepository يستقبل client/service من Provider المنصة |
| access | `AccessRepository` يقرأ `admin_users` وRBAC platform | نسك لا يثق بالواجهة ولا payload للنطاق |

## قرار الربط

```text
PalWakf SupabaseService / SupabaseClient
→ NosokRepository Adapter
→ public RPC wrappers
→ nosok schema
→ RLS/RBAC/Audit
```

وليس:

```text
Nosok standalone Supabase.initialize
```

## بوابات الحظر

- لا `service_role` في الكود.
- لا مفاتيح حساسة في الوثائق.
- لا direct public table exposure.
- لا قراءة مباشرة من `core/gis/waqf` إلا عبر RPC/snapshots مصرح بها.
- لا تعديل على `waqf_assets`.

## المخرجات

- صفحة إدارية: `/admin/systems/nosok/supabase-binding-discovery`
- صفحة أدلة: `/admin/systems/nosok/v38h-supabase-binding`
- ملف SQL read-only discovery: `sql/37_nosok_v38h_supabase_binding_contract_discovery.sql`
