# BASELINE CHANGELOG — Nosok V27A_LEGACY_REFERENCE_COMPANY_PORTAL

**التاريخ:** 2026-05-19  
**نوع الدفعة:** تنفيذ دفعة واحدة فوق Mega Batch Nosok UI A–E لاستيعاب مرجع بوابة نسك الحالية.  
**الحكم:** `staging-stable / legacy-nosok-reference-intake-applied / company-partner-workspace-added / public-contact-support-added / production-not-approved / no-waqf-assets-mutation`.

## نطاق التنفيذ

- استيعاب الصفحة الرئيسية القديمة كمرجع محتوى ومنطق: التسجيل، الحج، العمرة، الشركات المؤهلة، دخول الشركات، الشكاوى، اتصل بنا.
- تحديث الصفحة العامة `/services/nosok` لإظهار مسارات الشركات، بوابة الشركات، الشكاوى، التواصل، وفحص التسجيل ضمن رحلة خدمة حديثة.
- إعادة بناء صفحة الحج `/services/nosok/hajj` وفق شروط موسم 1447هـ/2026م كمحتوى إرشادي قابل للربط بجدول موسم.
- تحديث صفحة المتطلبات `/services/nosok/requirements` لتشمل قواعد الموسم والمتطلبات العامة دون كشف داخلي.
- إضافة صفحة اتصال عامة `/services/nosok/contact`.
- إضافة صفحة بوابة شركات/شريك `/services/nosok/company-login` كـ Partner Workspace visual contract، مع حالة تكامل pending واضحة.
- إضافة aliases توافقية `/systems/nosok/contact` و`/systems/nosok/company-login`.

## ما لم يتم

- لم يتم تنفيذ SQL إنتاجي.
- لم يتم تنفيذ DML.
- لم يتم لمس `waqf_assets` أو schema `waqf` أو `awqaf_system`.
- لم يتم إعلان الإنتاج.
- لم يتم تشغيل Flutter/Dart داخل الحاوية لأن الأدوات غير متاحة هنا.

## الملفات المعدلة

- `lib/features/nosok_system/system_routes.dart`
- `lib/features/nosok_system/system_navigation.dart`
- `lib/features/nosok_system/presentation/routes/nosok_routes.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_public_home_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_hajj_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_requirements_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_contact_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_company_portal_page.dart`
