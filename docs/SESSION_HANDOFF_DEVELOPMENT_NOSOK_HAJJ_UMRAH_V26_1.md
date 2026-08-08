# SESSION HANDOFF شامل جدًا — تطوير نسك للحج والعمرة

**التاريخ:** 2026-05-19  
**آخر baseline مصدر:** `nosok_platform_integration_patch_v26_evidence_result_redecision_under_platform.zip`  
**SHA256 للـ baseline المصدر:** `5b32b1bf45b86ad7cac70285b6a59d31e5663557de6ff87ec119b2d873f7d4d7`  
**حزمة التوريث الحالية:** `nosok_development_handoff_v26_1_2026_05_19.zip`  
**نوع الدفعة:** Session close / handoff / baseline consolidation فقط، بلا Flutter functional change وبلا SQL إنتاجي.  

---

## 1. الحكم التشغيلي الحالي

```text
staging-stable /
nosok-preview-host-built /
public-internal-ui-separated /
pwf-sis-ui-pack-applied /
latest-source-baseline-v26 /
v26-local-retest-required /
full-palwakf-merge-pending /
supabase-sql-uat-pending /
role-responsive-browser-evidence-pending /
production-not-approved /
no-waqf-assets-mutation
```

> ملاحظة حاكمة: `production-not-approved` مقصود؛ لأن نسك ما زال يعمل كـ preview/staging package ولم يتم بعد تطبيقه داخل ريبو PalWakf الكامل مع RBAC Provider Override وSQL UAT وRole/Responsive evidence.

---

## 2. تعريف النظام بعد هذه الجلسة

نظام **نسك للحج والعمرة** أصبح نظامًا شبه مستقل تحت منصة PalWakf، وليس منتجًا مستقلًا عنها. القواعد الحاكمة المعتمدة:

1. PalWakf هي المنصة الأم والسيادية.
2. نسك يملك البيانات وسير العمل فقط.
3. الهوية البصرية والمكونات الأساسية تخضع لـ **PWF-SIS — PalWakf Sovereign Interface System**.
4. لا يستخدم نسك `legacy.dart` في الملفات الجديدة، والاعتماد على `flutter_riverpod.dart`.
5. نسك لا ينشئ RBAC مستقلًا؛ بل ينتظر override من AccessProfile الحقيقي داخل PalWakf.
6. لا يوجد أي تعديل على `waqf_assets` أو schema `waqf` أو `awqaf_system`.
7. ملفات `platform_merge_patch`, `platform_real_merge_pack`, و`platform_finalization_proposals` هي مواد دمج داخل PalWakf الكامل، وليست جزءًا من standalone preview analyzer.

---

## 3. ملخص تطور الجلسة من v01 إلى v26

### v01–v08 — تأسيس نسك كحزمة تحت المنصة
- إنشاء `lib/features/nosok_system`.
- إنشاء SQL schema أولي `nosok` وجداول seasons/programs/companies/applications/documents/payments.
- بناء routes عامة وإدارية أولية.
- تفعيل `tracking_token` لاحقًا بعد نقاش الأمان.
- إضافة رفع ملفات فعلي عبر Supabase Storage وتصحيح storage setup.
- إضافة صفحة تفاصيل طلب إدارية وverification workflow للدفعات.

### v09–v13 — شبه استقلال وتشغيل داخلي
- إضافة Shell داخلي وسايدبار لنسك.
- إضافة صفحات الوحدات، الإعدادات، الصحة، المستخدمين/الأدوار، readiness.
- AccessProfile binding contract.
- Runtime Sidebar Filtering.
- Billing bridge وNotification bridge كتكاملات مع المنصة لا كمحركات مستقلة.
- Tracking privacy hardening.

### v14–v19 — تحسين UX ودورة حياة الطلب
- إعادة بناء الصفحة العامة لتكون واجهة خدمة حكومية لا صفحة معلومات إدارية.
- إعادة بناء Dashboard النظام.
- تطوير صفحات الوحدات والسايدبار والـ Workbench.
- إضافة Service Desk Search وSeason Gate Enforcement.
- إضافة Application Lifecycle State Machine.
- إضافة Citizen Follow-up Actions.
- إضافة Follow-up Inbox وNotification Provider UAT.
- عدة hotfixes مهمة: `Material/Scaffold`, `SnackBar`, Riverpod `update`, sidebar grouping, icon compatibility.

### v20–v22 — readiness وmerge packs
- Production UAT Closure.
- Application Operations Deepening.
- Platform Integration Readiness Pack.
- Real Platform Merge Pack.
- RBAC Provider Override Contract.
- SQL UAT Result Intake.
- Browser/Role Evidence Intake.
- Production Gate Decision بقي `production-not-approved`.

### v23 — Mega UI Batch
- فصل واجهة الجمهور عن واجهة الموظف.
- اعتماد public routes `/services/nosok...`.
- اعتماد internal routes `/admin/systems/nosok...`.
- إضافة PWF-SIS local components قابلة للترحيل إلى المنصة.
- إضافة ذكر تطبيق **مناسكنا** في شاشة الجمهور كقناة إرشادية/مساندة، دون Backend وهمي.
- إضافة Pages: requirements, internal requests/review/campaigns/groups/documents/messages.

### v24 — Browser/Role/Responsive/Supabase UAT Pack
- إضافة صفحات UAT evidence/readiness لـ v24.
- إضافة SQL read-only pack.
- إضافة production redecision page.
- بقي الإنتاج غير معتمد.

### v25 — Evidence + Merge Candidate
- إضافة Evidence Intake.
- إضافة Full PalWakf Merge Application Result.
- إضافة Production Candidate Decision.
- بقي production-not-approved.

### v26 — Evidence Result + Re-decision
- إغلاق تحذير analyzer المتبقي من v25 بحذف `_V25EvidenceSectionPanel` غير المستخدم.
- إضافة:
  - `/admin/systems/nosok/v26-evidence-result-intake`
  - `/admin/systems/nosok/v26-full-merge-apply-result`
  - `/admin/systems/nosok/v26-production-candidate-redecision`
- إضافة SQL read-only UAT: `sql/24_nosok_v26_read_only_evidence_result_redecision_uat.sql`
- الحكم: full merge/RBAC/SQL/Role/Responsive ما زالت pending.

---

## 4. آخر نتائج التشغيل المثبتة

آخر سجل قبل إغلاق الجلسة أظهر أن v25 كان يشغّل Chrome بنجاح لكن كان يحتوي تحذير analyzer واحد في `nosok_admin_v25_production_candidate_decision_page.dart` متعلق بـ `_V25EvidenceSectionPanel` غير المستخدم. تم تصحيح ذلك في v26.  

**مطلوب في بداية الجلسة الجديدة:** تشغيل أوامر retest فوق v26 للتأكد من clean state بعد التصحيح:

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

---

## 5. المسارات الحاكمة الحالية

### Public Service Portal

```text
/services/nosok
/services/nosok/hajj
/services/nosok/umrah
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/faq
```

### Compatibility / legacy redirects أو مسارات سابقة يجب عدم كسرها

```text
/systems/nosok
/systems/nosok/application-status
/systems/nosok/follow-up
/systems/nosok/service-guide
/systems/nosok/citizen-journey
```

### Internal Operations Console

```text
/admin/systems/nosok
/admin/systems/nosok/requests
/admin/systems/nosok/review
/admin/systems/nosok/campaigns
/admin/systems/nosok/groups
/admin/systems/nosok/documents
/admin/systems/nosok/messages
/admin/systems/nosok/reports
/admin/systems/nosok/settings
```

### صفحات تشغيل/حوكمة جاهزية مهمة

```text
/admin/systems/nosok/production-uat-closure
/admin/systems/nosok/application-operations
/admin/systems/nosok/platform-integration-readiness
/admin/systems/nosok/real-platform-merge
/admin/systems/nosok/rbac-provider-override
/admin/systems/nosok/sql-uat-intake
/admin/systems/nosok/v24-uat-evidence
/admin/systems/nosok/v24-responsive-uat
/admin/systems/nosok/v24-merge-readiness-closure
/admin/systems/nosok/v24-supabase-runtime-uat
/admin/systems/nosok/v24-production-redecision
/admin/systems/nosok/v25-evidence-intake
/admin/systems/nosok/v25-full-merge-application-result
/admin/systems/nosok/v25-production-candidate-decision
/admin/systems/nosok/v26-evidence-result-intake
/admin/systems/nosok/v26-full-merge-apply-result
/admin/systems/nosok/v26-production-candidate-redecision
```

---

## 6. الملفات المحورية التي يجب قراءتها أولًا في الجلسة الجديدة

1. `docs/SESSION_HANDOFF_DEVELOPMENT_NOSOK_HAJJ_UMRAH_V26_1.md` — هذا الملف.
2. `docs/NEXT_SESSION_PROMPT_DEVELOPMENT_NOSOK_HAJJ_UMRAH_V26_1.md`.
3. `docs/BASELINE_CHANGELOG_NOSOK_V26_1_SESSION_CLOSE.md`.
4. `docs/UAT_MATRIX_NOSOK_V26_1_SESSION_CLOSE.md`.
5. `docs/ERROR_RECORD_NOSOK_V26_1_SESSION_CLOSE.md`.
6. `docs/ROUTES_SUMMARY_NOSOK_V26_1.md`.
7. `docs/PALWAKF_PLATFORM_COMPREHENSIVE_GUIDE_NOSOK_APPENDIX_V26_1_SESSION_HANDOFF.md`.
8. `platform_real_merge_pack/README_APPLY_TO_PALWAKF.md` إن وجد.
9. `sql/24_nosok_v26_read_only_evidence_result_redecision_uat.sql`.
10. `lib/features/nosok_system/presentation/routes/nosok_routes.dart`.
11. `lib/features/nosok_system/system_routes.dart`.
12. `lib/features/nosok_system/system_permissions.dart`.
13. `lib/features/nosok_system/system_navigation.dart`.

---

## 7. المتبقي الحاكم — P0/P1/P2

### P0 — موانع الإنتاج

1. **تطبيق نسك داخل ريبو PalWakf الكامل** وليس preview host فقط.
2. **ربط `nosokAccessProfileProvider` بـ AccessProfile الحقيقي** داخل PalWakf.
3. **تشغيل SQL UAT داخل Supabase** وتوثيق النتائج.
4. **Role UAT فعلي** للأدوار:
   - زائر
   - مواطن/مستخدم عام
   - موظف نسك
   - مشرف نسك
   - مدير النظام
   - superuser
   - restricted user
5. **Responsive UAT** على desktop/laptop/tablet/mobile.
6. **Browser console review** مع إثبات عدم وجود runtime errors.
7. **اختبار الخصوصية العامة** لصفحة `/services/nosok/track`.
8. **تثبيت public/internal separation**: المواطن لا يرى واجهة الموظف، والموظف لا يرى أكثر من صلاحياته.

### P1 — قبل pilot محدود

1. ربط أولي فعلي مع `billing_system` أو إبقاء bridge disabled/contract-only.
2. ربط notification bridge مع خدمة إشعارات المنصة أو إبقاؤه pending صراحة.
3. مراجعة Supabase Storage policies للوثائق.
4. ربط `core.org_units` للوحدات بدل بيانات preview.
5. ربط media_center لإعلانات الحج والعمرة عند توفر backend.
6. إدخال seed staging للخدمات/المتطلبات/FAQ بعد موافقة صريحة.

### P2 — تحسينات لاحقة

1. تقارير موسمية متقدمة.
2. تصدير CSV/PDF للتقارير، إذا طُلب.
3. ربط document_intelligence لجودة الوثائق.
4. ربط tasks لإنشاء مهام متابعة.
5. ربط assistant لمساعد نسك العام والداخلي.
6. تحسينات accessibility وkeyboard navigation.
7. تحسينات density modes وdark mode UAT.

---

## 8. Error Record مختصر للجلسة السابقة

1. `Chip` بلا `Material` ancestor في الصفحة العامة — تم إصلاحه باستبدال badges وتغليف public shell.
2. `SnackBar` بلا `Scaffold` في public shell — تم إصلاحه بإضافة Scaffold.
3. `NosokSystemNavigation.adminItemForPath` غير معرف — تم إضافته.
4. تمرير `icon` إلى `PwfSisNotice` بينما المعامل غير مدعوم — تم حذفه.
5. import غير مستخدم في v24/v25 pages — تم تنظيفه.
6. `_V25EvidenceSectionPanel` غير مستخدم — تم حذفه في v26.
7. تحليل `platform_merge_patch` داخل preview سبب مئات الأخطاء سابقًا — تم عزل مجلدات الدمج عن analyzer.

---

## 9. تعليمات الجلسة الجديدة

اسم الجلسة الجديد:

```text
تطوير نسك للحج والعمرة
```

ابدأ دائمًا من هذه الحزمة، ولا ترجع إلى v23/v24/v25 إلا للمقارنة التاريخية.  
نقطة الاستئناف الموصى بها:

```text
Nosok v27 — Full PalWakf Merge Execution Evidence + Supabase SQL UAT Intake + Conditional Production Candidate Decision
```

أول عمل في الجلسة الجديدة:

1. فك ضغط baseline الحالي.
2. تشغيل retest على v26.
3. إن عاد analyzer clean وChrome startup passed، انتقل إلى v27.
4. إن ظهرت أخطاء، نفذ hotfix موضعي أولًا ولا تبدأ تطويرًا جديدًا قبل الاستقرار.
5. لا تعتمد الإنتاج إلا بعد إغلاق P0.

---

## 10. أمر تشغيل UAT في الجلسة الجديدة

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

ثم افتح:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/admin/systems/nosok
/admin/systems/nosok/requests
/admin/systems/nosok/review
/admin/systems/nosok/v26-evidence-result-intake
/admin/systems/nosok/v26-full-merge-apply-result
/admin/systems/nosok/v26-production-candidate-redecision
```

ثم شغّل SQL read-only:

```sql
\i sql/24_nosok_v26_read_only_evidence_result_redecision_uat.sql
```

---

## 11. قرار الإغلاق

تم إغلاق الجلسة الحالية بسبب ثقل المحادثة، مع حزمة توريث وbaseline محدث للتسليم.  
لا توجد موافقة إنتاج.  
لا يوجد SQL إنتاجي جديد.  
لا يوجد تعديل على `waqf_assets`.  
