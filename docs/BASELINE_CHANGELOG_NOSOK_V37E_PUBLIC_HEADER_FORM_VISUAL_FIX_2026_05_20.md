# BASELINE CHANGELOG — Nosok v37E

**Date:** 2026-05-20  
**Batch:** Nosok v37E — Public Header + Apply Form Visual Consistency Fix  
**Type:** UI/UX corrective sweep; no backend, no SQL, no DML.

## Summary

This batch responds to visual UAT screenshots showing two remaining public UX issues:

1. Public header navigation still rendered as Material `ChoiceChip`, which may inherit undesired theme tones and can visually drift away from the Nosok sovereign blue/gold identity.
2. The public application form still used a vertical `Stepper` on desktop, leaving an administrative-looking vertical connector near the step title and form fields.

## Changes

- Replaced public navigation chips with explicit sovereign custom pills:
  - selected: deep sovereign blue `#0A3B5A` with white text.
  - unselected: white surface, light blue-grey border, dark text.
  - no pink/rose/purple-derived Material chip surfaces.
- Hardened header CTAs:
  - `تقديم طلب` uses explicit deep blue background.
  - `متابعة` uses explicit deep blue text.
  - `دخول الموظفين` remains visible but secondary with neutral border.
- Updated public brand icon colors:
  - deep blue icon container.
  - white icon.
  - gold subtitle.
- Updated `/services/nosok/apply` stepper behavior:
  - desktop/tablet wide layout uses horizontal stepper.
  - mobile remains vertical for single-column usability.

## Sovereign Boundaries

- No SQL apply.
- No nosok schema creation.
- No backend binding change.
- No waqf_assets mutation.
- No awqaf_system mutation.

## Status

```text
staging-stable /
nosok-v37e-public-header-form-visual-fix-applied /
no-pink-public-navigation-enforced /
apply-form-desktop-stepper-deadministrated /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```
