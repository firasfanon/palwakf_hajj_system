# ERROR RECORD — Nosok v26.1 Session Close

## Current baseline

`nosok_development_handoff_v26_1_2026_05_19.zip`

## Resolved issues during the completed session

| ID | Issue | Cause | Fix | Status |
|---|---|---|---|---|
| ER-01 | Public page Material runtime error | استخدام Chip خارج Material ancestor | تغليف shell واستبدال badges | resolved |
| ER-02 | SnackBar runtime error | public shell بلا Scaffold | إضافة Scaffold في public shell | resolved |
| ER-03 | `adminItemForPath` missing | استدعاء method غير معرف | إضافة method في `system_navigation.dart` | resolved |
| ER-04 | `PwfSisNotice.icon` unsupported | تمرير named parameter غير موجود | حذف `icon` من requirements page | resolved |
| ER-05 | platform merge folders caused analyzer failures | تحليل ملفات overlay تحتاج PalWakf full repo | عزل merge/proposal folders في analysis options | resolved |
| ER-06 | Unused imports in v24/v25 pages | بقايا imports بعد refactor | حذف imports | resolved |
| ER-07 | `_V25EvidenceSectionPanel` unused | بقايا component غير مستخدم | حذفه في v26 | resolved |

## Open risks / blockers

| ID | Risk | Severity | Required next action |
|---|---|---|---|
| OPEN-01 | v26 يحتاج retest محلي بعد حذف warning | Medium | تشغيل `flutter analyze` و`flutter run -d chrome` في بداية الجلسة الجديدة |
| OPEN-02 | لم يتم تطبيق النظام داخل PalWakf الكامل | High | تنفيذ full repo merge وتوثيق الأدلة |
| OPEN-03 | RBAC Provider Override الحقيقي غير مغلق | High | ربط `nosokAccessProfileProvider` بـ PalWakf AccessProfile |
| OPEN-04 | SQL UAT داخل Supabase غير مرفق | High | تشغيل read-only UAT ثم إرفاق النتائج |
| OPEN-05 | Role/Responsive UAT غير مرفق | High | جمع screenshots/logs حسب matrix |

## No mutation guarantees

- No `waqf_assets` mutation.
- No `waqf` schema mutation.
- No `awqaf_system` mutation.
- No production SQL/DML in this close package.
