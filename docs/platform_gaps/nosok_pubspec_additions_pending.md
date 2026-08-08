# Nosok Pubspec Additions Pending

هذه الدفعة أضافت رفع ملفات فعلي من الجهاز، لذلك يلزم إضافة الحزم التالية داخل `pubspec.yaml` للمنصة قبل التجميع:

```yaml
dependencies:
  file_picker: ^8.1.2
  mime: ^2.0.0
```

> السبب:
- `file_picker`: لاختيار الملفات من الجهاز على Flutter Web/Mobile.
- `mime`: لاشتقاق `contentType` الصحيح عند الرفع إلى Supabase Storage.

لا يوجد تعديل جذري آخر على بنية المنصة المطلوبة من هذه الدفعة خارج dependencies أعلاه.
