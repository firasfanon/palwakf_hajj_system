# ERROR RECORD — Nosok v37F

## Issue 1 — Analyzer warnings after v37E

**Observed:** Local `flutter analyze` reported 5 warnings.  
**Root cause:** v37E introduced or retained unused style constants and an unused private helper widget after public header/form refactoring.  
**Files:**

- `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`
- `lib/features/nosok_system/presentation/widgets/pwf_sis_nosok_components.dart`

**Fix:** Removed unused palette fields and removed `_HeroVisualRow`.

## Issue 2 — DevTools/AppInspector context warning

**Observed:** Chrome startup succeeded, but DevTools/AppInspector logged transient `Cannot find context with specified id`.  
**Assessment:** Not a compile blocker. It should be monitored during final browser UAT.  
**Fix in this batch:** No code fix; documented as console UAT observation.

## Stable baseline before fix

`nosok_v37e_public_header_form_visual_fix_2026_05_20.zip`

## New baseline after fix

`nosok_v37f_final_analyzer_warning_cleanup_2026_05_20.zip`
