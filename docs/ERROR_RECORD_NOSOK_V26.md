# ERROR RECORD — Nosok v26

## Error
Analyzer warning:
`The declaration '_V25EvidenceSectionPanel' isn't referenced` in `nosok_admin_v25_production_candidate_decision_page.dart`.

## Cause
A helper panel class remained in the v25 production decision page after the page was simplified to summary-only rendering.

## Fix
Removed the unused helper class and its dependent unused model import.

## Status
Fixed in v26. Local retest required.

## Stable previous baseline
Nosok v25 with Chrome startup passed but one analyzer warning.
