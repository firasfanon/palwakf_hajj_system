# BASELINE CHANGELOG — Nosok v26

## Title
Nosok v26 — SQL/Browser/Role/Responsive Evidence Result Intake + Full PalWakf Merge Apply Result + Production Candidate Re-decision

## Baseline
Built on Nosok v25.

## Evidence intake
- User log confirms `flutter clean`, `flutter pub get`, and `dart format .` ran.
- `flutter analyze` produced one warning only: `_V25EvidenceSectionPanel` unused in `nosok_admin_v25_production_candidate_decision_page.dart`.
- `flutter run -d chrome` reached Debug Service.

## Changes
- Removed unused `_V25EvidenceSectionPanel` helper and unused model import from v25 production candidate decision page.
- Added v26 evidence/result model and Riverpod controller.
- Added three v26 admin surfaces:
  - `/admin/systems/nosok/v26-evidence-result-intake`
  - `/admin/systems/nosok/v26-full-merge-apply-result`
  - `/admin/systems/nosok/v26-production-candidate-redecision`
- Added read-only SQL UAT pack.
- Added v26 evidence log copy and handoff docs.

## Decision
`production-not-approved` remains in force.

## Sovereign boundary
No waqf_assets mutation. No schema waqf mutation. No awqaf_system mutation. No production SQL/DML.
