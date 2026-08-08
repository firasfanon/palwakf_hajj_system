# Merge Instructions — Nosok v06 (v73 aligned)

## 1) what this package is
هذه الحزمة **نظام نسك نفسه** + **مقترحات دمج نهائي** + **تصحيح معماري وفق مرجع v73**.

## 2) what changed from v05
- إلغاء الاعتماد المعماري على `/nosok` كمدخل عام.
- اعتماد proposal للدخول عبر `/switch/nosok` ثم `/systems/nosok`.
- إرجاع `SystemKey` و`Permission` و`admin registry` إلى حالة pending/proposal بدل افتراضها منجزة داخل المنصة.
- إضافة `docs/platform_gaps` و`docs/platform_proposals`.

## 3) apply order
1. SQL schema + wrappers (`sql/`)
2. feature files under `lib/features/nosok_system`
3. route integration patches only after مراجعة المنصة لمسارات system shell
4. final platform registration proposals when PalWakf approves `SystemKey.nosok` and its permissions

## 4) important note
لا تطبق ملفات التسجيل النهائي للمنصة بلا مراجعة، لأن مرجع v73 صرّح أنها غير محسومة نهائيًا بعد.
