# Next Prompt — Nosok v27.1 Retest Intake

Use the v27.1 baseline. First run:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

Then provide the full log. If clean, proceed to:

`Nosok v28 — Owner Schema Design + Guarded DDL Draft Pack`

Do not execute owner-schema DDL unless explicitly authorized. Keep `public` as views/RPC wrappers only. Reuse `core` reference objects and `billing_system` payment bridge. Do not touch `waqf`, `waqf_assets`, or `awqaf_system`.
