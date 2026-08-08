# دليل نسك الشامل — نظام خدمات الحج والعمرة والرحلات الدينية داخل منصة PalWakf

**الإصدار:** v36.1 — Comprehensive Guide Baseline  
**التاريخ:** 2026-05-20  
**النطاق:** دليل شامل لجميع مراحل تطوير نسك من التأسيس حتى التشغيل الموسمي والتحضير للدمج مع منصة PalWakf  
**الحالة الحاكمة:** `staging-stable / analyzer-clean / chrome-startup-passed / production-not-approved / database-schema-not-created-by-design / no-waqf-assets-mutation`

---

## 0. ملخص تنفيذي

نظام **نسك للحج والعمرة** هو نظام شبه مستقل تحت منصة **PalWakf** السيادية متعددة الأنظمة. هدفه إدارة خدمات الحج والعمرة والرحلات الدينية من واجهة المواطن، إلى تشغيل الموظفين، إلى الشركات والحملات، إلى القرعة الجغرافية القائمة على حصص التجمعات السكانية، وصولًا إلى التشغيل الموسمي والتقارير والتكاملات.

هذا الدليل هو المرجع الشامل لتطوير نسك حتى baseline v36، ويجمع:

1. الرؤية والحدود الحاكمة.
2. جميع مراحل التطوير v01–v36.
3. واجهات الجمهور والموظفين والشركات.
4. قرعة الحج LGU quota/capacity-aware.
5. تصميم schema وRPC/RLS كعقود مؤجلة التنفيذ.
6. خطة الدمج مع PalWakf.
7. التشغيل الموسمي والتحسينات.
8. المسارات والملفات الأساسية.
9. UAT والإنتاجية وموانع الإنتاج.
10. القواعد الصارمة لما قبل وما بعد الدمج.

> **قاعدة حاكمة:** لم يتم إنشاء جداول قاعدة بيانات نسك بعد، وهذا مقصود. يتم دمج نسك أولًا داخل منصة PalWakf، ثم إنشاء schema `nosok` في Supabase بعد اعتماد الدمج.

---

## 1. تعريف النظام

### 1.1 الاسم

```text
Nosok / نسك للحج والعمرة
```

### 1.2 التصنيف

```text
Semi-independent system under PalWakf
```

نسك ليس منصة مستقلة خارج PalWakf، وليس مجرد صفحة خدمات. هو نظام تشغيلي شبه مستقل يملك نطاقه وسير عمله، لكنه يعمل تحت حوكمة المنصة.

### 1.3 الوظيفة العامة

إدارة دورة حياة خدمات الحج والعمرة والرحلات الدينية، بما يشمل:

- الخدمات العامة للمواطنين.
- التسجيل والمتابعة والاستكمال.
- الشركات المؤهلة والحملات.
- مراجعة الطلبات والوثائق.
- قرعة الحج وحصص التجمعات.
- الاعتراضات وقرارات لجنة الحج.
- التقارير والتشغيل الموسمي.
- التكامل مع الدفع والوثائق والمساعد والمهام لاحقًا.

---

## 2. العلاقة مع منصة PalWakf

### 2.1 PalWakf يملك

- الهوية البصرية العامة.
- PWF-SIS.
- Shell العام.
- RBAC الحاكم.
- Dynamic System Registry.
- System Sections Registry.
- AccessProfile.
- الصلاحيات العامة.
- health/maintenance/error boundary.
- التكاملات السيادية.

### 2.2 Nosok يملك

- بيانات الحج والعمرة.
- الطلبات ومقدمي الطلبات والمرافقين.
- الشركات والحملات والمجموعات.
- الوثائق والمراسلات والمتابعة.
- سياسة الموسم.
- قرعة الحج وحصص التجمعات.
- قرارات لجنة الحج والاعتراضات.
- تقارير نسك التشغيلية.

### 2.3 قاعدة الفصل

```text
PalWakf owns the platform contract.
Nosok owns the domain workflow.
```

---

## 3. PWF-SIS — PalWakf Sovereign Interface System

نسك ملتزم بـ PWF-SIS في كل الواجهات:

- RTL كامل.
- دعم i18n.
- توافق مع Dark Mode.
- ألوان المنصة: الأزرق السيادي، الذهبي الوقفي، الأحمر الملكي `#B22222`.
- عدم إنشاء Design System مستقل.
- runtime states موحدة.
- Anti-overload UX.
- responsive حقيقي للـ desktop/tablet/mobile.
- عدم عرض backend/raw errors للمستخدم.
- عدم استخدام `legacy.dart` في الملفات الجديدة؛ الاعتماد على `flutter_riverpod.dart`.

---

## 4. القواعد الحاكمة الصارمة

1. لا إنتاج قبل الدمج الكامل داخل PalWakf.
2. لا إنشاء schema `nosok` قبل الدمج.
3. لا SQL apply ولا DML قبل تصريح صريح وبيئة sandbox معتمدة.
4. لا تعديل على `waqf_assets` أو schema `waqf` أو `awqaf_system`.
5. لا اعتماد production-ready قبل:
   - analyzer clean.
   - Chrome startup passed.
   - Browser role UAT.
   - Responsive UAT.
   - SQL/RPC/RLS UAT بعد إنشاء schema.
   - security/privacy gates.
6. المواطن لا يرى واجهات الموظفين.
7. الشركة ترى Partner Workspace لا Admin Console.
8. الموظف لا يرى أكثر من صلاحياته.
9. القرعة لا تتم دون audit evidence.
10. نقل أو إعادة توزيع حصة LGU لا يتم تلقائيًا؛ يحتاج قرار لجنة الحج.

---

## 5. تقسيم واجهات نسك

```text
Nosok System
├── Public Citizen Portal
├── Company / Partner Workspace
├── Internal Operations Console
└── Governance / Admin Scope
```

### 5.1 Public Citizen Portal

واجهة الجمهور/المواطن، هدفها رحلة خدمة بسيطة:

- معرفة الخدمة.
- تقديم طلب.
- رفع المرفقات.
- متابعة الطلب.
- معرفة النواقص.
- الاطلاع على نتائج القرعة.
- تقديم اعتراض.
- التواصل والدعم.

### 5.2 Company / Partner Workspace

واجهة الشركات المؤهلة والشريكة:

- عرض الحملات المرتبطة.
- السعات والتخصيصات.
- الحجاج المرتبطون بالحملة.
- النواقص والوثائق.
- المراسلات والتعليمات.
- حالة الاعتماد.

### 5.3 Internal Operations Console

واجهة الموظف والمشرف والمدير:

- الطلبات.
- المراجعة.
- الوثائق.
- القرعة.
- لجنة الحج.
- الحملات والشركات.
- التقارير.
- الإعدادات.

### 5.4 Governance / Admin Scope

نطاق خاص بالحاكمية:

- الإنتاجية.
- readiness.
- RBAC.
- merge readiness.
- schema design.
- UAT.
- error records.

---

## 6. مراحل التطوير من v01 إلى v36

### v01–v08 — التأسيس الأولي

تم إنشاء الأساس الأولي لنظام نسك:

- مجلد `lib/features/nosok_system`.
- routes عامة وإدارية.
- models أولية للطلبات والبرامج والشركات.
- SQL schema أولي كفكرة/design.
- tracking token.
- رفع ملفات أولي عبر Supabase Storage.
- workflow مبدئي للدفعات والمراجعة.

### v09–v13 — شبه الاستقلال والتشغيل الداخلي

- Internal Shell.
- Sidebar filtering.
- AccessProfile binding contract.
- وحدات وإعدادات وصحة ومستخدمون/أدوار.
- Billing bridge وNotification bridge كعقود تكامل.
- Tracking privacy hardening.

### v14–v19 — تحسين رحلة المواطن ودورة حياة الطلب

- إعادة بناء الصفحة العامة كواجهة خدمة حكومية لا dashboard.
- تطوير dashboard النظام.
- تطوير Workbench.
- Service Desk Search.
- Season Gate Enforcement.
- Application Lifecycle State Machine.
- Citizen Follow-up Actions.
- Follow-up Inbox.
- Notification Provider UAT.
- إصلاحات runtime مثل Material/Scaffold/SnackBar/Riverpod/sidebar/icon compatibility.

### v20–v22 — جاهزية الإنتاج والدمج

- Production UAT Closure.
- Application Operations Deepening.
- Platform Integration Readiness Pack.
- Real Platform Merge Pack.
- RBAC Provider Override Contract.
- SQL UAT Result Intake كعقد لا تطبيق إنتاجي.
- Production gate بقي مغلقًا.

### v23 — Mega UI Batch

- فصل واجهة المواطن عن واجهة الموظف.
- مسارات الجمهور `/services/nosok...`.
- مسارات الإدارة `/admin/systems/nosok...`.
- PWF-SIS local components.
- صفحات requirements/internal requests/review/campaigns/groups/documents/messages.
- ذكر تطبيق مناسكنا كقناة إرشادية/مساندة دون backend وهمي.

### v24 — Browser/Role/Responsive/Supabase UAT Pack

- UAT evidence pages.
- SQL read-only pack.
- Production redecision page.
- الإنتاج غير معتمد.

### v25 — Evidence + Merge Candidate

- Evidence Intake.
- Full PalWakf Merge Application Result.
- Production Candidate Decision.
- استمرار `production-not-approved`.

### v26 — Evidence Result + Re-decision

- إصلاح `_V25EvidenceSectionPanel` غير المستخدم.
- صفحات v26:
  - `/admin/systems/nosok/v26-evidence-result-intake`
  - `/admin/systems/nosok/v26-full-merge-apply-result`
  - `/admin/systems/nosok/v26-production-candidate-redecision`
- SQL read-only UAT.

### v27A — Legacy Nosok Portal Reference Intake

تمت مراجعة موقع نسك القديم واستخراج المنطق لا التصميم:

- الحج.
- الشركات المؤهلة.
- بوابة الشركات.
- التواصل.
- الشكاوى.

أضيفت/ثُبتت مسارات مثل:

```text
/services/nosok/companies
/services/nosok/company-login
/services/nosok/contact
/services/nosok/complaints
```

### v27B — Operational Workflow Deepening

- تعميق الطلبات والمراجعة.
- الشركات والحملات.
- الوثائق والمراسلات.
- فصل المواطن/الموظف/الشركة.

### v27C — Lottery Governance + LGU Quota

أول بناء حاكم لقرعة الحج:

- Eligibility Rules.
- LGU quota lottery.
- Capacity-aware draw.
- Waiting List.
- Committee Decision.
- Audit Evidence.

### v27C-1 — Lottery Compile Fix

- إصلاح import الخاص بـ `NosokLguQuotaStatus` و`labelAr`.

### v27D — Lottery Operational Hardening

- تعميق سياسة الموسم.
- مصادر السكان والحصة والعنوان/LGU.
- سياسة الحصص غير المستكملة.
- تحسين صفحات القرعة والنتائج والاعتراضات واللجنة.

### v27D-1 — Admin Dashboard Entry

- إضافة زر واضح لدخول الموظفين/لوحة التحكم من الواجهة العامة.
- الحفاظ على RBAC route guard.

### v28 — Lottery Backend Schema/RPC Draft

- تصميم backend schema/RPC/RLS كعقود.
- صفحة readiness:
  - `/admin/systems/nosok/v28-lottery-backend-readiness`
- لا SQL apply.

### v28A/v28B — SQL/RLS/RPC Review Decisions

تم تثبيت لاحقًا أن هذه الدفعات كانت مبكرة لأن قاعدة بيانات نسك لم تُنشأ بعد. القرار الجديد:

```text
SQL/RPC remains draft until PalWakf merge + nosok schema creation.
```

### v29 — PalWakf Merge Readiness Consolidation

- تثبيت قاعدة: لا جداول قبل الدمج.
- تصميم schema النهائي كعقد.
- خطة Registry/RBAC.
- Pre-database integration pack.
- صفحة:
  - `/admin/systems/nosok/v29-merge-readiness`

### v30 — Full PalWakf Merge Pack Application

- تجهيز حزمة الدمج داخل PalWakf.
- Platform Registry Entry.
- AccessProfile Override Closure Plan.
- تحضير إنشاء schema بعد الدمج.
- إصلاح blocker نحوي في v29.
- صفحة:
  - `/admin/systems/nosok/v30-palwakf-merge-application`

### v31–v35 — Consolidated Development Closure

حزمة كبرى واحدة تضمنت:

- PalWakf Merge Pack Application.
- Schema/RPC/RLS creation preparation.
- Backend Runtime Binding Candidate disabled.
- Full UAT Pack.
- Production Candidate Closure.
- صفحة:
  - `/admin/systems/nosok/v31-v35-production-closure`

القرار:

```text
production-candidate deferred
```

### v36 — Seasonal Operations Enhancements

- تقارير متقدمة.
- ربط الدفع كـ bridge disabled.
- ربط document intelligence كـ bridge disabled.
- ربط assistant كـ bridge disabled.
- تحسين الحملات والشركات.
- تحسين UX.
- إضافات سياسة الوزارة.
- صفحة:
  - `/admin/systems/nosok/v36-seasonal-operations`

---

## 7. قرعة الحج — النموذج الحاكم

### 7.1 التسجيل

التسجيل مفتوح للجميع ممن تنطبق عليهم الشروط. لكن قبول الطلب للدخول في القرعة يحتاج:

- اكتمال الشروط.
- اكتمال الوثائق.
- عدم التكرار.
- عدم الحج السابق إن كانت السياسة تشترط ذلك.
- صحة بيانات الهوية.
- اعتماد العنوان الرسمي من البطاقة الشخصية.
- ربط العنوان بـ LGU.

### 7.2 أساس العنوان

```text
العنوان المعتمد في البطاقة الشخصية → LGU
```

لا يعتمد النظام اختيارًا يدويًا حرًا للتجمع إذا كان يخالف البطاقة الشخصية.

### 7.3 الحصة الجغرافية

لكل تجمع/LGU حصة محددة حسب سياسة الموسم. يمكن أن تكون:

1. محسوبة:

```text
population / quota_divisor
```

2. أو مدخلة يدويًا من الوزارة.

### 7.4 مثال نحالين

```text
LGU: نحالين
Population: 10,000
Quota divisor: 1000
Quota capacity: 10 persons
```

القرعة لا تختار 10 طلبات، بل تختار طلبات بحيث لا يتجاوز مجموع الأشخاص 10.

### 7.5 Capacity-Aware Draw

كل طلب له:

```text
total_people_count = applicant + companions + mahram if applicable
```

يختار النظام الطلبات المؤهلة من نفس LGU حتى لا يتجاوز مجموع الأشخاص الحصة.

### 7.6 استكمال الحصة داخل نفس التجمع

إذا بقيت سعة شاغرة:

1. يبحث النظام عن طلب آخر من نفس LGU.
2. يشترط أن يكون مكتملًا ومؤهلًا.
3. يشترط ألا يتجاوز عدد أفراده السعة المتبقية.

### 7.7 تعذر استكمال الحصة

إذا تعذر إيجاد طلب مناسب:

```text
quota_underfilled_committee_decision_required
```

ولا يتم النقل تلقائيًا لتجمع آخر.

### 7.8 قرار لجنة الحج

لجنة الحج تقرر:

- إبقاء المقعد شاغرًا.
- إعادة فتح مراجعة داخل نفس LGU.
- ترحيل الحصة وفق سياسة رسمية.
- توزيعها على تجمع آخر بقرار موثق.
- منح استثناء وفق حوكمة واضحة.

كل قرار يحتاج:

```text
committee decision + reason + audit evidence
```

---

## 8. سياسة الموسم

سياسة الموسم قابلة للتعديل حسب الوزارة، وتشمل:

- سنة الموسم.
- فتح/إغلاق التسجيل.
- الحد الأدنى للعمر.
- شرط الحج السابق.
- شرط المحرم.
- حد المرافقين.
- رسوم التسجيل.
- إلزام الدفع قبل القرعة أو بعد القبول.
- معامل الحصة.
- حصة كل LGU.
- فئات الأولوية إن اعتمدت.
- سياسة النواقص.
- سياسة الاعتراضات.
- سياسة إعادة توزيع الحصص.
- توقيت إعلان النتائج.

---

## 9. حالات الطلب والقرعة

### 9.1 حالات الطلب للمواطن

```text
submitted
received
under_review
needs_completion
approved
rejected
assigned
in_followup
completed
closed
```

### 9.2 حالات الأهلية والقرعة

```text
pending_validation
eligible
ineligible
duplicate_detected
included_in_draw
excluded_from_draw
selected_in_draw
waiting_list
objection_submitted
objection_approved
objection_rejected
assigned_to_campaign
```

### 9.3 حالات الحصة LGU

```text
quota_pending
quota_locked
included_in_lgu_draw
selected_under_lgu_quota
waiting_list_under_lgu_quota
quota_exhausted
committee_decision_required
```

---

## 10. تصميم schema نسك — مؤجل التنفيذ

> لا تُنشأ هذه الجداول الآن. هذا تصميم نهائي/مبدئي لما بعد الدمج.

```text
nosok.seasons
nosok.applications
nosok.applicants
nosok.companions
nosok.documents
nosok.companies
nosok.campaigns
nosok.groups
nosok.messages
nosok.followups
nosok.lottery_policies
nosok.lgu_quota_snapshots
nosok.lottery_eligibility_snapshots
nosok.lottery_draw_runs
nosok.lottery_draw_results
nosok.lottery_committee_decisions
nosok.lottery_objections
nosok.lottery_audit_events
nosok.payment_events
nosok.document_intelligence_events
nosok.assistant_interactions
```

### 10.1 قواعد public schema

- لا تكون جداول نسك الحاكمة داخل `public`.
- `public` يستخدم فقط views/RPC wrappers عامة وآمنة.
- المواطن يرى payload محدودًا يخص طلبه فقط.
- الموظف يرى حسب AccessProfile/RBAC.

---

## 11. RPC Contracts المقترحة

```text
public.rpc_nosok_public_submit_application_v1
public.rpc_nosok_public_track_application_v1
public.rpc_nosok_public_lottery_result_v1
public.rpc_nosok_public_submit_objection_v1
public.rpc_nosok_admin_applications_snapshot_v1
public.rpc_nosok_admin_update_application_status_v1
public.rpc_nosok_admin_freeze_lottery_pool_v1
public.rpc_nosok_admin_run_lottery_v1
public.rpc_nosok_admin_committee_decision_v1
public.rpc_nosok_admin_lottery_audit_v1
public.rpc_nosok_readiness_v1
```

كل RPC يجب أن يكون:

- RLS-aware أو `SECURITY DEFINER` بضوابط صارمة.
- لا يكشف بيانات حساسة للمواطن.
- يسجل audit عند الإجراءات التشغيلية.
- يمنع تنفيذ القرعة مرتين دون حوكمة.

---

## 12. RLS Matrix المختصرة

| الدور | القراءة | الكتابة | الملاحظات |
|---|---|---|---|
| زائر | خدمات عامة فقط | لا | لا يرى طلبات |
| مواطن | طلبه فقط | تقديم/استكمال/اعتراض | payload محدود |
| شركة | نطاق الشركة فقط | تحديثات ضمن العقد | لا admin |
| موظف نسك | الطلبات المسندة | مراجعة ضمن الصلاحية | لا إعدادات عليا |
| مشرف نسك | نطاقه | قرارات تشغيلية محدودة | لا override عام |
| مدير النظام | إدارة نطاق نسك | إعدادات/تقارير | حسب RBAC |
| Superuser | كامل | كامل مع audit | لا bypass بلا سجل |
| Restricted | read-only/forbidden | لا | fail-closed |

---

## 13. Backend Binding

حتى v36، حالة backend binding:

```text
candidate-ready-disabled
```

أي:

- repositories موجودة أو مهيأة.
- contracts جاهزة.
- لكن الربط الحقيقي مع Supabase مؤجل.

سبب التأجيل:

```text
PalWakf merge first → create nosok schema → apply SQL in sandbox → UAT → enable binding
```

---

## 14. تكاملات v36 الموسمية

### 14.1 التقارير المتقدمة

- تقارير الطلبات حسب الحالة.
- تقارير القرعة حسب LGU.
- تقارير الحصة غير المستكملة.
- تقارير الشركات والحملات.
- تصدير CSV/PDF كـ policy-gated.

### 14.2 الدفع

- رسوم التسجيل.
- التحقق من الدفع.
- الاسترداد.
- الاستثناءات.
- الربط مع `billing_system` مؤجل/disabled حتى الدمج.

### 14.3 document intelligence

- OCR.
- جودة الوثيقة.
- كشف النواقص كمساعدة.
- لا يتخذ قرارًا بدل الموظف.

### 14.4 assistant

- مساعد عام للمواطن.
- مساعد داخلي للموظف.
- إجابات مرتبطة بسياسة الموسم.
- لا يكشف بيانات غير مصرح بها.

### 14.5 الحملات والشركات

- بطاقة أداء الشركة.
- سعة الحملات.
- مهام الشركات.
- الوثائق والنواقص.
- الرسائل والتعليمات.

---

## 15. المسارات العامة الأساسية

```text
/services/nosok
/services/nosok/hajj
/services/nosok/umrah
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/faq
/services/nosok/companies
/services/nosok/company-login
/services/nosok/contact
/services/nosok/complaints
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
```

## 16. المسارات الإدارية الأساسية

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
/admin/systems/nosok/lottery
/admin/systems/nosok/lottery/eligibility
/admin/systems/nosok/lottery/draw
/admin/systems/nosok/lottery/waiting-list
/admin/systems/nosok/lottery/committee
/admin/systems/nosok/lottery/audit
/admin/systems/nosok/v28-lottery-backend-readiness
/admin/systems/nosok/v29-merge-readiness
/admin/systems/nosok/v30-palwakf-merge-application
/admin/systems/nosok/v31-v35-production-closure
/admin/systems/nosok/v36-seasonal-operations
```

---

## 17. الملفات والمجلدات المحورية

```text
lib/features/nosok_system/
  application/
  data/
  domain/
  presentation/
  system_routes.dart
  system_navigation.dart
  system_permissions.dart
  system_manifest.dart
  system_visual_context.dart
```

مجلدات/حزم مهمة:

```text
platform_merge_patch/
platform_real_merge_pack/
platform_finalization_proposals/
pre_database_integration_pack/
seasonal_operations_pack/
sql/
docs/
```

---

## 18. UAT المطلوب قبل الإنتاج

### 18.1 Flutter local gates

```bash
dart format .
flutter analyze
flutter run -d chrome
```

آخر سجل محلي مرفق بعد v36 يثبت:

```text
dart format . ✅
flutter analyze: No issues found ✅
flutter run -d chrome: Debug Service available ✅
```

### 18.2 Browser click-through

اختبار كل المسارات العامة والإدارية والقرعة والتشغيل الموسمي.

### 18.3 Role UAT

- زائر.
- مواطن.
- شركة.
- موظف نسك.
- مشرف نسك.
- مدير النظام.
- Superuser.
- Restricted user.

### 18.4 Responsive UAT

- Desktop.
- Laptop.
- Tablet.
- Mobile.

### 18.5 Console Review

يجب عدم وجود:

- Overflow.
- RenderBox errors.
- ParentDataWidget errors.
- raw backend errors.
- route exceptions.

---

## 19. موانع الإنتاج الحالية

حتى v36، لا يزال الإنتاج غير معتمد للأسباب التالية:

1. لم يتم دمج نسك فعليًا داخل ريبو PalWakf الكامل.
2. لم يتم تسجيله runtime في Dynamic System Registry الحقيقي.
3. لم يتم تفعيل AccessProfile الحقيقي داخل المنصة.
4. لم يتم إنشاء schema `nosok`.
5. لم تُطبّق RPC/RLS في Supabase.
6. Backend binding ما زال disabled.
7. Role/Responsive UAT داخل PalWakf غير مغلق.
8. تكامل الدفع والوثائق والمساعد ما زال bridge/contract فقط.

---

## 20. قرار الإنتاج الحالي

```text
production-not-approved
```

الحالة الأقرب:

```text
staging-stable / merge-ready / pre-database / production-candidate-deferred
```

---

## 21. خطة ما بعد v36

### v37 — PalWakf Actual Merge Evidence

- تطبيق الحزمة داخل ريبو PalWakf الحقيقي.
- معالجة route/RBAC conflicts.
- إدخال system registry entry.
- إغلاق Browser UAT داخل المنصة.

### v38 — Nosok Schema Sandbox Creation

- إنشاء schema `nosok` في sandbox.
- تطبيق RLS/RPC drafts.
- read-only readiness RPC.
- عدم الإنتاج حتى مراجعة أمنية.

### v39 — Backend Runtime Binding

- ربط repositories بـ RPCs.
- إغلاق in-memory preview.
- تفعيل public tracking/lottery results/objections.

### v40 — Production Candidate

- UAT كامل.
- privacy/security review.
- role-based evidence.
- قرار production candidate.

---

## 22. Error Record ملخص

أبرز الأخطاء التي عولجت خلال التطوير:

1. Chip بلا Material ancestor.
2. SnackBar بلا Scaffold.
3. missing adminItemForPath.
4. icon parameter غير مدعوم.
5. imports غير مستخدمة.
6. enum/import لـ `NosokLguQuotaStatus`.
7. string literal broken في صفحة v29.
8. غياب زر واضح للوحة التحكم.
9. دفعات SQL apply كانت مبكرة قبل الدمج؛ تم تصحيح المسار إلى pre-database contracts.

---

## 23. قواعد التطوير القادمة

1. الدفعات القادمة كبيرة لا micro patches، إلا إذا كان هناك compile blocker.
2. لا طلب SQL evidence قبل إنشاء schema.
3. لا backend binding قبل PalWakf merge.
4. أي bridge خارجي يبقى disabled حتى توفر backend.
5. توثيق كل Batch في:
   - changelog.
   - handoff.
   - UAT matrix.
   - error record.
   - routes summary.
   - modified files.
6. تحديث هذا الدليل أو ملحقه بعد كل دفعة كبيرة ناجحة.

---

## 24. الخلاصة

حتى v36، أصبح نسك نظامًا شبه مستقل ناضجًا من ناحية الواجهة والعقود والتشغيل الموسمي، وجاهزًا للدخول في مرحلة الدمج الفعلي مع PalWakf. لم يصل بعد إلى production-ready لأنه لم يُدمج بعد داخل المنصة ولم تُنشأ قاعدة بياناته الرسمية.

الحكم النهائي للدليل:

```text
staging-stable /
nosok-v36-comprehensive-guide-added /
frontend-contract-and-seasonal-operations-ready /
palwakf-merge-required /
nosok-schema-not-created-by-design /
production-not-approved /
no-waqf-assets-mutation
```

---

# ملحق v37 — إعادة تصميم الصفحة الرئيسية العامة كواجهة خدمة عصرية

## الحكم

```text
staging-stable /
nosok-v37-modern-public-homepage-applied /
citizen-journey-ux-applied /
seasonal-service-landing-applied /
governance-de-emphasized-on-public-home /
mobile-first-public-experience-applied /
production-not-approved /
no-waqf-assets-mutation
```

## سبب الدفعة

بعد اكتمال مراحل v31–v36 أصبح واضحًا أن الصفحة الرئيسية العامة يجب ألا تبدو كواجهة إدارية أو صفحة حوكمة، بل كبوابة خدمة حكومية عصرية للمواطن. لذلك تم نقل التركيز في `/services/nosok` من مفاهيم الجاهزية والدمج والحوكمة إلى رحلة المواطن والخدمات الموسمية.

## البنية الجديدة للصفحة العامة

```text
Modern Public Hero
→ Seasonal Service Landing
→ Citizen Primary Actions
→ Citizen Journey Preview
→ Tracking and Support Strip
→ Trust and Transparency
→ Requirements Preview
→ FAQ
→ Compact Admin Entry
```

## ما يظهر للمواطن

- تقديم طلب جديد.
- متابعة طلب.
- عرض الشروط والمتطلبات.
- التسجيل للحج والعمرة.
- نتائج القرعة.
- قائمة الانتظار.
- الاعتراضات.
- الشركات المؤهلة.
- التواصل والدعم.
- شرح مبسط للحصة الجغرافية والقرعة حسب LGU.

## ما لا يظهر في الصفحة العامة

- حالة schema.
- RLS/RPC.
- backend binding.
- production gate.
- registry readiness.
- audit evidence.
- تفاصيل تشغيل داخلية.

## موضع الحوكمة الصحيح

تبقى الحوكمة داخل:

```text
/admin/systems/nosok
/admin/systems/nosok/v29-merge-readiness
/admin/systems/nosok/v30-palwakf-merge-application
/admin/systems/nosok/v31-v35-production-closure
/admin/systems/nosok/v36-seasonal-operations
```

## قرار الاستمرارية

v37 لا يغيّر قاعدة البيانات ولا ينشئ schema ولا يربط backend. هو تحديث واجهة عامة فقط مع الحفاظ على قرار أن نسك ينتظر الدمج داخل PalWakf ثم إنشاء schema خاصة به.

---

# ملحق v37A — Premium Public Homepage Visual Upgrade

## الهدف

تحويل الصفحة العامة لنسك من واجهة نظيفة ومنظمة لكنها باهتة نسبيًا إلى تجربة خدمة وطنية حديثة موجهة للمواطن.

## التغييرات المعتمدة

1. تقوية Hero العام في `/services/nosok`.
2. جعل “تقديم طلب جديد” هو الإجراء الرئيسي الأكثر بروزًا.
3. تبسيط Navigation العام وتقليل عدد العناصر المباشرة.
4. نقل الخدمات الثانوية إلى قائمة “المزيد”.
5. إضافة Seasonal Status Banner واضح وغير إداري.
6. تقسيم بطاقات الخدمة إلى:
   - إجراءات رئيسية.
   - خدمات ومعلومات مساندة.
7. اعتماد صياغة مواطنية مباشرة بدل لغة backend/حوكمة.
8. إبقاء رابط دخول الموظفين واضحًا لكن غير مسيطر بصريًا.
9. تعزيز Mobile Visual Polish عبر stacking أفضل وتقليل الازدحام.

## حدود الملحق

- لا SQL.
- لا schema.
- لا backend binding.
- لا production approval.
- لا تعديل على `waqf_assets`.

## الحكم

```text
staging-stable /
nosok-v37a-premium-public-homepage-upgrade-applied /
stronger-hero-applied /
navigation-simplified /
service-card-hierarchy-applied /
seasonal-status-banner-applied /
citizen-first-copywriting-applied /
mobile-visual-polish-applied /
production-not-approved /
no-waqf-assets-mutation
```

---

## ملحق v37C — Public Homepage Final Polish

**التاريخ:** 2026-05-20  
**النطاق:** صقل نهائي للصفحة الرئيسية العامة وHeader وتجربة Mobile، دون أي Backend أو SQL أو تعديل على `waqf_assets`.

### القرار البصري

تم استبدال اللون الزهري/الوردي المستخدم سابقًا في حالات التحذير العامة بلون ذهبي متسق مع هوية نسك وPalWakf:

```text
warning background: #F9F3E7
warning border:     #D7B56D
warning text/icon:  #5D4215
gold accent:        #B68B40
```

السبب: اللون الزهري لا ينسجم مع الأزرق السيادي والذهبي الوقفي، بينما الذهبي مناسب للتنبيه الموسمي والمواعيد والحصة دون إيحاء بخطأ أو خطر.

### التغييرات الأساسية

1. ضغط ارتفاع Hero وتقليل الفراغ الرأسي حتى تظهر الخدمات مبكرًا في أول شاشة.
2. تقوية Hero بتدرج أزرق سيادي ولمسة ذهبية بدل الألوان الباهتة.
3. تحويل أيقونة Hero إلى زخرفة/بطاقة أقل حجمًا على Desktop وإخفائها من تخطيط Mobile المضغوط.
4. إثراء بطاقات الخدمات الرئيسية بوصف عملي قصير.
5. إبراز أولويات المواطن: تقديم طلب، متابعة طلب، نتائج القرعة.
6. إضافة CTA سريع في Header للتقديم والمتابعة على Desktop، وزر تقديم مختصر على Mobile.
7. ضغط Seasonal Status Banner وتحويله إلى شريط ذهبي خفيف متسق مع الهوية.
8. تقليل اللغة التقنية في مدخل الموظفين واستبدالها بعبارات خدمية واضحة.
9. الحفاظ على مسارات الصفحة دون تغيير:
   - `/services/nosok`
   - `/services/nosok/apply`
   - `/services/nosok/track`
   - `/services/nosok/lottery-results`

### الحكم

```text
staging-stable /
nosok-v37c-public-homepage-final-polish-applied /
gold-warning-tone-applied /
hero-density-optimized /
service-card-content-enriched /
header-cta-refined /
mobile-journey-layout-hardened /
local-flutter-retest-required /
production-not-approved /
no-waqf-assets-mutation
```

---

# ملحق v37D — منع اللون الزهري وتوحيد صفحات الجمهور

تم اعتماد قاعدة تصميمية نهائية لواجهات الجمهور في نسك:

```text
لا يستخدم اللون الزهري أو الوردي أو مشتقاته في واجهات المواطن.
```

النبرات المعتمدة:

| النوع | اللون |
|---|---|
| معلومات | أزرق سيادي فاتح |
| تحذير/موعد/حصة | ذهبي وقفي |
| نجاح | أخضر هادئ |
| خطأ حقيقي | سطح محايد مع حد ونص أحمر ملكي #B22222 فقط |

كما تم توحيد المظهر العام للصفحات الفرعية عبر ترقية المكونات المشتركة:

- `PwfSisServiceHero`
- `NosokPageScaffold`
- `NosokSectionCard`
- صفحة دليل الخدمات

الهدف: ألا تبدو الصفحة الرئيسية وحدها حديثة بينما تبقى الصفحات الفرعية بطابع قديم أو إداري.

---

## ملحق v37E — ضبط الشريط العلوي ونموذج التقديم العام

تمت إضافة v37E بعد ملاحظات فحص بصري للواجهة العامة. الهدف ليس إضافة وظائف جديدة، بل إزالة آخر مظاهر الانحراف عن هوية نسك العامة:

1. إلغاء اعتماد شريط التنقل العام على `ChoiceChip` لأنه قد يرث ألوانًا غير مرغوبة من Theme، واستبداله بمكوّن تنقل واضح بألوان سيادية صريحة: أزرق عميق للحالة النشطة، أبيض/حد رمادي أزرق للحالة العادية، وذهبي فقط كتأكيد فرعي.
2. الحفاظ على ظهور أزرار المواطن الأساسية في الشريط العلوي دون ازدحام أو اختصار مربك.
3. جعل نموذج التقديم على الشاشات الواسعة أقل طابعًا إداريًا عبر استخدام stepper أفقي، مع إبقاء العرض العمودي على الموبايل لسهولة الاستخدام.
4. استمرار قاعدة منع اللون الزهري أو الوردي أو مشتقاته في واجهات الجمهور.

لا يتضمن v37E أي SQL أو Backend Binding أو تعديل على `waqf_assets`.

---

## ملحق v37F — تنظيف تحذيرات التحليل وإدخال دليل Chrome UAT

تم في v37F تنظيف آخر تحذيرات `flutter analyze` الناتجة عن صقل الواجهة العامة بعد v37E، وذلك بحذف ثوابت ألوان غير مستخدمة من شل الواجهة العامة وحذف المكوّن الخاص غير المستخدم `_HeroVisualRow`. كما تم إدخال سجل التشغيل المحلي الذي أثبت وصول التطبيق إلى Chrome Debug Service. لا توجد تغييرات SQL أو Backend أو `waqf_assets` في هذه الدفعة. تبقى حالة الإنتاج غير معتمدة حتى اكتمال UAT البصري والوظيفي داخل المتصفح.

```text
staging-stable /
nosok-v37f-final-analyzer-warning-cleanup-applied /
public-ui-console-uat-intaken /
chrome-startup-passed-confirmed /
public-homepage-subpages-visual-closure-candidate /
production-not-approved /
no-waqf-assets-mutation
```


---

## ملحق v37G — إصلاح Runtime لصفحة تقديم الطلب

تم إغلاق خطأ `RenderFlex children have non-zero flex but incoming height constraints are unbounded` في صفحة `/services/nosok/apply` عبر تقييد ارتفاع Stepper الأفقي على الشاشات الواسعة فقط، مع إبقاء Stepper العمودي للموبايل. لا SQL ولا Backend ولا تعديل على `waqf_assets`.

---

## ملحق v37H — Public Transaction Forms Premium UX

تم في v37H صقل الصفحات الإجرائية العامة في نسك، خصوصًا صفحة تقديم الطلب، بعد ظهور أن صفحة `/services/nosok/apply` أصبحت تعمل بعد v37G لكنها ما زالت تستخدم `Stepper` افتراضيًا بطابع إداري.

### القرار

لا تستخدم صفحة التقديم العامة `Stepper` الافتراضي داخل scrollable. يتم اعتماد `Citizen Progress Bar` مخصص يعرض رحلة المواطن بلغة واضحة، ويعمل على Desktop وMobile دون unbounded height.

### الصفحات المشمولة

- `/services/nosok/apply`
- `/services/nosok/track`
- `/services/nosok/lottery-results`
- `/services/nosok/waiting-list`
- `/services/nosok/objections`

### القواعد البصرية

- لا ألوان زهري/وردي أو مشتقاتها في واجهات الجمهور.
- الأزرق السيادي للأفعال الرئيسية.
- الذهبي الوقفي للتنبيهات الموسمية والملاحظات.
- الأحمر الملكي للأخطاء الحقيقية فقط.
- لا لغة تقنية أو backend في الصفحات العامة.

---

# Appendix — Nosok v38A Development / Preparation Only

## Governing correction

After the v39 reversal, the Nosok development track is explicitly limited to development and preparation. The actual join into PalWakf is deferred to the PalWakf platform track.

## Current state

```text
staging-stable /
nosok-v38a-development-preparation-only-applied /
palwakf-join-execution-deferred-to-platform-track /
schema-creation-deferred-until-platform-hosting /
production-not-approved /
no-waqf-assets-mutation
```

## What v38A adds

v38A adds a `development_preparation_pack/` that includes:

- scope lock,
- platform join precheck package,
- large-batch development backlog,
- schema creation deferred gate,
- public UAT execution checklist,
- v39 revocation record.

## Rule

Do not execute actual platform join from the Nosok standalone project. Prepare only.

---

# ملحق v38B — Pre-Join Final Development Closure

## الحكم

```text
staging-stable /
nosok-prejoin-development-closure-applied /
public-runtime-uat-closure-pack-ready /
company-workspace-prepared /
evidence-center-hardened /
schema-rpc-rls-design-finalized-not-applied /
palwakf-join-package-ready-for-platform-track /
role-responsive-uat-matrix-ready /
production-not-approved /
no-waqf-assets-mutation
```

## القاعدة الحاكمة

نسك قبل الانضمام لا ينفذ الدمج داخل PalWakf، بل يجهز نفسه فقط كحزمة شبه مستقلة قابلة للاستقبال. أي تنفيذ فعلي للانضمام يتم في مسار منصة PalWakf، وليس في مسار نسك.

## مخرجات v38B

- إغلاق مصفوفة Public Runtime UAT كحزمة فحص.
- تجهيز Company/Partner Workspace contracts.
- تقوية Evidence Center.
- مراجعة نهائية لتصميم Schema/RPC/RLS دون تطبيق.
- تثبيت PalWakf Join Package كحزمة تسليم.
- إكمال Role/Responsive Matrix.

## المسار الجديد

```text
/admin/systems/nosok/v38b-prejoin-closure
```

## ممنوعات محفوظة

- لا SQL apply.
- لا schema creation.
- لا backend binding.
- لا PalWakf join execution.
- لا production approval.
- لا waqf_assets mutation.

---

# ملحق v38C — Admin Tools Pre-Join Scope

## الحكم

```text
staging-stable /
nosok-v38c-admin-tools-prejoin-scope-applied /
homepage-sections-admin-contract-ready /
unit-slug-lgu-access-contract-ready /
registration-governance-locks-contract-ready /
schema-draft-not-applied /
production-not-approved /
no-waqf-assets-mutation
```

## لماذا أضيف v38C؟

لأن نسك نظام شبه مستقل، فهو يحتاج أدوات إدارية داخل لوحة التحكم قبل الانضمام للمنصة، لا مجرد واجهات عامة. أهم هذه الأدوات:

1. إدارة أقسام الصفحة الرئيسية وما يظهر للجمهور.
2. ربط دخول الموظفين ونطاقهم حسب `unitSlug` والمديرية والتجمعات LGU.
3. قيود التسجيل بعد انتهاء الفترة القانونية وتجميد القرعة.
4. عقود جداول/RPC لا تطبق الآن، لكنها جاهزة عند إنشاء `nosok schema` داخل PalWakf لاحقًا.

## المسارات الإدارية الجديدة

```text
/admin/systems/nosok/homepage-sections
/admin/systems/nosok/unit-scope-access
/admin/systems/nosok/registration-governance
/admin/systems/nosok/v38c-admin-tools-prejoin
```

## الجداول المستقبلية المقترحة

```text
nosok.homepage_sections
nosok.public_content_items
nosok.unit_scope_policies
nosok.registration_governance_windows
nosok.admin_override_events
```

## قاعدة الموظف حسب slug/LGU

موظف مديرية بيت لحم مثلًا يجب أن يرى سجلات المواطنين المرتبطين بتجمعات بيت لحم فقط عند التسجيل أو التعديل أو المراجعة، ويجب أن يطبق هذا لاحقًا عبر `AccessProfile + core.org_units + LGU mapping + RPC/RLS`، وليس عبر إخفاء بصري فقط.

## قيود ما بعد إغلاق التسجيل

بعد انتهاء الفترة القانونية للتسجيل:

- يمنع إنشاء طلب جديد.
- يمنع تعديل البيانات الأساسية التي تؤثر على الأهلية أو الحصة أو LGU.
- يسمح باستكمال النواقص فقط ضمن نافذة استكمال واضحة.
- أي استثناء يحتاج قرار لجنة الحج أو صلاحية عليا مع سبب وسجل تدقيق.
- لا نقل تلقائي للحصص بين التجمعات دون قرار لجنة موثق.

## ممنوعات محفوظة

- لا PalWakf join execution.
- لا إنشاء schema.
- لا SQL apply.
- لا backend binding.
- لا production approval.
- لا waqf_assets mutation.


---

## ملحق v38D — منشئ الصفحات والأقسام الديناميكية قبل الانضمام

أضيف في v38D عقد تحضيري جديد لأن نسك نظام شبه مستقل ويجب أن يستطيع مستقبلًا إضافة صفحات عامة وأقسام جديدة من لوحة الإدارة دون الرجوع للمطور لكل تعديل محتوى أو صفحة موسمية.

### القرار الحاكم
- الصفحات العامة الديناميكية تُنشأ من قوالب معتمدة فقط.
- لا يسمح بحقن HTML أو Script حر.
- كل slug يخضع لفحص عدم التعارض مع المسارات الثابتة والإدارية.
- الصفحات الإدارية الجديدة تحتاج permission key وroute contract وRPC/RLS ونطاق وحدة.
- النشر والإخفاء والأرشفة تحتاج audit events.
- التنفيذ الحقيقي مؤجل حتى استضافة نسك داخل PalWakf وإنشاء `nosok schema`.

### المسارات التحضيرية
- `/admin/systems/nosok/dynamic-pages`
- `/admin/systems/nosok/v38d-dynamic-pages-prejoin`

### الجداول المستقبلية المقترحة
- `nosok.page_registry`
- `nosok.page_sections`
- `nosok.page_actions`
- `nosok.page_templates`
- `nosok.page_audit_events`

### الحالة
`contract-ready / schema-not-created / production-not-approved / no-waqf-assets-mutation`.

---

# ملحق v38E — مواءمة نظام تنظيم شؤون الحج رقم (15) لسنة 2025م

تم في v38E اعتماد أثر النظام القانوني الجديد على عقد نسك قبل الانضمام إلى PalWakf. لم يعد نموذج القرعة السابق، المبني على LGU quota وcapacity-aware فقط، كافيًا وحده. يجب أن تصبح القرعة في نسك خاضعة لعقد قانوني واضح يحتوي فروع الخوارزمية المنصوص عليها في النظام، ومنها الاختيار العشوائي الأولي، وحصة الطلب الواحد، وحالة تبقي مقعدين مع طلب بثلاثة أسماء، وحالة البحث في طلبات اسم/اسمين ثم ثلاثة أسماء.

## صفحات v38E

- `/services/nosok/legal-regulation`
- `/admin/systems/nosok/legal-compliance`
- `/admin/systems/nosok/v38e-legal-lottery-alignment`

## قواعد v38E

- لا انضمام لمنصة PalWakf قبل إغلاق مواءمة القانون.
- لا إنشاء schema ولا SQL apply قبل الاستضافة داخل المنصة.
- لا تنفيذ قرعة من Flutter أو الواجهة.
- كل تنفيذ حقيقي للقرعة يجب أن يكون عبر RPC مدقق يحمل `algorithm_policy_version` و`registration_policy_version` و`quota_snapshot_id`.
- صفحة القانون داخل المشروع تلخص أثر النظام ولا تغني عن الرجوع للنص الرسمي المنشور عند الاعتماد القانوني النهائي.

---

## ملحق v38F — إغلاق الأدوات التشغيلية التحضيرية قبل الانضمام

اعتمدت v38F نطاق **Development / Preparation Only**، ووسّعت حزمة نسك قبل الانضمام بما يلي:

- صفحة إغلاق تحضيري: `/admin/systems/nosok/v38f-prejoin-operational-closure`.
- صفحة محاكاة خوارزمية الحج القانونية: `/admin/systems/nosok/legal-algorithm-simulation`.
- صفحة إغلاق بوابة الشركات: `/admin/systems/nosok/company-workspace-closure`.
- صفحة مصفوفة Public/Responsive UAT: `/admin/systems/nosok/public-responsive-uat`.

تبقى كل هذه الصفحات تحضيرية ولا تنفذ schema أو SQL أو backend binding. التنفيذ الحقيقي بعد استضافة نسك داخل منصة PalWakf واعتماد schema/RPC/RLS.

---

## ملحق v38H — اكتشاف عقد Supabase وتجهيز Adapter

تمت إضافة v38H لتصحيح فجوة مهمة: تصميم schema لا يكفي للربط الحقيقي بقاعدة Supabase. نسك يجب أن يستخدم عميل Supabase المركزي من PalWakf بعد الاستضافة، لا أن ينشئ اتصالًا مستقلًا.

### قرارات v38H

- Supabase initialization يبقى في PalWakf.
- مفاتيح `SUPABASE_URL` و`SUPABASE_ANON_KEY` لا تُخزن داخل نسك.
- `NosokRepository` يتحول لاحقًا إلى `NosokSupabaseRepository` عبر SupabaseService/Provider من المنصة.
- واجهات نسك تستدعي public/admin RPC wrappers، لا الجداول مباشرة.
- Shape discovery يجب أن يسبق إنشاء `nosok schema`.
- لا SQL apply ولا backend binding في v38H.

### المسارات المضافة

- `/admin/systems/nosok/supabase-binding-discovery`
- `/admin/systems/nosok/v38h-supabase-binding`

### ملفات التحضير

- `supabase_binding_contract_pack/`
- `sql/37_nosok_v38h_supabase_binding_contract_discovery.sql`

