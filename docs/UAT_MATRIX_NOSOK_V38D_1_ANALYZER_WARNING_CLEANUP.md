# UAT Matrix — Nosok v38D-1

| المسار / الفحص | الحالة | القرار |
|---|---|---|
| dart format . | pending local retest | يجب إعادة التشغيل بعد v38D-1 |
| flutter analyze | pending local retest | متوقع clean بعد حذف الاستيرادين |
| flutter run -d chrome | pending local retest | متوقع startup passed |
| /admin/systems/nosok/dynamic-pages | previously displayed | إعادة فحص بصري |
| /admin/systems/nosok/v38d-dynamic-pages-prejoin | previously displayed | إعادة فحص بصري |
| /admin/systems/nosok/homepage-sections | previously displayed | إعادة فحص بصري |
| /admin/systems/nosok/unit-scope-access | previously displayed | إعادة فحص بصري |
| /admin/systems/nosok/registration-governance | previously displayed | إعادة فحص بصري |

## موانع الإنتاج

لا يوجد اعتماد إنتاج، ولا يوجد إنشاء schema أو SQL apply أو backend binding قبل استضافة نسك داخل PalWakf.
