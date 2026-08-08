# PalWakf Comprehensive Guide Appendix — Nosok v10.1

هذه الدفعة تثبت قاعدة إضافية في تطوير نسك كنظام شبه مستقل تحت المنصة:

1. أي حزمة تشغيل preview يجب أن تحتوي على `main.dart`, `pubspec.yaml`, وملفات platform target المطلوبة، ولا يكفي وجود feature files فقط.
2. Widgets المشتركة داخل نسك يجب أن تُوسّع بتوافق خلفي عند استعمالها عبر صفحات إدارية متعددة.
3. compile blockers تعالج كـ hotfix موضعي لا كدفعة معمارية جديدة.
4. لا يتم تغيير موقع نسك تحت PalWakf بسبب hotfix تشغيلي.
