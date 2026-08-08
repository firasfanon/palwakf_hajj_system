# تعليمات حاكمة لنسك — بناء Schema خاصة وفق متطلبات منصة PalWakf

**المشروع:** PalWakf / Nosok للحج والعمرة  
**التاريخ:** 2026-06-04  
**الصفة:** تعليمات تنفيذية حاكمة قبل بناء السكيما والجداول  
**الحالة:** Pre-Join / Platform-Compliant Owner Schema Build Preparation  
**لا يمثل هذا الملف تفويض إنتاج أو تشغيل قرعة أو فتح طلبات حقيقية.**

---

## 1. القرار الحاكم

```text
NOSOK_BUILDS_ITS_OWNER_SCHEMA_UNDER_PLATFORM_REQUIREMENTS
```

المعنى التنفيذي:

```text
يسمح لنسك ببناء schema خاصة به وجداول تشغيلية داخل nosok.* فقط،
وفق عقد منصة PalWakf،
مع منع إنشاء أي base tables جديدة داخل public،
ومنع تكرار البيانات السيادية الموجودة في core،
ومنع تفعيل الإنتاج قبل UAT وقرار دمج مستقل.
```

---

## 2. الوضع الحالي لنسك

نسك في هذه المرحلة هو:

```text
semi-independent / pre-join / platform-readiness system
```

وليس بعد:

```text
fully merged production system
```

لذلك يسمح له الآن ببناء البنية الخلفية الخاصة به، بشرط أن تكون:

1. داخل `nosok.*`.
2. محكومة بـ RLS/RPC/UAT.
3. قابلة للانضمام إلى المنصة لاحقًا.
4. غير معتمدة للإنتاج حتى صدور قرار مستقل.

---

## 3. قاعدة public

### 3.1 ممنوع داخل public

يمنع على نسك إنشاء أي جداول تشغيلية أو سيادية داخل:

```sql
public.*
```

أمثلة مرفوضة:

```sql
create table public.nosok_applications (...);
create table public.hajj_applications (...);
create table public.nosok_lottery_runs (...);
create table public.nosok_lgu_quotas (...);
create table public.nosok_documents (...);
```

أي SQL يحتوي:

```text
CREATE TABLE public.*
```

يعتبر مرفوضًا تلقائيًا بالقرار:

```text
NOSOK_PUBLIC_BASE_TABLE_CREATION_BLOCKED_OWNER_SCHEMA_REQUIRED
```

### 3.2 المسموح داخل public

`public` يستخدم فقط كطبقة توافق أو واجهة قراءة/استدعاء محكومة:

```text
public views
public RPC wrappers
public compatibility surfaces
```

أمثلة مقبولة بشرط وجود RLS/permissions/audit:

```sql
public.v_nosok_campaigns_public_v1
public.v_nosok_application_tracking_public_v1
public.rpc_nosok_application_track_v1(...)
public.rpc_nosok_campaigns_public_list_v1(...)
```

قاعدة مختصرة:

```text
public is not an owner schema.
public is a compatibility/read/RPC surface only.
```

---

## 4. Schema المالكة لنسك

الاسم المعتمد المقترح:

```sql
nosok
```

كل الجداول التشغيلية الجديدة يجب أن تكون تحت:

```sql
nosok.*
```

قبل التنفيذ يجب تقديم:

1. Schema/table ownership matrix.
2. RLS policy matrix.
3. RPC/view exposure plan.
4. Flutter repository adapter plan.
5. UAT matrix.
6. Rollback/safe disable plan.
7. No-public-base-table proof.

---

## 5. الجداول المسموح تصميمها داخل nosok.*

هذه قائمة أولية قابلة للتعديل بعد التصميم التفصيلي:

| الجدول | الغرض | ملاحظات حاكمة |
|---|---|---|
| `nosok.campaigns` | مواسم/حملات الحج والعمرة | لا تشغيل إنتاجي قبل approval |
| `nosok.applications` | طلبات المواطنين | لا تحفظ بيانات غير لازمة |
| `nosok.application_documents` | مرفقات الطلب | تخزين metadata فقط إذا كانت الملفات في Storage |
| `nosok.eligibility_rules` | شروط الأهلية | قابلة للتعديل بإذن وزاري/إداري |
| `nosok.quota_rules` | قواعد الحصص | لا تعتمد قانونيًا قبل approval |
| `nosok.lgu_quotas` | حصص LGU للموسم | تقرأ LGU من core ولا تكررها كمصدر حقيقة |
| `nosok.lottery_runs` | تشغيلات القرعة | audit إلزامي |
| `nosok.lottery_entries` | مدخلات/نتائج القرعة | immutable بعد الإغلاق إلا بإجراء لجنة |
| `nosok.committee_decisions` | قرارات اللجنة | audit + reason required |
| `nosok.workflow_events` | تاريخ انتقالات الطلب | append-only قدر الإمكان |
| `nosok.tracking_events` | أحداث التتبع العامة | بدون كشف بيانات حساسة |
| `nosok.messages` | رسائل وإشعارات الطلب | privacy-aware |
| `nosok.audit_events` | سجل تدقيق داخلي | لا يعرض للجمهور |
| `nosok.settings` | إعدادات النظام | RBAC صارم |

---

## 6. بيانات core السيادية

لا يملك نسك ولا public مصدر الحقيقة للبيانات المرجعية التالية:

```text
org_units
governorates
LGU
reference geography
unit slugs
```

المصدر السيادي هو:

```sql
core.*
```

نسك يقرأ هذه البيانات فقط عبر:

```text
views/RPC wrappers آمنة
read-only adapters
permission-aware services
```

يمنع تكرارها داخل `nosok.*` كمصدر حقيقة. يمكن تخزين مفاتيح مرجعية فقط مثل:

```text
org_unit_id
lgu_id
governorate_id
unit_slug snapshot عند الحاجة للتدقيق فقط
```

---

## 7. علاقة نسك بمنصة الوصول الموحد

نسك لا يبني:

```text
login page
password recovery page
forbidden page
raw auth error messages
service_role calls
```

يجب أن يستخدم:

```text
PwfPlatformLoginPage
PwfAccessDeniedPage
PwfActorContextStrip
PwfAuthErrorNormalizer
PwfSafeReturnPath
PwfRouteAccessGuard
```

أي مسار إداري داخل نسك يجب أن يمر عبر Platform Access Gateway وRBAC/Scope Guard.

---

## 8. أدوار نسك المقترحة

قبل التنفيذ يجب اعتماد RBAC matrix. الأدوار الأولية المقترحة:

| الدور | النطاق | الصلاحيات الأولية |
|---|---|---|
| `nosok_supervisor` | مركزي | إشراف عام وقراءة تقارير |
| `nosok_unit_admin` | وحدة/LGU | إدارة طلبات ضمن النطاق |
| `nosok_reviewer` | وحدة/مركزي | مراجعة أهلية ووثائق |
| `nosok_committee_member` | لجنة | قرارات لجنة محكومة ومؤرشفة |
| `nosok_viewer` | قراءة فقط | اطلاع محدود |
| `public_applicant` | عام | تقديم/تتبع آمن فقط |

لا يساوي أي دور داخل نسك `platform superuser`.

---

## 9. قرعة نسك والحصص

نظرًا لحساسية نسك قانونيًا، يجب تثبيت الآتي قبل أي تشغيل فعلي:

1. Eligibility rules.
2. Quota per LGU.
3. Lottery algorithm contract.
4. Audit trail لكل تشغيل قرعة.
5. Committee override/shortage rules.
6. Appeal/review path.
7. Freeze window بعد الإغلاق.
8. Immutable results أو controlled reversal protocol.

لا يجوز تشغيل قرعة إنتاجية بناءً على جداول أولية فقط.

---

## 10. RLS/RPC/View requirements

كل جدول في `nosok.*` يحتاج قبل الاعتماد إلى:

```text
RLS enabled
role policies
unit/LGU scope policies
audit policy أو audit trigger عند الحاجة
safe RPC contract
public view/RPC surface عند الضرورة فقط
negative UAT
```

قواعد RPC:

1. لا تستخدم `service_role` من Flutter.
2. `search_path` مقفل في الدوال الحساسة.
3. لا تعرض raw internal payload للجمهور.
4. RPCs العامة تكون tracking/lookup محدودة.
5. RPCs الإدارية تتطلب auth + RBAC + scope.

---

## 11. Flutter repository modes

نسك يجب أن يحافظ على adapters واضحة:

```text
preview
standaloneSupabaseDevelopment
platformHosted
```

القواعد:

| mode | الاستخدام |
|---|---|
| `preview` | بيانات وهمية/واجهة فقط |
| `standaloneSupabaseDevelopment` | تطوير محكوم قبل الدمج |
| `platformHosted` | بعد الدمج مع PalWakf |

لا يجوز استخدام `service_role` داخل أي Flutter mode.

---

## 12. مسارات نسك المقترحة

### Public routes

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/faq
```

### Admin routes

```text
/admin/systems/nosok
/admin/systems/nosok/applications
/admin/systems/nosok/review
/admin/systems/nosok/campaigns
/admin/systems/nosok/quotas
/admin/systems/nosok/lottery
/admin/systems/nosok/documents
/admin/systems/nosok/messages
/admin/systems/nosok/reports
/admin/systems/nosok/settings
```

كل admin route يجب أن يمر عبر Platform Access Gateway.

---

## 13. UAT matrix قبل الدمج الكامل

| الحالة | المتوقع |
|---|---|
| anonymous يفتح صفحة نسك العامة | render آمن |
| anonymous يقدم طلب | submit محكوم أو preview حسب المرحلة |
| anonymous يتتبع طلبًا | لا كشف بيانات حساسة |
| authenticated بلا دور نسك | forbidden عربي |
| مستخدم وحدة يفتح وحدة أخرى | forbidden scope denied |
| reviewer داخل نطاقه | يرى الطلبات المسموحة فقط |
| committee member | يرى قرارات اللجنة فقط حسب الدور |
| admin وحدة | لا يرى وحدات أخرى |
| supervisor مركزي | يرى تقارير حسب السياسة |
| write/review before approval | blocked أو gated |
| public table scan | no new public base tables |
| Flutter scan | no service_role |
| SQL scan | no writes to core/platform/public |

---

## 14. الممنوعات الصريحة

```text
CREATE TABLE public.*
تكرار org_units/governorates/LGU كمصدر حقيقة
service_role داخل Flutter
كتابة في core/platform/gis/public دون تفويض
تشغيل قرعة فعلية قبل audit/legal approval
تشغيل دفع قبل billing/payment contract مستقل
فتح طلبات إنتاجية قبل production gate
حذف أو أرشفة جداول public القديمة دون dependency-zero proof
تجاوز Platform Access Gateway
```

---

## 15. متطلبات التسليم قبل أي SQL تنفيذي

قبل تشغيل أي DDL/DML لنسك، يجب تسليم:

1. `NOSOK_OWNER_SCHEMA_DESIGN.md`
2. `NOSOK_TABLE_OWNERSHIP_MATRIX.csv`
3. `NOSOK_RLS_POLICY_MATRIX.md`
4. `NOSOK_RPC_VIEW_SURFACE_PLAN.md`
5. `NOSOK_CORE_REFERENCE_WRAPPER_PLAN.md`
6. `NOSOK_FLUTTER_REPOSITORY_ADAPTER_PLAN.md`
7. `NOSOK_UAT_MATRIX.md`
8. `NOSOK_NO_PUBLIC_BASE_TABLE_PROOF.sql` read-only
9. `NOSOK_ROLLBACK_AND_DISABLE_PLAN.md`
10. Explicit operator authorization for guarded staging execution.

---

## 16. القرار النهائي

```text
NOSOK_BUILDS_ITS_OWNER_SCHEMA_UNDER_PLATFORM_REQUIREMENTS
```

ويُقرأ معه:

```text
Nosok owns nosok.* operational data.
Core owns sovereign reference data.
Platform owns access/auth/navigation.
Public owns only compatibility views/RPCs.
Production remains blocked until UAT and independent approval.
```

---

## 17. الحالة

```text
pre-join-ready / owner-schema-build-authorized-under-platform-contract / no-public-base-tables / no-production-approval
```
