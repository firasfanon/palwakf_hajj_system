class NosokV38GPlatformSchemaBindingContract {
  const NosokV38GPlatformSchemaBindingContract({
    required this.version,
    required this.platformSources,
    required this.nosokSchemaObjects,
    required this.bindingRules,
    required this.homepageContentObjects,
    required this.securityGates,
  });

  final String version;
  final List<NosokV38GPlatformSource> platformSources;
  final List<NosokV38GSchemaObject> nosokSchemaObjects;
  final List<NosokV38GBindingRule> bindingRules;
  final List<NosokV38GSchemaObject> homepageContentObjects;
  final List<String> securityGates;
}

class NosokV38GPlatformSource {
  const NosokV38GPlatformSource({
    required this.key,
    required this.sourceName,
    required this.platformContract,
    required this.nosokUsage,
    required this.bindingStatus,
  });

  final String key;
  final String sourceName;
  final String platformContract;
  final String nosokUsage;
  final String bindingStatus;
}

class NosokV38GSchemaObject {
  const NosokV38GSchemaObject({
    required this.objectName,
    required this.objectType,
    required this.purposeAr,
    required this.platformDependency,
    required this.statusAr,
  });

  final String objectName;
  final String objectType;
  final String purposeAr;
  final String platformDependency;
  final String statusAr;
}

class NosokV38GBindingRule {
  const NosokV38GBindingRule({
    required this.key,
    required this.titleAr,
    required this.ruleAr,
    required this.enforcementAr,
  });

  final String key;
  final String titleAr;
  final String ruleAr;
  final String enforcementAr;
}
