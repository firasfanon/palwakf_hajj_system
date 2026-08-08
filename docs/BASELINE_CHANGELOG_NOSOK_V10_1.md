# Nosok v10.1 — Compile/Web Preview Hotfix Changelog

التاريخ: 2026-05-17

## السبب
استيعاب سجل التشغيل المحلي الذي أظهر نجاح `flutter pub get` وفشل `flutter run -d chrome` بسبب:

- غياب تهيئة Web للمعاينة التشغيلية.
- استخدام `actions` داخل `NosokSectionCard` بينما الودجت لا يدعمها.
- استخدام `label` داخل `NosokStatCard` بينما الودجت يدعم `title` فقط.
- استدعاء `_companyField` داخل `_CompanyDialogState` دون تعريفه.

## التصحيحات

1. إضافة دعم Web preview عبر:
   - `web/index.html`
   - `web/manifest.json`
   - `.metadata`

2. تحديث `NosokSectionCard` لدعم `actions` بشكل آمن.

3. تحديث `NosokStatCard` لدعم `label` كاسم بديل لـ `title` حفاظًا على التوافق.

4. إضافة helper `_companyField` داخل `_CompanyDialogState`.

## الحدود

- لا تغيير SQL إنتاجي.
- لا تغيير في route architecture.
- لا تغيير في RBAC contract.
- لا waqf_assets mutation.

## الحكم

`hotfix-ready / compile-blockers-addressed / web-preview-files-added / local-retest-required / production-not-approved`.
