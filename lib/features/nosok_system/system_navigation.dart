import 'package:flutter/material.dart';

import 'application/access/nosok_access_profile.dart';
import 'system_permissions.dart';
import 'system_routes.dart';

class NosokSystemNavItem {
  const NosokSystemNavItem({
    required this.key,
    required this.titleAr,
    required this.route,
    required this.icon,
    this.permissionKeys = const <String>{},
    this.isOperational = true,
  });

  final String key;
  final String titleAr;
  final String route;
  final IconData icon;
  final Set<String> permissionKeys;
  final bool isOperational;
}

class NosokSystemNavigation {
  const NosokSystemNavigation._();

  static const publicItems = <NosokSystemNavItem>[
    NosokSystemNavItem(
        key: 'home',
        titleAr: 'الرئيسية',
        route: NosokSystemRoutes.publicHome,
        icon: Icons.home_outlined,
        isOperational: false),
    NosokSystemNavItem(
        key: 'hajj',
        titleAr: 'الحج',
        route: NosokSystemRoutes.hajj,
        icon: Icons.flag_outlined,
        isOperational: false),
    NosokSystemNavItem(
        key: 'umrah',
        titleAr: 'العمرة',
        route: NosokSystemRoutes.umrah,
        icon: Icons.travel_explore_outlined,
        isOperational: false),
    NosokSystemNavItem(
        key: 'apply',
        titleAr: 'تقديم طلب',
        route: NosokSystemRoutes.apply,
        icon: Icons.app_registration_outlined),
    NosokSystemNavItem(
        key: 'track',
        titleAr: 'متابعة',
        route: NosokSystemRoutes.track,
        icon: Icons.track_changes_outlined),
    NosokSystemNavItem(
        key: 'requirements',
        titleAr: 'المتطلبات',
        route: NosokSystemRoutes.requirements,
        icon: Icons.fact_check_outlined,
        isOperational: false),
    NosokSystemNavItem(
        key: 'companies',
        titleAr: 'الشركات',
        route: NosokSystemRoutes.companies,
        icon: Icons.business_center_outlined,
        isOperational: false),
    NosokSystemNavItem(
        key: 'follow_up',
        titleAr: 'استكمال',
        route: NosokSystemRoutes.citizenFollowup,
        icon: Icons.playlist_add_check_outlined),
    NosokSystemNavItem(
        key: 'faq',
        titleAr: 'الأسئلة',
        route: NosokSystemRoutes.faq,
        icon: Icons.quiz_outlined,
        isOperational: false),
  ];

  static const adminItems = <NosokSystemNavItem>[
    NosokSystemNavItem(
        key: 'dashboard',
        titleAr: 'لوحة النظام',
        route: NosokSystemRoutes.adminHome,
        icon: Icons.dashboard_outlined,
        permissionKeys: {NosokPermissionKeys.viewNosokDashboard}),
    NosokSystemNavItem(
        key: 'requests',
        titleAr: 'الطلبات',
        route: NosokSystemRoutes.adminRequests,
        icon: Icons.inbox_outlined,
        permissionKeys: {
          NosokPermissionKeys.viewNosokRequests,
          NosokPermissionKeys.manageNosokApplications
        }),
    NosokSystemNavItem(
        key: 'review',
        titleAr: 'المراجعة',
        route: NosokSystemRoutes.adminReview,
        icon: Icons.rate_review_outlined,
        permissionKeys: {
          NosokPermissionKeys.reviewNosokRequestsQueue,
          NosokPermissionKeys.reviewNosokApplications
        }),
    NosokSystemNavItem(
        key: 'campaigns',
        titleAr: 'الحملات',
        route: NosokSystemRoutes.adminCampaigns,
        icon: Icons.campaign_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokCampaigns}),
    NosokSystemNavItem(
        key: 'groups',
        titleAr: 'المجموعات',
        route: NosokSystemRoutes.adminGroups,
        icon: Icons.groups_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokGroups}),
    NosokSystemNavItem(
        key: 'documents',
        titleAr: 'المرفقات',
        route: NosokSystemRoutes.adminDocuments,
        icon: Icons.description_outlined,
        permissionKeys: {
          NosokPermissionKeys.viewNosokDocumentsConsole,
          NosokPermissionKeys.manageNosokDocuments
        }),
    NosokSystemNavItem(
        key: 'messages',
        titleAr: 'المراسلات',
        route: NosokSystemRoutes.adminMessages,
        icon: Icons.mail_outline,
        permissionKeys: {
          NosokPermissionKeys.manageNosokMessages,
          NosokPermissionKeys.manageNosokFollowupInbox
        }),
    NosokSystemNavItem(
        key: 'workflow_workbench',
        titleAr: 'Workbench التشغيل',
        route: NosokSystemRoutes.adminWorkflowWorkbench,
        icon: Icons.view_kanban_outlined,
        permissionKeys: {NosokPermissionKeys.viewNosokWorkflowWorkbench}),
    NosokSystemNavItem(
        key: 'season_command',
        titleAr: 'قيادة الموسم',
        route: NosokSystemRoutes.adminSeasonCommand,
        icon: Icons.event_available_outlined,
        permissionKeys: {NosokPermissionKeys.viewNosokSeasonCommand}),
    NosokSystemNavItem(
        key: 'service_desk',
        titleAr: 'مكتب الخدمة',
        route: NosokSystemRoutes.adminServiceDesk,
        icon: Icons.support_agent_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokServiceDesk}),
    NosokSystemNavItem(
        key: 'applications_legacy',
        titleAr: 'الطلبات القديمة',
        route: NosokSystemRoutes.adminApplications,
        icon: Icons.assignment_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokApplications}),
    NosokSystemNavItem(
        key: 'application_lifecycle',
        titleAr: 'دورة حياة الطلب',
        route: NosokSystemRoutes.adminApplicationLifecycle,
        icon: Icons.alt_route_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokApplicationLifecycle}),
    NosokSystemNavItem(
        key: 'follow_up_inbox',
        titleAr: 'صندوق المتابعة',
        route: NosokSystemRoutes.adminFollowupInbox,
        icon: Icons.mark_email_unread_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokFollowupInbox}),
    NosokSystemNavItem(
        key: 'seasons',
        titleAr: 'المواسم',
        route: NosokSystemRoutes.adminSeasons,
        icon: Icons.calendar_month_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokSeasons}),
    NosokSystemNavItem(
        key: 'programs',
        titleAr: 'البرامج',
        route: NosokSystemRoutes.adminPrograms,
        icon: Icons.route_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokPrograms}),
    NosokSystemNavItem(
        key: 'companies',
        titleAr: 'الشركات',
        route: NosokSystemRoutes.adminCompanies,
        icon: Icons.business_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokCompanies}),
    NosokSystemNavItem(
        key: 'unit_queues',
        titleAr: 'طوابير الوحدات',
        route: NosokSystemRoutes.adminUnitQueues,
        icon: Icons.account_tree_outlined,
        permissionKeys: {NosokPermissionKeys.viewNosokUnitQueues}),
    NosokSystemNavItem(
        key: 'payment_bridge',
        titleAr: 'جسر الدفع',
        route: NosokSystemRoutes.adminPaymentBridge,
        icon: Icons.account_balance_wallet_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokPaymentBridge}),
    NosokSystemNavItem(
        key: 'billing_adapters',
        titleAr: 'Adapters الدفع',
        route: NosokSystemRoutes.adminBillingAdapters,
        icon: Icons.hub_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokBillingAdapters}),
    NosokSystemNavItem(
        key: 'notification_dispatch',
        titleAr: 'إرسال الإشعارات',
        route: NosokSystemRoutes.adminNotificationDispatch,
        icon: Icons.send,
        permissionKeys: {NosokPermissionKeys.dispatchNosokNotifications}),
    NosokSystemNavItem(
        key: 'notifications',
        titleAr: 'قوالب الإشعار',
        route: NosokSystemRoutes.adminNotifications,
        icon: Icons.notifications_none_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokNotifications}),
    NosokSystemNavItem(
        key: 'reports',
        titleAr: 'التقارير',
        route: NosokSystemRoutes.adminReports,
        icon: Icons.query_stats_outlined,
        permissionKeys: {NosokPermissionKeys.viewNosokReports}),
    NosokSystemNavItem(
        key: 'tracking_privacy',
        titleAr: 'خصوصية التتبع',
        route: NosokSystemRoutes.adminTrackingPrivacy,
        icon: Icons.privacy_tip_outlined,
        permissionKeys: {NosokPermissionKeys.reviewNosokTrackingPrivacy}),
    NosokSystemNavItem(
        key: 'users_roles',
        titleAr: 'المستخدمون والأدوار',
        route: NosokSystemRoutes.adminUsersRoles,
        icon: Icons.manage_accounts_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokAccess}),
    NosokSystemNavItem(
        key: 'visual_governance',
        titleAr: 'حوكمة الواجهة',
        route: NosokSystemRoutes.adminVisualGovernance,
        icon: Icons.palette_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokVisualGovernance}),
    NosokSystemNavItem(
        key: 'settings',
        titleAr: 'الإعدادات',
        route: NosokSystemRoutes.adminSettings,
        icon: Icons.settings_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokSettings}),
    NosokSystemNavItem(
        key: 'health',
        titleAr: 'الصحة والتدقيق',
        route: NosokSystemRoutes.adminHealth,
        icon: Icons.health_and_safety_outlined,
        permissionKeys: {NosokPermissionKeys.viewNosokHealth}),
    NosokSystemNavItem(
        key: 'production_gate',
        titleAr: 'بوابة الإنتاج',
        route: NosokSystemRoutes.adminProductionGateDecision,
        icon: Icons.verified_user_outlined,
        permissionKeys: {NosokPermissionKeys.decideNosokProductionGate}),
    NosokSystemNavItem(
        key: 'v24_uat_evidence',
        titleAr: 'أدلة UAT v24',
        route: NosokSystemRoutes.adminV24UatEvidence,
        icon: Icons.fact_check_outlined,
        permissionKeys: {
          NosokPermissionKeys.closeNosokBrowserRoleResponsiveUat
        }),
    NosokSystemNavItem(
        key: 'v24_responsive_uat',
        titleAr: 'Responsive UAT',
        route: NosokSystemRoutes.adminV24ResponsiveUat,
        icon: Icons.devices_outlined,
        permissionKeys: {
          NosokPermissionKeys.closeNosokBrowserRoleResponsiveUat
        }),
    NosokSystemNavItem(
        key: 'v24_merge_closure',
        titleAr: 'إغلاق جاهزية الدمج',
        route: NosokSystemRoutes.adminV24MergeReadinessClosure,
        icon: Icons.merge_type_outlined,
        permissionKeys: {NosokPermissionKeys.closeNosokMergeReadiness}),
    NosokSystemNavItem(
        key: 'v24_supabase_uat',
        titleAr: 'Supabase UAT',
        route: NosokSystemRoutes.adminV24SupabaseRuntimeUat,
        icon: Icons.storage_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokSupabaseRuntimeUat}),
    NosokSystemNavItem(
        key: 'v24_production_redecision',
        titleAr: 'إعادة قرار الإنتاج',
        route: NosokSystemRoutes.adminV24ProductionRedecision,
        icon: Icons.rule_folder_outlined,
        permissionKeys: {NosokPermissionKeys.redecideNosokProductionGate}),
    NosokSystemNavItem(
        key: 'v25_evidence_intake',
        titleAr: 'استيعاب أدلة v25',
        route: NosokSystemRoutes.adminV25EvidenceIntake,
        icon: Icons.fact_check_outlined,
        permissionKeys: {NosokPermissionKeys.intakeNosokV25Evidence}),
    NosokSystemNavItem(
        key: 'v25_full_merge_result',
        titleAr: 'نتيجة الدمج الحقيقي',
        route: NosokSystemRoutes.adminV25FullMergeApplicationResult,
        icon: Icons.integration_instructions_outlined,
        permissionKeys: {
          NosokPermissionKeys.intakeNosokFullMergeApplicationResult
        }),
    NosokSystemNavItem(
        key: 'v25_candidate_decision',
        titleAr: 'قرار Production Candidate',
        route: NosokSystemRoutes.adminV25ProductionCandidateDecision,
        icon: Icons.verified_outlined,
        permissionKeys: {NosokPermissionKeys.decideNosokProductionCandidate}),
    NosokSystemNavItem(
        key: 'v26_evidence_results',
        titleAr: 'نتائج أدلة v26',
        route: NosokSystemRoutes.adminV26EvidenceResultIntake,
        icon: Icons.rule_outlined,
        permissionKeys: {NosokPermissionKeys.intakeNosokV26EvidenceResults}),
    NosokSystemNavItem(
        key: 'v26_full_merge_apply',
        titleAr: 'تطبيق الدمج v26',
        route: NosokSystemRoutes.adminV26FullMergeApplyResult,
        icon: Icons.merge_type_outlined,
        permissionKeys: {NosokPermissionKeys.intakeNosokFullMergeApplyResult}),
    NosokSystemNavItem(
        key: 'v26_candidate_redecision',
        titleAr: 'إعادة قرار v26',
        route: NosokSystemRoutes.adminV26ProductionCandidateRedecision,
        icon: Icons.gpp_maybe_outlined,
        permissionKeys: {NosokPermissionKeys.redecideNosokProductionCandidate}),
    NosokSystemNavItem(
        key: 'v27_schema_census',
        titleAr: 'جرد السكيما v27',
        route: NosokSystemRoutes.adminV27SchemaCensusResult,
        icon: Icons.schema_outlined,
        permissionKeys: {NosokPermissionKeys.intakeNosokV27SchemaCensus}),
    NosokSystemNavItem(
        key: 'v27_object_reconciliation',
        titleAr: 'مطابقة الموجود',
        route: NosokSystemRoutes.adminV27ExistingObjectReconciliation,
        icon: Icons.compare_arrows_outlined,
        permissionKeys: {NosokPermissionKeys.reconcileNosokExistingObjects}),
    NosokSystemNavItem(
        key: 'v27_diff_plan',
        titleAr: 'خطة nosok.*',
        route: NosokSystemRoutes.adminV27OwnerSchemaDiffPlan,
        icon: Icons.account_tree_outlined,
        permissionKeys: {NosokPermissionKeys.planNosokOwnerSchemaDiff}),
    NosokSystemNavItem(
        key: 'v27_safe_sql_gate',
        titleAr: 'بوابة SQL الآمن',
        route: NosokSystemRoutes.adminV27SafeSqlExecutionGate,
        icon: Icons.rule_folder_outlined,
        permissionKeys: {NosokPermissionKeys.decideNosokSafeSqlExecutionGate}),
    NosokSystemNavItem(
        key: 'v28_owner_schema_design',
        titleAr: 'تصميم schema نسك',
        route: NosokSystemRoutes.adminV28OwnerSchemaDesign,
        icon: Icons.schema_outlined,
        permissionKeys: {NosokPermissionKeys.designNosokOwnerSchema}),
    NosokSystemNavItem(
        key: 'v28_guarded_ddl_draft',
        titleAr: 'DDL محروس v28',
        route: NosokSystemRoutes.adminV28GuardedDdlDraft,
        icon: Icons.code_outlined,
        permissionKeys: {NosokPermissionKeys.reviewNosokGuardedDdlDraft}),
    NosokSystemNavItem(
        key: 'v28_rls_rpc_matrix',
        titleAr: 'RLS/RPC Matrix',
        route: NosokSystemRoutes.adminV28RlsRpcMatrix,
        icon: Icons.policy_outlined,
        permissionKeys: {NosokPermissionKeys.planNosokRlsRpcMatrix}),
    NosokSystemNavItem(
        key: 'v28_execution_gate',
        titleAr: 'تفويض التنفيذ v28',
        route: NosokSystemRoutes.adminV28ExecutionAuthorizationGate,
        icon: Icons.lock_outline,
        permissionKeys: {
          NosokPermissionKeys.decideNosokExecutionAuthorizationGate
        }),
    NosokSystemNavItem(
        key: 'v29_ddl_authorization',
        titleAr: 'تفويض DDL v29',
        route: NosokSystemRoutes.adminV29DdlAuthorizationIntake,
        icon: Icons.key_outlined,
        permissionKeys: {NosokPermissionKeys.intakeNosokV29DdlAuthorization}),
    NosokSystemNavItem(
        key: 'v29_staging_apply_gate',
        titleAr: 'بوابة staging v29',
        route: NosokSystemRoutes.adminV29StagingApplyGate,
        icon: Icons.cloud_upload_outlined,
        permissionKeys: {NosokPermissionKeys.manageNosokV29StagingApplyGate}),
    NosokSystemNavItem(
        key: 'v29_negative_uat',
        titleAr: 'RLS/RPC UAT v29',
        route: NosokSystemRoutes.adminV29RlsRpcNegativeUatPreflight,
        icon: Icons.rule_outlined,
        permissionKeys: {
          NosokPermissionKeys.runNosokV29RlsRpcNegativeUatPreflight
        }),
    NosokSystemNavItem(
        key: 'v30_authorization_token',
        titleAr: 'تفويض v30',
        route: NosokSystemRoutes.adminV30AuthorizationTokenIntake,
        icon: Icons.vpn_key_outlined,
        permissionKeys: {NosokPermissionKeys.intakeNosokV30AuthorizationToken}),
    NosokSystemNavItem(
        key: 'v30_apply_result',
        titleAr: 'نتيجة DDL v30',
        route: NosokSystemRoutes.adminV30ControlledDdlApplyResult,
        icon: Icons.fact_check_outlined,
        permissionKeys: {
          NosokPermissionKeys.intakeNosokV30ControlledDdlApplyResult
        }),
    NosokSystemNavItem(
        key: 'v30_negative_uat_gate',
        titleAr: 'UAT تنفيذ v30',
        route: NosokSystemRoutes.adminV30RlsRpcNegativeUatExecutionGate,
        icon: Icons.rule_folder_outlined,
        permissionKeys: {
          NosokPermissionKeys.runNosokV30RlsRpcNegativeUatExecutionGate
        }),
    NosokSystemNavItem(
        key: 'v31_authorization_evidence',
        titleAr: 'تفويض v31',
        route: NosokSystemRoutes.adminV31AuthorizationTokenEvidence,
        icon: Icons.verified_user_outlined,
        permissionKeys: {
          NosokPermissionKeys.intakeNosokV31AuthorizationTokenEvidence
        }),
    NosokSystemNavItem(
        key: 'v31_apply_certification',
        titleAr: 'شهادة DDL v31',
        route: NosokSystemRoutes.adminV31ControlledStagingApplyCertification,
        icon: Icons.fact_check_outlined,
        permissionKeys: {
          NosokPermissionKeys.certifyNosokV31ControlledStagingApply
        }),
    NosokSystemNavItem(
        key: 'v31_post_apply_uat',
        titleAr: 'إغلاق UAT v31',
        route: NosokSystemRoutes.adminV31PostApplyRlsRpcNegativeUatClosure,
        icon: Icons.rule_outlined,
        permissionKeys: {
          NosokPermissionKeys.closeNosokV31PostApplyNegativeUat
        }),
    NosokSystemNavItem(
        key: 'v32_apply_evidence',
        titleAr: 'أدلة apply v32',
        route: NosokSystemRoutes.adminV32ControlledStagingDdlApplyEvidence,
        icon: Icons.cloud_done_outlined,
        permissionKeys: {
          NosokPermissionKeys.intakeNosokV32ControlledApplyEvidence
        }),
    NosokSystemNavItem(
        key: 'v32_post_apply_rls',
        titleAr: 'إغلاق RLS v32',
        route: NosokSystemRoutes.adminV32PostApplyCensusRlsResultClosure,
        icon: Icons.policy_outlined,
        permissionKeys: {NosokPermissionKeys.closeNosokV32PostApplyCensusRls}),
    NosokSystemNavItem(
        key: 'v32_production_gate',
        titleAr: 'قرار الإنتاج v32',
        route: NosokSystemRoutes.adminV32ProductionGateRedecision,
        icon: Icons.gpp_maybe_outlined,
        permissionKeys: {NosokPermissionKeys.redecideNosokV32ProductionGate}),
    NosokSystemNavItem(
        key: 'v33_negative_uat',
        titleAr: 'UAT سلبي v33',
        route: NosokSystemRoutes.adminV33PostApplyRlsRpcNegativeUatExecution,
        icon: Icons.rule_folder_outlined,
        permissionKeys: {
          NosokPermissionKeys.executeNosokV33PostApplyNegativeUat
        }),
    NosokSystemNavItem(
        key: 'v33_public_wrappers',
        titleAr: 'Wrappers عامة v33',
        route: NosokSystemRoutes.adminV33PublicWrapperSurfaceDraft,
        icon: Icons.api_outlined,
        permissionKeys: {
          NosokPermissionKeys.draftNosokV33PublicWrapperSurface
        }),
    NosokSystemNavItem(
        key: 'v33_repository_binding',
        titleAr: 'ربط المستودعات v33',
        route: NosokSystemRoutes.adminV33RepositoryBindingGate,
        icon: Icons.sync_alt_outlined,
        permissionKeys: {
          NosokPermissionKeys.decideNosokV33RepositoryBindingGate
        }),
    NosokSystemNavItem(
        key: 'v34_wrapper_authorization',
        titleAr: 'تفويض Wrappers v34',
        route: NosokSystemRoutes.adminV34PublicWrapperRpcAuthorization,
        icon: Icons.api_outlined,
        permissionKeys: {
          NosokPermissionKeys.authorizeNosokV34PublicWrapperRpcApply
        }),
    NosokSystemNavItem(
        key: 'v34_browser_role_uat',
        titleAr: 'أدلة UAT v34',
        route: NosokSystemRoutes.adminV34BrowserRoleNegativeUatEvidenceIntake,
        icon: Icons.fact_check_outlined,
        permissionKeys: {
          NosokPermissionKeys.intakeNosokV34BrowserRoleNegativeUatEvidence
        }),
    NosokSystemNavItem(
        key: 'v34_repository_binding',
        titleAr: 'بوابة الربط v34',
        route: NosokSystemRoutes.adminV34RepositoryBindingAuthorizationGate,
        icon: Icons.sync_alt_outlined,
        permissionKeys: {
          NosokPermissionKeys.decideNosokV34RepositoryBindingAuthorizationGate
        }),
    NosokSystemNavItem(
        key: 'v35_wrapper_apply_result',
        titleAr: 'نتيجة Wrapper v35',
        route: NosokSystemRoutes.adminV35WrapperRpcApplyResult,
        icon: Icons.cloud_done_outlined,
        permissionKeys: {
          NosokPermissionKeys.intakeNosokV35WrapperRpcApplyResult
        }),
    NosokSystemNavItem(
        key: 'v35_wrapper_evidence',
        titleAr: 'إغلاق Wrapper/RPC v35',
        route: NosokSystemRoutes.adminV35PostApplyWrapperRpcEvidenceClosure,
        icon: Icons.fact_check_outlined,
        permissionKeys: {NosokPermissionKeys.closeNosokV35WrapperRpcEvidence}),
    NosokSystemNavItem(
        key: 'v35_repository_preflight',
        titleAr: 'ربط المستودعات v35',
        route: NosokSystemRoutes.adminV35RepositoryBindingPreflightDecision,
        icon: Icons.sync_alt_outlined,
        permissionKeys: {
          NosokPermissionKeys.decideNosokV35RepositoryBindingPreflight
        }),
    NosokSystemNavItem(
        key: 'v36_browser_role_scope',
        titleAr: 'UAT Wrapper v36',
        route: NosokSystemRoutes.adminV36BrowserRoleScopeWrapperUat,
        icon: Icons.fact_check_outlined,
        permissionKeys: {
          NosokPermissionKeys.intakeNosokV36BrowserRoleScopeUat
        }),
    NosokSystemNavItem(
        key: 'v36_repository_adapter',
        titleAr: 'Adapter الربط v36',
        route: NosokSystemRoutes.adminV36RepositoryBindingControlledAdapter,
        icon: Icons.api_outlined,
        permissionKeys: {
          NosokPermissionKeys.manageNosokV36RepositoryBindingAdapter
        }),
    NosokSystemNavItem(
        key: 'v36_production_gate',
        titleAr: 'قرار الإنتاج v36',
        route: NosokSystemRoutes.adminV36ProductionGateRedecision,
        icon: Icons.gpp_maybe_outlined,
        permissionKeys: {NosokPermissionKeys.redecideNosokV36ProductionGate}),
    NosokSystemNavItem(
        key: 'v37_runtime_switch',
        titleAr: 'Switch الربط v37',
        route: NosokSystemRoutes
            .adminV37PublicRepositoryBindingRuntimeSwitchCandidate,
        icon: Icons.swap_horiz_outlined,
        permissionKeys: {
          NosokPermissionKeys.manageNosokV37RuntimeSwitchCandidate
        }),
    NosokSystemNavItem(
        key: 'v37_browser_evidence',
        titleAr: 'أدلة المتصفح v37',
        route: NosokSystemRoutes.adminV37BrowserEvidenceResultIntake,
        icon: Icons.monitor_heart_outlined,
        permissionKeys: {NosokPermissionKeys.intakeNosokV37BrowserEvidence}),
    NosokSystemNavItem(
        key: 'v37_production_gate',
        titleAr: 'قرار الإنتاج v37',
        route: NosokSystemRoutes.adminV37ProductionGateRedecision,
        icon: Icons.gpp_maybe_outlined,
        permissionKeys: {NosokPermissionKeys.redecideNosokV37ProductionGate}),
  ];

  static List<NosokSystemNavItem> visibleAdminItems(
      NosokAccessProfile profile) {
    if (profile.isSuperuser) return adminItems;
    return adminItems
        .where((item) =>
            item.permissionKeys.isEmpty ||
            profile.hasAnyPermission(item.permissionKeys))
        .toList(growable: false);
  }

  static NosokSystemNavItem? adminItemForPath(String location) {
    final normalized = location.split('?').first.split('#').first;
    NosokSystemNavItem? bestMatch;
    for (final item in adminItems) {
      if (normalized == item.route || normalized.startsWith('${item.route}/')) {
        if (bestMatch == null || item.route.length > bestMatch.route.length) {
          bestMatch = item;
        }
      }
    }
    return bestMatch;
  }
}
