# Error Record — Nosok v19.2

## Error
`flutter analyze` عرض 593 issues بعد v19.1.

## Cause
الـ analyzer شمل مجلدات ليست جزءًا من تطبيق نسك standalone:

- `platform_merge_patch`
- `platform_finalization_proposals`

هذه الملفات مخصصة للدمج داخل PalWakf الكامل وتستورد كائنات غير موجودة داخل حزمة preview مثل `AppRoutes`, `AccessProfile`, `PlatformAdminShell`, `PublicShell` وغيرها.

## Evidence
سجل التشغيل المحلي أظهر أن `flutter run -d chrome` نجح رغم فشل analyze، ما يؤكد أن runtime blocker ليس داخل تطبيق نسك الأساسي، بل في نطاق الملفات التي لا يجب تحليلها داخل preview.

## Fix
- عزل مجلدات overlay/proposals من `analysis_options.yaml`.
- تنظيف warnings موضعية في feature نفسه.
- حذف مسار تحديث الحالة القديم لصالح State Machine.

## Stable Baseline
v19.2
