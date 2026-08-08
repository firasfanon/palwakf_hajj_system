# ERROR RECORD — Nosok v36 Seasonal Operations

## ER-V36-001 — Avoid premature SQL apply requests

- **Cause:** Earlier v28A/v28B path expected SQL evidence before Nosok schema existed.
- **Current rule:** No actual SQL apply is required until Nosok is merged into PalWakf and a dedicated `nosok` schema is approved.
- **Affected batch:** v36 preserves all SQL/RPC/RLS as drafts/readiness contracts.
- **Stable baseline before v36:** `nosok_v31_v35_consolidated_development_closure_2026_05_20.zip`.
- **Resolution:** v36 page and docs explicitly mark integrations as disabled/candidate.

## ER-V36-002 — Integration overclaim prevention

- **Cause:** Payment, document intelligence, and assistant systems may not be available in the standalone Nosok preview.
- **Resolution:** v36 represents them as bridge contracts and policy-gated runtime candidates only.
- **Production impact:** Production remains not approved.

## ER-V36-003 — Sensitive report export risk

- **Cause:** Advanced reports may include sensitive citizen/payment/company data.
- **Resolution:** Export governance is marked disabled until ministry policy, audit, and RLS are approved.
