# Nosok v38H — Shape Discovery SQL Readiness

## الهدف

قبل إنشاء `nosok schema` داخل PalWakf Supabase يجب التحقق من شكل مصادر المنصة الحالية حتى لا نبني FK/RPC على أعمدة غير مؤكدة.

## مصادر يجب اكتشافها

- `public.admin_users`
- `auth.users`
- `platform.system_user_roles`
- `platform.system_user_permissions`
- `core.org_units`
- `public.org_units`
- GIS governorates/LGU objects
- storage buckets/policies

## القرار

أي إنشاء schema أو RPC production ينتظر:

1. تشغيل discovery read-only.
2. تثبيت أسماء الأعمدة والعلاقات.
3. تثبيت mapping بين `unitSlug` و`LGU` و`governorate`.
4. اعتماد RLS matrix.
5. اعتماد migration order.

## لا تنفيذ في v38H

ملف SQL المرفق للقراءة فقط ولا يحتوي DDL أو DML.
