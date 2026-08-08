# Route Registration Pending

بعد مرجع v73 أصبح واضحًا أن `/nosok` ليس مناسبًا كمدخل عام بسبب تعارضه المحتمل مع `/:unitSlug`. المقترح المحفوظ داخل مشروع نسك هو:

- `/switch/nosok`
- `/systems/nosok`
- `/systems/nosok/hajj`
- `/systems/nosok/umrah`
- `/systems/nosok/companies`
- `/systems/nosok/complaints`
- `/systems/nosok/faq`
- `/systems/nosok/apply`
- `/systems/nosok/application-status`

أما الإدارة الحاكمة فتبقى تحت `/admin/systems/nosok`، مع إبقاء `/admin/nosok` كتحويل legacy فقط.
