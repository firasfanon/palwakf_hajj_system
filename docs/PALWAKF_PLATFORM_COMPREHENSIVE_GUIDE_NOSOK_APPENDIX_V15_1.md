# PalWakf Comprehensive Guide Appendix — Nosok v15.1

اعتماد Nosok v15.1 كتصحيح موضعي فوق v15 لمعالجة compile blocker في سايدبار النظام الإداري.

## Governance
- لا تعديل على `waqf_assets` أو `waqf` أو `awqaf_system`.
- لا تغيير في عقد المسارات أو RBAC.
- لا SQL جديد في هذه الدفعة.
- PalWakf هي المنصة الأم، ونسك نظام شبه مستقل تحتها.

## Fix Summary
تم إكمال بنية تجميع السايدبار التي بدأها v15 بإضافة helper classes محلية داخل `nosok_admin_system_shell.dart`.
