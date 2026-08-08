# BASELINE CHANGELOG — Mega Batch Nosok UI A–E

**التاريخ:** 2026-05-19  
**العنوان:** Mega Batch Nosok UI — Public Service Portal + Internal Operations Console + PWF-SIS Compliance + Responsive Anti-Overload UX + Role-Based UI Separation + PalWakf Integration Readiness  
**نوع الدفعة:** دفعة كبيرة واحدة تشمل المراحل A إلى E، بدون SQL إنتاجي، وبدون تعديل `waqf_assets`.

## الحكم

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

## التغييرات الرئيسية

1. **Public Service Portal — المرحلة A**
   - إعادة بناء صفحة FAQ العامة باستخدام `PwfSisPublicServiceShell` و`PwfSisServiceHero` و`PwfSisFAQAccordion`.
   - إبقاء المسارات العامة `/services/nosok`, `/apply`, `/track`, `/requirements`, `/faq` تحت واجهة خدمة عامة لا Dashboard.
   - تعقيم رسائل الخطأ العامة في التقديم والتتبع والشركات والمتابعة لمنع عرض تفاصيل backend خامة.

2. **Internal Operations Console — المرحلة B**
   - إعادة بناء صفحة التقارير الداخلية بمكونات PWF-SIS بدل البطاقات القديمة.
   - إعادة بناء صفحة الإعدادات كمجال restricted/read-only preview محكوم بالمنصة.
   - تطوير صفحة المجموعات من notice فقط إلى مساحة تشغيلية تحتوي مؤشرات وقائمة responsive.
   - تعقيم رسائل الخطأ في صفحات التشغيل اليومية، التفاصيل، البرامج، المواسم، الشركات، الشكاوى، workbench، service desk، notification surfaces.

3. **PWF-SIS Compliance — المرحلة C**
   - زيادة استخدام `PwfSisSystemHero`, `PwfSisPanel`, `PwfSisMetricCard`, `PwfSisDataTable`, `PwfSisNotice`, `PwfSisStatusBadge`.
   - الإبقاء على RTL، ThemeData، ColorScheme وعدم hardcode ألوان خارج نظام الثيم.
   - حماية `NosokAsyncView` من عرض `$error` للمستخدم.

4. **Responsive Anti-Overload UX — المرحلة D**
   - صفحات التقارير والمجموعات تستخدم `PwfSisAdaptiveWorkspace` و`PwfSisDataTable` التي تتحول إلى بطاقات على الشاشات الصغيرة.
   - FAQ يستخدم Accordion بدل قائمة طويلة.
   - الصفحة الداخلية الرئيسية تبقى summary-first ولا تحمل الجداول الثقيلة.

5. **Role-Based UI Separation — المرحلة E**
   - لم يتم كسر `NosokAccessGate` ولا route guards القائمة.
   - الواجهة العامة بقيت تحت `/services/nosok`.
   - الواجهة الداخلية بقيت تحت `/admin/systems/nosok` ومحكومة بالصلاحيات.
   - الإعدادات والتقارير بقيت internal/restricted.

## ما لم يتم تنفيذه عمدًا

- لا SQL إنتاجي.
- لا DML.
- لا تعديل على `waqf_assets` أو schema `waqf` أو `awqaf_system`.
- لا إعلان production-ready.
- لم يتم تشغيل `flutter analyze` أو `flutter run -d chrome` داخل هذه البيئة لعدم توفر Flutter/Dart CLI في الحاوية؛ مطلوب retest محلي.

## نقطة الاستئناف التالية

```text
Nosok UI A–E Retest + v27 Evidence Intake — Local Flutter Analyzer/Chrome + Browser/Role/Responsive UAT Result Intake
```
