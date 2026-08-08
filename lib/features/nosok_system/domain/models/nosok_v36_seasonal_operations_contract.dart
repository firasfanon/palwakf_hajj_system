class NosokV36SeasonalOperationsContract {
  const NosokV36SeasonalOperationsContract({
    required this.version,
    required this.status,
    required this.productionDecision,
    required this.databaseDecision,
    required this.advancedReports,
    required this.paymentBridge,
    required this.documentIntelligence,
    required this.assistantBridge,
    required this.campaignCompanyEnhancements,
    required this.uxEnhancements,
    required this.ministryPolicyAddons,
    required this.runtimeGates,
    required this.acceptanceChecklist,
    required this.remainingBlockers,
  });

  final String version;
  final String status;
  final String productionDecision;
  final String databaseDecision;
  final List<NosokV36Capability> advancedReports;
  final List<NosokV36Capability> paymentBridge;
  final List<NosokV36Capability> documentIntelligence;
  final List<NosokV36Capability> assistantBridge;
  final List<NosokV36Capability> campaignCompanyEnhancements;
  final List<NosokV36Capability> uxEnhancements;
  final List<NosokV36Capability> ministryPolicyAddons;
  final List<NosokV36RuntimeGate> runtimeGates;
  final List<String> acceptanceChecklist;
  final List<String> remainingBlockers;

  int get reportsCount => advancedReports.length;
  int get paymentCount => paymentBridge.length;
  int get documentCount => documentIntelligence.length;
  int get assistantCount => assistantBridge.length;
  int get campaignCompanyCount => campaignCompanyEnhancements.length;
  int get uxCount => uxEnhancements.length;
  int get policyCount => ministryPolicyAddons.length;
}

class NosokV36Capability {
  const NosokV36Capability({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.runtimeMode,
    required this.integrationTarget,
    required this.securityNoteAr,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final String runtimeMode;
  final String integrationTarget;
  final String securityNoteAr;
  final String status;
}

class NosokV36RuntimeGate {
  const NosokV36RuntimeGate({
    required this.key,
    required this.titleAr,
    required this.requiredEvidenceAr,
    required this.decisionAr,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String requiredEvidenceAr;
  final String decisionAr;
  final String status;
}
