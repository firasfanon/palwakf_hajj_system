# NEXT SESSION PROMPT — Nosok v30

Start from:

```text
nosok_v29_palwakf_merge_readiness_pre_database_pack_2026_05_20.zip
```

## Current state

```text
staging-stable /
nosok-v29-palwakf-merge-readiness-applied /
database-schema-not-created-by-design /
sql-apply-not-required-until-platform-merge /
production-not-approved /
no-waqf-assets-mutation
```

## Governing rule

Do not request or run SQL apply before Nosok is merged into the full PalWakf platform. The `nosok` schema is created after merge.

## Next batch

```text
Nosok v30 — Full PalWakf Merge Pack Application
+ Platform Registry Entry
+ AccessProfile Override Closure
+ Browser/Role Responsive UAT Inside PalWakf
+ Nosok Schema Creation Preparation
```

## First local checks

```bash
dart format .
flutter analyze
flutter run -d chrome
```

Open:

```text
/admin/systems/nosok/v29-merge-readiness
/services/nosok
/admin/systems/nosok
```

## Do not

- Do not apply SQL production.
- Do not create schema before merge.
- Do not touch `waqf_assets`, schema `waqf`, or `awqaf_system`.
