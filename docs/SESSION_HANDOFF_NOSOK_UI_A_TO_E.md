# SESSION HANDOFF — Mega Batch Nosok UI A–E

**التاريخ:** 2026-05-19  
**الجلسة:** تطوير نسك للحج والعمرة  
**الدفعة:** Mega Batch Nosok UI — A to E  
**baseline السابق:** `nosok_development_handoff_v26_1_2026_05_19.zip`  
**نطاق التنفيذ:** Public Service Portal + Internal Operations Console + PWF-SIS Compliance + Responsive Anti-Overload UX + Role-Based UI Separation + PalWakf Integration Readiness.

## الحكم الحالي

```text
staging-stable /
nosok-public-internal-ui-separated /
pwf-sis-compliance-hardened /
responsive-anti-overload-ui-applied /
role-based-ui-separation-preserved /
raw-backend-error-exposure-reduced /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## ما تم تنفيذه في دفعة واحدة

### A — Public Service Portal
- إعادة بناء `nosok_faq_page.dart` بالكامل باستخدام PWF-SIS public shell وaccordion.
- إبقاء الصفحة العامة كرحلة خدمة لا Dashboard.
- تعقيم أخطاء `apply`, `track`, `citizen followup`, `companies` حتى لا تظهر تفاصيل backend خامة.

### B — Internal Operations Console
- إعادة بناء `nosok_admin_reports_page.dart` لتصبح صفحة تقارير PWF-SIS مع metrics وreport source badges وحدود تصدير آمنة.
- إعادة بناء `nosok_admin_settings_page.dart` كصفحة restricted/read-only preview داخل PWF-SIS.
- تطوير `nosok_internal_groups_page.dart` إلى سطح تشغيل يحتوي metrics وجدول responsive.
- تعقيم رسائل الأخطاء الداخلية في ملفات admin اليومية والتفصيلية.

### C — PWF-SIS Compliance
- زيادة الاعتماد على مكونات `pwf_sis_nosok_components.dart`.
- تحديث `NosokAsyncView` لمنع عرض `$error`.
- عدم hardcode ألوان خارج `Theme.of(context).colorScheme`.

### D — Responsive Anti-Overload UX
- FAQ accordion.
- تقارير ومجموعات عبر adaptive workspace.
- جداول PWF-SIS قابلة للتحول إلى بطاقات على mobile.
- عدم حشر الجداول الثقيلة في الصفحة الداخلية الرئيسية.

### E — Role-Based UI Separation
- لم يتم تعديل `NosokAccessGate` بما يكسر الحماية.
- public routes بقيت تحت `/services/nosok`.
- internal routes بقيت تحت `/admin/systems/nosok`.
- الإعدادات والتقارير بقيت ضمن internal console.

## الملفات الأهم المعدلة

راجع: `CHANGED_FILES_NOSOK_UI_A_TO_E.txt`.

## فحص ساكن تم هنا

- فحص نصي داخل `lib/features/nosok_system` للتأكد من عدم بقاء `$error` أو `error.toString()` في presentation.
- فحص عدم استخدام `legacy.dart` داخل `lib/features/nosok_system`.
- لم يتم تشغيل Flutter/Dart بسبب غياب CLI في الحاوية.

## المطلوب محليًا فورًا

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح المسارات:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/faq
/admin/systems/nosok
/admin/systems/nosok/requests
/admin/systems/nosok/review
/admin/systems/nosok/campaigns
/admin/systems/nosok/groups
/admin/systems/nosok/documents
/admin/systems/nosok/messages
/admin/systems/nosok/reports
/admin/systems/nosok/settings
```

## موانع الإنتاج الباقية

- Full PalWakf repo merge evidence غير مغلق.
- RBAC Provider Override الحقيقي غير مغلق.
- Supabase SQL UAT غير مرفق.
- Role UAT غير مرفق.
- Responsive UAT غير مرفق.
- Browser console review غير مرفق.
- Production approval ممنوع قبل إغلاق P0.

## نقطة البداية التالية

```text
Nosok UI A–E Retest + v27 Evidence Intake — Local Analyzer/Chrome + Browser/Role/Responsive UAT Result Intake
```
