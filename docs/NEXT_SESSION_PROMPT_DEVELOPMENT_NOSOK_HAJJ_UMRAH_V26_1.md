# NEXT SESSION PROMPT — تطوير نسك للحج والعمرة

ابدأ من الحزمة:

```text
nosok_development_handoff_v26_1_2026_05_19.zip
```

أنت تعمل داخل منصة PalWakf السيادية متعددة الأنظمة، ونظام نسك للحج والعمرة هو نظام شبه مستقل تحت المنصة وليس فوقها أو خارجها. يجب الالتزام بـ PWF-SIS، وFlutter Web + Supabase + Riverpod + GoRouter، وعدم استخدام `legacy.dart` في الملفات الجديدة، وعدم لمس `waqf_assets` أو schema `waqf` أو `awqaf_system`.

## اقرأ أولًا

1. `docs/SESSION_HANDOFF_DEVELOPMENT_NOSOK_HAJJ_UMRAH_V26_1.md`
2. `docs/BASELINE_CHANGELOG_NOSOK_V26_1_SESSION_CLOSE.md`
3. `docs/UAT_MATRIX_NOSOK_V26_1_SESSION_CLOSE.md`
4. `docs/ERROR_RECORD_NOSOK_V26_1_SESSION_CLOSE.md`
5. `docs/ROUTES_SUMMARY_NOSOK_V26_1.md`

## حالة البداية

```text
staging-stable /
latest-source-baseline-v26 /
v26-local-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

## نفّذ أولًا

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح المسارات الأساسية:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/admin/systems/nosok
/admin/systems/nosok/requests
/admin/systems/nosok/review
/admin/systems/nosok/v26-evidence-result-intake
/admin/systems/nosok/v26-full-merge-apply-result
/admin/systems/nosok/v26-production-candidate-redecision
```

## الدفعة التالية المقترحة

```text
Nosok v27 — Full PalWakf Merge Execution Evidence + Supabase SQL UAT Intake + Conditional Production Candidate Decision
```

## موانع الإنتاج التي لا يجوز تجاوزها

- Full PalWakf repo merge لم يُثبت بعد.
- RBAC Provider Override الحقيقي لم يُغلق.
- Supabase SQL UAT لم يُرفق.
- Role UAT لم يُرفق.
- Responsive UAT لم يُرفق.
- Browser console review لم يُرفق.

## قواعد صارمة

- لا تعلن production-ready دون إغلاق P0.
- لا تنفذ SQL إنتاجي أو DML إلا بطلب صريح.
- لا تلمس `waqf_assets`.
- بعد كل Batch ناجح حدث changelog + handoff + error record + ZIP + SHA256.
