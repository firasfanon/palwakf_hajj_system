# ERROR RECORD — Nosok UI Mega Batch v23.1

## الخطأ
`The method 'adminItemForPath' isn't defined for the type 'NosokSystemNavigation'`

## السبب
أضيف استدعاء للعثور على عنصر السايدبار النشط داخل `NosokAdminSystemShell` دون إضافة method مماثلة في `NosokSystemNavigation`.

## الملفات
- `lib/features/nosok_system/presentation/widgets/nosok_admin_system_shell.dart`
- `lib/features/nosok_system/system_navigation.dart`

## الحل
إضافة method ثابتة:
`static NosokSystemNavItem? adminItemForPath(String location)`
مع تطبيع المسار وإرجاع أفضل تطابق route.

## آخر baseline مستقر
v19.3 analyzer-clean/chrome-startup-passed قبل دفعات UI، وv23 كتوسيع UI مع compile blocker موضعي.
