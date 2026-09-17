class NosokV38PublicRuntimeContract {
  const NosokV38PublicRuntimeContract({
    required this.version,
    required this.decision,
    required this.adapterIntegrations,
    required this.networkEvidenceCases,
    required this.productionGateItems,
    required this.boundaryRules,
  });

  final String version;
  final String decision;
  final List<NosokV38AdapterIntegration> adapterIntegrations;
  final List<NosokV38NetworkEvidenceCase> networkEvidenceCases;
  final List<NosokV38ProductionGateItem> productionGateItems;
  final List<String> boundaryRules;
}

class NosokV38AdapterIntegration {
  const NosokV38AdapterIntegration({
    required this.surface,
    required this.rpcName,
    required this.flutterEntry,
    required this.statusAr,
    required this.noteAr,
  });

  final String surface;
  final String rpcName;
  final String flutterEntry;
  final String statusAr;
  final String noteAr;
}

class NosokV38NetworkEvidenceCase {
  const NosokV38NetworkEvidenceCase({
    required this.caseKey,
    required this.route,
    required this.expectedRpc,
    required this.expectedNetworkFilter,
    required this.evidenceStatusAr,
  });

  final String caseKey;
  final String route;
  final String expectedRpc;
  final String expectedNetworkFilter;
  final String evidenceStatusAr;
}

class NosokV38ProductionGateItem {
  const NosokV38ProductionGateItem({
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
