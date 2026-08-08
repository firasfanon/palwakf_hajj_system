class NosokV38IStandaloneSupabaseDevelopmentContract {
  const NosokV38IStandaloneSupabaseDevelopmentContract({
    required this.version,
    required this.executionStatus,
    required this.runtimeModes,
    required this.coreReferenceObjects,
    required this.schemaObjects,
    required this.rpcWrappers,
    required this.repositoryAdapters,
    required this.homepageRuntimeAdminCapabilities,
    required this.shapeDiscoveryGates,
    required this.productionSafetyRules,
    required this.developmentApplySequence,
  });

  final String version;
  final String executionStatus;
  final List<NosokRuntimeModeContract> runtimeModes;
  final List<NosokCoreReferenceObjectContract> coreReferenceObjects;
  final List<NosokSchemaObjectContract> schemaObjects;
  final List<NosokRpcWrapperContract> rpcWrappers;
  final List<NosokRepositoryAdapterContract> repositoryAdapters;
  final List<NosokHomepageRuntimeAdminCapability>
      homepageRuntimeAdminCapabilities;
  final List<String> shapeDiscoveryGates;
  final List<String> productionSafetyRules;
  final List<String> developmentApplySequence;
}

class NosokRuntimeModeContract {
  const NosokRuntimeModeContract({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.statusAr,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final String statusAr;
}

class NosokCoreReferenceObjectContract {
  const NosokCoreReferenceObjectContract({
    required this.key,
    required this.sourceSchema,
    required this.expectedObjectFamily,
    required this.nosokUsageAr,
    required this.accessRuleAr,
  });

  final String key;
  final String sourceSchema;
  final String expectedObjectFamily;
  final String nosokUsageAr;
  final String accessRuleAr;
}

class NosokSchemaObjectContract {
  const NosokSchemaObjectContract({
    required this.objectName,
    required this.objectType,
    required this.purposeAr,
    required this.crossSchemaRuleAr,
    required this.statusAr,
  });

  final String objectName;
  final String objectType;
  final String purposeAr;
  final String crossSchemaRuleAr;
  final String statusAr;
}

class NosokRpcWrapperContract {
  const NosokRpcWrapperContract({
    required this.rpcName,
    required this.surface,
    required this.purposeAr,
    required this.securityAr,
    required this.statusAr,
  });

  final String rpcName;
  final String surface;
  final String purposeAr;
  final String securityAr;
  final String statusAr;
}

class NosokRepositoryAdapterContract {
  const NosokRepositoryAdapterContract({
    required this.key,
    required this.titleAr,
    required this.modeAr,
    required this.supabaseSourceAr,
    required this.decisionAr,
  });

  final String key;
  final String titleAr;
  final String modeAr;
  final String supabaseSourceAr;
  final String decisionAr;
}

class NosokHomepageRuntimeAdminCapability {
  const NosokHomepageRuntimeAdminCapability({
    required this.key,
    required this.titleAr,
    required this.workflowAr,
    required this.guardAr,
  });

  final String key;
  final String titleAr;
  final String workflowAr;
  final String guardAr;
}
