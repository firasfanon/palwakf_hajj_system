# UAT MATRIX — Nosok v37B

| المسار | المطلوب فحصه | الحالة |
|---|---|---|
| `/services/nosok` | Hero قوي، خدمات رئيسية، رحلة المواطن، الشفافية | pending-local-browser-uat |
| `/services/nosok/hajj` | صفحة حج خدمية بدون لغة تقنية | pending-local-browser-uat |
| `/services/nosok/umrah` | صفحة عمرة خدمية حديثة | pending-local-browser-uat |
| `/services/nosok/apply` | صياغة مواطن للنموذج | pending-local-browser-uat |
| `/services/nosok/track` | متابعة برقم الطلب/رمز التتبع | pending-local-browser-uat |
| `/services/nosok/requirements` | شروط واضحة ومبسطة | pending-local-browser-uat |
| `/services/nosok/companies` | بحث الشركات بواجهة عامة | pending-local-browser-uat |
| `/services/nosok/contact` | المساعدة والتواصل | pending-local-browser-uat |
| `/services/nosok/complaints` | شكاوى عامة بدون بيانات حساسة | pending-local-browser-uat |
| `/services/nosok/faq` | أسئلة شائعة Accordion | pending-local-browser-uat |
| `/services/nosok/lottery-results` | إزالة لغة staging/Backend من الجمهور | pending-local-browser-uat |
| `/services/nosok/waiting-list` | قائمة انتظار حسب التجمع | pending-local-browser-uat |
| `/services/nosok/objections` | اعتراضات بلغة المواطن | pending-local-browser-uat |

## فحوص عامة

- لا raw backend errors.
- لا مصطلحات schema/RLS/RPC/SQL في الواجهة العامة.
- لا overflow على mobile.
- زر الموظفين واضح لكنه غير مسيطر.
- المسارات تستعمل `/services/nosok/...` لا المسارات العامة المقترحة خارج المشروع.
