# UAT MATRIX — Nosok V27A_LEGACY_REFERENCE_COMPANY_PORTAL

| المسار | الهدف | الحالة |
|---|---|---|
| `/services/nosok` | الصفحة العامة بعد استيعاب مرجع البوابة الحالية | pending local browser UAT |
| `/services/nosok/hajj` | شروط الحج وخطوات التسجيل | pending local browser UAT |
| `/services/nosok/requirements` | المتطلبات والقواعد الموسمية | pending local browser UAT |
| `/services/nosok/companies` | دليل الشركات المؤهلة | pending local browser UAT |
| `/services/nosok/company-login` | Partner Workspace visual contract | pending local browser UAT |
| `/services/nosok/contact` | الدعم والتواصل العام | pending local browser UAT |
| `/systems/nosok/company-login` | legacy redirect compatibility | pending local browser UAT |
| `/systems/nosok/contact` | legacy redirect compatibility | pending local browser UAT |

## أوامر retest المطلوبة

```bash
flutter clean
flutter pub get
dart format .
flutter analyze
flutter run -d chrome
```

## قرار UAT

لا production approval حتى إرفاق analyzer clean وChrome startup وBrowser console وResponsive screenshots.
