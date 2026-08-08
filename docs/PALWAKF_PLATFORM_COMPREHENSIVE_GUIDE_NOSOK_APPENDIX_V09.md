# ملحق تحديث الدليل الشامل للمنصة — نسك v09

## تحديث حاكم
يُعتمد نسك كنظام شبه مستقل تحت PalWakf، له بنية صفحات وسايدبار ووحدات ولوحة تحكم داخلية، مع بقاء المنصة مصدر الهوية والصلاحيات والـ shell العام.

## مسارات نسك المعتمدة
- عام: `/switch/nosok` ثم `/systems/nosok`.
- صفحة وحدة عامة: `/systems/nosok/units/:unitSlug`.
- إدارة: `/admin/systems/nosok`.
- إدارة وحدة: `/admin/systems/nosok/units/:unitId`.
- legacy فقط: `/admin/nosok` redirects.

## قواعد المستخدمين والأدوار
- لا جدول مستخدمين مستقل داخل `nosok`.
- `admin_users` وAccessProfile وplatform RBAC هي المرجع.
- أدوار نسك قوالب تشغيل للتسجيل داخل المنصة.
- superuser/platformAdmin يملكان سلطة عليا.

## قواعد الوحدات
- `core.org_units` هو المرجع الحاكم للوحدات.
- `nosok.unit_service_scopes` يضبط ظهور وخدمات نسك ضمن الوحدة فقط.
- لا تنشأ وحدة جديدة داخل نسك إلا كربط/سطح خدمة.

## قواعد السايدبار
- سايدبار نسك داخلي ضمن Body النظام، لا يستبدل سايدبار المنصة.
- visibility يجب أن يطابق route guard وRBAC.

## حالة الإنتاج
v09 ليست production-approved. هي staging-ready وتحتاج SQL/Browser/Role UAT.
