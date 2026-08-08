/// PalWakf / awqaf_system
/// Awqaf System 7 — Waqf Assets User Screens Read-Only Workspace.
///
/// This contract documents the user-facing waqf-assets screens added on
/// 2026-06-05. It is intentionally read-only and does not authorize writes.
abstract final class AwqafSystem7WaqfAssetsUserScreensContract {
  static const String batchName =
      'Awqaf System 7 — Waqf Assets User Screens Read-Only Workspace';

  static const String decision =
      'AWQAF_SYSTEM_7_WAQF_ASSETS_USER_SCREENS_READ_ONLY_IMPLEMENTED_RETEST_REQUIRED';

  static const String status =
      'scoped-production-active / waqf-assets-user-screens-added / '
      'read-only-search-and-asset-summary-workspace / '
      'platform-access-gateway-dependency-preserved / '
      'role-unit-browser-uat-required / write-still-disabled / '
      'global-production-not-approved / no-waqf-assets-mutation';

  static const String centralRoute =
      '/systems/awqaf-system/waqf-assets/user-screens';

  static const String unitScopedRoutePattern =
      '/{unitSlug}/systems/awqaf-system/waqf-assets/user-screens';

  static const List<String> readOnlyRpcSurfaces = <String>[
    'public.rpc_waqf_assets_runtime_auth_gate_v1',
    'public.rpc_waqf_assets_search_v1',
    'public.rpc_waqf_asset_source_records_v1',
    'public.rpc_waqf_asset_lifecycle_operational_v1',
    'public.rpc_waqf_asset_review_queue_v1',
  ];

  static const List<String> blockedActions = <String>[
    'create_draft',
    'review_decision',
    'add_note',
    'controlled_apply',
    'target_write',
    'insert_update_delete',
    'waqf_assets_mutation',
    'public_base_table_creation',
  ];

  static const List<String> browserUatRequired = <String>[
    'central_platform_superuser_route_renders',
    'unit_scoped_positive_route_renders',
    'wrong_unit_redirects_to_platform_forbidden',
    'logged_out_direct_route_uses_platform_access_gateway',
    'no_awqaf_permission_is_denied_without_data_leak',
    'network_read_only_rpc_200',
    'console_clean',
  ];

  static const bool sqlExecutionAuthorized = false;
  static const bool ddlDmlGrantRevokeAuthorized = false;
  static const bool serviceRoleInFlutterAllowed = false;
  static const bool writeReviewApplyAuthorized = false;
  static const bool waqfAssetsMutationAuthorized = false;
  static const bool publicBaseTableCreationAllowed = false;
}
