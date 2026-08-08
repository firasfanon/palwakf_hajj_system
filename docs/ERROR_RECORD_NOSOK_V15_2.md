# ERROR RECORD — NOSOK V15.2

## Error
`No Material widget found. Chip widgets require a Material widget ancestor.`

## Surface
Public Nosok home page: `/systems/nosok`.

## Symptom
The public shell/top navigation rendered, then the content area showed Flutter's red runtime error panel.

## Root Cause
The public shell placed `Material` only around the top navigation. The routed child was rendered in `Expanded(child: child)` outside a Material ancestor. Public hero badges used `Chip`, which requires a `Material` ancestor.

## Files Involved
- `lib/features/nosok_system/presentation/widgets/nosok_public_system_shell.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_public_home_page.dart`
- `lib/features/nosok_system/presentation/pages/public/nosok_public_unit_page.dart`

## Failed Before
- `/systems/nosok` runtime render after v15.1.

## Fix
- Added `Material(type: MaterialType.transparency)` around the public routed child.
- Replaced public hero badges using `Chip` with Material-independent decorated pills.
- Replaced unit hero `Chip` badges with Material-independent decorated pills.

## Stable Baseline After Fix
Nosok v15.2 — pending local retest.

## Production Status
Not approved. This is a hotfix-ready staging package pending local analyzer/browser retest.
