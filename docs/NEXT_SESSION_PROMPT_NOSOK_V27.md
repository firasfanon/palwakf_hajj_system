# NEXT_SESSION_PROMPT_NOSOK_V27

تابع مشروع PalWakf / Nosok من baseline v27.

الحالة الحالية:

```text
staging-stable / schema-census-accepted / owner-schema-diff-prepared / sql-execution-blocked-owner-review-required / public-base-table-creation-blocked / production-not-approved / no-waqf-assets-mutation
```

ابدأ بإعادة الاختبار:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

```text
/admin/systems/nosok/v27-schema-census-result
/admin/systems/nosok/v27-existing-object-reconciliation
/admin/systems/nosok/v27-owner-schema-diff-plan
/admin/systems/nosok/v27-safe-sql-execution-gate
```

وشغّل SQL read-only:

```sql
\i sql/25_nosok_v27_schema_census_owner_diff_safe_gate_read_only.sql
```

لا تنفذ `CREATE SCHEMA nosok` أو `CREATE TABLE nosok.*` قبل تفويض صريح.
