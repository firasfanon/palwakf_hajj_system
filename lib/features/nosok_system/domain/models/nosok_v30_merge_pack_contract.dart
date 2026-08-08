class NosokV30MergePackContract {
  const NosokV30MergePackContract({
    required this.version,
    required this.status,
    required this.productionDecision,
    required this.databaseState,
    required this.mergeApplicationSteps,
    required this.registryEntries,
    required this.rbacClosures,
    required this.palwakfUatSurfaces,
    required this.schemaPreparationItems,
    required this.blockers,
  });

  final String version;
  final String status;
  final String productionDecision;
  final String databaseState;
  final List<NosokV30MergeStep> mergeApplicationSteps;
  final List<NosokV30RegistryEntry> registryEntries;
  final List<NosokV30RbacClosure> rbacClosures;
  final List<NosokV30UatSurface> palwakfUatSurfaces;
  final List<NosokV30SchemaPreparationItem> schemaPreparationItems;
  final List<String> blockers;

  int get mergeStepCount => mergeApplicationSteps.length;
  int get registryEntryCount => registryEntries.length;
  int get rbacClosureCount => rbacClosures.length;
  int get uatSurfaceCount => palwakfUatSurfaces.length;
  int get schemaPreparationCount => schemaPreparationItems.length;
}

class NosokV30MergeStep {
  const NosokV30MergeStep({
    required this.key,
    required this.titleAr,
    required this.actionAr,
    required this.targetPath,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String actionAr;
  final String targetPath;
  final String status;
}

class NosokV30RegistryEntry {
  const NosokV30RegistryEntry({
    required this.key,
    required this.platformObject,
    required this.valueContract,
    required this.status,
  });

  final String key;
  final String platformObject;
  final String valueContract;
  final String status;
}

class NosokV30RbacClosure {
  const NosokV30RbacClosure({
    required this.roleKey,
    required this.roleAr,
    required this.permissions,
    required this.guardSurface,
    required this.status,
  });

  final String roleKey;
  final String roleAr;
  final String permissions;
  final String guardSurface;
  final String status;
}

class NosokV30UatSurface {
  const NosokV30UatSurface({
    required this.route,
    required this.actorAr,
    required this.requiredEvidenceAr,
    required this.status,
  });

  final String route;
  final String actorAr;
  final String requiredEvidenceAr;
  final String status;
}

class NosokV30SchemaPreparationItem {
  const NosokV30SchemaPreparationItem({
    required this.family,
    required this.preparationAr,
    required this.applyTiming,
    required this.status,
  });

  final String family;
  final String preparationAr;
  final String applyTiming;
  final String status;
}
