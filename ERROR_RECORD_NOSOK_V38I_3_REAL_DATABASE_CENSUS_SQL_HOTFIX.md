# ERROR RECORD — Nosok v38I-3

## Issue

The file `sql/38A_nosok_real_database_environment_census_read_only.sql` was referenced as the correct next read-only database census step, but it was not included in the baseline.

## Cause

The earlier v38I/v38I-2 delivery included `sql/38_nosok_v38i_core_reference_shape_discovery_read_only.sql`, but not the wider `38A` real database environment census script.

## Fix

Added:

```text
sql/38A_nosok_real_database_environment_census_read_only.sql
```

## Stable Baseline After Fix

```text
nosok-v38i3-real-database-census-sql-hotfix-applied
```

## Remaining Gate

Do not run schema creation pack until 38A results are reviewed.
