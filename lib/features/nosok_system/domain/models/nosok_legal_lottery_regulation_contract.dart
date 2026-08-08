class NosokLegalLotteryRegulationContract {
  const NosokLegalLotteryRegulationContract({
    required this.version,
    required this.regulationTitleAr,
    required this.regulationNumber,
    required this.regulationYear,
    required this.sourceNameAr,
    required this.publicationReferenceAr,
    required this.statusAr,
    required this.prejoinDecisionAr,
    required this.registrationRules,
    required this.algorithmRules,
    required this.impactDecisions,
    required this.requiredTables,
    required this.requiredRpcs,
    required this.implementationGates,
  });

  final String version;
  final String regulationTitleAr;
  final String regulationNumber;
  final String regulationYear;
  final String sourceNameAr;
  final String publicationReferenceAr;
  final String statusAr;
  final String prejoinDecisionAr;
  final List<NosokLegalRegistrationRule> registrationRules;
  final List<NosokLegalLotteryAlgorithmRule> algorithmRules;
  final List<NosokLegalImpactDecision> impactDecisions;
  final List<NosokLegalSchemaContract> requiredTables;
  final List<NosokLegalSchemaContract> requiredRpcs;
  final List<String> implementationGates;
}

class NosokLegalRegistrationRule {
  const NosokLegalRegistrationRule({
    required this.key,
    required this.titleAr,
    required this.contractAr,
    required this.uiImpactAr,
    required this.backendImpactAr,
  });

  final String key;
  final String titleAr;
  final String contractAr;
  final String uiImpactAr;
  final String backendImpactAr;
}

class NosokLegalLotteryAlgorithmRule {
  const NosokLegalLotteryAlgorithmRule({
    required this.key,
    required this.titleAr,
    required this.ruleAr,
    required this.previousModelImpactAr,
    required this.requiredRuntimeGuardAr,
  });

  final String key;
  final String titleAr;
  final String ruleAr;
  final String previousModelImpactAr;
  final String requiredRuntimeGuardAr;
}

class NosokLegalImpactDecision {
  const NosokLegalImpactDecision({
    required this.areaAr,
    required this.oldContractAr,
    required this.newContractAr,
    required this.statusAr,
  });

  final String areaAr;
  final String oldContractAr;
  final String newContractAr;
  final String statusAr;
}

class NosokLegalSchemaContract {
  const NosokLegalSchemaContract({
    required this.name,
    required this.type,
    required this.purposeAr,
    required this.statusAr,
  });

  final String name;
  final String type;
  final String purposeAr;
  final String statusAr;
}
