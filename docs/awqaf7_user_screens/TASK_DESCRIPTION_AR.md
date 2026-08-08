# وصف المهمة بالعربية

## Awqaf System 7 — Waqf Assets User Screens Read-Only Workspace

هذه دفعة **تطوير واجهات مستخدم read-only** داخل مسار الأصول الوقفية. الهدف منها ليس فتح الكتابة أو المراجعة أو الاعتماد، بل توفير شاشة مبسطة للمستخدم التشغيلي تسمح له بالبحث عن أصل وقفي، قراءة ملخصه، مشاهدة سجلات المصدر، وفهم حالة الصلاحية الحالية عبر Platform Access Gateway.

## ما تنفذه الدفعة

- إضافة مسار مركزي جديد:
  `/systems/awqaf-system/waqf-assets/user-screens`
- إضافة مسار وحداتي:
  `/{unitSlug}/systems/awqaf-system/waqf-assets/user-screens`
- إضافة صفحة Flutter جديدة:
  `PwfWaqfAssetsUserScreensPage`
- ربط الصفحة عبر GoRouter وAwqafSystemRegistry.
- اعتماد نفس read-only runtime surfaces المستخدمة في Operational Read Console.
- عرض actor/access strip، نتائج بحث المستخدم، سجلات المصدر، وحدود الكتابة.

## ما لا تنفذه الدفعة

- لا SQL apply.
- لا DDL/DML/GRANT/REVOKE.
- لا إنشاء جداول داخل public.
- لا service_role داخل Flutter.
- لا create draft.
- لا review decision.
- لا add note.
- لا controlled apply.
- لا target write.
- لا mutation على `waqf.waqf_assets`.

## القرار

`AWQAF_SYSTEM_7_WAQF_ASSETS_USER_SCREENS_READ_ONLY_IMPLEMENTED_RETEST_REQUIRED`
