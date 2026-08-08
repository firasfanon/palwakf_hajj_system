# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok Appendix v27C-1

## Update

Nosok v27C-1 applies a compile/import hotfix for the LGU quota waiting list page introduced in the v27C lottery governance batch.

## Rule confirmed

Lottery governance remains:

```text
registration open for eligible public
+ LGU based quota from ID-card address
+ capacity-aware draw
+ no automatic cross-LGU quota transfer
+ committee decision required for underfilled quota
```

## Technical note

`NosokLguQuotaStatus` and its Arabic label extension are defined in:

```text
lib/features/nosok_system/domain/models/nosok_lottery_policy.dart
```

Any UI page that directly references the enum or `labelAr` must import this model file.

## Boundary

No production SQL, no DML, no waqf-assets mutation, no awqaf-system mutation.
