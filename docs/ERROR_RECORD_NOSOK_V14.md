# ERROR RECORD — Nosok v14

## Issue 1 — Public homepage looked administrative
- **Cause:** Earlier homepage exposed platform/system-governance copy too prominently and lacked modern citizen-service structure.
- **Files:** `nosok_public_home_page.dart`
- **Fix:** Rebuilt as a government service UX with hero, primary actions, service journey, dynamic content and trust blocks.
- **Status:** Addressed; browser UAT pending.

## Issue 2 — Dashboard not operational enough
- **Cause:** Earlier dashboard was mostly stat cards plus architecture note.
- **Files:** `nosok_admin_dashboard_page.dart`
- **Fix:** Rebuilt as operational command dashboard with attention indicators, workbench, gates, timeline and governance chips.
- **Status:** Addressed; analyzer/browser retest pending.

## Issue 3 — Local formatter/analyzer unavailable in this environment
- **Cause:** `dart` command is not installed in this execution environment.
- **Failed command:** `dart format ...`
- **Fix/Workaround:** Static balance checks were performed; local Flutter toolchain retest is mandatory.
- **Status:** Open until user runs local commands.

## Last stable baseline before this patch
`nosok_platform_integration_patch_v13_billing_provider_privacy_readiness_under_platform.zip`

## New baseline candidate
`nosok_platform_integration_patch_v14_public_ux_operational_dashboard_under_platform.zip`
