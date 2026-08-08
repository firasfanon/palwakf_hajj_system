# BASELINE CHANGELOG — Nosok v37D

**العنوان:** Public Pages Full Visual Sweep + No Pink Palette Enforcement + Subpage Premium Alignment  
**التاريخ:** 2026-05-20  
**النوع:** واجهات عامة فقط / Flutter UI polish / لا SQL / لا Backend / لا waqf_assets mutation

## الحكم

```text
staging-stable /
nosok-v37d-public-pages-full-visual-sweep-applied /
no-pink-palette-enforced /
public-subpages-premium-alignment-applied /
legacy-public-scaffold-upgraded /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## سبب الدفعة

أظهر الفحص البصري أن الواجهة الرئيسية تحسّنت، لكن:

1. لا يجوز استخدام اللون الزهري أو مشتقاته في الواجهة العامة.
2. بعض الصفحات الفرعية لم تكن متناسقة كفاية مع النمط Premium الذي تم تطبيقه على الصفحة الرئيسية.
3. صفحات قديمة مثل التقديم/المتابعة/إجراءات المواطن كانت ما زالت تستخدم `NosokPageScaffold` و`NosokSectionCard` بنمط أبسط من الصفحة الرئيسية.

## التغييرات

- فرض Palette خالية من الزهري للواجهات العامة:
  - التحذير = ذهبي وقفي.
  - النجاح = أخضر هادئ غير صارخ.
  - الخطأ = أبيض/سطح محايد مع نص وحدّ أحمر ملكي `#B22222` فقط، دون خلفية وردية.
  - المعلومات = أزرق سيادي فاتح.
- إلغاء الاعتماد على `errorContainer` و`tertiaryContainer` في مكونات الجمهور لأنها قد تنتج درجات وردية حسب Theme seed.
- جعل `PwfSisServiceHero` يستخدم النمط Premium تلقائيًا حتى الصفحات التي لم تُحدّث يدويًا.
- ترقية `NosokPageScaffold` إلى Hero سيادي حديث متوافق مع الصفحة الرئيسية.
- ترقية `NosokSectionCard` إلى بطاقة عامة حديثة بتدرج أزرق فاتح وحدود موحدة.
- ترقية صفحة دليل الخدمات `nosok_service_guide_page.dart` لتستخدم `PwfSisPremiumPublicHero` بدل Hero قديم.

## الملفات المعدلة

```text
lib/features/nosok_system/presentation/widgets/pwf_sis_nosok_components.dart
lib/features/nosok_system/presentation/widgets/nosok_page_scaffold.dart
lib/features/nosok_system/presentation/widgets/nosok_section_card.dart
lib/features/nosok_system/presentation/pages/public/nosok_service_guide_page.dart
docs/BASELINE_CHANGELOG_NOSOK_V37D_PUBLIC_PAGES_FULL_VISUAL_SWEEP.md
docs/SESSION_HANDOFF_NOSOK_V37D_PUBLIC_PAGES_FULL_VISUAL_SWEEP.md
docs/UAT_MATRIX_NOSOK_V37D_PUBLIC_PAGES_FULL_VISUAL_SWEEP.md
docs/ERROR_RECORD_NOSOK_V37D_PUBLIC_PAGES_FULL_VISUAL_SWEEP.md
docs/ROUTES_SUMMARY_NOSOK_V37D_PUBLIC_PAGES_FULL_VISUAL_SWEEP.md
docs/NEXT_SESSION_PROMPT_NOSOK_V37D_PUBLIC_PAGES_FULL_VISUAL_SWEEP.md
CHANGED_FILES_NOSOK_V37D.txt
```

## موانع الإنتاج

- لم يتم الدمج داخل PalWakf بعد.
- لم يتم إنشاء `nosok schema` عمدًا.
- لم يتم تنفيذ SQL.
- مطلوب retest محلي بعد الدفعة.

