# Nosok v29 — RLS/RPC/Negative UAT Preflight

## Required negative tests after staging apply

| Case | Actor | Expected |
|---|---|---|
| NEG_ANON_ADMIN | anonymous | Cannot read admin tables/RPCs |
| NEG_PUBLIC_ENUM_DOCS | anonymous/applicant | Cannot enumerate documents |
| NEG_WRONG_UNIT_QUEUE | unit reviewer | Cannot see other unit/LGU queue |
| NEG_REVIEWER_RULE_WRITE | reviewer | Cannot change eligibility/quota rules |
| NEG_PUBLIC_TABLE_SCAN | SQL reviewer | No public.nosok_* base tables |
| NEG_WAQF_BOUNDARY | SQL reviewer | No mutation in waqf/awqaf_system |

## Production gate

Production remains blocked until the negative UAT evidence is attached and accepted.
