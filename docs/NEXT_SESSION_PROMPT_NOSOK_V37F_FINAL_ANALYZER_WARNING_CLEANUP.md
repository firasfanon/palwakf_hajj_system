# NEXT SESSION PROMPT — Nosok v37F

Start from:

```text
nosok_v37f_final_analyzer_warning_cleanup_2026_05_20.zip
```

Current state:

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

Run:

```bash
dart format .
flutter analyze
flutter run -d chrome
```

Then capture screenshots for:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/companies
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
```

Do not create SQL tables. Do not apply backend binding. Do not touch `waqf_assets`, `waqf`, or `awqaf_system`.
