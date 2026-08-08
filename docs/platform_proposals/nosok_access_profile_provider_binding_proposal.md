# Nosok v10 — AccessProfile Provider Binding Proposal

## الهدف
ربط نظام نسك شبه المستقل بمصدر الصلاحيات الحاكم في PalWakf دون إنشاء جدول مستخدمين داخل `nosok`.

## قاعدة حاكمة
- `admin_users` و`AccessProfile` وplatform RBAC هي المصدر.
- `nosokAccessProfileProvider` هو نقطة حقن فقط داخل Flutter.
- عند الدمج الإنتاجي يجب على المنصة override لهذا provider من `AccessProfile` الحقيقي.

## مثال ربط داخل منصة PalWakf
```dart
ProviderScope(
  overrides: [
    nosokAccessProfileProvider.overrideWith((ref) {
      final profile = ref.watch(accessProfileProvider);
      return NosokAccessProfile(
        isAuthenticated: profile.isAuthenticated,
        isSuperuser: profile.isSuperuser || profile.hasPlatformSuperuserOverride,
        roleKeys: profile.roleKeys,
        permissionKeys: profile.permissionKeys,
        unitIds: profile.unitIds,
        unitSlugs: profile.unitSlugs,
        source: 'palwakf-access-profile',
      );
    }),
  ],
  child: child,
)
```

## أثر الربط
- تصفية سايدبار نسك حسب الصلاحيات.
- حراسة الصفحات الإدارية عبر `NosokAccessGate`.
- دعم Superuser override.
- دعم unit scope عبر `unitIds/unitSlugs`.

## عدم التنفيذ داخل نسك
لا يحق لنسك إنشاء مصدر مستخدمين أو أدوار خاص به. قوالب الأدوار داخل نسك تُعرض كمرجع تسجيل فقط.
