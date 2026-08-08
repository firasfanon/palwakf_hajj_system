# NEXT SESSION PROMPT — Nosok v38B

ابدأ من:

```text
nosok_v38b_prejoin_final_development_closure_2026_05_21.zip
```

الحالة:

```text
staging-stable /
nosok-prejoin-development-closure-applied /
public-runtime-uat-closure-pack-ready /
company-workspace-prepared /
evidence-center-hardened /
schema-rpc-rls-design-finalized-not-applied /
palwakf-join-package-ready-for-platform-track /
role-responsive-uat-matrix-ready /
production-not-approved /
no-waqf-assets-mutation
```

## قواعد حاكمة

- لا تنفذ الانضمام إلى PalWakf داخل مسار نسك.
- لا تنشئ schema.
- لا تطبق SQL.
- لا تربط backend الحقيقي.
- لا تعتمد الإنتاج.
- لا تلمس `waqf_assets` أو schema `waqf` أو `awqaf_system`.

## أول فحص

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/lottery-results
/admin/systems/nosok/v38b-prejoin-closure
/admin/systems/nosok/evidence-center
```

## التالي المقترح داخل مسار نسك فقط

```text
Nosok v38C —
Browser/Responsive Evidence Result Intake
+ Final Pre-Join Handoff and Baseline Freeze
```
