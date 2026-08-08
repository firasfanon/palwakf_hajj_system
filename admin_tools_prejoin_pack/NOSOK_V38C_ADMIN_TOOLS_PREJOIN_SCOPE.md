# Nosok v38C — Admin Tools Pre-Join Scope

## الحكم

هذه الدفعة داخل مسار نسك فقط، وغايتها تجهيز أدوات الإدارة المطلوبة قبل انضمام نسك إلى PalWakf، لا تنفيذ الانضمام ولا إنشاء قاعدة البيانات.

```text
staging-stable /
nosok-v38c-admin-tools-prejoin-scope-applied /
homepage-sections-admin-contract-ready /
unit-slug-lgu-access-contract-ready /
registration-governance-locks-contract-ready /
schema-draft-not-applied /
production-not-approved /
no-waqf-assets-mutation
```

## لماذا هذه الدفعة؟

بما أن نسك نظام شبه مستقل تحت PalWakf، فلا يكفي أن تكون له واجهات عامة فقط. يجب أن يكون لديه أدوات إدارية محكومة تمكن الوزارة لاحقًا من إدارة:

1. أقسام الصفحة الرئيسية وما يظهر للجمهور.
2. نطاق عمل الموظف حسب المديرية/الوحدة والتجمعات المرتبطة بعنوان المواطن.
3. قيود التسجيل بعد انتهاء الفترة القانونية.
4. الاستثناءات وقرارات لجنة الحج مع تدقيق.

## أدوات الإدارة المضافة

### 1. إدارة أقسام الصفحة الرئيسية

المسار التحضيري:

```text
/admin/systems/nosok/homepage-sections
```

الغرض: تجهيز جدول `nosok.homepage_sections` المستقبلي للتحكم في:

- Hero.
- حالة الموسم.
- الخدمات الرئيسية.
- الشركات المؤهلة.
- الشفافية والعدالة.
- المساعدة والدعم.
- الترتيب.
- النشر/الإخفاء.
- نطاق الوحدة أو الموسم عند الحاجة.

### 2. نطاق الموظفين حسب slug/LGU

المسار التحضيري:

```text
/admin/systems/nosok/unit-scope-access
```

الغرض: ضمان أن موظف مديرية مثل بيت لحم لا يرى عند التسجيل أو التعديل إلا السجلات المرتبطة بتجمعات بيت لحم، وفق:

- `unitSlug`.
- `core.org_units` لاحقًا.
- قاموس LGU المعتمد.
- AccessProfile/RBAC الحقيقي داخل PalWakf.

### 3. قيود التسجيل والنزاهة

المسار التحضيري:

```text
/admin/systems/nosok/registration-governance
```

الغرض: ضبط الحالات التالية:

- التسجيل مفتوح.
- التسجيل مغلق.
- نافذة استكمال النواقص.
- تجميد Pool القرعة.
- منع تعديل المواطن أو الموظف بعد الموعد القانوني إلا عبر استثناء موثق.

## الجداول المقترحة لاحقًا

لا يتم إنشاء هذه الجداول الآن، لكنها جاهزة كعقود:

```text
nosok.homepage_sections
nosok.public_content_items
nosok.unit_scope_policies
nosok.registration_governance_windows
nosok.admin_override_events
```

ملف SQL draft:

```text
sql/32_nosok_v38c_admin_tools_homepage_unit_scope_registration_contract.sql
```

الملف يحتوي `BEGIN` و`ROLLBACK` وهو غير إنتاجي.

## موانع التنفيذ

- لا PalWakf join execution.
- لا إنشاء schema.
- لا SQL apply.
- لا DML.
- لا backend binding.
- لا production approval.
- لا waqf_assets mutation.

