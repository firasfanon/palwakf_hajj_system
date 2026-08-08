# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok UI Appendix

## Rule added by this batch
Nosok must be treated as a semi-independent system under PalWakf with two separated UI surfaces:

1. Public Service Portal: citizen journey under `/services/nosok`.
2. Internal Operations Console: staff/admin workflow under `/admin/systems/nosok`.

## PWF-SIS compliance
- The platform owns visual identity, design tokens, shell, contrast, RTL, dark mode, responsive rules, and runtime states.
- Nosok owns data and workflow only.
- Nosok must not hardcode a separate brand identity or behave like an external product.
- Visual Identity Admin overrides must be honored through ThemeData/colorScheme and platform PWF-SIS components.

## Anti-overload UX
- Public home presents summary and journey, not administrative governance.
- Internal home presents operational command surface, not full tables.
- Heavy data is moved to dedicated requests/review/documents/messages/reports pages.
- Detail and audit areas are collapsible/detail-page oriented.

## Backend constraint
No production SQL/DML in this batch. Integrations not available are shown as planned/disabled visual contracts.
