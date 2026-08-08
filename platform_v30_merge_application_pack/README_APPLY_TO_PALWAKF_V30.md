# Nosok v30 — Apply to PalWakf

## الهدف

نقل نسك إلى ريبو PalWakf كنظام شبه مستقل تحت المنصة، دون إنشاء قاعدة البيانات في هذه الخطوة.

## خطوات الدمج

1. انسخ:

```text
lib/features/nosok_system
```

إلى:

```text
PalWakf/lib/features/nosok_system
```

2. اربط routes عبر:

```dart
NosokRoutes.buildRoutes()
```

ضمن GoRouter الخاص بالمنصة.

3. سجل النظام في Dynamic System Registry:

```text
system_key = nosok
route_base = /admin/systems/nosok
public_route_base = /services/nosok
system_type = semi_independent_service_system
owner_schema = nosok بعد إنشاء schema لاحقًا
```

4. اربط AccessProfile الحقيقي بدل preview profile.

5. نفذ Browser/Role/Responsive UAT داخل PalWakf.

6. بعد نجاح الدمج فقط، جهز إنشاء schema `nosok` في sandbox.

## ممنوع

- لا SQL production.
- لا إنشاء schema الآن.
- لا DML.
- لا تعديل على `waqf_assets`.
