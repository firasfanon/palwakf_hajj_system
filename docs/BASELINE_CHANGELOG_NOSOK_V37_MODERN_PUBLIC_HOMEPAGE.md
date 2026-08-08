# BASELINE CHANGELOG — Nosok v37 Modern Public Homepage Redesign

**Date:** 2026-05-20  
**Baseline:** `nosok_v37_modern_public_homepage_redesign_2026_05_20.zip`  
**Type:** Frontend public UX redesign / no SQL / no backend mutation

## Summary

Nosok v37 rebuilds the public homepage as a modern citizen-facing service portal rather than an administrative/governance-heavy surface. The public homepage now emphasizes a service journey, seasonal landing information, primary citizen actions, tracking/support, and public trust messaging.

## Applied Changes

- Reworked `/services/nosok` public homepage.
- Replaced governance/reference-heavy blocks with modern citizen UX sections.
- Added modern hero with clear CTA actions:
  - تقديم طلب جديد
  - متابعة طلب
  - عرض الشروط والمتطلبات
- Added seasonal service landing block:
  - registration window
  - ID-card address/LGU source
  - LGU quota principle
  - lottery principle
- Added citizen action cards:
  - الحج
  - العمرة
  - تقديم طلب
  - متابعة طلب
  - نتائج القرعة
  - قائمة الانتظار
  - الاعتراضات
  - الشركات المؤهلة
- Added public trust/transparency block without exposing internal governance.
- Kept employee/admin entry compact and secondary.
- Preserved RBAC and route guard authority.

## Non-Changes

- No SQL apply.
- No schema creation.
- No Supabase backend binding.
- No `waqf_assets` mutation.
- No change to `waqf`, `awqaf_system`, or PalWakf sovereign schemas.
- No production approval.

## Previous Evidence Preserved

The previous v36.1 local retest evidence remains the latest attached evidence: `dart format .` passed, `flutter analyze` returned `No issues found!`, and `flutter run -d chrome` reached Chrome Debug Service.

## Required Local Retest

```bash
dart format .
flutter analyze
flutter run -d chrome
```

Then open:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
/admin/systems/nosok
```

## Final Status

```text
staging-stable /
nosok-v37-modern-public-homepage-applied /
citizen-journey-ux-applied /
seasonal-service-landing-applied /
governance-de-emphasized-on-public-home /
mobile-first-public-experience-applied /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```
