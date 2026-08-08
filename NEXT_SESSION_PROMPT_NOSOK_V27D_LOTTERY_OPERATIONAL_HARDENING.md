# NEXT SESSION PROMPT — Nosok v27D+

ابدأ من baseline:

```text
nosok_v27d_lottery_operational_hardening_2026_05_19.zip
```

نفذ أولًا:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم اختبر:

```text
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
/admin/systems/nosok/lottery
/admin/systems/nosok/lottery/eligibility
/admin/systems/nosok/lottery/draw
/admin/systems/nosok/lottery/waiting-list
/admin/systems/nosok/lottery/committee
/admin/systems/nosok/lottery/audit
```

الدفعة التالية المقترحة:

```text
Nosok v27E — Lottery SQL/RPC Contract Draft + Role UAT Evidence Intake + Browser Result Closure
```

لا تعتمد الإنتاج. لا تنفذ SQL إنتاجي دون تصريح صريح. لا تلمس waqf_assets.
