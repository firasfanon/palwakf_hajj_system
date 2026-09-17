class NosokV39TawafRealityGapContract {
  const NosokV39TawafRealityGapContract({
    required this.version,
    required this.decision,
    required this.summaryAr,
    required this.observedPublicSources,
    required this.realityGaps,
    required this.evidenceMatrix,
    required this.productionGateItems,
    required this.boundaryRules,
    required this.localRetestCommands,
  });

  final String version;
  final String decision;
  final String summaryAr;
  final List<NosokV39ObservedPublicSource> observedPublicSources;
  final List<NosokV39RealityGapItem> realityGaps;
  final List<NosokV39EvidenceCase> evidenceMatrix;
  final List<NosokV39GateItem> productionGateItems;
  final List<String> boundaryRules;
  final List<String> localRetestCommands;
}

class NosokV39ObservedPublicSource {
  const NosokV39ObservedPublicSource({
    required this.sourceKey,
    required this.titleAr,
    required this.url,
    required this.observedSignalAr,
    required this.status,
    required this.adapterImplicationAr,
  });

  final String sourceKey;
  final String titleAr;
  final String url;
  final String observedSignalAr;
  final String status;
  final String adapterImplicationAr;
}

class NosokV39RealityGapItem {
  const NosokV39RealityGapItem({
    required this.key,
    required this.domainAr,
    required this.officialSignalAr,
    required this.nosokV38StateAr,
    required this.adapterDecisionAr,
    required this.evidenceRequiredAr,
  });

  final String key;
  final String domainAr;
  final String officialSignalAr;
  final String nosokV38StateAr;
  final String adapterDecisionAr;
  final String evidenceRequiredAr;
}

class NosokV39EvidenceCase {
  const NosokV39EvidenceCase({
    required this.caseKey,
    required this.domainAr,
    required this.surface,
    required this.expectedSignalAr,
    required this.negativeProbeAr,
    required this.status,
    required this.acceptanceEvidenceAr,
  });

  final String caseKey;
  final String domainAr;
  final String surface;
  final String expectedSignalAr;
  final String negativeProbeAr;
  final String status;
  final String acceptanceEvidenceAr;
}

class NosokV39GateItem {
  const NosokV39GateItem({
    required this.key,
    required this.titleAr,
    required this.status,
    required this.reasonAr,
  });

  final String key;
  final String titleAr;
  final String status;
  final String reasonAr;
}
