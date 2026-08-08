# Session Handoff — Nosok v15.1

## Current Baseline
Nosok v15.1 فوق v15.

## What changed
تمت معالجة compile blocker في السايدبار الإداري الناتج عن استخدام `_NosokSidebarGroups.fromItems(...)` و`_NosokSidebarGroupHeader(...)` دون تعريفهما.

## Architectural Position
- نسك نظام شبه مستقل تحت PalWakf.
- PalWakf تبقى المنصة الأم ومصدر الهوية والصلاحيات والوحدات.
- هذا الإصلاح لا يغير المسارات ولا صلاحيات النظام ولا SQL.

## Next Action
إعادة تشغيل الاختبارات المحلية:
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم فتح:
- `/admin/systems/nosok`
- `/admin/systems/nosok/sidebar`
- `/admin/systems/nosok/unit-queues`
- `/systems/nosok`

## Gate
Production remains not approved until analyzer/browser/sql/role UAT evidence is closed.
