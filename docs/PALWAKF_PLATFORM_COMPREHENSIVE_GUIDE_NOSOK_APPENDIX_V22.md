# PALWAKF PLATFORM COMPREHENSIVE GUIDE — NOSOK APPENDIX V22

## القاعدة الحاكمة
نسك نظام شبه مستقل تحت PalWakf، وليس منصة موازية. يجب تطبيقه داخل Dynamic Registry وRBAC وSystem Sections وPWF-SIS الخاصة بالمنصة.

## قرار v22
- Preview host مستقر.
- حزمة الدمج الحقيقي جاهزة.
- الإنتاج غير معتمد حتى تنفيذ الدمج داخل الريبو الكامل وتشغيل SQL/Browser/Role UAT.

## المتبقي الحرج
1. Full PalWakf repo apply.
2. AccessProfile provider override.
3. SQL UAT evidence.
4. Browser/Role UAT evidence.
5. Production gate decision record.

## علاقة نسك بالمنصة
- Auth/RBAC: المنصة.
- الوحدات: `core.org_units`.
- الدفع: `billing_system`.
- الإشعارات: خدمة إشعارات المنصة.
- نسك يملك domain workflow فقط: مواسم، برامج، شركات، طلبات، وثائق، دفعات، متابعة، شكاوى.
