# ERROR RECORD — Nosok v37B

## ملاحظة التصميم الخارجي

**السبب:** الحزمة الخارجية قدمت الصفحة الرئيسية فقط، ولم تغطِّ كل الصفحات الفرعية العامة. كما اقترحت مسارات عامة مثل `/new-request` و`/services/apply` لا تطابق مسارات نسك الحالية.

**الإجراء:** تم اعتماد التصميم كمصدر بصري ومفاهيمي، مع تحويل المسارات إلى:

```text
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/lottery-results
/services/nosok/waiting-list
/services/nosok/objections
/services/nosok/companies
/services/nosok/contact
```

## خطأ محتمل تم تجنبه

**المشكلة:** إدخال مصطلحات Backend/SQL/staging في صفحات المواطن يضعف التجربة العامة.

**الإجراء:** تم تخفيف اللغة التقنية في الصفحات العامة، مع إبقاء التفاصيل الحاكمة داخل `/admin/systems/nosok`.

## آخر baseline مستقر قبل الدفعة

```text
nosok_v37a_premium_public_homepage_visual_upgrade_2026_05_20.zip
```
