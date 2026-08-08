# ERROR RECORD — Nosok v30

## ER-V30-001 — Unterminated Dart string in v29 merge readiness page

**الملف:**
`lib/features/nosok_system/presentation/pages/admin/nosok_admin_v29_merge_readiness_page.dart`

**السبب:**
تم إدخال نص متعدد الأسطر داخل single-quoted string مثل:

```dart
Text('${surface.surfaceAr}
الحالة: ...')
```

**الأثر:**
- `dart format` فشل جزئيًا.
- `flutter analyze` أظهر 45 issue.
- `flutter run -d chrome` فشل عند compile.

**الحل:**
استخدام `\n` داخل النص:

```dart
Text('${surface.surfaceAr}\nالحالة: ${surface.runtimeState}\nالربط: ${surface.bindingMode}')
```

**الحالة:**
Fixed in v30. يلزم retest محلي.

**آخر baseline مستقر قبل الخطأ:**
`nosok_v28b_sql_apply_evidence_binding_redecision_2026_05_20.zip` من حيث compile evidence، ثم v29 احتاج hotfix.
