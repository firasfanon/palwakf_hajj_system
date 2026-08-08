# UAT MATRIX — Nosok v37G

| المسار | الفحص | الحالة المتوقعة | النتيجة |
|---|---|---|---|
| `/services/nosok/apply` | فتح صفحة التقديم | لا صفحة فارغة، لا RenderFlex unbounded | pending local retest |
| `/services/nosok/apply` desktop | Stepper | أفقي بارتفاع محدود | pending local retest |
| `/services/nosok/apply` mobile | Stepper | عمودي ومناسب للموبايل | pending local retest |
| `/services/nosok` | الصفحة الرئيسية | لا regression | pending local retest |
| `/services/nosok/track` | متابعة الطلب | لا regression | pending local retest |
| Browser console | Render errors | لا RenderBox/MouseTracker cascades | pending local retest |
| `flutter analyze` | Analyzer | No issues found | pending local retest |
| `flutter run -d chrome` | Startup | Chrome startup passed | pending local retest |
