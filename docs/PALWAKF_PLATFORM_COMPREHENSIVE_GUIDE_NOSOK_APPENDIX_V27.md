# PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE_NOSOK_APPENDIX_V27

## Nosok database ownership rule

Nosok may own operational data only inside `nosok.*` after explicit staging SQL authorization. Public remains views/RPC compatibility only. Core remains sovereign reference owner. Billing remains payment owner. Platform Access remains RBAC/auth owner.

## Current gate

```text
SQL_EXECUTION_BLOCKED_OWNER_REVIEW_AND_EXPLICIT_AUTHORIZATION_REQUIRED
```
