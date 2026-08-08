# ERROR RECORD — NOSOK V22

## ER-V22-01 — Full PalWakf repo not present in workspace
- **السبب:** الحزمة الحالية تعمل كـ preview host وليست الريبو الكامل للمنصة.
- **الأثر:** لا يمكن الادعاء أن Real Merge Pack طُبق فعليًا داخل PalWakf من هذه البيئة.
- **الحل:** تجهيز Full Apply Runbook + Merge Evidence Matrix + SQL evidence، ثم تطبيقها في الريبو الكامل محليًا.
- **آخر baseline مستقر:** v21 مع analyzer-clean/chrome-startup evidence من سجل المستخدم.

## ER-V22-02 — Production approval blocked by evidence gates
- **السبب:** إنتاجية نسك تتطلب SQL UAT وBrowser/Role UAT وRBAC override الحقيقي.
- **الأثر:** الإنتاج غير معتمد رغم توسع التشغيل.
- **الحل:** استخدام صفحات v22 وRPCs v22 لاستيعاب الأدلة ثم إعادة قرار البوابة.
