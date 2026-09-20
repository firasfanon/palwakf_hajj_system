# Nosok v39 — Hebron Awqaf Organizational Identity Reconciliation

Date: 2026-09-20

## Purpose

Reconcile the four active Hebron-governorate Awqaf units in `core.org_units` against current/public organizational labels before any Unit→LGU policy load.

## Canonical Core identities

- `8e0238db-2e20-49d4-8cf2-db7c376d512b` — `hebron` — Directorate of Awqaf Hebron.
- `7270d37a-6eca-4fd4-8abe-0164022f9a80` — `dura` — Directorate of Awqaf Dura.
- `7e391f77-ded8-4ea8-b0eb-d518507ff194` — `yatta` — Directorate of Awqaf Yatta.
- `04f19f65-5e0c-47df-b897-9dd88152ea6c` — `halhul` — Directorate of Awqaf Halhul.

UUIDs remain the authority keys. Labels/slugs are not authorization keys.
## Public/current identity evidence

### Hebron

Current 2026 public material continues to use the Hebron Awqaf administration label.

Classification: `CURRENT_IDENTITY_SUPPORTED`.

### Yatta

Recent institutional material continues to use “Directorate of Awqaf Yatta”, including 2024 cooperation activity and a current municipal development document describing the directorate's role in Hajj and religious services.

Classification: `CURRENT_IDENTITY_SUPPORTED`.

### Halhul / North Hebron

Public evidence shows “Directorate of Awqaf North Hebron” based in Halhul. Older municipal evidence also uses “Directorate of Awqaf Halhul”.

Classification: `LIKELY_ORGANIZATIONAL_RENAME_OR_SCOPE_LABEL`.
No UUID mutation is authorized.
### Dura / South Hebron

Institutional/public evidence uses “Directorate of Awqaf South Hebron” in Dura. Older material also refers to the same organization as Directorate of Awqaf Dura.

Classification: `LIKELY_ORGANIZATIONAL_RENAME_OR_SCOPE_LABEL`.
No UUID mutation is authorized.

## Jurisdiction evidence

North Hebron was publicly described as serving 14 local authorities.

South Hebron public activity includes Dura and provides direct evidence of activity in al-Dhahiriya and as-Samu.

These facts are supporting scope evidence, not yet a complete Unit→LGU crosswalk.

## Decision

```text
HEBRON_ORG_UNIT_UUIDS = PRESERVE
HEBRON_UNIT_LABEL_DRIFT = CONFIRMED_FOR_REVIEW
HALHUL_TO_NORTH_HEBRON = HIGH_CONFIDENCE_IDENTITY_LINEAGE_CANDIDATE
DURA_TO_SOUTH_HEBRON = HIGH_CONFIDENCE_IDENTITY_LINEAGE_CANDIDATE
YATTA = CURRENT_IDENTITY_SUPPORTED
HEBRON = CURRENT_IDENTITY_SUPPORTED
UNIT_TO_LGU_FULL_CROSSWALK = NOT_COMPLETE
DATABASE_MUTATION = NO
```
