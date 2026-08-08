# PALWAKF PLATFORM COMPREHENSIVE GUIDE — Nosok UI A–E Appendix

## قاعدة حاكمة مضافة

نظام نسك للحج والعمرة يجب أن يقدم واجهتين منفصلتين بصريًا ووظيفيًا ضمن نفس النظام:

1. **Public Service Portal** للمواطن والجمهور.
2. **Internal Operations Console** للموظف والإدارة.

القاعدة:

```text
شاشة المواطن = رحلة خدمة
شاشة الموظف = مساحة تشغيل
البيانات وسير العمل مشتركة خلفيًا
```

## PWF-SIS

- الهوية والمكونات والـ runtime states مملوكة للمنصة.
- نسك يملك البيانات وسير العمل الخاص بالحج والعمرة فقط.
- لا يجوز إنشاء design system منفصل لنسك.
- لا يجوز عرض أخطاء backend الخام.
- الجداول الثقيلة لا تظهر في الصفحة الرئيسية الداخلية.
- النماذج الطويلة يجب أن تكون wizard أو progressive disclosure.

## المسارات الحاكمة

Public:

```text
/services/nosok
/services/nosok/apply
/services/nosok/track
/services/nosok/requirements
/services/nosok/faq
```

Internal:

```text
/admin/systems/nosok
/admin/systems/nosok/requests
/admin/systems/nosok/review
/admin/systems/nosok/campaigns
/admin/systems/nosok/groups
/admin/systems/nosok/documents
/admin/systems/nosok/messages
/admin/systems/nosok/reports
/admin/systems/nosok/settings
```

## الإنتاج

لا يجوز اعتماد نسك production-ready قبل:

- Full PalWakf merge evidence.
- RBAC Provider Override الحقيقي.
- Supabase SQL UAT.
- Role UAT.
- Responsive UAT.
- Browser console review.
- Public tracking privacy check.

## السيادة

هذه الدفعة لم تلمس:

- `waqf_assets`
- schema `waqf`
- `awqaf_system`
- SQL إنتاجي أو DML
