# Error Record — Nosok Repository Contamination Cleanup

Date: 2026-09-17
Project: HAJJ_SYSTEM / palwakf_hajj_system

## Error

Foreign `awqaf_system` and `waqf_assets` implementation fragments were committed into the Hajj/Nosok repository canonical baseline.

## Root cause

The canonical baseline commit bundled experimental Awqaf System 7 code, dedicated Awqaf documentation, and a sandbox SQL probe together with the Hajj/Nosok source tree. These files were not wired into the Hajj/Nosok root routing graph and referenced many dependencies that do not exist in this repository.

## Impact

Whole-repository `flutter analyze` produced 564 errors even though `nosok_system` itself was clean. The foreign fragments obscured the actual health of the Hajj/Nosok codebase.

## Corrective action

Removed the dedicated foreign code under `lib/features/awqaf_system` and `lib/features/waqf_assets`, the `docs/awqaf7_user_screens` package, and its dedicated SQL sandbox probe. Removed the Awqaf System 7 sections from the Hajj/Nosok comprehensive guide.

## Verification

- Deleted-path reference scan: PASS
- Whole-repository `flutter analyze --no-pub`: PASS / No issues found
- `flutter build web --debug --no-pub`: PASS
- `git diff --check`: PASS

## Lesson / preventive gate

`FOREIGN_FEATURE_CONTAMINATION_GATE`: before baseline/import packaging, reject foreign feature roots whose declared product identity does not belong to HAJJ_SYSTEM unless an explicit dependency contract requires source inclusion.

Database/schema census evidence that merely references `awqaf_system` or `waqf_assets` must not be treated as source contamination; those read-only evidence artifacts remain preserved.

Regression test: repository-wide analyzer must remain clean after foreign-source cleanup, in addition to scoped Nosok analysis.
