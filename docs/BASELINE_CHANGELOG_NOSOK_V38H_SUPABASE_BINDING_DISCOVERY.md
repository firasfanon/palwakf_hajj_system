# BASELINE CHANGELOG — Nosok v38H

## الدفعة

**Nosok v38H — Supabase Binding Contract Discovery + Platform Client Adapter Preparation + RPC/Repository Binding Design + Shape Discovery SQL Readiness**

## النطاق

Development / Preparation Only. لا يوجد SQL apply ولا إنشاء schema ولا backend binding فعلي.

## التغييرات

- إضافة عقد Dart لاكتشاف طريقة ربط Supabase داخل PalWakf.
- إضافة Controller/Provider لعرض العقد داخل لوحة نسك.
- إضافة صفحة إدارية:
  - `/admin/systems/nosok/supabase-binding-discovery`
  - `/admin/systems/nosok/v38h-supabase-binding`
- إضافة صلاحية تحضيرية:
  - `manageNosokSupabaseBindingDiscovery`
- تحديث route/access/navigation contracts.
- إضافة حزمة وثائق:
  - `supabase_binding_contract_pack/`
- إضافة SQL read-only discovery:
  - `sql/37_nosok_v38h_supabase_binding_contract_discovery.sql`

## المصادر المكتشفة من PalWakf

- `lib/main.dart` — Supabase.initialize مركزي.
- `lib/core/constants/app_constants.dart` — SUPABASE_URL / SUPABASE_ANON_KEY من البيئة.
- `lib/data/services/supabase_service.dart` — SupabaseService singleton.
- `lib/presentation/providers/supabase_providers.dart` — supabaseServiceProvider.
- `lib/core/access/access_repository.dart` — admin_users + platform RBAC.

## حدود التنفيذ

- لا مفاتيح اتصال داخل نسك.
- لا عميل Supabase مستقل.
- لا DDL/DML.
- لا تعديل على waqf_assets.
