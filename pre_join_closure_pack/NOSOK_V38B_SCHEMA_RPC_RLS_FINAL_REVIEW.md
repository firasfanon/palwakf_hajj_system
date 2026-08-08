# Nosok v38B — Schema/RPC/RLS Design Final Review

## قرار حاكم

لا يتم إنشاء schema نسك الآن. التصميم جاهز لكنه غير مطبق.

## الجداول المقترحة

| العلاقة | الوظيفة | الحالة |
|---|---|---|
| `nosok.seasons` | سياسة ومواسم الحج/العمرة | final design / not applied |
| `nosok.applications` | طلبات الجمهور | final design / not applied |
| `nosok.applicants` | بيانات مقدم الطلب | final design / not applied |
| `nosok.companions` | المرافقون والمحرم | final design / not applied |
| `nosok.documents` | بيانات الوثائق وروابط التخزين | final design / not applied |
| `nosok.companies` | الشركات المؤهلة | final design / not applied |
| `nosok.campaigns` | الحملات والسعة | final design / not applied |
| `nosok.lottery_policies` | سياسة القرعة الموسمية | final design / not applied |
| `nosok.lgu_quota_snapshots` | حصة التجمع LGU | final design / not applied |
| `nosok.lottery_draw_runs` | تشغيلات القرعة | final design / not applied |
| `nosok.lottery_draw_results` | النتائج وقوائم الانتظار | final design / not applied |
| `nosok.lottery_committee_decisions` | قرارات لجنة الحج | final design / not applied |
| `nosok.lottery_objections` | الاعتراضات | final design / not applied |
| `nosok.lottery_audit_events` | سجل التدقيق | final design / not applied |

## RPC families

- Public safe: submit application, track request, lottery result lookup, objection submit.
- Citizen scoped: own requests, own documents, own objection.
- Company scoped: company campaigns, linked applicants, missing documents, messages.
- Admin scoped: review queues, eligibility, draw execution, waiting list, committee decisions.
- Superuser scoped: audit evidence, emergency override with reason.

## RLS principles

- لا قراءة مباشرة من public للجداول الحساسة.
- public exposure عبر RPC/view payload آمن فقط.
- company scope يربط الممثل بشركته فقط.
- admin scope يعتمد AccessProfile/RBAC من PalWakf بعد الانضمام.
