import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'access/nosok_access_profile.dart';
import 'nosok_unit_scopes_controller.dart';

class NosokAdministrativeUnitScopeResolution {
  const NosokAdministrativeUnitScopeResolution({
    required this.unitId,
    required this.canonicalSlug,
    required this.unitNameAr,
    required this.unitType,
    required this.governorateId,
    required this.allowedLguIds,
    required this.unitAccessAllowed,
    required this.governorateDerived,
    required this.lguScopeStatus,
  });

  final String unitId;
  final String canonicalSlug;
  final String unitNameAr;
  final String unitType;
  final String? governorateId;
  final Set<String> allowedLguIds;
  final bool unitAccessAllowed;
  final bool governorateDerived;
  final String lguScopeStatus;
}

final nosokAdministrativeUnitScopeProvider =
    FutureProvider.family<NosokAdministrativeUnitScopeResolution?, String>(
        (ref, unitId) async {
  final normalizedId = unitId.trim();
  if (normalizedId.isEmpty) return null;

  final units = await ref.watch(nosokAdminUnitScopesProvider.future);
  final matches = units.where((item) => item.unitId == normalizedId);
  if (matches.isEmpty) return null;
  final unit = matches.first;
  final profile = ref.watch(nosokAccessProfileProvider);

  final governorateId = unit.governorateId?.trim();
  final derivedGovernorate = governorateId != null && governorateId.isNotEmpty;
  final explicitLguIds = profile.lguIds;

  return NosokAdministrativeUnitScopeResolution(
    unitId: unit.unitId,
    canonicalSlug: unit.unitSlug,
    unitNameAr: unit.unitNameAr,
    unitType: unit.unitType ?? 'unknown',
    governorateId: derivedGovernorate ? governorateId : null,
    allowedLguIds: explicitLguIds,
    unitAccessAllowed: profile.canAccessUnit(unitId: unit.unitId),
    governorateDerived: derivedGovernorate,
    lguScopeStatus: explicitLguIds.isEmpty
        ? 'fail-closed-explicit-unit-lgu-mapping-required'
        : 'explicit-access-profile-lgu-scope',
  );
});
