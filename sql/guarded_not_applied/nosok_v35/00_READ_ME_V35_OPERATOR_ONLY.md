# Nosok v35 — Public Wrapper/RPC Controlled Staging Apply

**طبيعة المهمة:** تطوير محكوم لأسطح public views/RPC الخاصة بنسك على staging فقط.

## ترتيب التشغيل

1. شغّل `33_nosok_v35_public_wrapper_rpc_apply_result_read_only.sql` قبل التطبيق إن أردت تأكيد الوضع.
2. شغّل `01_public_wrapper_rpc_surface_AUTHORIZED_STAGING_ONLY.sql` فقط على staging وبعد backup/restore point.
3. شغّل `02_post_apply_wrapper_rpc_evidence_READ_ONLY.sql` بعد نجاح التطبيق مباشرة.
4. لا تشغّل rollback إلا بقرار صريح.

## الممنوع

- لا production approval.
- لا CREATE TABLE public.*.
- لا تعديل على waqf أو awqaf_system.
- لا ربط Repository قبل post-apply evidence + Browser/Network/Role evidence.
