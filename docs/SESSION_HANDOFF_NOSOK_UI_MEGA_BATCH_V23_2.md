# SESSION HANDOFF — Nosok UI Mega Batch v23.2

## نقطة البداية للجلسة القادمة
ابدأ من الحزمة:
`nosok_platform_integration_patch_v23_2_requirements_compile_hotfix_under_platform.zip`

## الهدف المنجز
تصحيح compile blocker في صفحة `/services/nosok/requirements` بعد إضافة ذكر تطبيق مناسكنا.

## الحالة الفنية
- تم الحفاظ على الفصل بين واجهة الجمهور وواجهة الموظف.
- تم الحفاظ على PWF-SIS local compatibility layer.
- لم تُنفذ أي SQL إنتاجي.
- لم يتم لمس `waqf`, `waqf_assets`, `awqaf_system`.

## الملفات المعدلة في v23.2
- `lib/features/nosok_system/presentation/pages/public/nosok_requirements_page.dart`
- `docs/BASELINE_CHANGELOG_NOSOK_UI_MEGA_BATCH_V23_2.md`
- `docs/ERROR_RECORD_NOSOK_UI_MEGA_BATCH_V23_2.md`
- `docs/SESSION_HANDOFF_NOSOK_UI_MEGA_BATCH_V23_2.md`
- `docs/NEXT_SESSION_PROMPT_NOSOK_UI_MEGA_BATCH_V23_2.md`
- `docs/UAT_MATRIX_NOSOK_UI_MEGA_BATCH_V23_2.md`
- `CHANGED_FILES_NOSOK_UI_MEGA_BATCH_V23_2.txt`

## المطلوب فورًا
تشغيل الفحص المحلي:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## مسارات Browser UAT ذات الأولوية
- `/services/nosok`
- `/services/nosok/requirements`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/admin/systems/nosok`
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`

## ملاحظة معمارية
ذكر تطبيق مناسكنا يجب أن يبقى إرشاديًا/مخططًا ما لم يتم توفير backend أو route رسمي داخل PalWakf. لا تستخدم روابط أو أزرار تدّعي تشغيل التكامل قبل اعتماده.
