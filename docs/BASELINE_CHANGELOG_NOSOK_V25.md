# BASELINE CHANGELOG — Nosok v25

## Title
Nosok v25 — Evidence Intake + Full PalWakf Merge Application Result Intake + Production Candidate Decision

## Source Baseline
Nosok v24.2 — Analyzer/Chrome Evidence Intake

## User Evidence Intake
The latest user log proves:
- `flutter clean` passed.
- `flutter pub get` passed.
- `dart format .` passed.
- `flutter analyze` returned `No issues found!`.
- `flutter run -d chrome` started successfully and reached Debug Service.

## Changes
- Added v25 evidence intake model and controller.
- Added v25 admin surfaces:
  - `/admin/systems/nosok/v25-evidence-intake`
  - `/admin/systems/nosok/v25-full-merge-application-result`
  - `/admin/systems/nosok/v25-production-candidate-decision`
- Added new permissions:
  - `intakeNosokV25Evidence`
  - `intakeNosokFullMergeApplicationResult`
  - `decideNosokProductionCandidate`
- Added read-only SQL UAT pack: `sql/23_nosok_v25_read_only_evidence_candidate_uat.sql`.
- Added runtime evidence log under `evidence/runtime/nosok_v25/`.

## Production Decision
`production-not-approved`.

Reason: preview stability is accepted, but Full PalWakf Merge, real AccessProfile override, SQL UAT in Supabase, Browser/Role/Responsive evidence, and final production gate remain pending.

## Sovereign Boundary
No changes to:
- `waqf`
- `waqf_assets`
- `awqaf_system`

No SQL production DDL/DML was added.
