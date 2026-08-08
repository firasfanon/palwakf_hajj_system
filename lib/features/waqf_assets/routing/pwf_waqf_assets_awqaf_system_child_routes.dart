// PalWakf — Waqf Asset Registry
// Batch 03C — Platform Router Intake + Actual go_router_config Wiring
//
// Use this file when the platform already has a parent GoRoute mounted at:
// /systems/awqaf-system
//
// Important: child paths MUST be relative and must not start with '/'.

import 'package:go_router/go_router.dart';

import '../presentation/pages/pwf_waqf_asset_cross_system_bindings_page.dart';
import '../presentation/pages/pwf_waqf_asset_create_page.dart';
import '../presentation/pages/pwf_waqf_asset_detail_page.dart';
import '../presentation/pages/pwf_waqf_asset_review_queue_page.dart';
import '../presentation/pages/pwf_waqf_asset_lifecycle_page.dart';
import '../presentation/pages/pwf_waqf_assets_operational_development_page.dart';
import '../presentation/pages/pwf_waqf_assets_operational_read_console_page.dart';
import '../presentation/pages/pwf_waqf_assets_user_screens_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_duplicate_candidates_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_parcel_candidates_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_record_detail_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_records_review_page.dart';
import '../presentation/pages/pwf_waqf_assets_sovereign_readiness_page.dart';
import '../presentation/pages/pwf_waqf_assets_admin_page.dart';

class PwfWaqfAssetsChildRoutePaths {
  const PwfWaqfAssetsChildRoutePaths._();

  static const root = 'waqf-assets';
  static const create = 'waqf-assets/create';
  static const review = 'waqf-assets/review';
  static const lifecycle = 'waqf-assets/lifecycle';
  static const operationalDevelopment = 'waqf-assets/operational-development';
  static const operationalReadConsole = 'waqf-assets/operational-read-console';
  static const userScreens = 'waqf-assets/user-screens';
  static const sovereignReadiness = 'waqf-assets/sovereign-readiness';
  static const crossSystemBindings = 'waqf-assets/cross-system-bindings';
  static const sourceRecords = 'waqf-assets/source-records';
  static const sourceRecordDetail =
      'waqf-assets/source-records/:sourceRecordId';
  static const sourceDuplicates = 'waqf-assets/source-duplicates';
  static const sourceParcels = 'waqf-assets/source-parcels';
  static const detail = 'waqf-assets/:waqfAssetId';
}

const Map<String, String> _reservedWaqfAssetStaticSegments = <String, String>{
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

String? _redirectReservedWaqfAssetSegment(GoRouterState state) {
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

final List<RouteBase> pwfWaqfAssetsAwqafSystemChildRoutes = [
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.root,
    builder: (context, state) => const PwfWaqfAssetsAdminPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.create,
    builder: (context, state) => const PwfWaqfAssetCreatePage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.review,
    builder: (context, state) => const PwfWaqfAssetReviewQueuePage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.lifecycle,
    builder: (context, state) => const PwfWaqfAssetLifecyclePage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.operationalDevelopment,
    builder: (context, state) =>
        const PwfWaqfAssetsOperationalDevelopmentPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.operationalReadConsole,
    builder: (context, state) =>
        const PwfWaqfAssetsOperationalReadConsolePage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.userScreens,
    builder: (context, state) => const PwfWaqfAssetsUserScreensPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.sovereignReadiness,
    builder: (context, state) => const PwfWaqfAssetsSovereignReadinessPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.crossSystemBindings,
    builder: (context, state) => const PwfWaqfAssetCrossSystemBindingsPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.sourceRecords,
    builder: (context, state) => const PwfWaqfAssetSourceRecordsReviewPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.sourceRecordDetail,
    builder: (context, state) {
      final id = state.pathParameters['sourceRecordId'] ?? '';
      return PwfWaqfAssetSourceRecordDetailPage(sourceRecordId: id);
    },
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.sourceDuplicates,
    builder: (context, state) =>
        const PwfWaqfAssetSourceDuplicateCandidatesPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.sourceParcels,
    builder: (context, state) => const PwfWaqfAssetSourceParcelCandidatesPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsChildRoutePaths.detail,
    redirect: (context, state) => _redirectReservedWaqfAssetSegment(state),
    builder: (context, state) {
      final id = state.pathParameters['waqfAssetId'] ?? '';
      return PwfWaqfAssetDetailPage(waqfAssetId: id);
    },
  ),
];
