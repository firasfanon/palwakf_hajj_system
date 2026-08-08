class NosokLotteryBackendContract {
  const NosokLotteryBackendContract({
    required this.version,
    required this.status,
    required this.schemaName,
    required this.tables,
    required this.rpcs,
    required this.integrationSteps,
    required this.uatChecks,
    required this.productionBlockers,
  });

  final String version;
  final String status;
  final String schemaName;
  final List<NosokLotteryBackendTableContract> tables;
  final List<NosokLotteryBackendRpcContract> rpcs;
  final List<NosokLotteryIntegrationStep> integrationSteps;
  final List<NosokLotteryBackendUatCheck> uatChecks;
  final List<String> productionBlockers;

  int get requiredTables => tables.length;
  int get requiredRpcs => rpcs.length;
  int get requiredUatChecks => uatChecks.length;
  int get unresolvedBlockers => productionBlockers.length;
}

class NosokLotteryBackendTableContract {
  const NosokLotteryBackendTableContract({
    required this.name,
    required this.purposeAr,
    required this.ownerScope,
    required this.keyColumns,
    required this.privacyGateAr,
    required this.rlsContractAr,
    required this.stage,
  });

  final String name;
  final String purposeAr;
  final String ownerScope;
  final List<String> keyColumns;
  final String privacyGateAr;
  final String rlsContractAr;
  final String stage;
}

class NosokLotteryBackendRpcContract {
  const NosokLotteryBackendRpcContract({
    required this.name,
    required this.purposeAr,
    required this.visibility,
    required this.mutationPolicyAr,
    required this.requiredRoleAr,
    required this.outputSafetyAr,
  });

  final String name;
  final String purposeAr;
  final String visibility;
  final String mutationPolicyAr;
  final String requiredRoleAr;
  final String outputSafetyAr;
}

class NosokLotteryIntegrationStep {
  const NosokLotteryIntegrationStep({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final String status;
}

class NosokLotteryBackendUatCheck {
  const NosokLotteryBackendUatCheck({
    required this.key,
    required this.titleAr,
    required this.sqlSurfaceAr,
    required this.expectedResultAr,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String sqlSurfaceAr;
  final String expectedResultAr;
  final String status;

  bool get passed => status == 'passed';
}
