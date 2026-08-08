# NEXT SESSION PROMPT — Nosok v27C Closure / v27D

ابدأ من:

```text
nosok_v27c_lottery_governance_lgu_quota_2026_05_19.zip
```

نفذ أولًا:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

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

ثم شغل:

```sql
\i sql/25_nosok_v27c_lottery_governance_read_only_uat.sql
```

الدفعة التالية المقترحة:

```text
Nosok v27D — Lottery Backend Contract Draft + Supabase RLS/RPC Plan + Committee Workflow UAT Intake
```

لا تعتمد الإنتاج ولا تنفذ SQL DML إلا بتصريح صريح.
