# Nosok v16 — Error Record

## Previous blocker carried in
- v15.2 addressed runtime Material ancestor issue on public home.

## v16 risk controls
- New public widgets avoid `Chip` in public shell surfaces.
- Admin pages may use Material components because they are under Scaffold/Material admin shell.
- New routes use additive constants and existing AccessGate pattern.

## Local retest required
- `dart format .`
- `flutter analyze`
- `flutter run -d chrome`
