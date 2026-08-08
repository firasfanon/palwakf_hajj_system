class NosokV38FPrejoinOperationalContract {
  const NosokV38FPrejoinOperationalContract({
    required this.version,
    required this.adminToolingItems,
    required this.legalSimulationScenarios,
    required this.companyWorkspaceItems,
    required this.publicResponsiveUatItems,
    required this.prejoinGates,
    required this.schemaContracts,
  });

  final String version;
  final List<NosokV38FOperationalItem> adminToolingItems;
  final List<NosokV38FLegalSimulationScenario> legalSimulationScenarios;
  final List<NosokV38FOperationalItem> companyWorkspaceItems;
  final List<NosokV38FResponsiveUatItem> publicResponsiveUatItems;
  final List<String> prejoinGates;
  final List<NosokV38FSchemaContract> schemaContracts;
}

class NosokV38FOperationalItem {
  const NosokV38FOperationalItem({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.runtimePreviewAr,
    required this.backendRequirementAr,
    required this.statusAr,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final String runtimePreviewAr;
  final String backendRequirementAr;
  final String statusAr;
}

class NosokV38FLegalSimulationScenario {
  const NosokV38FLegalSimulationScenario({
    required this.key,
    required this.titleAr,
    required this.inputAr,
    required this.expectedAr,
    required this.auditAr,
  });

  final String key;
  final String titleAr;
  final String inputAr;
  final String expectedAr;
  final String auditAr;
}

class NosokV38FResponsiveUatItem {
  const NosokV38FResponsiveUatItem({
    required this.route,
    required this.desktopExpectationAr,
    required this.mobileExpectationAr,
    required this.consoleExpectationAr,
    required this.statusAr,
  });

  final String route;
  final String desktopExpectationAr;
  final String mobileExpectationAr;
  final String consoleExpectationAr;
  final String statusAr;
}

class NosokV38FSchemaContract {
  const NosokV38FSchemaContract({
    required this.objectName,
    required this.objectType,
    required this.ownerAr,
    required this.statusAr,
  });

  final String objectName;
  final String objectType;
  final String ownerAr;
  final String statusAr;
}
