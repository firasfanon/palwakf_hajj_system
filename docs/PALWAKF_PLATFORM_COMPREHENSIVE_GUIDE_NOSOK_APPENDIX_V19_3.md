# PalWakf Governing Guide Appendix — Nosok v19.3

## Runtime Shell Rule

Semi-independent systems that provide standalone preview routes must ensure their local shells include a valid Material/Scaffold surface for runtime feedback such as `SnackBar`, dialogs, and validation messages.

For Nosok:

- Admin shell already uses `Scaffold`.
- Public shell now also uses `Scaffold`.
- The platform integration remains under PalWakf; nested shell structure is acceptable as long as the platform shell remains the outer sovereign frame.

## Production Gate

Analyzer-clean evidence and Chrome startup are accepted as positive evidence, but production remains not approved until:

- public snackbar/runtime blocker retest passes,
- SQL UAT passes,
- Browser UAT passes across public and admin routes,
- Role UAT evidence is attached,
- platform overlay is tested inside the actual PalWakf repository.
