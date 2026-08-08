# Nosok v38B — Public Runtime UAT Closure Pack

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

## الغرض

هذه الوثيقة تغلق نطاق فحص واجهات الجمهور قبل تسليم نسك كحزمة جاهزة للانضمام إلى PalWakf. لا تعني هذه الوثيقة أن الدمج تم أو أن backend موجود.

## المسارات العامة المطلوب فحصها

| المسار | الهدف | شرط الإغلاق |
|---|---|---|
| `/services/nosok` | الصفحة الرئيسية العامة | واجهة حديثة، لا لغة تقنية، لا ألوان وردية/زهري |
| `/services/nosok/apply` | تقديم طلب | لا صفحة بيضاء، لا RenderFlex، نموذج مواطن لا Stepper إداري |
| `/services/nosok/track` | متابعة طلب | لا كشف بيانات حساسة، lookup آمن |
| `/services/nosok/lottery-results` | نتائج القرعة | نتيجة المواطن فقط، لا بيانات الآخرين |
| `/services/nosok/waiting-list` | قائمة الانتظار | عرض حالة/ترتيب المواطن فقط حسب السياسة |
| `/services/nosok/objections` | الاعتراضات | نموذج اعتراض واضح بدون backend وهمي |
| `/services/nosok/companies` | الشركات المؤهلة | دليل عام غير إداري |
| `/services/nosok/contact` | التواصل | دعم ومساعدة بلغة المواطن |
| `/services/nosok/complaints` | الشكاوى | قناة شكوى/ملاحظة عامة |
| `/services/nosok/faq` | الأسئلة الشائعة | Accordion/محتوى مبسط عند الحاجة |

## قواعد الواجهة العامة

- لا تعرض `schema`, `RPC`, `RLS`, `SQL`, `backend`, `production gate` للمواطن.
- لا تستخدم اللون الزهري أو الوردي أو مشتقاته.
- استخدم الأزرق السيادي والذهبي الوقفي والأخضر للحالات الإيجابية والأحمر الملكي للتنبيه الحقيقي فقط.
- كل صفحة عامة يجب أن تكون RTL وMobile-first.
- أي ربط غير موجود backend يظهر كـ planned/disabled لا كوظيفة عاملة.

## حالة v38B

جاهز كـ UAT target. الدليل الفعلي للمتصفح يبقى مطلوبًا عند تشغيل المشروع محليًا أو داخل PalWakf لاحقًا.
