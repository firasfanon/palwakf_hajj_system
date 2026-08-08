import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/enums/system_key.dart';
import '../shells/presentation/platform_admin_shell.dart';
import '../shells/presentation/system_shell.dart';

import 'awqaf_system_registry.dart';
import 'domain/enums/awqaf_system_section.dart';
import 'presentation/pages/awqaf_system_shell_page.dart';
import 'presentation/pages/communities/communities_page.dart';
import 'presentation/pages/community_waqf_evidence/community_waqf_evidence_page.dart';
import 'presentation/pages/community_waqf_evidence_documents/community_waqf_evidence_documents_page.dart';
import 'presentation/pages/community_waqf_portion_documents/community_waqf_portion_documents_page.dart';
import 'presentation/pages/community_waqf_portions/community_waqf_portions_page.dart';
import 'presentation/pages/dashboard/awqaf_system_dashboard_page.dart';
import 'presentation/pages/home/awqaf_system_home_page.dart';
import 'awqaf_content/presentation/pages/awqaf_system_content_admin_page.dart';
import 'historical_admin_topology/presentation/pages/awqaf_historical_topology_page.dart';
import 'reference_waqf_linking/presentation/pages/reference_waqf_linking_page.dart';
import 'community_document_evidence_linking/presentation/pages/community_document_evidence_linking_page.dart';
import 'awqaf_assist_workspace/presentation/pages/awqaf_assist_workspace_page.dart';
import 'awqaf_assist_answer_contracts/presentation/pages/awqaf_assist_answer_contracts_page.dart';
import 'sql_contract_runtime_closure/presentation/pages/awqaf_sql_contract_runtime_closure_page.dart';
import 'system_certification/presentation/pages/awqaf_system_certification_page.dart';
import 'presentation/pages/endowment_links/endowment_links_page.dart';
import 'presentation/pages/endowment_types/endowment_types_page.dart';
import 'presentation/pages/endowment_supervisors/endowment_supervisors_page.dart';
import 'presentation/pages/endowment_beneficiaries/endowment_beneficiaries_page.dart';
import 'presentation/pages/endowment_deed_documents/endowment_deed_documents_page.dart';
import 'presentation/pages/waqf_asset_beneficiaries/waqf_asset_beneficiaries_page.dart';
import 'presentation/pages/waqf_asset_endowers/waqf_asset_endowers_page.dart';
import 'presentation/pages/waqf_asset_supervision_assignments/waqf_asset_supervision_assignments_page.dart';
import 'presentation/pages/waqf_asset_deed_documents/waqf_asset_deed_documents_page.dart';
import 'presentation/pages/endowers/endowers_page.dart';
import 'presentation/pages/endowments/endowments_page.dart';
import 'presentation/pages/governorates/governorates_page.dart';
import 'presentation/pages/institution/institution_page.dart';
import 'history_sources/presentation/pages/ontology_page.dart';
import 'history_sources/presentation/pages/other_empire_page.dart';
import 'history_sources/presentation/pages/ottoman_empire_page.dart';
import 'history_sources/presentation/pages/british_mandate_page.dart';
import 'history_sources/presentation/pages/jordanian_administration_page.dart';
import 'history_sources/presentation/pages/state_of_israel_page.dart';
import 'history_sources/presentation/pages/israeli_occupation_page.dart';
import 'history_sources/presentation/pages/egypt_gaza_strip_page.dart';
import 'history_sources/presentation/pages/palestinian_autonomy_page.dart';
import 'political_divisions/presentation/pages/political_divisions_starter_page.dart';
import 'political_divisions/presentation/pages/political_explorer_page.dart';
import 'political_divisions/presentation/pages/historical_welaya_page.dart';
import 'political_divisions/presentation/pages/historical_sonjoq_page.dart';
import 'political_divisions/presentation/pages/historical_lewa_page.dart';
import 'political_divisions/presentation/pages/historical_kada_page.dart';
import 'political_divisions/presentation/pages/political_westbank_gaza_anchor_page.dart';
import 'political_divisions/presentation/pages/political_jordanian_administration_page.dart';
import 'political_divisions/presentation/pages/political_egypt_gaza_strip_page.dart';
import 'political_divisions/presentation/pages/political_state_of_israel_page.dart';
import 'political_divisions/presentation/pages/political_israeli_occupation_page.dart';
import 'political_divisions/presentation/pages/political_palestinian_autonomy_page.dart';
import 'political_divisions/presentation/pages/modern_governorates_page.dart';
import 'political_divisions/presentation/pages/modern_governorate_details_page.dart';
import 'political_divisions/presentation/pages/historical_governorates_page.dart';
import 'political_divisions/presentation/pages/modern_communities_page.dart';
import 'political_divisions/presentation/pages/modern_community_details_page.dart';
import 'political_divisions/presentation/pages/historical_communities_page.dart';
import 'political_divisions/presentation/pages/historical_community_details_page.dart';
import 'political_divisions/presentation/pages/historical_governorate_details_page.dart';
import 'presentation/pages/lgus/lgus_page.dart';
import 'presentation/pages/org_structure/org_structure_page.dart';
import 'presentation/pages/org_units/org_units_page.dart';
import 'presentation/pages/reports/awqaf_system_reports_page.dart';
import 'presentation/pages/audit_log/audit_log_page.dart';
import 'presentation/pages/settings/awqaf_system_settings_page.dart';
import 'presentation/pages/operational_readiness/awqaf_system_operational_readiness_page.dart';
import 'presentation/pages/system_readiness/awqaf_system_join_readiness_pages.dart';
import 'presentation/pages/unit_pages/unit_pages_page.dart';
import 'presentation/pages/waqf_assets_candidate_dry_run/awqaf_system_waqf_assets_candidate_dry_run_page.dart';
import 'presentation/pages/waqf_assets_apply_gate/awqaf_system_waqf_assets_apply_gate_page.dart';
import 'presentation/pages/data_quality/data_quality_page.dart';
import 'presentation/pages/waqf_dictionaries/waqf_dictionaries_page.dart';
import 'presentation/pages/import_export/import_export_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_asset_cross_system_bindings_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_asset_create_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_asset_detail_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_asset_lifecycle_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_assets_operational_development_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_assets_operational_read_console_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_assets_user_screens_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_asset_review_queue_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_asset_source_record_detail_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_asset_source_records_review_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_assets_admin_page.dart';
import '../waqf_assets/presentation/pages/pwf_waqf_assets_sovereign_readiness_page.dart';

abstract final class AwqafSystemRoutes {
  static const String root = '/systems/awqaf-system';
  static const String home = root;
  static const String unitRoot = '/:unitSlug/systems/awqaf-system';
  static const String legacyRoot = '/systems/admin-data';

  static const Set<String> reservedUnitSlugs = <String>{
    'admin',
    'api',
    'assets',
    'auth',
    'home',
    'login',
    'systems',
    'services',
    'eservices',
    'news',
    'announcements',
    'activities',
    'search',
    'switch-system',
    'forbidden',
    '404',
  };

  static String? unitSlugFromLocation(String location) {
    final Uri? uri = Uri.tryParse(location);
    final String path = uri?.path ?? location;
    final match =
        RegExp(r'^/([^/]+)/systems/awqaf-system(?:/.*)?$').firstMatch(path);
    if (match == null) return null;
    final String slug = (match.group(1) ?? '').trim().toLowerCase();
    if (slug.isEmpty || reservedUnitSlugs.contains(slug)) return null;
    return slug;
  }

  static bool isAwqafSystemLocation(String location) {
    final Uri? uri = Uri.tryParse(location);
    final String path = uri?.path ?? location;
    return path == root ||
        path.startsWith('$root/') ||
        unitSlugFromLocation(path) != null;
  }

  static bool isAwqafSystemEntryLocation(String location) {
    final Uri? uri = Uri.tryParse(location);
    final String path = uri?.path ?? location;
    if (path == root) return true;
    final String? unitSlug = unitSlugFromLocation(path);
    if (unitSlug == null) return false;
    return path == '/$unitSlug$root';
  }

  static bool isAwqafSystemProtectedLocation(String location) {
    return isAwqafSystemLocation(location) &&
        !isAwqafSystemEntryLocation(location);
  }

  static String scopedPath(String currentLocation, String canonicalPath) {
    final String? unitSlug = unitSlugFromLocation(currentLocation);
    if (unitSlug == null || !canonicalPath.startsWith(root)) {
      return canonicalPath;
    }
    return '/$unitSlug${canonicalPath}';
  }

  static String scopedPathOf(BuildContext context, String canonicalPath) =>
      scopedPath(GoRouterState.of(context).uri.path, canonicalPath);

  static String unitScopedPath(String unitSlug, String canonicalPath) {
    final String normalizedSlug = unitSlug.trim().toLowerCase();
    if (normalizedSlug.isEmpty ||
        reservedUnitSlugs.contains(normalizedSlug) ||
        !canonicalPath.startsWith(root)) {
      return canonicalPath;
    }
    return '/$normalizedSlug${canonicalPath}';
  }

  static String _unitPath(String canonicalPath) =>
      canonicalPath.replaceFirst(root, unitRoot);
  static const String dashboard = '$root/dashboard';
  static const String contentCenter = '$root/content-center';
  static const String homeSectionsAdmin = '$root/home-sections';
  static const String safePageBuilder = '$root/page-builder';
  static const String evidenceCenter = '$root/evidence-center';
  static const String standaloneDevelopment = '$root/standalone-development';
  static const String schemaRpcDesign = '$root/schema-rpc-rls';
  static const String rbacRlsSupabaseReadiness =
      '$root/rbac-rls-supabase-readiness';
  static const String joinPackage = '$root/join-package';
  static const String historicalAdminTopology =
      '$root/historical-admin-topology';
  static const String institution = '$root/institution';
  static const String orgUnits = '$root/org-units';
  static const String orgStructure = '$root/org-structure';
  static const String governorates = '$root/governorates';
  static const String communities = '$root/communities';
  static const String lgus = '$root/lgus';
  static const String communityWaqfPortions = '$root/community-waqf-portions';
  static const String communityWaqfEvidence = '$root/community-waqf-evidence';
  static const String communityWaqfEvidenceDocuments =
      '$root/community-waqf-evidence-documents';
  static const String communityWaqfPortionDocuments =
      '$root/community-waqf-portion-documents';
  static const String endowmentTypes = '$root/endowment-types';
  static const String endowments = '$root/endowments';
  static const String referenceWaqfLinking = '$root/reference-waqf-linking';
  static const String communityDocumentEvidenceLinking =
      '$root/community-document-evidence-linking';
  static const String awqafAssistWorkspace = '$root/awqaf-assist-workspace';
  static const String awqafAssistAnswerContracts =
      '$root/awqaf-assist-answer-contracts';
  static const String sqlContractRuntimeClosure =
      '$root/sql-contract-runtime-closure';
  static const String systemCertification = '$root/system-certification';
  static const String operationalReadiness = '$root/operational-readiness';
  static const String waqfAssets = '$root/waqf-assets';
  static const String waqfAssetsCreate = '$root/waqf-assets/create';
  static const String waqfAssetsReview = '$root/waqf-assets/review';
  static const String waqfAssetLifecycle = '$root/waqf-assets/lifecycle';
  static const String waqfAssetsOperationalDevelopment =
      '$root/waqf-assets/operational-development';
  static const String waqfAssetsOperationalReadConsole =
      '$root/waqf-assets/operational-read-console';
  static const String waqfAssetsUserScreens = '$root/waqf-assets/user-screens';
  static const String waqfAssetsCandidateDryRun =
      '$root/waqf-assets/candidate-dry-run';
  static const String waqfAssetsOperationalApplyGate =
      '$root/waqf-assets/operational-apply-gate';
  static const String waqfAssetsSovereignReadiness =
      '$root/waqf-assets/sovereign-readiness';
  static const String waqfAssetCrossSystemBindings =
      '$root/waqf-assets/cross-system-bindings';
  static const String waqfAssetSourceRecords =
      '$root/waqf-assets/source-records';
  static const String waqfAssetSourceRecordDetailsPath =
      '$root/waqf-assets/source-records/:sourceRecordId';
  static String waqfAssetSourceRecordDetails(String sourceRecordId) =>
      '$root/waqf-assets/source-records/$sourceRecordId';
  static const String waqfAssetDetailsPath = '$root/waqf-assets/:waqfAssetId';
  static String waqfAssetDetails(String waqfAssetId) =>
      '$root/waqf-assets/$waqfAssetId';
  static const Map<String, String> _reservedWaqfAssetStaticSegments =
      <String, String>{
    'create': 'create',
    'review': 'review',
    'lifecycle': 'lifecycle',
    'operational-development': 'operational-development',
    'operational-read-console': 'operational-read-console',
    'user-screens': 'user-screens',
    'candidate-dry-run': 'candidate-dry-run',
    'operational-apply-gate': 'operational-apply-gate',
    'sovereign-readiness': 'sovereign-readiness',
    'cross-system-bindings': 'cross-system-bindings',
    'source-records': 'source-records',
    'source-duplicates': 'source-duplicates',
    'source-parcels': 'source-parcels',
  };

  static String? _redirectReservedWaqfAssetSegment(GoRouterState state) {
    final String segment =
        (state.pathParameters['waqfAssetId'] ?? '').trim().toLowerCase();
    final String? targetSegment = _reservedWaqfAssetStaticSegments[segment];
    if (targetSegment == null) return null;

    final Uri uri = state.uri;
    final String redirectedPath = uri.path.replaceFirst(
      RegExp(r'/waqf-assets/[^/]+$'),
      '/waqf-assets/$targetSegment',
    );
    if (redirectedPath == uri.path) return null;

    return uri.replace(path: redirectedPath).toString();
  }

  static const String endowers = '$root/endowers';
  static const String endowmentLinks = '$root/endowment-links';
  static const String endowmentSupervisors = '$root/endowment-supervisors';
  static const String endowmentBeneficiaries = '$root/endowment-beneficiaries';
  static const String endowmentDeedDocuments = '$root/endowment-deed-documents';
  static const String waqfAssetEndowers = '$root/waqf-asset-endowers';
  static const String waqfAssetBeneficiaries = '$root/waqf-asset-beneficiaries';
  static const String waqfAssetSupervisionAssignments =
      '$root/waqf-asset-supervision-assignments';
  static const String waqfAssetDeedDocuments =
      '$root/waqf-asset-deed-documents';
  static const String waqfDictionaries = '$root/waqf-dictionaries';
  static const String unitPages = '$root/unit-pages';
  static const String importExport = '$root/import-center';
  static const String dataQuality = '$root/data-quality';
  static const String reports = '$root/reports';
  static const String auditLog = '$root/audit-log';
  static const String settings = '$root/settings';
  static const String historyOntology = '$root/history/ontology';
  static const String historyOtherEmpire = '$root/history/other-empire';
  static const String historyOttomanEmpire = '$root/history/ottoman-empire';
  static const String historyBritishMandate = '$root/history/british-mandate';
  static const String historyJordanianAdministration =
      '$root/history/jordanian-administration';
  static const String historyStateOfIsrael = '$root/history/state-of-israel';
  static const String historyIsraeliOccupation =
      '$root/history/israeli-occupation';
  static const String historyEgyptGazaStrip = '$root/history/egypt-gaza-strip';
  static const String historyPalestinianAutonomy =
      '$root/history/palestinian-autonomy';
  static const String politicalDivisionsStarter =
      '$root/history/political-divisions';
  static const String politicalExplorer = '$root/political-divisions/explorer';
  static const String politicalHistoricalWelaya =
      '$root/political-divisions/historical-welaya';
  static const String politicalHistoricalSonjoq =
      '$root/political-divisions/historical-sonjoq';
  static const String politicalHistoricalLewa =
      '$root/political-divisions/historical-lewa';
  static const String politicalHistoricalKada =
      '$root/political-divisions/historical-kada';
  static const String politicalWestbankGazaAnchor =
      '$root/political-divisions/westbank-gaza';
  static const String politicalWestbankGaza = politicalWestbankGazaAnchor;
  static const String politicalJordanianAdministrationBranch =
      '$root/political-divisions/jordanian-administration';
  static const String politicalEgyptGazaStripBranch =
      '$root/political-divisions/egypt-gaza-strip';
  static const String politicalStateOfIsraelBranch =
      '$root/political-divisions/state-of-israel';
  static const String politicalIsraeliOccupationBranch =
      '$root/political-divisions/israeli-occupation';
  static const String politicalPalestinianAutonomyBranch =
      '$root/political-divisions/palestinian-autonomy';
  static const String politicalModernGovernorates =
      '$root/political-divisions/modern-governorates';
  static const String politicalModernGovernorateDetailsPath =
      '$root/political-divisions/modern-governorates/:governorateNo';
  static String politicalModernGovernorateDetails(int governorateNo) =>
      '$root/political-divisions/modern-governorates/$governorateNo';
  static const String politicalHistoricalGovernorates =
      '$root/political-divisions/historical-governorates';
  static const String politicalHistoricalGovernorateDetailsPath =
      '$root/political-divisions/historical-governorates/:governorateNo';
  static String politicalHistoricalGovernorateDetails(int governorateNo) =>
      '$root/political-divisions/historical-governorates/$governorateNo';
  static const String politicalModernCommunities =
      '$root/political-divisions/modern-communities';
  static const String politicalModernCommunityDetailsPath =
      '$root/political-divisions/modern-communities/:communityNo';
  static String politicalModernCommunityDetails(int communityNo) =>
      '$root/political-divisions/modern-communities/$communityNo';
  static const String politicalHistoricalCommunities =
      '$root/political-divisions/historical-communities';
  static const String politicalHistoricalCommunityDetailsPath =
      '$root/political-divisions/historical-communities/:communityNo';
  static String politicalHistoricalCommunityDetails(int communityNo) =>
      '$root/political-divisions/historical-communities/$communityNo';

  static List<RouteBase> buildRoutes() {
    Widget wrap(
      AwqafSystemSection section,
      Widget child, {
      String? unitSlug,
    }) {
      return AwqafSystemShellPage(
        currentSection: section,
        unitSlug: unitSlug,
        child: child,
      );
    }

    String? unitSlugOf(GoRouterState state) =>
        (state.pathParameters['unitSlug'] ?? '').trim().toLowerCase().isEmpty
            ? null
            : (state.pathParameters['unitSlug'] ?? '').trim().toLowerCase();

    final List<RouteBase> awqafRoutes = <RouteBase>[
      // Unit-scoped protected system routes. Public entry routes are declared outside the admin shell.
      GoRoute(
        path: _unitPath(dashboard),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.dashboard,
          const AwqafSystemDashboardPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(contentCenter),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.contentCenter,
          const AwqafSystemContentAdminPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),

      GoRoute(
        path: _unitPath(homeSectionsAdmin),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.homeSectionsAdmin,
          const AwqafSystemHomeSectionsAdminPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(safePageBuilder),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.safePageBuilder,
          const AwqafSystemSafePageBuilderPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(evidenceCenter),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.evidenceCenter,
          const AwqafSystemEvidenceCenterPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(standaloneDevelopment),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.standaloneDevelopment,
          const AwqafSystemStandaloneDevelopmentPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(schemaRpcDesign),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.schemaRpcDesign,
          const AwqafSystemSchemaRpcRlsPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(rbacRlsSupabaseReadiness),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.rbacRlsSupabaseReadiness,
          const AwqafSystemRbacRlsSupabaseReadinessPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(joinPackage),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.joinPackage,
          const AwqafSystemJoinPackagePage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(awqafAssistWorkspace),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.awqafAssistWorkspace,
          const AwqafAssistWorkspacePage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(awqafAssistAnswerContracts),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.awqafAssistAnswerContracts,
          const AwqafAssistAnswerContractsPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(sqlContractRuntimeClosure),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.sqlContractRuntimeClosure,
          const AwqafSqlContractRuntimeClosurePage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(systemCertification),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.systemCertification,
          const AwqafSystemCertificationPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(operationalReadiness),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.operationalReadiness,
          const AwqafSystemOperationalReadinessPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(auditLog),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.auditLog,
          const AuditLogPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(settings),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.settings,
          const AwqafSystemSettingsPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssets),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsAdminPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsCreate),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetCreatePage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsReview),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetReviewQueuePage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsCandidateDryRun),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetsCandidateDryRun,
          const AwqafSystemWaqfAssetsCandidateDryRunPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsOperationalApplyGate),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetsOperationalApplyGate,
          const AwqafSystemWaqfAssetsApplyGatePage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetLifecycle),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetLifecycle,
          const PwfWaqfAssetLifecyclePage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsOperationalDevelopment),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsOperationalDevelopmentPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsOperationalReadConsole),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          PwfWaqfAssetsOperationalReadConsolePage(
            unitSlug: unitSlugOf(state),
          ),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsUserScreens),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          PwfWaqfAssetsUserScreensPage(
            unitSlug: unitSlugOf(state),
          ),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetsSovereignReadiness),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsSovereignReadinessPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetCrossSystemBindings),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetCrossSystemBindingsPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetSourceRecords),
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetSourceRecordsReviewPage(),
          unitSlug: unitSlugOf(state),
        ),
      ),
      GoRoute(
        path: _unitPath(waqfAssetSourceRecordDetailsPath),
        builder: (BuildContext context, GoRouterState state) {
          final String sourceRecordId =
              state.pathParameters['sourceRecordId'] ?? '';
          return wrap(
            AwqafSystemSection.waqfAssets,
            PwfWaqfAssetSourceRecordDetailPage(
              sourceRecordId: sourceRecordId,
            ),
            unitSlug: unitSlugOf(state),
          );
        },
      ),
      GoRoute(
        path: _unitPath(waqfAssetDetailsPath),
        redirect: (BuildContext context, GoRouterState state) =>
            _redirectReservedWaqfAssetSegment(state),
        builder: (BuildContext context, GoRouterState state) {
          final String waqfAssetId = state.pathParameters['waqfAssetId'] ?? '';
          return wrap(
            AwqafSystemSection.waqfAssets,
            PwfWaqfAssetDetailPage(waqfAssetId: waqfAssetId),
            unitSlug: unitSlugOf(state),
          );
        },
      ),
      GoRoute(
        path: legacyRoot,
        redirect: (BuildContext context, GoRouterState state) => dashboard,
      ),
      GoRoute(
        path: '/systems/admin-data/governorates',
        redirect: (BuildContext context, GoRouterState state) => governorates,
      ),
      GoRoute(
        path: '/systems/admin-data/communities',
        redirect: (BuildContext context, GoRouterState state) => communities,
      ),
      GoRoute(
        path: '/systems/admin-data/lgus',
        redirect: (BuildContext context, GoRouterState state) => lgus,
      ),
      GoRoute(
        path: dashboard,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.dashboard, const AwqafSystemDashboardPage()),
      ),
      GoRoute(
        path: contentCenter,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.contentCenter,
          const AwqafSystemContentAdminPage(),
        ),
      ),
      GoRoute(
        path: homeSectionsAdmin,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.homeSectionsAdmin,
          const AwqafSystemHomeSectionsAdminPage(),
        ),
      ),
      GoRoute(
        path: safePageBuilder,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.safePageBuilder,
          const AwqafSystemSafePageBuilderPage(),
        ),
      ),
      GoRoute(
        path: evidenceCenter,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.evidenceCenter,
          const AwqafSystemEvidenceCenterPage(),
        ),
      ),
      GoRoute(
        path: standaloneDevelopment,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.standaloneDevelopment,
          const AwqafSystemStandaloneDevelopmentPage(),
        ),
      ),
      GoRoute(
        path: schemaRpcDesign,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.schemaRpcDesign,
          const AwqafSystemSchemaRpcRlsPage(),
        ),
      ),
      GoRoute(
        path: rbacRlsSupabaseReadiness,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.rbacRlsSupabaseReadiness,
          const AwqafSystemRbacRlsSupabaseReadinessPage(),
        ),
      ),
      GoRoute(
        path: joinPackage,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.joinPackage,
          const AwqafSystemJoinPackagePage(),
        ),
      ),
      GoRoute(
        path: historicalAdminTopology,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.historicalAdminTopology,
          const AwqafHistoricalTopologyPage(),
        ),
      ),
      GoRoute(
        path: institution,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.institution, const InstitutionPage()),
      ),
      GoRoute(
        path: orgUnits,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.orgUnits, const OrgUnitsPage()),
      ),
      GoRoute(
        path: orgStructure,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.orgStructure, const OrgStructurePage()),
      ),
      GoRoute(
        path: governorates,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.governorates, const GovernoratesPage()),
      ),
      GoRoute(
        path: communities,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.communities, const CommunitiesPage()),
      ),
      GoRoute(
        path: lgus,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.lgus, const LgusPage()),
      ),
      GoRoute(
        path: communityWaqfPortions,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.communityWaqfPortions,
          const CommunityWaqfPortionsPage(),
        ),
      ),
      GoRoute(
        path: communityWaqfEvidence,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.communityWaqfEvidence,
          const CommunityWaqfEvidencePage(),
        ),
      ),
      GoRoute(
        path: communityWaqfEvidenceDocuments,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.communityWaqfEvidenceDocuments,
          const CommunityWaqfEvidenceDocumentsPage(),
        ),
      ),
      GoRoute(
        path: communityWaqfPortionDocuments,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.communityWaqfPortionDocuments,
          const CommunityWaqfPortionDocumentsPage(),
        ),
      ),
      GoRoute(
        path: endowmentTypes,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.endowmentTypes, const EndowmentTypesPage()),
      ),
      GoRoute(
        path: endowments,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.endowments, const EndowmentsPage()),
      ),
      GoRoute(
        path: referenceWaqfLinking,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.referenceWaqfLinking,
          const ReferenceWaqfLinkingPage(),
        ),
      ),
      GoRoute(
        path: communityDocumentEvidenceLinking,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.communityDocumentEvidenceLinking,
          const CommunityDocumentEvidenceLinkingPage(),
        ),
      ),
      GoRoute(
        path: awqafAssistWorkspace,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.awqafAssistWorkspace,
          const AwqafAssistWorkspacePage(),
        ),
      ),
      GoRoute(
        path: awqafAssistAnswerContracts,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.awqafAssistAnswerContracts,
          const AwqafAssistAnswerContractsPage(),
        ),
      ),
      GoRoute(
        path: sqlContractRuntimeClosure,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.sqlContractRuntimeClosure,
          const AwqafSqlContractRuntimeClosurePage(),
        ),
      ),
      GoRoute(
        path: systemCertification,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.systemCertification,
          const AwqafSystemCertificationPage(),
        ),
      ),
      GoRoute(
        path: waqfAssets,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsAdminPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetsCreate,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetCreatePage(),
        ),
      ),
      GoRoute(
        path: waqfAssetsReview,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetReviewQueuePage(),
        ),
      ),
      GoRoute(
        path: waqfAssetsSovereignReadiness,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsSovereignReadinessPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetCrossSystemBindings,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetCrossSystemBindingsPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetSourceRecords,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetSourceRecordsReviewPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetSourceRecordDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          final String sourceRecordId =
              state.pathParameters['sourceRecordId'] ?? '';
          return wrap(
            AwqafSystemSection.waqfAssets,
            PwfWaqfAssetSourceRecordDetailPage(
              sourceRecordId: sourceRecordId,
            ),
          );
        },
      ),
      GoRoute(
        path: waqfAssetsCandidateDryRun,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetsCandidateDryRun,
          const AwqafSystemWaqfAssetsCandidateDryRunPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetsOperationalApplyGate,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetsOperationalApplyGate,
          const AwqafSystemWaqfAssetsApplyGatePage(),
        ),
      ),
      GoRoute(
        path: waqfAssetLifecycle,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetLifecycle,
          const PwfWaqfAssetLifecyclePage(),
        ),
      ),
      GoRoute(
        path: waqfAssetsOperationalDevelopment,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsOperationalDevelopmentPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetsOperationalReadConsole,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsOperationalReadConsolePage(),
        ),
      ),
      GoRoute(
        path: waqfAssetsUserScreens,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssets,
          const PwfWaqfAssetsUserScreensPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetDetailsPath,
        redirect: (BuildContext context, GoRouterState state) =>
            _redirectReservedWaqfAssetSegment(state),
        builder: (BuildContext context, GoRouterState state) {
          final String waqfAssetId = state.pathParameters['waqfAssetId'] ?? '';
          return wrap(
            AwqafSystemSection.waqfAssets,
            PwfWaqfAssetDetailPage(waqfAssetId: waqfAssetId),
          );
        },
      ),
      GoRoute(
        path: endowmentDeedDocuments,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.endowmentDeedDocuments,
          const EndowmentDeedDocumentsPage(),
        ),
      ),
      GoRoute(
        path: endowers,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.endowers, const EndowersPage()),
      ),
      GoRoute(
        path: endowmentLinks,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.endowmentLinks, const EndowmentLinksPage()),
      ),
      GoRoute(
        path: endowmentSupervisors,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.endowmentSupervisors,
          const EndowmentSupervisorsPage(),
        ),
      ),
      GoRoute(
        path: endowmentBeneficiaries,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.endowmentBeneficiaries,
          const EndowmentBeneficiariesPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetEndowers,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetEndowers,
          const WaqfAssetEndowersPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetBeneficiaries,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetBeneficiaries,
          const WaqfAssetBeneficiariesPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetSupervisionAssignments,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetSupervisionAssignments,
          const WaqfAssetSupervisionAssignmentsPage(),
        ),
      ),
      GoRoute(
        path: waqfAssetDeedDocuments,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.waqfAssetDeedDocuments,
          const WaqfAssetDeedDocumentsPage(),
        ),
      ),
      GoRoute(
        path: waqfDictionaries,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.waqfDictionaries, const WaqfDictionariesPage()),
      ),
      GoRoute(
        path: unitPages,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.unitPages, const UnitPagesPage()),
      ),
      GoRoute(
        path: historyOntology,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.historyOntology, const OntologyPage()),
      ),
      GoRoute(
        path: historyOtherEmpire,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.historyOtherEmpire, const OtherEmpirePage()),
      ),
      GoRoute(
        path: historyOttomanEmpire,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.historyOttomanEmpire, const OttomanEmpirePage()),
      ),
      GoRoute(
        path: historyBritishMandate,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.historyBritishMandate,
            const BritishMandatePage()),
      ),
      GoRoute(
        path: historyJordanianAdministration,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.historyJordanianAdministration,
          const JordanianAdministrationPage(),
        ),
      ),
      GoRoute(
        path: historyStateOfIsrael,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.historyStateOfIsrael, const StateOfIsraelPage()),
      ),
      GoRoute(
        path: historyIsraeliOccupation,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.historyIsraeliOccupation,
          const IsraeliOccupationPage(),
        ),
      ),
      GoRoute(
        path: historyEgyptGazaStrip,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.historyEgyptGazaStrip,
            const EgyptGazaStripPage()),
      ),
      GoRoute(
        path: historyPalestinianAutonomy,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.historyPalestinianAutonomy,
          const PalestinianAutonomyPage(),
        ),
      ),
      GoRoute(
        path: politicalDivisionsStarter,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalDivisionsStarter,
          const PoliticalDivisionsStarterPage(),
        ),
      ),
      GoRoute(
        path: politicalExplorer,
        builder: (BuildContext context, GoRouterState state) => wrap(
            AwqafSystemSection.politicalExplorer,
            const PoliticalExplorerPage()),
      ),
      GoRoute(
        path: politicalHistoricalWelaya,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalHistoricalWelaya,
          const HistoricalWelayaPage(),
        ),
      ),
      GoRoute(
        path: politicalHistoricalSonjoq,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalHistoricalSonjoq,
          const HistoricalSonjoqPage(),
        ),
      ),
      GoRoute(
        path: politicalHistoricalLewa,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalHistoricalLewa,
          const HistoricalLewaPage(),
        ),
      ),
      GoRoute(
        path: politicalHistoricalKada,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalHistoricalKada,
          const HistoricalKadaPage(),
        ),
      ),
      GoRoute(
        path: politicalWestbankGazaAnchor,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalWestbankGazaAnchor,
          const PoliticalWestbankGazaAnchorPage(),
        ),
      ),
      GoRoute(
        path: politicalJordanianAdministrationBranch,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalJordanianAdministrationBranch,
          const PoliticalJordanianAdministrationPage(),
        ),
      ),
      GoRoute(
        path: politicalEgyptGazaStripBranch,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalEgyptGazaStripBranch,
          const PoliticalEgyptGazaStripPage(),
        ),
      ),
      GoRoute(
        path: politicalStateOfIsraelBranch,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalStateOfIsraelBranch,
          const PoliticalStateOfIsraelPage(),
        ),
      ),
      GoRoute(
        path: politicalIsraeliOccupationBranch,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalIsraeliOccupationBranch,
          const PoliticalIsraeliOccupationPage(),
        ),
      ),
      GoRoute(
        path: politicalPalestinianAutonomyBranch,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalPalestinianAutonomyBranch,
          const PoliticalPalestinianAutonomyPage(),
        ),
      ),
      GoRoute(
        path: politicalModernGovernorates,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalModernGovernorates,
          const ModernGovernoratesPage(),
        ),
      ),
      GoRoute(
        path: politicalModernGovernorateDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          final int governorateNo =
              int.tryParse(state.pathParameters['governorateNo'] ?? '') ?? 0;
          return wrap(
            AwqafSystemSection.politicalModernGovernorates,
            ModernGovernorateDetailsPage(governorateNo: governorateNo),
          );
        },
      ),
      GoRoute(
        path: politicalHistoricalGovernorates,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalHistoricalGovernorates,
          const HistoricalGovernoratesPage(),
        ),
      ),
      GoRoute(
        path: politicalHistoricalGovernorateDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          final int governorateNo =
              int.tryParse(state.pathParameters['governorateNo'] ?? '') ?? 0;
          return wrap(
            AwqafSystemSection.politicalHistoricalGovernorates,
            HistoricalGovernorateDetailsPage(governorateNo: governorateNo),
          );
        },
      ),
      GoRoute(
        path: politicalModernCommunities,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalModernCommunities,
          const ModernCommunitiesPage(),
        ),
      ),
      GoRoute(
        path: politicalModernCommunityDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          final int communityNo =
              int.tryParse(state.pathParameters['communityNo'] ?? '') ?? 0;
          return wrap(
            AwqafSystemSection.politicalModernCommunities,
            ModernCommunityDetailsPage(communityNo: communityNo),
          );
        },
      ),
      GoRoute(
        path: politicalHistoricalCommunities,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.politicalHistoricalCommunities,
          const HistoricalCommunitiesPage(),
        ),
      ),
      GoRoute(
        path: politicalHistoricalCommunityDetailsPath,
        builder: (BuildContext context, GoRouterState state) {
          final int communityNo =
              int.tryParse(state.pathParameters['communityNo'] ?? '') ?? 0;
          return wrap(
            AwqafSystemSection.politicalHistoricalCommunities,
            HistoricalCommunityDetailsPage(communityNo: communityNo),
          );
        },
      ),
      GoRoute(
        path: operationalReadiness,
        builder: (BuildContext context, GoRouterState state) => wrap(
          AwqafSystemSection.operationalReadiness,
          const AwqafSystemOperationalReadinessPage(),
        ),
      ),
      GoRoute(
        path: importExport,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.importExport, const ImportExportPage()),
      ),
      GoRoute(
        path: dataQuality,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.dataQuality, const DataQualityPage()),
      ),
      GoRoute(
        path: reports,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.reports, const AwqafSystemReportsPage()),
      ),
      GoRoute(
        path: auditLog,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.auditLog, const AuditLogPage()),
      ),
      GoRoute(
        path: settings,
        builder: (BuildContext context, GoRouterState state) =>
            wrap(AwqafSystemSection.settings, const AwqafSystemSettingsPage()),
      ),
    ];

    return <RouteBase>[
      // Public-safe system entry: visible without operational grants and without
      // the protected admin/sidebar shell.
      GoRoute(
        path: root,
        builder: (BuildContext context, GoRouterState state) =>
            const AwqafSystemHomePage(),
      ),
      GoRoute(
        path: _unitPath(root),
        builder: (BuildContext context, GoRouterState state) =>
            AwqafSystemHomePage(unitSlug: unitSlugOf(state)),
      ),
      ShellRoute(
        builder: (BuildContext context, GoRouterState state, Widget child) =>
            PlatformAdminShell(
          child: SystemShell(
            systemKey: SystemKey.awqafSystem,
            child: child,
          ),
        ),
        routes: awqafRoutes,
      ),
    ];
  }

  static String titleFromLocation(String location) {
    return AwqafSystemRegistry.itemForSection(
      AwqafSystemRegistry.sectionFromLocation(location),
    ).titleAr;
  }
}
