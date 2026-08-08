# Nosok Integration Notes — v08

- النظام يبقى **شبه منفصل تحت PalWakf**.
- الدخول العام عبر `/systems/nosok` وليس `/nosok` لتفادي تعارض `/:unitSlug`.
- الإدارة الحاكمة تحت `/admin/systems/nosok`، و`/admin/nosok` legacy redirect فقط.
- الرفع الفعلي للملفات يعتمد الآن على Supabase Storage bucket:
  - `nosok-public`
- راجع:
  - `sql/07_nosok_storage_setup.sql`
  - `docs/platform_gaps/nosok_pubspec_additions_pending.md`
