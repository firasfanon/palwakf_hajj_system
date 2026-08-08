# Session Handoff — Nosok v38D-1

## نقطة الاستئناف

```text
Nosok v38D-1 — Analyzer Warning Cleanup
```

## آخر baseline

```text
nosok_v38d1_analyzer_warning_cleanup_2026_05_21.zip
```

## الحالة

```text
staging-stable /
v38d-dynamic-pages-builder-contract-preserved /
v38d1-unused-import-warning-cleanup-applied /
local-final-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## ما يجب تشغيله محليًا

```bash
dart format .
flutter analyze
flutter run -d chrome
```

## المسارات التي يجب فحصها

```text
/admin/systems/nosok/dynamic-pages
/admin/systems/nosok/v38d-dynamic-pages-prejoin
/admin/systems/nosok/homepage-sections
/admin/systems/nosok/unit-scope-access
/admin/systems/nosok/registration-governance
/services/nosok
/services/nosok/apply
/services/nosok/track
```

## حدود المرحلة

مسار نسك قبل الانضمام هو Development / Preparation Only. لا يتم الانضمام الفعلي إلى PalWakf ولا إنشاء schema ولا تشغيل SQL داخل هذا المسار.
