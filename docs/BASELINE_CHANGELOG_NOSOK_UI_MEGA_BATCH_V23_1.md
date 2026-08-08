# BASELINE CHANGELOG — Nosok UI Mega Batch v23.1

## الحالة
hotfix-ready / mega-ui-compile-blocker-fixed / manasikna-public-mention-added / analyzer-retest-required / production-not-approved / no-waqf-assets-mutation

## السبب
بعد Mega Batch UI v23 ظهر خطأ compile واحد في `nosok_admin_system_shell.dart` بسبب استدعاء `NosokSystemNavigation.adminItemForPath(location)` دون وجود method مقابلة في `system_navigation.dart`.

كما طُلب إضافة ذكر واضح لتطبيق **مناسكنا** في شاشة الجمهور.

## التغييرات
- إضافة `NosokSystemNavigation.adminItemForPath(String location)` مع matching آمن لأطول route.
- إضافة تطبيق مناسكنا إلى Hero badges في واجهة الجمهور.
- إضافة بطاقة خدمة عامة لتطبيق مناسكنا كقناة إرشادية مساندة disabled/planned.
- تحديث Help Card لذكر تطبيق مناسكنا.
- إضافة ملاحظة إرشادية في صفحة المتطلبات إن وجدت.

## حدود الدفعة
- لا SQL إنتاجي.
- لا DML.
- لا تعديل على `waqf_assets` أو `waqf` أو `awqaf_system`.
