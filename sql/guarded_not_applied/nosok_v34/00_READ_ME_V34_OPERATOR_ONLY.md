# Nosok v34 — Operator-only instructions

هذه الحزمة تجهز public views/RPC wrappers فقط.

## المسموح
- إنشاء views/functions داخل `public` كطبقة توافق واستدعاء.
- القراءة من `nosok.*` عبر wrappers محكومة.
- منح EXECUTE/SELECT محدود لـ `anon` و`authenticated` حيث يلزم للواجهات العامة.

## المحظور
- إنشاء أي `public.*` base tables.
- تعديل `waqf`, `waqf_assets`, `awqaf_system`, `core`, `platform_access`, `billing_system`.
- تشغيل production أو repository binding قبل post-apply UAT.

## ترتيب التشغيل
1. شغل `sql/32_nosok_v34_public_wrapper_rpc_authorization_read_only.sql`.
2. بعد تفويض operator وbackup/staging، أزل guard من `01_public_wrapper_rpc_surface_OPERATOR_ONLY_NOT_RUN.sql` وشغله على staging فقط.
3. شغل `02_post_apply_wrapper_rpc_negative_uat_READ_ONLY.sql`.
4. لا تشغل rollback إلا بقرار صريح.
