# SESSION HANDOFF — Nosok UI Mega Batch v23.1

## نقطة البداية التالية
ابدأ من:
`nosok_platform_integration_patch_v23_1_mega_ui_compile_manasikna_hotfix_under_platform.zip`

## حالة النظام
- Nosok شبه مستقل تحت PalWakf.
- واجهة الجمهور فصلت عن واجهة الموظف.
- PWF-SIS component pack موجود.
- تم إصلاح compile blocker الخاص بالسايدبار.
- تم إدراج ذكر تطبيق مناسكنا في واجهة الجمهور.

## المطلوب محليًا
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## مسارات UAT
Public:
- `/services/nosok`
- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/requirements`

Internal:
- `/admin/systems/nosok`
- `/admin/systems/nosok/requests`
- `/admin/systems/nosok/review`
- `/admin/systems/nosok/campaigns`
- `/admin/systems/nosok/documents`
- `/admin/systems/nosok/messages`
- `/admin/systems/nosok/reports`

## تنبيه
لا تعتمد production approval قبل Browser/Role/Responsive UAT وSQL read-only UAT.
