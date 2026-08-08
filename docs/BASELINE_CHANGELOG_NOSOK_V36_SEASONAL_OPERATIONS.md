# BASELINE CHANGELOG — Nosok v36 Seasonal Operations Enhancements

**Date:** 2026-05-20  
**Source baseline:** `nosok_v31_v35_consolidated_development_closure_2026_05_20.zip`  
**Batch type:** Large seasonal operations enhancement pack.  
**SQL mode:** Draft/readiness only. No schema creation, no production SQL, no DML.  

## Scope

Nosok v36 adds a unified seasonal operations readiness surface covering:

1. Advanced reports.
2. Payment bridge with `billing_system`.
3. `document_intelligence` bridge.
4. Public/internal assistant bridge.
5. Campaign and company operations enhancements.
6. PWF-SIS UX improvements and anti-overload rules.
7. Ministry policy addons for seasonal rules, exceptions, publication, and committee decisions.

## Flutter changes

- Added `NosokV36SeasonalOperationsContract` domain model.
- Added `nosokV36SeasonalOperationsContractProvider`.
- Added admin page `/admin/systems/nosok/v36-seasonal-operations`.
- Registered route in `NosokRoutes`.
- Added route constant in `NosokSystemRoutes`.
- Added sidebar/navigation item in `NosokSystemNavigation`.

## Governance decisions

- Payment, document intelligence, and assistant integrations remain disabled/candidate until PalWakf merge and schema creation.
- Seasonal ministry policies remain configurable and versioned; no hardcoded seasonal policy rules.
- Export/reporting of sensitive data requires policy approval and audit.
- No `waqf_assets`, `waqf`, or `awqaf_system` change.

## Resulting status

```text
staging-stable /
nosok-v36-seasonal-operations-enhancement-pack-applied /
advanced-reports-contract-ready /
payment-document-assistant-bridges-ready-disabled /
campaign-company-ux-policy-enhancements-ready /
database-schema-not-created-by-design /
production-not-approved /
no-waqf-assets-mutation
```
