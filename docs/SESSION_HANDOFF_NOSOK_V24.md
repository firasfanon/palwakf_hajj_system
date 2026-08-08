# SESSION_HANDOFF — Nosok v24

## الحالة الحالية
`staging-stable / browser-role-responsive-uat-pack-added / palwakf-merge-readiness-closure-added / supabase-runtime-read-only-uat-pack-added / production-not-approved / no-waqf-assets-mutation`

## آخر أساس مستقر
v23.2 — Requirements compile hotfix + Manasikna mention preservation، مع تأكيد المستخدم أن كل الصفحات تعمل وأن `flutter analyze` أعاد No issues found وChrome startup نجح.

## ما أُضيف في v24
1. Browser/Role UAT Evidence surface.
2. Responsive Anti-Overload UAT surface.
3. PalWakf Merge Readiness Closure surface.
4. Supabase Runtime UAT Pack surface.
5. Production Gate Re-decision surface.
6. SQL read-only UAT pack.
7. تحديث routes/navigation/permissions.

## قرارات حاكمة
- نسك لا يعتمد الإنتاج تلقائيًا.
- الإنتاج مشروط بتطبيق الدمج داخل ريبو PalWakf الكامل.
- `nosokAccessProfileProvider` يجب override من AccessProfile الحقيقي.
- SQL v24 read-only فقط.
- لا تعديل على `waqf_assets` أو schema `waqf` أو `awqaf_system`.

## نقطة الاستئناف التالية
Nosok v25 — SQL/Browser/Role/Responsive Evidence Intake + Full PalWakf Merge Application Result Intake + Production Candidate Decision.

## أوامر الاختبار
```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## مسارات v24 الجديدة
- `/admin/systems/nosok/v24-uat-evidence`
- `/admin/systems/nosok/v24-responsive-uat`
- `/admin/systems/nosok/v24-merge-readiness-closure`
- `/admin/systems/nosok/v24-supabase-runtime-uat`
- `/admin/systems/nosok/v24-production-redecision`
