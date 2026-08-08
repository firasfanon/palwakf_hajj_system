# NEXT SESSION PROMPT — Nosok v37E

Start from:

```text
nosok_v37e_public_header_form_visual_fix_2026_05_20.zip
```

The current focus is public UI polish only. Do not create SQL tables. Do not apply backend binding. Do not touch `waqf_assets`, `waqf`, or `awqaf_system`.

Run:

```bash
dart format .
flutter analyze
flutter run -d chrome
```

Then visually inspect public routes, especially `/services/nosok` and `/services/nosok/apply`.
