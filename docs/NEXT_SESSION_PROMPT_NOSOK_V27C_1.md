# NEXT SESSION PROMPT — Nosok v27C-1

ابدأ من baseline:

```text
nosok_v27c1_lottery_compile_fix_2026_05_19.zip
```

## أول عمل

```bash
flutter analyze
flutter run -d chrome
```

## الهدف

التحقق من إغلاق compile blocker الخاص بـ:

```text
NosokLguQuotaStatus / labelAr
```

في:

```text
lib/features/nosok_system/presentation/pages/public/nosok_waiting_list_page.dart
```

## إذا نجح retest

استكمل بدفعة كبيرة لاحقة، وليس باتشات صغيرة، لتطوير محرك القرعة من مستوى الواجهة/العقد إلى مستوى SQL/RPC UAT أو Browser Role UAT حسب توجيه المستخدم.

## قواعد حاكمة

- لا تعلن production-ready.
- لا تنفذ SQL إنتاجي دون تصريح.
- لا تلمس `waqf_assets` أو `waqf` أو `awqaf_system`.
