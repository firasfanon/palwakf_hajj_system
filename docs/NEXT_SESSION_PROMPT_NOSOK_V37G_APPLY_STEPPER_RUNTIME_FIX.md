# NEXT SESSION PROMPT — Nosok v37G

ابدأ من:

```text
nosok_v37g_apply_stepper_runtime_layout_fix_2026_05_20.zip
```

## نفذ أولًا

```bash
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

```text
/services/nosok/apply
```

وتأكد من عدم ظهور:

```text
RenderFlex children have non-zero flex but incoming height constraints are unbounded
RenderBox was not laid out
Unexpected null value cascade
MouseTracker assertion cascade
```

إذا نجحت، انتقل إلى Browser click-through UAT للصفحات العامة. لا SQL ولا schema creation قبل دمج نسك داخل PalWakf.
