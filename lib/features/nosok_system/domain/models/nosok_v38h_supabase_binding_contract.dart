class NosokV38HSupabaseBindingContract {
  const NosokV38HSupabaseBindingContract({
    required this.version,
    required this.executionStatus,
    required this.platformClientFindings,
    required this.repositoryAdapterRules,
    required this.rpcContracts,
    required this.shapeDiscoveryChecks,
    required this.noApplyGates,
    required this.runtimeBindingSequence,
  });

  final String version;
  final String executionStatus;
  final List<NosokV38HPlatformClientFinding> platformClientFindings;
  final List<NosokV38HRepositoryAdapterRule> repositoryAdapterRules;
  final List<NosokV38HRpcContract> rpcContracts;
  final List<NosokV38HShapeDiscoveryCheck> shapeDiscoveryChecks;
  final List<String> noApplyGates;
  final List<String> runtimeBindingSequence;
}

class NosokV38HPlatformClientFinding {
  const NosokV38HPlatformClientFinding({
    required this.key,
    required this.sourceFile,
    required this.findingAr,
    required this.nosokDecisionAr,
    required this.status,
  });

  final String key;
  final String sourceFile;
  final String findingAr;
  final String nosokDecisionAr;
  final String status;
}

class NosokV38HRepositoryAdapterRule {
  const NosokV38HRepositoryAdapterRule({
    required this.key,
    required this.titleAr,
    required this.ruleAr,
    required this.implementationAr,
  });

  final String key;
  final String titleAr;
  final String ruleAr;
  final String implementationAr;
}

class NosokV38HRpcContract {
  const NosokV38HRpcContract({
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

class NosokV38HShapeDiscoveryCheck {
  const NosokV38HShapeDiscoveryCheck({
    required this.checkKey,
    required this.targetObject,
    required this.expectedPurposeAr,
    required this.decisionAr,
  });

  final String checkKey;
  final String targetObject;
  final String expectedPurposeAr;
  final String decisionAr;
}
