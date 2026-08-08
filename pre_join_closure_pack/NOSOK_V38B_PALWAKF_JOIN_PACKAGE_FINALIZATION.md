# Nosok v38B — PalWakf Join Package Finalization

## الغرض

هذه هي حزمة التسليم التي يأخذها مسار منصة PalWakf لاحقًا. لا ينفذها مشروع نسك بنفسه.

## محتويات الحزمة

1. Feature folder map: `lib/features/nosok_system/**`.
2. Public routes map تحت `/services/nosok`.
3. Admin routes map تحت `/admin/systems/nosok`.
4. Permission catalog.
5. Role catalog.
6. AccessProfile override requirements.
7. Dynamic System Registry entry draft.
8. System Sections draft.
9. Sidebar/Dashboard binding instructions.
10. PWF-SIS/theme requirements.
11. Health/Maintenance/Error Boundary requirements.
12. Role/Responsive UAT matrix.
13. Schema/RPC/RLS design pack.

## قاعدة التنفيذ

تنفيذ الانضمام يتم داخل PalWakf Platform track بعد فحص Preflight. لا يتم داخل مشروع نسك standalone.
