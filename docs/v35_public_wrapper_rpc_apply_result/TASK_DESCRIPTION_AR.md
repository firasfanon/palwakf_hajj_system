# وصف المهمة — Nosok v35

**اسم المهمة:** Nosok v35 — Public Wrapper/RPC Controlled Staging Apply Result Intake + Post-Apply Wrapper/RPC Evidence Closure + Repository Binding Preflight Decision

## طبيعة المهمة

هذه مهمة **تطوير محكوم** وليست حوكمة فقط. وهي أيضًا ليست تشغيلًا إنتاجيًا.

تضيف المهمة:

1. صفحات Flutter إدارية لنتيجة تطبيق public wrappers/RPCs.
2. بوابة أدلة post-apply.
3. قرار preflight لربط المستودعات.
4. SQL read-only للتحقق من وجود wrappers/RPCs وصلاحياتها.
5. SQL operator-ready لتطبيق views/RPCs على staging فقط.

## ما تنفذه

- تجهيز سطح `public` كـ views/RPC فقط.
- إبقاء البيانات التشغيلية داخل `nosok.*`.
- منع إنشاء أي `public` base tables.
- منع الإنتاج وربط المستودعات حتى تظهر أدلة post-apply وBrowser/Role evidence.

## ما لا تنفذه

- لا production approval.
- لا CREATE TABLE public.*.
- لا تعديل على `waqf`, `waqf_assets`, `awqaf_system`.
- لا اعتماد repository binding نهائي.
