class NosokV38FinalProductionGateContract {
  const NosokV38FinalProductionGateContract({
    required this.version,
    required this.decision,
    required this.summaryAr,
    required this.privacyNetworkCases,
    required this.negativeUatCases,
    required this.productionGateItems,
    required this.boundaryRules,
    required this.localRetestCommands,
  });

  final String version;
  final String decision;
  final String summaryAr;
  final List<NosokV38EvidenceCase> privacyNetworkCases;
  final List<NosokV38EvidenceCase> negativeUatCases;
  final List<NosokV38GateItem> productionGateItems;
  final List<String> boundaryRules;
  final List<String> localRetestCommands;
}

class NosokV38EvidenceCase {
  const NosokV38EvidenceCase({
    required this.caseKey,
    required this.surface,
    required this.expectedSignal,
    required this.status,
    required this.noteAr,
  });

  final String caseKey;
  final String surface;
  final String expectedSignal;
  final String status;
  final String noteAr;
}

class NosokV38GateItem {
  const NosokV38GateItem({
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
