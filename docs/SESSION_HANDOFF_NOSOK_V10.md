# SESSION HANDOFF — Nosok v10

## نقطة البداية التالية
ابدأ من:
`nosok_platform_integration_patch_v10_access_runtime_operational_under_platform.zip`

## الحالة
- نسك نظام شبه مستقل تحت PalWakf.
- يحتوي على host تشغيل preview: `pubspec.yaml` + `lib/main.dart`.
- يحتوي على Supabase repository للإنتاج وInMemory repository للمعاينة.
- تم تجهيز AccessProfile provider binding.
- تم تفعيل تصفية سايدبار نسك runtime حسب الصلاحيات.
- تم إغلاق Unit Scope RPC contract.

## أوامر التشغيل للمعاينة
```bash
flutter pub get
flutter run -d chrome
```

للتشغيل مع Supabase:
```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

## SQL المطلوب
شغّل بالترتيب:
1. `00_nosok_schema.sql`
2. `01_nosok_seed_content.sql`
3. `04_nosok_public_rpc_wrappers.sql`
4. `05_nosok_admin_rpc_wrappers.sql`
5. `06_nosok_operational_upgrade.sql`
6. `07_nosok_storage_setup.sql`
7. `08_nosok_semi_independent_runtime.sql`
8. `09_nosok_access_profile_sidebar_unit_scope_closure.sql`

## UAT التالي
- Flutter analyze على المشروع الكامل.
- Browser UAT لـ `/systems/nosok`.
- Browser UAT لـ `/admin/systems/nosok`.
- Role UAT: superuser، nosokAdmin، reviewer، payments officer، viewer، no permission.
- Unit UAT: `/systems/nosok/units/home` و`/admin/systems/nosok/units`.

## بوابات الإنتاج
غير معتمد للإنتاج حتى:
- ربط provider مع AccessProfile الحقيقي في PalWakf.
- تشغيل SQL UAT.
- ربط core.org_units فعليًا.
- إغلاق storage policies.
- إغلاق payment/billing integration.
