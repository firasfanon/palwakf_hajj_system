# Nosok v37 — شرح مبسط للمهمة والمصطلحات

## ما الذي نفعله؟

هذه دفعة تطوير كبيرة وليست حوكمة فقط. الهدف هو نقل نسك من مرحلة وجود `nosok.*` و`public RPC wrappers` إلى مرحلة تجهيز ربط الواجهة العامة بمستودع بيانات محكوم عبر wrappers.

## المصطلحات

- **Repository Binding**: ربط صفحات Flutter بمصدر بيانات حقيقي بدل بيانات preview.
- **Runtime Switch Candidate**: مرشح ربط جاهز للتجربة، لكنه ليس مفعلًا كربط إنتاجي عام.
- **Fallback-safe**: إذا فشل RPC أو رجع empty، لا تنهار الصفحة وتبقى الرسالة آمنة.
- **Network Evidence**: لقطة DevTools Network تثبت أن الصفحة استدعت RPC المطلوب.
- **Negative UAT**: اختبار مستخدم غير مصرح أو نطاق وحدة خاطئ للتأكد من المنع الآمن.

## القرار

```text
V37_PUBLIC_REPOSITORY_BINDING_RUNTIME_SWITCH_CANDIDATE_PREPARED_PRODUCTION_DEFERRED
```

يعني أن الربط المرشح جاهز، لكن الإنتاج والـ platformHosted switch مؤجلان حتى ظهور Network RPC evidence وسيناريوهات الدور/النطاق.
