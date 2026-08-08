import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../system_permissions.dart';
import '../../system_routes.dart';

class NosokAccessProfile {
  const NosokAccessProfile({
    required this.isAuthenticated,
    required this.isSuperuser,
    required this.roleKeys,
    required this.permissionKeys,
    this.unitIds = const <String>{},
    this.unitSlugs = const <String>{},
    this.source = 'unbound',
  });

  final bool isAuthenticated;
  final bool isSuperuser;
  final Set<String> roleKeys;
  final Set<String> permissionKeys;
  final Set<String> unitIds;
  final Set<String> unitSlugs;
  final String source;

  bool get isPlatformBound => source != 'unbound';

  bool hasAnyPermission(Set<String> requiredPermissions) {
    if (isSuperuser) return true;
    if (permissionKeys.contains(NosokPermissionKeys.manageNosok)) return true;
    if (requiredPermissions.isEmpty) return isAuthenticated;
    return requiredPermissions.any(permissionKeys.contains);
  }

  bool canOpenRoute(String path) {
    final required = NosokRouteAccessContract.requiredPermissionsForPath(path);
    return hasAnyPermission(required);
  }

  bool canAccessUnit({String? unitId, String? unitSlug}) {
    if (isSuperuser) return true;
    if (unitId != null && unitId.trim().isNotEmpty && unitIds.contains(unitId))
      return true;
    if (unitSlug != null &&
        unitSlug.trim().isNotEmpty &&
        unitSlugs.contains(unitSlug)) return true;
    return unitIds.isEmpty &&
        unitSlugs.isEmpty &&
        hasAnyPermission({NosokPermissionKeys.manageNosokUnits});
  }

  static const unbound = NosokAccessProfile(
    isAuthenticated: false,
    isSuperuser: false,
    roleKeys: <String>{},
    permissionKeys: <String>{},
    source: 'unbound',
  );

  static const standaloneSuperuser = NosokAccessProfile(
    isAuthenticated: true,
    isSuperuser: true,
    roleKeys: <String>{'standaloneSuperuser'},
    permissionKeys: NosokSystemPermissionsProposal.admin,
    unitIds: <String>{'home', 'bethlehem', 'hebron', 'jerusalem'},
    unitSlugs: <String>{'home', 'bethlehem', 'hebron', 'jerusalem'},
    source: 'standalone-preview',
  );

  NosokAccessProfile copyWith({
    bool? isAuthenticated,
    bool? isSuperuser,
    Set<String>? roleKeys,
    Set<String>? permissionKeys,
    Set<String>? unitIds,
    Set<String>? unitSlugs,
    String? source,
  }) {
    return NosokAccessProfile(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSuperuser: isSuperuser ?? this.isSuperuser,
      roleKeys: roleKeys ?? this.roleKeys,
      permissionKeys: permissionKeys ?? this.permissionKeys,
      unitIds: unitIds ?? this.unitIds,
      unitSlugs: unitSlugs ?? this.unitSlugs,
      source: source ?? this.source,
    );
  }
}

final nosokAccessProfileProvider = Provider<NosokAccessProfile>((ref) {
  // Fail-closed by default under PalWakf. The platform must override this
  // provider from AccessProfile/admin_users/RBAC. Standalone main.dart
  // overrides it with NosokAccessProfile.standaloneSuperuser.
  return NosokAccessProfile.unbound;
});

class NosokRouteAccessContract {
  const NosokRouteAccessContract._();

  static Set<String> requiredPermissionsForPath(String path) {
    if (path == NosokSystemRoutes.adminHome) {
      return {NosokPermissionKeys.viewNosokDashboard};
    }
    if (path.startsWith(NosokSystemRoutes.adminSeasons)) {
      return {NosokPermissionKeys.manageNosokSeasons};
    }
    if (path.startsWith(NosokSystemRoutes.adminPrograms)) {
      return {NosokPermissionKeys.manageNosokPrograms};
    }
    if (path.startsWith(NosokSystemRoutes.adminCompanies)) {
      return {NosokPermissionKeys.manageNosokCompanies};
    }
    if (path.startsWith(NosokSystemRoutes.adminApplications)) {
      return {
        NosokPermissionKeys.manageNosokApplications,
        NosokPermissionKeys.reviewNosokApplications
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminComplaints)) {
      return {NosokPermissionKeys.manageNosokComplaints};
    }
    if (path.startsWith(NosokSystemRoutes.adminContent)) {
      return {NosokPermissionKeys.manageNosokContent};
    }
    if (path.startsWith(NosokSystemRoutes.adminHomepageSections)) {
      return {
        NosokPermissionKeys.manageNosokHomepageSections,
        NosokPermissionKeys.manageNosokContent
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminDynamicPages)) {
      return {
        NosokPermissionKeys.manageNosokDynamicPages,
        NosokPermissionKeys.manageNosokContent
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminUnitScopeAccess)) {
      return {
        NosokPermissionKeys.manageNosokUnitScopeAccess,
        NosokPermissionKeys.manageNosokUnits
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminRegistrationGovernance)) {
      return {
        NosokPermissionKeys.manageNosokRegistrationGovernance,
        NosokPermissionKeys.viewNosokSeasonCommand
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminLegalCompliance)) {
      return {
        NosokPermissionKeys.manageNosokLegalCompliance,
        NosokPermissionKeys.viewNosokLotteryAudit
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminLegalAlgorithmSimulation)) {
      return {
        NosokPermissionKeys.manageNosokLegalCompliance,
        NosokPermissionKeys.executeNosokLotteryDraw
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminCompanyWorkspaceClosure)) {
      return {NosokPermissionKeys.manageNosokCompanies};
    }
    if (path.startsWith(NosokSystemRoutes.adminPublicResponsiveUat)) {
      return {
        NosokPermissionKeys.intakeNosokBrowserRoleEvidence,
        NosokPermissionKeys.closeNosokBrowserRoleResponsiveUat
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminStandaloneSupabaseDevelopment) ||
        path.startsWith(
            NosokSystemRoutes.adminV38IStandaloneSupabaseDevelopment)) {
      return {
        NosokPermissionKeys.manageNosokStandaloneSupabaseDevelopment,
        NosokPermissionKeys.manageNosokSupabaseBindingDiscovery,
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminSupabaseBindingDiscovery) ||
        path.startsWith(NosokSystemRoutes.adminV38HSupabaseBinding)) {
      return {
        NosokPermissionKeys.manageNosokSupabaseBindingDiscovery,
        NosokPermissionKeys.manageNosokPlatformIntegrationReadiness,
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminPlatformSchemaBindings) ||
        path.startsWith(NosokSystemRoutes.adminV38GPlatformSchemaBinding)) {
      return {
        NosokPermissionKeys.manageNosokPlatformSchemaBindings,
        NosokPermissionKeys.manageNosokPlatformIntegrationReadiness,
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminReports)) {
      return {NosokPermissionKeys.viewNosokReports};
    }
    if (path.startsWith(NosokSystemRoutes.adminUnits)) {
      return {NosokPermissionKeys.manageNosokUnits};
    }
    if (path.startsWith(NosokSystemRoutes.adminUsersRoles)) {
      return {NosokPermissionKeys.manageNosokAccess};
    }
    if (path.startsWith(NosokSystemRoutes.adminSidebar)) {
      return {NosokPermissionKeys.manageNosokSurface};
    }
    if (path.startsWith(NosokSystemRoutes.adminSettings)) {
      return {NosokPermissionKeys.manageNosokSettings};
    }
    if (path.startsWith(NosokSystemRoutes.adminHealth)) {
      return {NosokPermissionKeys.viewNosokHealth};
    }
    if (path.startsWith(NosokSystemRoutes.adminOperations)) {
      return {NosokPermissionKeys.viewNosokOperations};
    }
    if (path.startsWith(NosokSystemRoutes.adminPaymentBridge)) {
      return {
        NosokPermissionKeys.manageNosokPaymentBridge,
        NosokPermissionKeys.executeNosokBillingBridge
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminUnitQueues)) {
      return {NosokPermissionKeys.viewNosokUnitQueues};
    }
    if (path.startsWith(NosokSystemRoutes.adminRoleUat)) {
      return {
        NosokPermissionKeys.viewNosokRoleUat,
        NosokPermissionKeys.manageNosokRoleUatEvidence
      };
    }
    if (path.startsWith(NosokSystemRoutes.adminNotifications)) {
      return {NosokPermissionKeys.manageNosokNotifications};
    }

    if (path.startsWith(NosokSystemRoutes.adminRealPlatformMerge)) {
      return {NosokPermissionKeys.manageNosokRealPlatformMerge};
    }
    if (path.startsWith(NosokSystemRoutes.adminRbacProviderOverride)) {
      return {NosokPermissionKeys.manageNosokRbacProviderOverride};
    }
    if (path.startsWith(NosokSystemRoutes.adminSqlUatIntake)) {
      return {NosokPermissionKeys.intakeNosokSqlUatResults};
    }
    return <String>{};
  }
}
