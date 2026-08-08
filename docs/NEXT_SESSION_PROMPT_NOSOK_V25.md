# NEXT SESSION PROMPT — Nosok v26

ابدأ من baseline:
`nosok_platform_integration_patch_v25_evidence_merge_candidate_under_platform.zip`

المطلوب:
Nosok v26 — SQL/Browser/Role/Responsive Evidence Result Intake + Full PalWakf Merge Apply Result + Production Candidate Re-decision

المدخلات المطلوبة من المستخدم:
1. نتيجة تشغيل:
   - `flutter clean`
   - `flutter pub get`
   - `dart format .`
   - `flutter analyze`
   - `flutter run -d chrome`
2. لقطات Browser UAT لمسارات الجمهور والموظف.
3. Role UAT للأدوار السبعة.
4. Responsive UAT لسطح desktop/laptop/tablet/mobile.
5. نتيجة SQL UAT:
   - `sql/23_nosok_v25_read_only_evidence_candidate_uat.sql`
6. نتيجة تطبيق `platform_real_merge_pack` داخل ريبو PalWakf الكامل.

الحكم المطلوب:
- production-candidate فقط إذا أغلقت P0 كلها.
- otherwise production-not-approved with blockers.
