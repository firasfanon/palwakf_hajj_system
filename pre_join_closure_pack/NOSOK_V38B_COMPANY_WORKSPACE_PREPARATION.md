# Nosok v38B — Company / Partner Workspace Preparation

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

## تعريف بوابة الشركة

بوابة الشركة ليست لوحة وزارة وليست Admin Console. هي **مساحة شريك تشغيلية** للشركات المؤهلة ضمن نطاقها فقط.

## نطاق ممثل الشركة

| العقد | الوصف | الحالة قبل الانضمام |
|---|---|---|
| `company_rep_scope` | ممثل الشركة يرى نطاق شركته فقط | contract-ready / backend deferred |
| `campaign_capacity` | حملات الشركة والسعة | contract-ready / backend deferred |
| `linked_applicants` | الحجاج/الطلبات المرتبطة بالشركة | contract-ready / backend deferred |
| `missing_documents` | نواقص الوثائق ضمن نطاق الشركة | contract-ready / backend deferred |
| `partner_messages` | مراسلات الوزارة والشركة | contract-ready / backend deferred |
| `company_reports` | تقارير الشركة الموسمية | contract-ready / backend deferred |

## ما لا يجوز للشركة رؤيته

- طلبات شركات أخرى.
- ملاحظات موظفين داخلية خارج سياسة العرض.
- Audit الوزارة.
- صلاحيات النظام.
- إعدادات القرعة والسياسات.
- بيانات حساسة لمواطنين خارج نطاق التفويض.

## جاهزية الانضمام

يتم تسليم هذا النطاق إلى PalWakf كمتطلبات RBAC وRoute Guard وData Boundary. التنفيذ الفعلي ينتظر schema وربط backend بعد الانضمام.
