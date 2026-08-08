# PALWAKF PLATFORM COMPREHENSIVE GUIDE — NOSOK APPENDIX V15.2

## Governing Rule Reinforced
Semi-independent systems under PalWakf may have their own public body and internal navigation, but they must still inherit a valid platform visual/runtime shell. Public routed content must not assume Material ancestry unless the shell explicitly provides it.

## Nosok Public Shell Rule
`NosokPublicSystemShell` must wrap its routed child in a transparent `Material` layer:

- It preserves the public platform/system layout.
- It prevents runtime failures for Material-dependent widgets.
- It keeps Nosok under PalWakf rather than creating a standalone visual root.

## Public UX Component Rule
For hero-level badges and government UX markers, prefer lightweight decorated pill widgets over `Chip` when the component may appear in shell areas where Material ancestry could vary.

## Current Status
Nosok v15.2 resolves the public Material runtime blocker and remains staging-only pending local retest.

## Production Gate
Production remains blocked until:
- `flutter analyze` is clean.
- Browser UAT passes for public and admin surfaces.
- SQL UAT evidence is supplied where applicable.
- Role UAT and readiness evidence are closed.
