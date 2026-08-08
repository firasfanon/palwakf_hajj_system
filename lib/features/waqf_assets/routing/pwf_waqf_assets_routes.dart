// PalWakf — Waqf Asset Registry
// Batch 03B — Awqaf System Route Realignment
// Import this list into the platform GoRouter configuration.

import 'package:go_router/go_router.dart';

import 'pwf_waqf_assets_route_paths.dart';

import '../presentation/pages/pwf_waqf_asset_cross_system_bindings_page.dart';
import '../presentation/pages/pwf_waqf_asset_create_page.dart';
import '../presentation/pages/pwf_waqf_asset_detail_page.dart';
import '../presentation/pages/pwf_waqf_asset_review_queue_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_duplicate_candidates_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_parcel_candidates_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_record_detail_page.dart';
import '../presentation/pages/pwf_waqf_asset_source_records_review_page.dart';
import '../presentation/pages/pwf_waqf_assets_sovereign_readiness_page.dart';
import '../presentation/pages/pwf_waqf_assets_operational_read_console_page.dart';
import '../presentation/pages/pwf_waqf_assets_user_screens_page.dart';
import '../presentation/pages/pwf_waqf_assets_admin_page.dart';

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

final List<RouteBase> pwfWaqfAssetsRoutes = [
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.root,
    builder: (context, state) => const PwfWaqfAssetsAdminPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.create,
    builder: (context, state) => const PwfWaqfAssetCreatePage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.review,
    builder: (context, state) => const PwfWaqfAssetReviewQueuePage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.operationalReadConsole,
    builder: (context, state) =>
        const PwfWaqfAssetsOperationalReadConsolePage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.userScreens,
    builder: (context, state) => const PwfWaqfAssetsUserScreensPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.sovereignReadiness,
    builder: (context, state) => const PwfWaqfAssetsSovereignReadinessPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.crossSystemBindings,
    builder: (context, state) => const PwfWaqfAssetCrossSystemBindingsPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.sourceRecords,
    builder: (context, state) => const PwfWaqfAssetSourceRecordsReviewPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.sourceRecordDetail,
    builder: (context, state) {
      final id = state.pathParameters['sourceRecordId'] ?? '';
      return PwfWaqfAssetSourceRecordDetailPage(sourceRecordId: id);
    },
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.sourceDuplicates,
    builder: (context, state) =>
        const PwfWaqfAssetSourceDuplicateCandidatesPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.sourceParcels,
    builder: (context, state) => const PwfWaqfAssetSourceParcelCandidatesPage(),
  ),
  GoRoute(
    path: PwfWaqfAssetsRoutePaths.detail,
    redirect: (context, state) => _redirectReservedWaqfAssetSegment(state),
    builder: (context, state) {
      final id = state.pathParameters['waqfAssetId'] ?? '';
      return PwfWaqfAssetDetailPage(waqfAssetId: id);
    },
  ),
];
