# NEXT SESSION PROMPT — تطوير نسك للحج والعمرة بعد Nosok UI A–E

ابدأ من baseline:

```text
nosok_ui_a_to_e_mega_batch_2026_05_19.zip
```

اقرأ أولًا:

1. `docs/SESSION_HANDOFF_NOSOK_UI_A_TO_E.md`
2. `docs/BASELINE_CHANGELOG_NOSOK_UI_A_TO_E.md`
3. `docs/UAT_MATRIX_NOSOK_UI_A_TO_E.md`
4. `docs/ERROR_RECORD_NOSOK_UI_A_TO_E.md`
5. `docs/ROUTES_SUMMARY_NOSOK_UI_A_TO_E.md`
6. `CHANGED_FILES_NOSOK_UI_A_TO_E.txt`

## الحالة الحالية

```text
staging-stable /
nosok-public-internal-ui-separated /
pwf-sis-compliance-hardened /
responsive-anti-overload-ui-applied /
role-based-ui-separation-preserved /
local-flutter-retest-required /
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

## افتح المسارات الأساسية

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/faq
/admin/systems/nosok
/admin/systems/nosok/requests
/admin/systems/nosok/review
/admin/systems/nosok/campaigns
/admin/systems/nosok/groups
/admin/systems/nosok/documents
/admin/systems/nosok/messages
/admin/systems/nosok/reports
/admin/systems/nosok/settings
```

## الدفعة التالية المقترحة

```text
Nosok UI A–E Retest + v27 Evidence Intake — Analyzer/Chrome + Browser/Role/Responsive UAT Result Intake + Conditional Production Candidate Re-decision
```

## قواعد صارمة

- لا تعلن production-ready.
- لا تنفذ SQL إنتاجي أو DML دون تصريح صريح.
- لا تلمس `waqf_assets` أو schema `waqf` أو `awqaf_system`.
- لا تستخدم `legacy.dart` في الملفات الجديدة.
- أي خطأ analyzer يعالج موضعيًا قبل أي تطوير جديد.
