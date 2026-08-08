# BASELINE CHANGELOG — Nosok v27C Lottery Governance

**التاريخ:** 2026-05-19  
**الدفعة:** Nosok v27C — Hajj Lottery Governance + Eligibility Rules + LGU Quota Lottery + Waiting List + Committee Decision + Audit Evidence  
**النوع:** Flutter UI/contract + documentation + read-only SQL UAT. لا SQL إنتاجي ولا DML.

## الحكم

```text
staging-stable /
nosok-v27c-lottery-governance-applied /
lgu-quota-policy-configurable /
capacity-aware-draw-engine-contract-applied /
committee-decision-required-for-unfilled-quota /
production-not-approved /
local-flutter-retest-required /
no-waqf-assets-mutation
```

## المبدأ الحاكم الجديد

التسجيل في الحج مفتوح لكل من تنطبق عليه شروط الوزارة، لكن دخول القرعة مشروط بالأهلية واكتمال الطلب. يتم احتساب القرعة حسب العنوان المعتمد في البطاقة الشخصية وربطه بالتجمع/LGU، ولكل تجمع حصة موسمية قابلة للتعديل حسب سياسة الوزارة أو بيانات السكان أو الحصة الرسمية.

## إضافات Flutter

- نموذج سياسة قرعة موسمية قابل للتعديل.
- نموذج snapshot لحصص LGU.
- نموذج مرشح قرعة مع `totalPeopleCount`.
- Provider staging باسم `nosokLotteryDashboardProvider`.
- صفحات جمهور:
  - `/services/nosok/lottery-results`
  - `/services/nosok/waiting-list`
  - `/services/nosok/objections`
- صفحات إدارة:
  - `/admin/systems/nosok/lottery`
  - `/admin/systems/nosok/lottery/eligibility`
  - `/admin/systems/nosok/lottery/draw`
  - `/admin/systems/nosok/lottery/waiting-list`
  - `/admin/systems/nosok/lottery/committee`
  - `/admin/systems/nosok/lottery/audit`

## قواعد الحصة

- الحصة يمكن أن تكون محسوبة: `population_snapshot / quota_divisor`.
- يمكن تجاوزها يدويًا بسياسة موسمية مع audit.
- الاختيار لا يكون بعدد الطلبات فقط، بل بعدد الأشخاص داخل الطلب.
- عند بقاء سعة شاغرة، يبحث النظام داخل نفس LGU عن طلب مؤهل يلائم السعة.
- إذا تعذر الاستكمال من نفس LGU، لا يتم النقل تلقائيًا إلى LGU آخر؛ يلزم قرار لجنة الحج.

## الحدود

- لا تشغيل قرعة إنتاجية.
- لا إنشاء جداول إنتاجية.
- لا تعديل `waqf_assets`.
- لا تعديل schema `waqf`.
- لا تعديل `awqaf_system`.
