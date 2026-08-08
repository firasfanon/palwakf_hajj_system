# UAT MATRIX — Nosok v37A Premium Public Homepage

| البوابة | الاختبار | الحالة المتوقعة |
|---|---|---|
| Public homepage | فتح `/services/nosok` | يظهر Hero قوي وخدمات مرتبة دون طابع إداري |
| Navigation | الشريط العلوي | عناصر مختصرة: الرئيسية، تقديم طلب، متابعة، نتائج القرعة، الشركات، المساعدة، المزيد، دخول الموظفين |
| More menu | قائمة المزيد | تعرض الحج، العمرة، الشروط، قائمة الانتظار، الاعتراضات، بوابة الشركات، الأسئلة، الشكاوى |
| CTA | تقديم طلب جديد | ينتقل إلى `/services/nosok/apply` |
| CTA | متابعة طلب | ينتقل إلى `/services/nosok/track` |
| CTA | نتائج القرعة | ينتقل إلى `/services/nosok/lottery-results` |
| Seasonal banner | حالة الموسم | نص واضح للمواطن دون مصطلحات backend/registry/RLS |
| Responsive | عرض mobile/tablet | لا overflow، وتتحول العناصر إلى stacking منطقي |
| Admin entry | دخول الموظفين | واضح لكنه أقل حضورًا من CTA المواطن، وينتقل إلى `/admin/systems/nosok` |
| Governance | صفحة الجمهور | لا تعرض schema/backend binding/RLS/production gate |
