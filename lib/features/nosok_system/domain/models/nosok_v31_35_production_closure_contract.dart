class NosokV31ToV35ProductionClosureContract {
  const NosokV31ToV35ProductionClosureContract({
    required this.version,
    required this.status,
    required this.productionDecision,
    required this.databaseDecision,
    required this.mergeExecution,
    required this.schemaCreation,
    required this.backendBinding,
    required this.uatClosure,
    required this.productionCandidate,
    required this.stageGates,
    required this.acceptanceChecklist,
    required this.blockers,
  });

  final String version;
  final String status;
  final String productionDecision;
  final String databaseDecision;
  final List<NosokV31MergeExecutionItem> mergeExecution;
  final List<NosokV32SchemaCreationItem> schemaCreation;
  final List<NosokV33BackendBindingItem> backendBinding;
  final List<NosokV34UatClosureItem> uatClosure;
  final List<NosokV35ProductionCandidateItem> productionCandidate;
  final List<NosokV31ToV35StageGate> stageGates;
  final List<String> acceptanceChecklist;
  final List<String> blockers;

  int get mergeExecutionCount => mergeExecution.length;
  int get schemaCreationCount => schemaCreation.length;
  int get backendBindingCount => backendBinding.length;
  int get uatClosureCount => uatClosure.length;
  int get productionCandidateCount => productionCandidate.length;
  int get stageGateCount => stageGates.length;
}

class NosokV31MergeExecutionItem {
  const NosokV31MergeExecutionItem({
    required this.key,
    required this.surfaceAr,
    required this.palwakfTarget,
    required this.applicationMode,
    required this.status,
  });

  final String key;
  final String surfaceAr;
  final String palwakfTarget;
  final String applicationMode;
  final String status;
}

class NosokV32SchemaCreationItem {
  const NosokV32SchemaCreationItem({
    required this.objectName,
    required this.objectType,
    required this.purposeAr,
    required this.rlsPolicyAr,
    required this.creationMode,
    required this.status,
  });

  final String objectName;
  final String objectType;
  final String purposeAr;
  final String rlsPolicyAr;
  final String creationMode;
  final String status;
}

class NosokV33BackendBindingItem {
  const NosokV33BackendBindingItem({
    required this.repositorySurface,
    required this.rpcContract,
    required this.publicSafetyAr,
    required this.bindingMode,
    required this.status,
  });

  final String repositorySurface;
  final String rpcContract;
  final String publicSafetyAr;
  final String bindingMode;
  final String status;
}

class NosokV34UatClosureItem {
  const NosokV34UatClosureItem({
    required this.actorAr,
    required this.routesAr,
    required this.requiredEvidenceAr,
    required this.responsiveScope,
    required this.status,
  });

  final String actorAr;
  final String routesAr;
  final String requiredEvidenceAr;
  final String responsiveScope;
  final String status;
}

class NosokV35ProductionCandidateItem {
  const NosokV35ProductionCandidateItem({
    required this.gateAr,
    required this.requiredClosureAr,
    required this.decisionAr,
    required this.status,
  });

  final String gateAr;
  final String requiredClosureAr;
  final String decisionAr;
  final String status;
}

class NosokV31ToV35StageGate {
  const NosokV31ToV35StageGate({
    required this.stage,
    required this.titleAr,
    required this.deliverableAr,
    required this.decisionAr,
    required this.status,
  });

  final String stage;
  final String titleAr;
  final String deliverableAr;
  final String decisionAr;
  final String status;
}
