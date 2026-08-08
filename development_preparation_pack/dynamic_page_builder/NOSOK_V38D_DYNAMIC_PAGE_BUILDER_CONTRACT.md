# Nosok v38D — Dynamic Pages + Sections Builder Contract

## الهدف
لأن نسك نظام شبه مستقل تحت PalWakf، يجب أن يمتلك قدرة مستقبلية على إضافة صفحات عامة وأقسام جديدة من لوحة الإدارة دون الرجوع للمطور لكل صفحة محتوى أو تغيير موسمي.

## القرار الحاكم
- الصفحات العامة الديناميكية مسموحة عبر قوالب معتمدة فقط.
- الصفحات الإدارية الجديدة ليست مجرد محتوى؛ تحتاج permission key وroute contract وRPC/RLS ونطاق وحدة.
- لا يتم إنشاء schema الآن.
- لا SQL apply ولا DML.
- التنفيذ الحقيقي مؤجل إلى ما بعد استضافة نسك داخل PalWakf.

## الكائنات المستقبلية
- `nosok.page_registry`
- `nosok.page_sections`
- `nosok.page_actions`
- `nosok.page_templates`
- `nosok.page_audit_events`

## المسارات التحضيرية
- `/admin/systems/nosok/dynamic-pages`
- `/admin/systems/nosok/v38d-dynamic-pages-prejoin`

## قواعد الأمان
1. منع arbitrary HTML/script.
2. منع slug يتعارض مع المسارات الثابتة.
3. public RPC يعرض المنشور فقط.
4. admin dynamic pages تحتاج RBAC/RPC/RLS.
5. النشر/الإخفاء/الأرشفة يحتاج audit.
6. لا تظهر صفحات إدارية جديدة لموظف دون صلاحية ونطاق.

## حالة التنفيذ
`contract-ready / schema-not-created / production-not-approved`.
