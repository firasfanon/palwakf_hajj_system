# BASELINE CHANGELOG — Nosok v37B

**الدفعة:** Nosok v37B — External Premium Public UI Integration + Public Subpages Citizen UX Alignment  
**التاريخ:** 2026-05-20  
**نوع الدفعة:** واجهة عامة / تجربة مواطن / لا Backend / لا SQL / لا waqf_assets mutation.

## الحكم

```text
staging-stable /
nosok-v37b-external-premium-ui-integrated /
public-homepage-premium-design-applied /
public-subpages-citizen-ux-aligned /
governance-technical-language-removed-from-public-pages /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## مصدر التصميم

تم استيعاب حزمة التسليم الخارجية التي تضمنت مكونات الصفحة العامة: Header، Hero، SeasonalBanner، ServiceCardsGrid، CitizenJourney، TrustSection، CompaniesSection، HelpSection، Footer، مع ألوان وهوية وأيقونات ومسارات وسلوك موبايل. لم تُنقل المسارات العامة كما وردت حرفيًا إذا كانت تخالف مسارات نسك المعتمدة؛ تم تحويلها إلى مسارات المشروع الحالية تحت `/services/nosok`.

## ما تم تطبيقه

1. بناء مكونات PWF-SIS عامة جديدة:
   - `PwfSisPremiumPublicHero`
   - `PwfSisPremiumServiceCard`
   - `PwfSisTrustTransparencyBox`
2. إعادة بناء الصفحة الرئيسية `/services/nosok` وفق منطق:
   - Hero أقوى.
   - Seasonal Status Banner.
   - خدمات رئيسية بإبراز أعلى.
   - خدمات مساندة.
   - رحلة المواطن.
   - شفافية وعدالة.
   - الشركات والمساعدة.
   - مدخل الموظفين بشكل مضغوط وغير مسيطر.
3. محاذاة الصفحات الفرعية العامة مع لغة المواطن:
   - الحج.
   - العمرة.
   - الشروط والمتطلبات.
   - الشركات المؤهلة.
   - المساعدة والتواصل.
   - الشكاوى.
   - الأسئلة الشائعة.
   - رحلة المواطن.
4. تخفيف اللغة الإدارية/التقنية من الواجهة العامة.
5. إبقاء صفحات الموظف والإدارة كما هي داخل `/admin/systems/nosok`.

## ملاحظات حاكمة

- لم يتم إنشاء جداول.
- لم يتم تنفيذ SQL.
- لم يتم ربط Backend جديد.
- لم يتم تعديل waqf_assets.
- بقيت قاعدة إنشاء `nosok schema` بعد دمج نسك داخل PalWakf فقط.
