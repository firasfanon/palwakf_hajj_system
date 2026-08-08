# Nosok v36 — Production Gate Re-decision

## القرار

```text
V36_PRODUCTION_GATE_REDECISION_STAGING_CANDIDATE_ONLY_PRODUCTION_NOT_APPROVED
```

## المقبول

- `nosok.*` موجودة.
- الجداول الثمانية موجودة.
- RLS مفعّل.
- public wrappers/RPCs موجودة.
- Grants موجودة لـ `anon` و`authenticated`.
- لا توجد public base tables جديدة.

## المحجوب

- Browser/Role/Scope evidence لم يغلق.
- Repository global switch لم ينفذ.
- Admin RPCs غير موجودة بعد.
- الدفع والإنتاج غير معتمدين.

## التالي

تشغيل SQL 35 read-only ثم تزويد Browser/Role/Scope evidence. بعد ذلك v37 إما يربط public repository فعليًا أو يغلق production gate بالرفض/التأجيل.
