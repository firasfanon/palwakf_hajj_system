# Nosok System Integration Patch v10 — Under PalWakf

نسك هنا نظام شبه مستقل **تحت منصة PalWakf**، وليس منصة منفصلة.

## ماذا تحتوي v10؟
- تشغيل معاينة مستقل عبر `pubspec.yaml` و`lib/main.dart`.
- كود النظام داخل `lib/features/nosok_system`.
- SQL تأسيسي وتشغيلي داخل `sql/`.
- ربط AccessProfile كعقد حقن من المنصة.
- تصفية سايدبار نسك حسب الصلاحيات.
- ربط صفحات الوحدات بعقد `unit_service_scopes`.

## تشغيل المعاينة
```bash
flutter pub get
flutter run -d chrome
```

مع Supabase:
```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

## الدمج الحقيقي داخل PalWakf
- انسخ `lib/features/nosok_system` إلى ريبو المنصة.
- سجّل routes من `NosokRoutes.publicRoutes` و`NosokRoutes.adminRoutes` ضمن route groups المناسبة.
- اربط `nosokAccessProfileProvider` من AccessProfile الحقيقي للمنصة.
- شغّل SQL حسب ترتيب handoff.
- لا تنشئ مستخدمين داخل `nosok`.

## ملاحظة حاكمة
`main.dart` و`pubspec.yaml` في هذه الحزمة مخصصان للمعاينة والتطوير. في الإنتاج، PalWakf main/app/router هو host الحقيقي.

## Nosok v12 update

This package now includes the v12 operational runtime expansion:

- Billing bridge execute/sync contracts under `billing_system` governance.
- Unit-scoped application queues under `/admin/systems/nosok/unit-queues`.
- Role UAT evidence intake from browser evidence.
- SQL contract: `sql/11_nosok_billing_unit_queues_role_uat_execution.sql`.

Nosok remains a semi-independent system under PalWakf. Standalone preview exists only for local development.

---

## Nosok v38A — Development / Preparation Only

This baseline restores the correct Nosok track after the v39 reversal. Nosok continues as a development/preparation package. Actual hosting inside PalWakf must be executed from the PalWakf platform baseline, not from this standalone package.

Current decision:

```text
nosok-v38a-development-preparation-only-applied /
palwakf-join-deferred-to-platform-track /
schema-creation-deferred-until-platform-hosting /
production-not-approved /
no-waqf-assets-mutation
```

Read first:

```text
docs/SESSION_HANDOFF_NOSOK_V38A_DEVELOPMENT_PREPARATION_ONLY.md
development_preparation_pack/NOSOK_V38A_DEVELOPMENT_PREPARATION_SCOPE_LOCK.md
```


---

## Nosok v38B — Pre-Join Final Development Closure

تمت إضافة حزمة v38B كإغلاق تحضيري قبل الانضمام إلى PalWakf. هذه الدفعة لا تنفذ الانضمام ولا تنشئ schema ولا تطبق SQL. نطاقها تجهيز نسك فقط: واجهات الجمهور، مساحة الشركة، مركز الأدلة، تصميم schema/RPC/RLS، وحزمة الانضمام للمنصة.

المسار الجديد:

```text
/admin/systems/nosok/v38b-prejoin-closure
```

## Nosok v38C — Admin Tools Pre-Join Scope

تمت إضافة أدوات إدارية تحضيرية لأن نسك نظام شبه مستقل:

- `/admin/systems/nosok/homepage-sections`
- `/admin/systems/nosok/unit-scope-access`
- `/admin/systems/nosok/registration-governance`
- `/admin/systems/nosok/v38c-admin-tools-prejoin`

لا تنفذ هذه الدفعة أي SQL أو إنشاء schema. هي عقود وتجهيزات فقط قبل استضافة PalWakf.

## Nosok v38D — Dynamic Pages + Sections Builder

تمت إضافة حزمة تحضيرية تسمح مستقبلًا بإضافة صفحات عامة وأقسام من لوحة الإدارة دون الرجوع للمطور، لكن التنفيذ الحقيقي مؤجل إلى ما بعد انضمام نسك إلى PalWakf وإنشاء schema/RPC/RLS.

المسارات الجديدة:
- `/admin/systems/nosok/dynamic-pages`
- `/admin/systems/nosok/v38d-dynamic-pages-prejoin`

لا SQL apply، لا schema creation، لا backend binding، ولا تعديل على `waqf_assets`.


## Nosok v38D-1 — Analyzer Warning Cleanup

تم حذف استيرادين غير مستخدمين في صفحات أدوات الإدارة التحضيرية. لا يوجد SQL ولا schema creation ولا backend binding.

## Nosok v38E — Legal Lottery Alignment

This baseline includes a pre-join legal compliance update for Palestinian Hajj Regulation No. 15 of 2025. It adds public/admin legal pages and updates the lottery contract from capacity-aware only to legal-algorithm-aware. No schema, SQL apply, backend binding, or PalWakf join execution is included.

## Nosok v38E-1 — Legal Alignment UAT Intake

v38E local retest evidence was added. Analyzer is clean, Chrome startup passed, and legal alignment / regulation admin pages opened in browser screenshots. This is evidence intake only: no source code change, no SQL apply, no schema creation, no backend binding, no production approval, and no waqf_assets mutation.
