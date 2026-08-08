# Error Record — Nosok v31

No new runtime error has been reported for v31 yet.

Known inherited context:
- v30.1 Flutter was analyzer clean and Chrome startup passed according to user-provided log.
- v30 read-only SQL showed `nosok_present=false` and apply still pending.

V31 expected retest:
- `dart format .`
- `flutter analyze`
- `flutter run -d chrome`
- Open V31 routes.
- Run v31 read-only SQL only.
