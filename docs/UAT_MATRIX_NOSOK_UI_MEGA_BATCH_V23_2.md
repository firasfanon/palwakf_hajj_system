# UAT MATRIX — Nosok UI Mega Batch v23.2

| المحور | المسار/الفحص | الحالة | ملاحظات |
|---|---|---|---|
| Analyzer | `flutter analyze` | pending retest | v23.2 أصلح blocker `PwfSisNotice.icon`. |
| Chrome startup | `flutter run -d chrome` | pending retest | مطلوب إعادة تشغيل بعد v23.2. |
| Public requirements | `/services/nosok/requirements` | pending | يجب التأكد من ظهور تنبيه مناسكنا دون خطأ. |
| Public home | `/services/nosok` | pending | يجب التأكد من استمرار ذكر مناسكنا كقناة إرشادية. |
| Public apply | `/services/nosok/apply` | pending | Wizard + no overflow. |
| Public tracking | `/services/nosok/track` | pending | لا raw backend errors ولا بيانات حساسة. |
| Internal home | `/admin/systems/nosok` | pending | console منفصل عن public. |
| Requests | `/admin/systems/nosok/requests` | pending | table/cards responsive. |
| Review | `/admin/systems/nosok/review` | pending | Decision panel access-aware. |
| Waqf safety | `waqf/waqf_assets` | passed-by-scope | لا تعديل ضمن v23.2. |
