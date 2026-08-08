# UAT Matrix — Nosok v38D

| المسار | المطلوب |
|---|---|
| `/admin/systems/nosok/dynamic-pages` | يفتح كصفحة عقد تحضيري للصفحات والأقسام |
| `/admin/systems/nosok/v38d-dynamic-pages-prejoin` | يعرض ملخص v38D وأزرار فتح العقود |
| `/admin/systems/nosok/homepage-sections` | يبقى يعمل ولا يتعارض مع منشئ الصفحات |
| `/services/nosok` | لا يتغير كسطح عام ولا يعتمد DB |

## نجاح الفحص
- `flutter analyze` clean.
- لا Page Not Found للمسارات الجديدة في مشروع نسك standalone.
- لا ألوان وردية/زهري.
- لا SQL apply.
