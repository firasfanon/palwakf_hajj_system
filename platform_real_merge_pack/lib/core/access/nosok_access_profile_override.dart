// Apply inside PalWakf ProviderScope only.
// Map PalWakf AccessProfile/admin_users/RBAC into NosokAccessProfile.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/nosok_system/application/access/nosok_access_profile.dart';

class NosokPalWakfAccessProfileMapper {
  const NosokPalWakfAccessProfileMapper._();

  static NosokAccessProfile fromDynamicProfile(dynamic profile) {
    final isAuthenticated = _readBool(
        profile, const ['isAuthenticated', 'authenticated', 'isLoggedIn']);
    final isSuperuser = _readBool(
        profile, const ['isSuperuser', 'isPlatformAdmin', 'superuser']);
    return NosokAccessProfile(
      isAuthenticated: isAuthenticated,
      isSuperuser: isSuperuser,
      roleKeys: _readStringSet(
          profile, const ['roleKeys', 'roles', 'systemRoleKeys']),
      permissionKeys: _readStringSet(profile,
          const ['permissionKeys', 'permissions', 'effectivePermissionKeys']),
      unitIds: _readStringSet(
          profile, const ['unitIds', 'scopeUnitIds', 'assignedUnitIds']),
      unitSlugs: _readStringSet(
          profile, const ['unitSlugs', 'scopeUnitSlugs', 'assignedUnitSlugs']),
      source: 'palwakf',
    );
  }

  static bool _readBool(dynamic source, List<String> names) {
    for (final name in names) {
      try {
        final value = _read(source, name);
        if (value is bool) return value;
      } catch (_) {}
    }
    return false;
  }

  static Set<String> _readStringSet(dynamic source, List<String> names) {
    for (final name in names) {
      try {
        final value = _read(source, name);
        if (value is Iterable)
          return value
              .map((e) => e.toString())
              .where((e) => e.trim().isNotEmpty)
              .toSet();
      } catch (_) {}
    }
    return <String>{};
  }

  static dynamic _read(dynamic source, String name) {
    final asMap = source is Map ? source : null;
    if (asMap != null && asMap.containsKey(name)) return asMap[name];
    // Replace this dynamic adapter with typed AccessProfile mapping once applied in PalWakf.
    throw StateError(
        'Typed platform AccessProfile mapping is required for $name');
  }
}

Override nosokAccessProfileOverrideFrom(dynamic platformAccessProfileProvider) {
  return nosokAccessProfileProvider.overrideWith((ref) {
    final profile = ref.watch(platformAccessProfileProvider);
    return NosokPalWakfAccessProfileMapper.fromDynamicProfile(profile);
  });
}
