# UAT Matrix — Nosok v38E

| المسار | المتوقع |
|---|---|
| `/services/nosok/legal-regulation` | صفحة قانون عامة مبسطة بدون لغة backend |
| `/admin/systems/nosok/legal-compliance` | صفحة امتثال قانوني تعرض التسجيل والخوارزمية والجداول/RPC draft |
| `/admin/systems/nosok/v38e-legal-lottery-alignment` | صفحة قرار v38E وتوضيح منع الانضمام قبل المواءمة |
| `/admin/systems/nosok/registration-governance` | تظهر الإشارة إلى نظام 15/2025 ضمن قيود التسجيل |
| `/admin/systems/nosok/lottery/draw` | يظهر أن القرعة قانونية الخوارزمية وليس capacity-aware فقط |

## فحص محلي

```bash
dart format .
flutter analyze
flutter run -d chrome
```
