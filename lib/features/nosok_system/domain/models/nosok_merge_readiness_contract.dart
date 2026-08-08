class NosokV29MergeReadinessContract {
  const NosokV29MergeReadinessContract({
    required this.version,
    required this.status,
    required this.databaseState,
    required this.productionDecision,
    required this.registryBindings,
    required this.schemaTables,
    required this.rbacBindings,
    required this.frontendSurfaces,
    required this.integrationSteps,
    required this.preDatabasePack,
    required this.productionBlockers,
  });

  final String version;
  final String status;
  final String databaseState;
  final String productionDecision;
  final List<NosokRegistryBindingContract> registryBindings;
  final List<NosokSchemaTableDesign> schemaTables;
  final List<NosokRbacBindingContract> rbacBindings;
  final List<NosokFrontendRuntimeSurface> frontendSurfaces;
  final List<NosokMergeIntegrationStep> integrationSteps;
  final List<String> preDatabasePack;
  final List<String> productionBlockers;

  int get registryBindingCount => registryBindings.length;
  int get schemaTableCount => schemaTables.length;
  int get rbacBindingCount => rbacBindings.length;
  int get frontendSurfaceCount => frontendSurfaces.length;
  int get integrationStepCount => integrationSteps.length;
}

class NosokRegistryBindingContract {
  const NosokRegistryBindingContract({
    required this.key,
    required this.titleAr,
    required this.platformSurface,
    required this.expectedBinding,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String platformSurface;
  final String expectedBinding;
  final String status;
}

class NosokSchemaTableDesign {
  const NosokSchemaTableDesign({
    required this.name,
    required this.purposeAr,
    required this.ownerScope,
    required this.primaryRelations,
    required this.privacyPolicyAr,
    required this.status,
  });

  final String name;
  final String purposeAr;
  final String ownerScope;
  final List<String> primaryRelations;
  final String privacyPolicyAr;
  final String status;
}

class NosokRbacBindingContract {
  const NosokRbacBindingContract({
    required this.roleKey,
    required this.roleAr,
    required this.allowedSurfacesAr,
    required this.deniedSurfacesAr,
    required this.platformPermissionContract,
  });

  final String roleKey;
  final String roleAr;
  final String allowedSurfacesAr;
  final String deniedSurfacesAr;
  final String platformPermissionContract;
}

class NosokFrontendRuntimeSurface {
  const NosokFrontendRuntimeSurface({
    required this.route,
    required this.surfaceAr,
    required this.runtimeState,
    required this.bindingMode,
    required this.status,
  });

  final String route;
  final String surfaceAr;
  final String runtimeState;
  final String bindingMode;
  final String status;
}

class NosokMergeIntegrationStep {
  const NosokMergeIntegrationStep({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.owner,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final String owner;
  final String status;
}
