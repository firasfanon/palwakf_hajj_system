# SESSION HANDOFF — Nosok v37B External Premium Public UI Integration

## نقطة البداية

آخر baseline قبل هذه الدفعة:

```text
nosok_v37a_premium_public_homepage_visual_upgrade_2026_05_20.zip
```

## سبب الدفعة

تم تزويد المشروع بحزمة تصميم خارجية للصفحة العامة، لكنها لم تغطِّ كل الصفحات الفرعية المطلوبة. لذلك تم تطبيق التصميم كمصدر بصري/تجريبي على الصفحة الرئيسية، ثم توسيع نمطه إلى الصفحات الفرعية العامة الموجودة ضمن نسك دون انتظار تصميم خارجي لكل صفحة.

## القرار التصميمي

```text
الصفحة العامة وصفحات المواطن = تجربة خدمة حديثة
الصفحات الإدارية = لوحة تشغيل وحوكمة داخلية
```

## الصفحات المتأثرة

```text
/services/nosok
/services/nosok/hajj
/services/nosok/umrah
/services/nosok/requirements
/services/nosok/companies
/services/nosok/contact
/services/nosok/complaints
/services/nosok/faq
/services/nosok/citizen-journey
/services/nosok/track
/services/nosok/follow-up
```

## الملفات الأساسية المعدلة

```text
lib/features/nosok_system/presentation/widgets/pwf_sis_nosok_components.dart
lib/features/nosok_system/presentation/pages/public/nosok_public_home_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_hajj_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_umrah_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_requirements_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_companies_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_contact_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_complaints_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_faq_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_citizen_journey_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_apply_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_application_status_page.dart
lib/features/nosok_system/presentation/pages/public/nosok_citizen_followup_page.dart
```

## مطلوب محليًا

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم فتح المسارات العامة الأساسية وفحص Desktop/Mobile.

## الحالة النهائية

```text
staging-stable /
nosok-v37b-external-premium-ui-integrated /
public-subpages-citizen-ux-aligned /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```
