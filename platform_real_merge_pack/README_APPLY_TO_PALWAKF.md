# Nosok v21 — Real Platform Merge Pack

هذه الحزمة تُطبق داخل ريبو PalWakf الكامل فقط. لا تُستخدم داخل standalone preview.

## الترتيب
1. انسخ `lib/features/nosok_system` إلى ريبو المنصة.
2. أضف `NosokRoutes.publicRoutes` إلى public route group الفعلي.
3. أضف `NosokRoutes.adminRoutes` إلى admin/system route group الفعلي.
4. طبّق provider override من `nosok_access_profile_override.dart`.
5. شغّل SQL التسجيل: system registry ثم RBAC ثم system sections.
6. شغّل SQL UAT v21 ووثق النتيجة.

## قاعدة حاكمة
PalWakf هي المصدر السيادي للهوية والصلاحيات والوحدات. نسك لا ينشئ users أو RBAC مستقل.
