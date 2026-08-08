class NosokSystemRoutes {
  const NosokSystemRoutes._();

  // Public entry points. The /services namespace is the preferred public service portal.
  static const switchEntry = '/switch/nosok';
  static const publicHome = '/services/nosok';
  static const hajj = '/services/nosok/hajj';
  static const umrah = '/services/nosok/umrah';
  static const apply = '/services/nosok/apply';
  static const track = '/services/nosok/track';
  static const requirements = '/services/nosok/requirements';
  static const faq = '/services/nosok/faq';
  static const lotteryResults = '/services/nosok/lottery-results';
  static const waitingList = '/services/nosok/waiting-list';
  static const objections = '/services/nosok/objections';
  static const contact = '/services/nosok/contact';
  static const companyLogin = '/services/nosok/company-login';
  static const legalRegulation = '/services/nosok/legal-regulation';
  static const companies = '/services/nosok/companies';
  static const complaints = '/services/nosok/complaints';
  static const serviceGuide = '/services/nosok/requirements';
  static const citizenJourney = '/services/nosok/citizen-journey';
  static const applicationStatus = '/services/nosok/track';
  static const citizenFollowup = '/services/nosok/follow-up';
  static const news = '/services/nosok/news';
  static const announcements = '/services/nosok/announcements';
  static const activities = '/services/nosok/activities';
  static const unitPrefix = '/services/nosok/units';

  // Backwards-compatible public aliases retained from earlier batches.
  static const legacyPublicHome = '/systems/nosok';
  static const legacyHajj = '/systems/nosok/hajj';
  static const legacyUmrah = '/systems/nosok/umrah';
  static const legacyCompanies = '/systems/nosok/companies';
  static const legacyComplaints = '/systems/nosok/complaints';
  static const legacyFaq = '/systems/nosok/faq';
  static const legacyServiceGuide = '/systems/nosok/service-guide';
  static const legacyCitizenJourney = '/systems/nosok/citizen-journey';
  static const legacyApply = '/systems/nosok/apply';
  static const legacyApplicationStatus = '/systems/nosok/application-status';
  static const legacyCitizenFollowup = '/systems/nosok/follow-up';
  static const legacyUnitPrefix = '/systems/nosok/units';

  static String publicUnit(String unitSlug) => '$unitPrefix/$unitSlug';
  static String legacyPublicUnit(String unitSlug) =>
      '$legacyUnitPrefix/$unitSlug';

  // Semi-independent admin namespace under the platform admin shell.
  static const adminHome = '/admin/systems/nosok';
  static const adminRequests = '/admin/systems/nosok/requests';
  static const adminReview = '/admin/systems/nosok/review';
  static const adminCampaigns = '/admin/systems/nosok/campaigns';
  static const adminGroups = '/admin/systems/nosok/groups';
  static const adminDocuments = '/admin/systems/nosok/documents';
  static const adminMessages = '/admin/systems/nosok/messages';
  static const adminSeasons = '/admin/systems/nosok/seasons';
  static const adminPrograms = '/admin/systems/nosok/programs';
  static const adminCompanies = '/admin/systems/nosok/companies';
  static const adminApplications = '/admin/systems/nosok/applications';
  static const adminApplicationDetailsPrefix =
      '/admin/systems/nosok/applications';
  static const adminComplaints = '/admin/systems/nosok/complaints';
  static const adminContent = '/admin/systems/nosok/content';
  static const adminReports = '/admin/systems/nosok/reports';
  static const adminUnits = '/admin/systems/nosok/units';
  static const adminUsersRoles = '/admin/systems/nosok/users-roles';
  static const adminSidebar = '/admin/systems/nosok/sidebar';
  static const adminSettings = '/admin/systems/nosok/settings';
  static const adminHealth = '/admin/systems/nosok/health';
  static const adminOperations = '/admin/systems/nosok/operations';
  static const adminPaymentBridge = '/admin/systems/nosok/payment-bridge';
  static const adminUnitQueues = '/admin/systems/nosok/unit-queues';
  static const adminRoleUat = '/admin/systems/nosok/role-uat';
  static const adminNotifications = '/admin/systems/nosok/notifications';
  static const adminBillingAdapters = '/admin/systems/nosok/billing-adapters';
  static const adminTrackingPrivacy = '/admin/systems/nosok/tracking-privacy';
  static const adminReadinessEvidence =
      '/admin/systems/nosok/readiness-evidence';
  static const adminWorkflowWorkbench =
      '/admin/systems/nosok/workflow-workbench';
  static const adminSeasonCommand = '/admin/systems/nosok/season-command';
  static const adminServiceDesk = '/admin/systems/nosok/service-desk';
  static const adminVisualGovernance = '/admin/systems/nosok/visual-governance';
  static const adminApplicationLifecycle =
      '/admin/systems/nosok/application-lifecycle';
  static const adminNotificationDispatch =
      '/admin/systems/nosok/notification-dispatch';
  static const adminFollowupInbox = '/admin/systems/nosok/follow-up-inbox';
  static const adminNotificationProviderUat =
      '/admin/systems/nosok/notification-provider-uat';
  static const adminProductionUatClosure =
      '/admin/systems/nosok/production-uat-closure';
  static const adminApplicationOperations =
      '/admin/systems/nosok/application-operations';
  static const adminPlatformIntegrationReadiness =
      '/admin/systems/nosok/platform-integration-readiness';
  static const adminRealPlatformMerge =
      '/admin/systems/nosok/real-platform-merge';
  static const adminRbacProviderOverride =
      '/admin/systems/nosok/rbac-provider-override';
  static const adminSqlUatIntake = '/admin/systems/nosok/sql-uat-intake';
  static const adminBrowserRoleEvidence =
      '/admin/systems/nosok/browser-role-evidence';
  static const adminProductionGateDecision =
      '/admin/systems/nosok/production-gate-decision';
  static const adminRemainingWork = '/admin/systems/nosok/remaining-work';
  static const adminHomepageSections = '/admin/systems/nosok/homepage-sections';
  static const adminDynamicPages = '/admin/systems/nosok/dynamic-pages';
  static const adminUnitScopeAccess = '/admin/systems/nosok/unit-scope-access';
  static const adminRegistrationGovernance =
      '/admin/systems/nosok/registration-governance';
  static const adminLegalCompliance = '/admin/systems/nosok/legal-compliance';
  static const adminLegalAlgorithmSimulation =
      '/admin/systems/nosok/legal-algorithm-simulation';
  static const adminCompanyWorkspaceClosure =
      '/admin/systems/nosok/company-workspace-closure';
  static const adminPublicResponsiveUat =
      '/admin/systems/nosok/public-responsive-uat';
  static const adminStandaloneSupabaseDevelopment =
      '/admin/systems/nosok/standalone-supabase-development';
  static const adminV38IStandaloneSupabaseDevelopment =
      '/admin/systems/nosok/v38i-standalone-supabase-development';
  static const adminSupabaseBindingDiscovery =
      '/admin/systems/nosok/supabase-binding-discovery';
  static const adminV38HSupabaseBinding =
      '/admin/systems/nosok/v38h-supabase-binding';
  static const adminPlatformSchemaBindings =
      '/admin/systems/nosok/platform-schema-bindings';
  static const adminV38GPlatformSchemaBinding =
      '/admin/systems/nosok/v38g-platform-schema-binding';
  static const adminV24UatEvidence = '/admin/systems/nosok/v24-uat-evidence';
  static const adminV24ResponsiveUat =
      '/admin/systems/nosok/v24-responsive-uat';
  static const adminV24MergeReadinessClosure =
      '/admin/systems/nosok/v24-merge-readiness-closure';
  static const adminV24SupabaseRuntimeUat =
      '/admin/systems/nosok/v24-supabase-runtime-uat';
  static const adminV24ProductionRedecision =
      '/admin/systems/nosok/v24-production-redecision';
  static const adminV25EvidenceIntake =
      '/admin/systems/nosok/v25-evidence-intake';
  static const adminV25FullMergeApplicationResult =
      '/admin/systems/nosok/v25-full-merge-application-result';
  static const adminV25ProductionCandidateDecision =
      '/admin/systems/nosok/v25-production-candidate-decision';
  static const adminV26EvidenceResultIntake =
      '/admin/systems/nosok/v26-evidence-result-intake';
  static const adminV26FullMergeApplyResult =
      '/admin/systems/nosok/v26-full-merge-apply-result';
  static const adminV26ProductionCandidateRedecision =
      '/admin/systems/nosok/v26-production-candidate-redecision';
  static const adminV27SchemaCensusResult =
      '/admin/systems/nosok/v27-schema-census-result';
  static const adminV27ExistingObjectReconciliation =
      '/admin/systems/nosok/v27-existing-object-reconciliation';
  static const adminV27OwnerSchemaDiffPlan =
      '/admin/systems/nosok/v27-owner-schema-diff-plan';
  static const adminV27SafeSqlExecutionGate =
      '/admin/systems/nosok/v27-safe-sql-execution-gate';
  static const adminV28OwnerSchemaDesign =
      '/admin/systems/nosok/v28-owner-schema-design';
  static const adminV28GuardedDdlDraft =
      '/admin/systems/nosok/v28-guarded-ddl-draft';
  static const adminV28RlsRpcMatrix = '/admin/systems/nosok/v28-rls-rpc-matrix';
  static const adminV28ExecutionAuthorizationGate =
      '/admin/systems/nosok/v28-execution-authorization-gate';
  static const adminV29DdlAuthorizationIntake =
      '/admin/systems/nosok/v29-ddl-authorization-intake';
  static const adminV29StagingApplyGate =
      '/admin/systems/nosok/v29-staging-apply-gate';
  static const adminV29RlsRpcNegativeUatPreflight =
      '/admin/systems/nosok/v29-rls-rpc-negative-uat-preflight';
  static const adminV30AuthorizationTokenIntake =
      '/admin/systems/nosok/v30-authorization-token-intake';
  static const adminV30ControlledDdlApplyResult =
      '/admin/systems/nosok/v30-controlled-ddl-apply-result';
  static const adminV30RlsRpcNegativeUatExecutionGate =
      '/admin/systems/nosok/v30-rls-rpc-negative-uat-execution-gate';
  static const adminV31AuthorizationTokenEvidence =
      '/admin/systems/nosok/v31-authorization-token-evidence';
  static const adminV31ControlledStagingApplyCertification =
      '/admin/systems/nosok/v31-controlled-staging-apply-certification';
  static const adminV31PostApplyRlsRpcNegativeUatClosure =
      '/admin/systems/nosok/v31-post-apply-rls-rpc-negative-uat-closure';
  static const adminV32ControlledStagingDdlApplyEvidence =
      '/admin/systems/nosok/v32-controlled-staging-ddl-apply-evidence';
  static const adminV32PostApplyCensusRlsResultClosure =
      '/admin/systems/nosok/v32-post-apply-census-rls-result-closure';
  static const adminV32ProductionGateRedecision =
      '/admin/systems/nosok/v32-production-gate-redecision';
  static const adminV33PostApplyRlsRpcNegativeUatExecution =
      '/admin/systems/nosok/v33-post-apply-rls-rpc-negative-uat-execution';
  static const adminV33PublicWrapperSurfaceDraft =
      '/admin/systems/nosok/v33-public-wrapper-surface-draft';
  static const adminV33RepositoryBindingGate =
      '/admin/systems/nosok/v33-repository-binding-gate';
  static const adminV34PublicWrapperRpcAuthorization =
      '/admin/systems/nosok/v34-public-wrapper-rpc-authorization';
  static const adminV34BrowserRoleNegativeUatEvidenceIntake =
      '/admin/systems/nosok/v34-browser-role-negative-uat-evidence-intake';
  static const adminV34RepositoryBindingAuthorizationGate =
      '/admin/systems/nosok/v34-repository-binding-authorization-gate';
  static const adminV35WrapperRpcApplyResult =
      '/admin/systems/nosok/v35-wrapper-rpc-apply-result';
  static const adminV35PostApplyWrapperRpcEvidenceClosure =
      '/admin/systems/nosok/v35-post-apply-wrapper-rpc-evidence-closure';
  static const adminV35RepositoryBindingPreflightDecision =
      '/admin/systems/nosok/v35-repository-binding-preflight-decision';
  static const adminV36BrowserRoleScopeWrapperUat =
      '/admin/systems/nosok/v36-browser-role-scope-wrapper-uat';
  static const adminV36RepositoryBindingControlledAdapter =
      '/admin/systems/nosok/v36-repository-binding-controlled-adapter';
  static const adminV36ProductionGateRedecision =
      '/admin/systems/nosok/v36-production-gate-redecision';
  static const adminV37PublicRepositoryBindingRuntimeSwitchCandidate =
      '/admin/systems/nosok/v37-public-repository-binding-runtime-switch-candidate';
  static const adminV37BrowserEvidenceResultIntake =
      '/admin/systems/nosok/v37-browser-evidence-result-intake';
  static const adminV37ProductionGateRedecision =
      '/admin/systems/nosok/v37-production-gate-redecision';

  static String adminApplicationDetails(String applicationId) =>
      '$adminApplicationDetailsPrefix/$applicationId';
  static String adminUnit(String unitId) => '$adminUnits/$unitId';

  // Legacy compatibility aliases from earlier patch stages.
  static const legacyAdminHome = '/admin/nosok';
  static const legacyAdminSeasons = '/admin/nosok/seasons';
  static const legacyAdminPrograms = '/admin/nosok/programs';
  static const legacyAdminCompanies = '/admin/nosok/companies';
  static const legacyAdminApplications = '/admin/nosok/applications';
  static const legacyAdminComplaints = '/admin/nosok/complaints';
  static const legacyAdminContent = '/admin/nosok/content';
  static const legacyAdminReports = '/admin/nosok/reports';
}
