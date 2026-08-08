class NosokPrejoinAdminToolsContract {
  const NosokPrejoinAdminToolsContract({
    required this.version,
    required this.scopeDecision,
    required this.databaseDecision,
    required this.homepageSections,
    required this.dynamicPages,
    required this.dynamicPageSections,
    required this.dynamicPageGovernanceRules,
    required this.unitScopeRules,
    required this.registrationGovernanceRules,
    required this.requiredTables,
    required this.requiredRpcs,
    required this.joinReadinessGates,
  });

  final String version;
  final String scopeDecision;
  final String databaseDecision;
  final List<NosokHomepageSectionContract> homepageSections;
  final List<NosokDynamicPageContract> dynamicPages;
  final List<NosokDynamicPageSectionContract> dynamicPageSections;
  final List<NosokDynamicPageGovernanceRuleContract> dynamicPageGovernanceRules;
  final List<NosokUnitScopeRuleContract> unitScopeRules;
  final List<NosokRegistrationGovernanceRuleContract>
      registrationGovernanceRules;
  final List<NosokSchemaObjectContract> requiredTables;
  final List<NosokSchemaObjectContract> requiredRpcs;
  final List<String> joinReadinessGates;
}

class NosokHomepageSectionContract {
  const NosokHomepageSectionContract({
    required this.key,
    required this.titleAr,
    required this.surface,
    required this.visibilityScope,
    required this.defaultState,
    required this.adminControl,
    required this.notesAr,
  });

  final String key;
  final String titleAr;
  final String surface;
  final String visibilityScope;
  final String defaultState;
  final String adminControl;
  final String notesAr;
}

class NosokUnitScopeRuleContract {
  const NosokUnitScopeRuleContract({
    required this.key,
    required this.titleAr,
    required this.sourceOfTruth,
    required this.filterContract,
    required this.roleImpact,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String sourceOfTruth;
  final String filterContract;
  final String roleImpact;
  final String status;
}

class NosokRegistrationGovernanceRuleContract {
  const NosokRegistrationGovernanceRuleContract({
    required this.key,
    required this.titleAr,
    required this.publicEffect,
    required this.adminEffect,
    required this.exceptionPath,
    required this.auditRequirement,
  });

  final String key;
  final String titleAr;
  final String publicEffect;
  final String adminEffect;
  final String exceptionPath;
  final String auditRequirement;
}

class NosokSchemaObjectContract {
  const NosokSchemaObjectContract({
    required this.name,
    required this.owner,
    required this.purposeAr,
    required this.status,
  });

  final String name;
  final String owner;
  final String purposeAr;
  final String status;
}

class NosokDynamicPageContract {
  const NosokDynamicPageContract({
    required this.key,
    required this.titleAr,
    required this.routePattern,
    required this.surface,
    required this.allowedAudience,
    required this.adminControl,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String routePattern;
  final String surface;
  final String allowedAudience;
  final String adminControl;
  final String status;
}

class NosokDynamicPageSectionContract {
  const NosokDynamicPageSectionContract({
    required this.key,
    required this.titleAr,
    required this.componentType,
    required this.reusableOn,
    required this.contentFields,
    required this.governanceNoteAr,
  });

  final String key;
  final String titleAr;
  final String componentType;
  final String reusableOn;
  final String contentFields;
  final String governanceNoteAr;
}

class NosokDynamicPageGovernanceRuleContract {
  const NosokDynamicPageGovernanceRuleContract({
    required this.key,
    required this.titleAr,
    required this.ruleAr,
    required this.securityLayer,
    required this.status,
  });

  final String key;
  final String titleAr;
  final String ruleAr;
  final String securityLayer;
  final String status;
}
