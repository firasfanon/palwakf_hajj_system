# BASELINE CHANGELOG — Nosok v37F

**Date:** 2026-05-20  
**Batch:** Nosok v37F — Final Analyzer Warning Cleanup + Public UI Console UAT Intake + Homepage/Subpages Visual Closure  
**Type:** UI cleanup / evidence intake / baseline closure. No backend, no SQL, no DML.

## Input Evidence

The received local log confirms:

- `dart format .` completed.
- `flutter analyze` reached only 5 warnings: 4 unused palette fields in `nosok_public_system_shell.dart`, and one unused private widget `_HeroVisualRow` in `pwf_sis_nosok_components.dart`.
- `flutter run -d chrome` launched successfully and reached Chrome Debug Service.
- DevTools/AppInspector produced a transient context warning, treated as console-monitoring evidence rather than a Flutter compile blocker.

## Changes

- Removed unused public shell palette fields:
  - `_NosokPublicUiPalette.blue`
  - `_NosokPublicUiPalette.softBlue`
  - `_NosokPublicUiPalette.goldSoft`
  - `_NosokPublicUiPalette.textMuted`
- Removed unused private widget:
  - `_HeroVisualRow`
- Added evidence copy:
  - `evidence/NOSOK_V37F_LOCAL_ANALYZE_CHROME_UAT_LOG_2026_05_20.txt`
- Added v37F documentation set.
- Updated the comprehensive Nosok guide with v37F closure note.

## Sovereign Boundaries

- No SQL apply.
- No schema creation.
- No Supabase runtime binding.
- No payment/document/assistant backend activation.
- No `waqf_assets`, `waqf`, or `awqaf_system` mutation.

## Status

```text
staging-stable /
nosok-v37f-final-analyzer-warning-cleanup-applied /
public-ui-console-uat-intaken /
chrome-startup-passed-confirmed /
public-homepage-subpages-visual-closure-candidate /
local-final-analyzer-retest-required /
production-not-approved /
no-waqf-assets-mutation
```
