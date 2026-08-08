# وصف مهمة Nosok v36 بالعربية

**العنوان:** Nosok v36 — Browser/Role/Scope Wrapper RPC UAT Evidence Intake + Repository Binding Controlled Adapter Pack + Production Gate Re-decision

## طبيعة المهمة

هذه المهمة **تطوير محكوم كبير** وليست حوكمة فقط.

تتضمن تطوير واجهات Flutter إدارية جديدة، وتجهيز Adapter تقني للربط مع public wrapper/RPCs، وإضافة SQL read-only للتحقق. لكنها لا تعتمد الإنتاج ولا تفعل `platformHosted` تلقائيًا.

## ما تنفذه

- صفحات إدارية جديدة لمسار v36.
- Controller/Models جديدة لحزمة v36.
- Adapter جديد: `NosokPublicWrapperRpcAdapter` لا يستخدم `service_role` ولا يقرأ `nosok.*` مباشرة.
- SQL read-only لفحص wrapper/RPC/security/grants/UAT matrix.
- إعادة قرار production gate بناءً على نتيجة v35.1.

## ما لا تنفذه

- لا تنشئ جداول جديدة.
- لا تنشئ public base tables.
- لا تشغل DDL/DML.
- لا تعتمد production.
- لا تربط provider العام `nosokRepositoryProvider` تلقائيًا.
- لا تلمس `waqf`, `waqf_assets`, `awqaf_system`.
