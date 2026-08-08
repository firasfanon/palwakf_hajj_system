# Error Record — Nosok v38D-1

## النوع
Analyzer warning cleanup.

## الأعراض

```text
warning - Unused import: '../../../domain/models/nosok_prejoin_admin_tools_contract.dart'
```

ظهر التحذير في:

```text
nosok_admin_registration_governance_page.dart
nosok_admin_unit_scope_access_page.dart
```

## السبب

الصفحتان كانتا تستوردان ملف عقد domain لم تعد تستخدمان أنواعه مباشرة بعد نقل القراءة إلى controller / presentation objects.

## الحل

حذف الاستيراد غير المستخدم فقط.

## الحكم

تصحيح موضعي آمن، لا يغير سلوك الواجهات أو عقود الانضمام.
