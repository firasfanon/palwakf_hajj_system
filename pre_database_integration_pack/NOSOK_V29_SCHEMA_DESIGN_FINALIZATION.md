# Nosok v29 — Schema Design Finalization Before PalWakf Merge

## Decision
The `nosok` database schema is **not created yet by design**. It will be created after Nosok is merged into the full PalWakf platform repository and after Platform Registry/RBAC contracts are accepted.

## Schema Families

| Family | Purpose | Creation state |
|---|---|---|
| `nosok.seasons` | حج/عمرة seasons, windows, lifecycle gates | design-finalized-not-created |
| `nosok.applications` | Root public service request and tracking contract | design-finalized-not-created |
| `nosok.applicants` | Applicant identity and official-card LGU mapping | design-finalized-not-created |
| `nosok.companions` | Companions/mahram and total_people_count | design-finalized-not-created |
| `nosok.documents` | Required and supplemental attachments | design-finalized-not-created |
| `nosok.companies` | Qualified companies and partner workspace | design-finalized-not-created |
| `nosok.campaigns` | Campaigns, capacity, assignment and groups | design-finalized-not-created |
| `nosok.lottery_policies` | Ministry-editable seasonal lottery rules | design-finalized-not-created |
| `nosok.lgu_quota_snapshots` | LGU population/quota snapshot per season | design-finalized-not-created |
| `nosok.lottery_*` | draw runs, results, waiting list, committee, objections, audit | design-finalized-not-created |

## Core Rule
No public direct table exposure. All public operations must go through safe RPC wrappers that reveal one citizen/application scope only.
