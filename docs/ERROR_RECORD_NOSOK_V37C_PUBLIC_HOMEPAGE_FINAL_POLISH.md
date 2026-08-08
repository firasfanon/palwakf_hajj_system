# ERROR RECORD — Nosok v37C

## المشكلة التصميمية

ظهور لون زهري/وردي في بعض الشارات الموسمية والتحذيرية لا ينسجم مع هوية الأزرق السيادي/الذهبي الوقفي.

## السبب

استخدام `errorContainer.withValues(alpha: .45)` لنبرة `warning` جعل التحذير يميل للزهري نتيجة ColorScheme الناتج من seed الأزرق.

## الحل

تعريف لون ذهبي تحذيري داخل مكونات PWF-SIS المحلية لنسك:

```text
#F9F3E7 background
#D7B56D border
#5D4215 text/icon
```

## الحالة

Fixed in v37C. يحتاج retest محلي.
