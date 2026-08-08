import 'package:go_router/go_router.dart';

import '../../system_permissions.dart';
import '../../system_routes.dart';
import '../pages/admin/nosok_admin_application_details_page.dart';
import '../pages/admin/nosok_admin_application_lifecycle_page.dart';
import '../pages/admin/nosok_admin_application_operations_page.dart';
import '../pages/admin/nosok_admin_applications_page.dart';
import '../pages/admin/nosok_admin_billing_adapters_page.dart';
import '../pages/admin/nosok_admin_browser_role_evidence_page.dart';
import '../pages/admin/nosok_admin_companies_page.dart';
import '../pages/admin/nosok_admin_complaints_page.dart';
import '../pages/admin/nosok_admin_content_page.dart';
import '../pages/admin/nosok_admin_dashboard_page.dart';
import '../pages/admin/nosok_admin_followup_inbox_page.dart';
import '../pages/admin/nosok_admin_health_page.dart';
import '../pages/admin/nosok_admin_notification_dispatch_page.dart';
import '../pages/admin/nosok_admin_notification_provider_uat_page.dart';
import '../pages/admin/nosok_admin_notifications_page.dart';
import '../pages/admin/nosok_admin_operations_page.dart';
import '../pages/admin/nosok_admin_payment_bridge_page.dart';
import '../pages/admin/nosok_admin_platform_integration_readiness_page.dart';
import '../pages/admin/nosok_admin_production_gate_decision_page.dart';
import '../pages/admin/nosok_admin_production_uat_closure_page.dart';
import '../pages/admin/nosok_admin_programs_page.dart';
import '../pages/admin/nosok_admin_rbac_provider_override_page.dart';
import '../pages/admin/nosok_admin_readiness_evidence_page.dart';
import '../pages/admin/nosok_admin_real_platform_merge_page.dart';
import '../pages/admin/nosok_admin_remaining_work_page.dart';
import '../pages/admin/nosok_admin_reports_page.dart';
import '../pages/admin/nosok_admin_role_uat_page.dart';
import '../pages/admin/nosok_admin_season_command_page.dart';
import '../pages/admin/nosok_admin_seasons_page.dart';
import '../pages/admin/nosok_admin_service_desk_page.dart';
import '../pages/admin/nosok_admin_settings_page.dart';
import '../pages/admin/nosok_admin_sidebar_page.dart';
import '../pages/admin/nosok_admin_sql_uat_intake_page.dart';
import '../pages/admin/nosok_admin_tracking_privacy_page.dart';
import '../pages/admin/nosok_admin_unit_page.dart';
import '../pages/admin/nosok_admin_unit_queues_page.dart';
import '../pages/admin/nosok_admin_units_page.dart';
import '../pages/admin/nosok_admin_users_roles_page.dart';
import '../pages/admin/nosok_admin_visual_governance_page.dart';
import '../pages/admin/nosok_admin_v24_merge_readiness_closure_page.dart';
import '../pages/admin/nosok_admin_v24_production_redecision_page.dart';
import '../pages/admin/nosok_admin_v24_responsive_uat_page.dart';
import '../pages/admin/nosok_admin_v24_supabase_runtime_uat_page.dart';
import '../pages/admin/nosok_admin_v24_uat_evidence_page.dart';
import '../pages/admin/nosok_admin_v25_evidence_intake_page.dart';
import '../pages/admin/nosok_admin_v25_full_merge_application_result_page.dart';
import '../pages/admin/nosok_admin_v25_production_candidate_decision_page.dart';
import '../pages/admin/nosok_admin_v26_evidence_result_intake_page.dart';
import '../pages/admin/nosok_admin_v26_full_merge_apply_result_page.dart';
import '../pages/admin/nosok_admin_v26_production_candidate_redecision_page.dart';
import '../pages/admin/nosok_admin_v27_existing_object_reconciliation_page.dart';
import '../pages/admin/nosok_admin_v27_owner_schema_diff_plan_page.dart';
import '../pages/admin/nosok_admin_v27_safe_sql_execution_gate_page.dart';
import '../pages/admin/nosok_admin_v27_schema_census_result_page.dart';
import '../pages/admin/nosok_admin_v28_execution_authorization_gate_page.dart';
import '../pages/admin/nosok_admin_v28_guarded_ddl_draft_page.dart';
import '../pages/admin/nosok_admin_v28_owner_schema_design_page.dart';
import '../pages/admin/nosok_admin_v28_rls_rpc_matrix_page.dart';
import '../pages/admin/nosok_admin_v29_ddl_authorization_intake_page.dart';
import '../pages/admin/nosok_admin_v29_rls_rpc_negative_uat_preflight_page.dart';
import '../pages/admin/nosok_admin_v29_staging_apply_gate_page.dart';
import '../pages/admin/nosok_admin_v30_authorization_token_intake_page.dart';
import '../pages/admin/nosok_admin_v30_controlled_ddl_apply_result_page.dart';
import '../pages/admin/nosok_admin_v30_rls_rpc_negative_uat_execution_gate_page.dart';
import '../pages/admin/nosok_admin_v31_authorization_token_evidence_page.dart';
import '../pages/admin/nosok_admin_v31_controlled_staging_apply_certification_page.dart';
import '../pages/admin/nosok_admin_v31_post_apply_rls_rpc_negative_uat_closure_page.dart';
import '../pages/admin/nosok_admin_v32_controlled_staging_ddl_apply_evidence_page.dart';
import '../pages/admin/nosok_admin_v32_post_apply_census_rls_result_closure_page.dart';
import '../pages/admin/nosok_admin_v32_production_gate_redecision_page.dart';
import '../pages/admin/nosok_admin_v33_post_apply_rls_rpc_negative_uat_execution_page.dart';
import '../pages/admin/nosok_admin_v33_public_wrapper_surface_draft_page.dart';
import '../pages/admin/nosok_admin_v33_repository_binding_gate_page.dart';
import '../pages/admin/nosok_admin_v34_browser_role_negative_uat_evidence_intake_page.dart';
import '../pages/admin/nosok_admin_v34_public_wrapper_rpc_authorization_page.dart';
import '../pages/admin/nosok_admin_v34_repository_binding_authorization_gate_page.dart';
import '../pages/admin/nosok_admin_v35_post_apply_wrapper_rpc_evidence_closure_page.dart';
import '../pages/admin/nosok_admin_v35_repository_binding_preflight_decision_page.dart';
import '../pages/admin/nosok_admin_v35_wrapper_rpc_apply_result_page.dart';
import '../pages/admin/nosok_admin_v36_browser_role_scope_wrapper_uat_page.dart';
import '../pages/admin/nosok_admin_v36_production_gate_redecision_page.dart';
import '../pages/admin/nosok_admin_v36_repository_binding_controlled_adapter_page.dart';
import '../pages/admin/nosok_admin_v37_browser_evidence_result_intake_page.dart';
import '../pages/admin/nosok_admin_v37_production_gate_redecision_page.dart';
import '../pages/admin/nosok_admin_v37_public_repository_binding_runtime_switch_candidate_page.dart';
import '../pages/admin/nosok_admin_workflow_workbench_page.dart';
import '../pages/admin/nosok_internal_campaigns_page.dart';
import '../pages/admin/nosok_internal_documents_page.dart';
import '../pages/admin/nosok_internal_groups_page.dart';
import '../pages/admin/nosok_internal_messages_page.dart';
import '../pages/admin/nosok_internal_requests_page.dart';
import '../pages/admin/nosok_internal_review_page.dart';
import '../pages/public/nosok_application_status_page.dart';
import '../pages/public/nosok_apply_page.dart';
import '../pages/public/nosok_citizen_followup_page.dart';
import '../pages/public/nosok_citizen_journey_page.dart';
import '../pages/public/nosok_companies_page.dart';
import '../pages/public/nosok_complaints_page.dart';
import '../pages/public/nosok_faq_page.dart';
import '../pages/public/nosok_hajj_page.dart';
import '../pages/public/nosok_public_home_page.dart';
import '../pages/public/nosok_public_unit_page.dart';
import '../pages/public/nosok_requirements_page.dart';
import '../pages/public/nosok_umrah_page.dart';
import '../widgets/nosok_access_gate.dart';
import '../widgets/nosok_admin_system_shell.dart';
import '../widgets/nosok_public_system_shell.dart';

class NosokRoutes {
  const NosokRoutes._();

  static List<RouteBase> publicRoutes = <RouteBase>[
    GoRoute(
        path: NosokSystemRoutes.switchEntry,
        redirect: (context, state) => NosokSystemRoutes.publicHome),
    GoRoute(
        path: NosokSystemRoutes.legacyPublicHome,
        redirect: (context, state) => NosokSystemRoutes.publicHome),
    GoRoute(
        path: NosokSystemRoutes.legacyHajj,
        redirect: (context, state) => NosokSystemRoutes.hajj),
    GoRoute(
        path: NosokSystemRoutes.legacyUmrah,
        redirect: (context, state) => NosokSystemRoutes.umrah),
    GoRoute(
        path: NosokSystemRoutes.legacyCompanies,
        redirect: (context, state) => NosokSystemRoutes.companies),
    GoRoute(
        path: NosokSystemRoutes.legacyComplaints,
        redirect: (context, state) => NosokSystemRoutes.complaints),
    GoRoute(
        path: NosokSystemRoutes.legacyFaq,
        redirect: (context, state) => NosokSystemRoutes.faq),
    GoRoute(
        path: NosokSystemRoutes.legacyServiceGuide,
        redirect: (context, state) => NosokSystemRoutes.requirements),
    GoRoute(
        path: NosokSystemRoutes.legacyCitizenJourney,
        redirect: (context, state) => NosokSystemRoutes.citizenJourney),
    GoRoute(
        path: NosokSystemRoutes.legacyApplicationStatus,
        redirect: (context, state) => NosokSystemRoutes.track),
    GoRoute(
        path: NosokSystemRoutes.legacyCitizenFollowup,
        redirect: (context, state) => NosokSystemRoutes.citizenFollowup),
    GoRoute(
        path: NosokSystemRoutes.legacyApply,
        redirect: (context, state) => NosokSystemRoutes.apply),
    ShellRoute(
      builder: (context, state, child) =>
          NosokPublicSystemShell(location: state.uri.path, child: child),
      routes: <RouteBase>[
        GoRoute(
          path: NosokSystemRoutes.publicHome,
          builder: (context, state) => const NosokPublicHomePage(),
          routes: <RouteBase>[
            GoRoute(
                path: 'hajj',
                builder: (context, state) => const NosokHajjPage()),
            GoRoute(
                path: 'umrah',
                builder: (context, state) => const NosokUmrahPage()),
            GoRoute(
                path: 'companies',
                builder: (context, state) => const NosokCompaniesPage()),
            GoRoute(
                path: 'complaints',
                builder: (context, state) => const NosokComplaintsPage()),
            GoRoute(
                path: 'faq', builder: (context, state) => const NosokFaqPage()),
            GoRoute(
                path: 'lottery-results',
                redirect: (context, state) => NosokSystemRoutes.track),
            GoRoute(
                path: 'waiting-list',
                redirect: (context, state) => NosokSystemRoutes.track),
            GoRoute(
                path: 'objections',
                redirect: (context, state) => NosokSystemRoutes.complaints),
            GoRoute(
                path: 'contact',
                redirect: (context, state) => NosokSystemRoutes.faq),
            GoRoute(
                path: 'company-login',
                redirect: (context, state) => NosokSystemRoutes.companies),
            GoRoute(
                path: 'legal-regulation',
                redirect: (context, state) => NosokSystemRoutes.requirements),
            GoRoute(
                path: 'requirements',
                builder: (context, state) => const NosokRequirementsPage()),
            GoRoute(
                path: 'citizen-journey',
                builder: (context, state) => const NosokCitizenJourneyPage()),
            GoRoute(
                path: 'track',
                builder: (context, state) =>
                    const NosokApplicationStatusPage()),
            GoRoute(
                path: 'follow-up',
                builder: (context, state) => const NosokCitizenFollowupPage()),
            GoRoute(
                path: 'apply',
                builder: (context, state) => const NosokApplyPage()),
            GoRoute(
                path: 'units/:unitSlug',
                builder: (context, state) => NosokPublicUnitPage(
                    unitSlug: state.pathParameters['unitSlug'] ?? 'home')),
          ],
        ),
      ],
    ),
  ];

  static List<RouteBase> adminRoutes = <RouteBase>[
    GoRoute(
        path: NosokSystemRoutes.legacyAdminHome,
        redirect: (context, state) => NosokSystemRoutes.adminHome),
    GoRoute(
        path: NosokSystemRoutes.legacyAdminSeasons,
        redirect: (context, state) => NosokSystemRoutes.adminSeasons),
    GoRoute(
        path: NosokSystemRoutes.legacyAdminPrograms,
        redirect: (context, state) => NosokSystemRoutes.adminPrograms),
    GoRoute(
        path: NosokSystemRoutes.legacyAdminCompanies,
        redirect: (context, state) => NosokSystemRoutes.adminCompanies),
    GoRoute(
        path: NosokSystemRoutes.legacyAdminApplications,
        redirect: (context, state) => NosokSystemRoutes.adminApplications),
    GoRoute(
        path: NosokSystemRoutes.legacyAdminComplaints,
        redirect: (context, state) => NosokSystemRoutes.adminComplaints),
    GoRoute(
        path: NosokSystemRoutes.legacyAdminContent,
        redirect: (context, state) => NosokSystemRoutes.adminContent),
    GoRoute(
        path: NosokSystemRoutes.legacyAdminReports,
        redirect: (context, state) => NosokSystemRoutes.adminReports),
    ShellRoute(
      builder: (context, state, child) =>
          NosokAdminSystemShell(location: state.uri.path, child: child),
      routes: <RouteBase>[
        GoRoute(
          path: NosokSystemRoutes.adminHome,
          builder: (context, state) => const NosokAccessGate(
              requiredPermissions: {NosokPermissionKeys.viewNosokDashboard},
              child: NosokAdminDashboardPage()),
          routes: <RouteBase>[
            GoRoute(
                path: 'requests',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.viewNosokRequests,
                      NosokPermissionKeys.manageNosokApplications
                    }, child: NosokInternalRequestsPage())),
            GoRoute(
                path: 'review',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.reviewNosokRequestsQueue,
                      NosokPermissionKeys.reviewNosokApplications
                    }, child: NosokInternalReviewPage())),
            GoRoute(
                path: 'campaigns',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokCampaigns
                        },
                        child: NosokInternalCampaignsPage())),
            GoRoute(
                path: 'groups',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokGroups
                        },
                        child: NosokInternalGroupsPage())),
            GoRoute(
                path: 'documents',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.viewNosokDocumentsConsole,
                      NosokPermissionKeys.manageNosokDocuments
                    }, child: NosokInternalDocumentsPage())),
            GoRoute(
                path: 'messages',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.manageNosokMessages,
                      NosokPermissionKeys.manageNosokFollowupInbox
                    }, child: NosokInternalMessagesPage())),
            GoRoute(
                path: 'seasons',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokSeasons
                        },
                        child: NosokAdminSeasonsPage())),
            GoRoute(
                path: 'programs',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokPrograms
                        },
                        child: NosokAdminProgramsPage())),
            GoRoute(
                path: 'companies',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokCompanies
                        },
                        child: NosokAdminCompaniesPage())),
            GoRoute(
              path: 'applications',
              builder: (context, state) =>
                  const NosokAccessGate(requiredPermissions: {
                NosokPermissionKeys.manageNosokApplications,
                NosokPermissionKeys.reviewNosokApplications
              }, child: NosokAdminApplicationsPage()),
              routes: <RouteBase>[
                GoRoute(
                    path: ':applicationId',
                    builder: (context, state) => NosokAccessGate(
                            requiredPermissions: const {
                              NosokPermissionKeys.manageNosokApplications,
                              NosokPermissionKeys.reviewNosokApplications
                            },
                            child: NosokAdminApplicationDetailsPage(
                                applicationId:
                                    state.pathParameters['applicationId'] ??
                                        ''))),
              ],
            ),
            GoRoute(
                path: 'complaints',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokComplaints
                        },
                        child: NosokAdminComplaintsPage())),
            GoRoute(
                path: 'content',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokContent
                        },
                        child: NosokAdminContentPage())),
            GoRoute(
                path: 'reports',
                builder: (context, state) => const NosokAccessGate(
                    requiredPermissions: {NosokPermissionKeys.viewNosokReports},
                    child: NosokAdminReportsPage())),
            GoRoute(
                path: 'units',
                builder: (context, state) => const NosokAccessGate(
                    requiredPermissions: {NosokPermissionKeys.manageNosokUnits},
                    child: NosokAdminUnitsPage()),
                routes: <RouteBase>[
                  GoRoute(
                      path: ':unitId',
                      builder: (context, state) => NosokAccessGate(
                              requiredPermissions: const {
                                NosokPermissionKeys.manageNosokUnits
                              },
                              child: NosokAdminUnitPage(
                                  unitId: state.pathParameters['unitId'] ??
                                      'home')))
                ]),
            GoRoute(
                path: 'users-roles',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokAccess
                        },
                        child: NosokAdminUsersRolesPage())),
            GoRoute(
                path: 'sidebar',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokSurface
                        },
                        child: NosokAdminSidebarPage())),
            GoRoute(
                path: 'settings',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokSettings
                        },
                        child: NosokAdminSettingsPage())),
            GoRoute(
                path: 'health',
                builder: (context, state) => const NosokAccessGate(
                    requiredPermissions: {NosokPermissionKeys.viewNosokHealth},
                    child: NosokAdminHealthPage())),
            GoRoute(
                path: 'workflow-workbench',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.viewNosokWorkflowWorkbench
                        },
                        child: NosokAdminWorkflowWorkbenchPage())),
            GoRoute(
                path: 'season-command',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.viewNosokSeasonCommand
                        },
                        child: NosokAdminSeasonCommandPage())),
            GoRoute(
                path: 'service-desk',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokServiceDesk
                        },
                        child: NosokAdminServiceDeskPage())),
            GoRoute(
                path: 'visual-governance',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokVisualGovernance
                        },
                        child: NosokAdminVisualGovernancePage())),
            GoRoute(
                path: 'operations',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.viewNosokOperations
                        },
                        child: NosokAdminOperationsPage())),
            GoRoute(
                path: 'payment-bridge',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.manageNosokPaymentBridge,
                      NosokPermissionKeys.executeNosokBillingBridge
                    }, child: NosokAdminPaymentBridgePage())),
            GoRoute(
                path: 'unit-queues',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.viewNosokUnitQueues
                        },
                        child: NosokAdminUnitQueuesPage())),
            GoRoute(
                path: 'role-uat',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.viewNosokRoleUat,
                      NosokPermissionKeys.manageNosokRoleUatEvidence
                    }, child: NosokAdminRoleUatPage())),
            GoRoute(
                path: 'notifications',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokNotifications
                        },
                        child: NosokAdminNotificationsPage())),
            GoRoute(
                path: 'billing-adapters',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokBillingAdapters
                        },
                        child: NosokAdminBillingAdaptersPage())),
            GoRoute(
                path: 'tracking-privacy',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.reviewNosokTrackingPrivacy
                        },
                        child: NosokAdminTrackingPrivacyPage())),
            GoRoute(
                path: 'readiness-evidence',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokReadinessEvidence
                        },
                        child: NosokAdminReadinessEvidencePage())),
            GoRoute(
                path: 'application-lifecycle',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokApplicationLifecycle
                        },
                        child: NosokAdminApplicationLifecyclePage())),
            GoRoute(
                path: 'notification-dispatch',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.dispatchNosokNotifications
                        },
                        child: NosokAdminNotificationDispatchPage())),
            GoRoute(
                path: 'follow-up-inbox',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokFollowupInbox
                        },
                        child: NosokAdminFollowupInboxPage())),
            GoRoute(
                path: 'notification-provider-uat',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.runNosokNotificationProviderUat
                        },
                        child: NosokAdminNotificationProviderUatPage())),
            GoRoute(
                path: 'production-uat-closure',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.closeNosokProductionUat
                        },
                        child: NosokAdminProductionUatClosurePage())),
            GoRoute(
                path: 'application-operations',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.viewNosokApplicationOperations
                        },
                        child: NosokAdminApplicationOperationsPage())),
            GoRoute(
                path: 'platform-integration-readiness',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .manageNosokPlatformIntegrationReadiness
                        },
                        child: NosokAdminPlatformIntegrationReadinessPage())),
            GoRoute(
                path: 'real-platform-merge',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokRealPlatformMerge
                        },
                        child: NosokAdminRealPlatformMergePage())),
            GoRoute(
                path: 'rbac-provider-override',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokRbacProviderOverride
                        },
                        child: NosokAdminRbacProviderOverridePage())),
            GoRoute(
                path: 'sql-uat-intake',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokSqlUatResults
                        },
                        child: NosokAdminSqlUatIntakePage())),
            GoRoute(
                path: 'browser-role-evidence',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokBrowserRoleEvidence
                        },
                        child: NosokAdminBrowserRoleEvidencePage())),
            GoRoute(
                path: 'production-gate-decision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.decideNosokProductionGate
                        },
                        child: NosokAdminProductionGateDecisionPage())),
            GoRoute(
                path: 'remaining-work',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.viewNosokRemainingWork
                        },
                        child: NosokAdminRemainingWorkPage())),
            GoRoute(
                path: 'homepage-sections',
                redirect: (context, state) => NosokSystemRoutes.adminContent),
            GoRoute(
                path: 'dynamic-pages',
                redirect: (context, state) => NosokSystemRoutes.adminContent),
            GoRoute(
                path: 'unit-scope-access',
                redirect: (context, state) => NosokSystemRoutes.adminUnits),
            GoRoute(
                path: 'registration-governance',
                redirect: (context, state) => NosokSystemRoutes.adminSettings),
            GoRoute(
                path: 'legal-compliance',
                redirect: (context, state) => NosokSystemRoutes.adminSettings),
            GoRoute(
                path: 'legal-algorithm-simulation',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminSeasonCommand),
            GoRoute(
                path: 'company-workspace-closure',
                redirect: (context, state) => NosokSystemRoutes.adminCompanies),
            GoRoute(
                path: 'public-responsive-uat',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminV24ResponsiveUat),
            GoRoute(
                path: 'standalone-supabase-development',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminV24SupabaseRuntimeUat),
            GoRoute(
                path: 'v38i-standalone-supabase-development',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminV24SupabaseRuntimeUat),
            GoRoute(
                path: 'supabase-binding-discovery',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminV27SchemaCensusResult),
            GoRoute(
                path: 'v38h-supabase-binding',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminV27SchemaCensusResult),
            GoRoute(
                path: 'platform-schema-bindings',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminV27OwnerSchemaDiffPlan),
            GoRoute(
                path: 'v38g-platform-schema-binding',
                redirect: (context, state) =>
                    NosokSystemRoutes.adminV27OwnerSchemaDiffPlan),
            GoRoute(
                path: 'v24-uat-evidence',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.closeNosokBrowserRoleResponsiveUat
                        },
                        child: NosokAdminV24UatEvidencePage())),
            GoRoute(
                path: 'v24-responsive-uat',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.closeNosokBrowserRoleResponsiveUat
                        },
                        child: NosokAdminV24ResponsiveUatPage())),
            GoRoute(
                path: 'v24-merge-readiness-closure',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.closeNosokMergeReadiness
                        },
                        child: NosokAdminV24MergeReadinessClosurePage())),
            GoRoute(
                path: 'v24-supabase-runtime-uat',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokSupabaseRuntimeUat
                        },
                        child: NosokAdminV24SupabaseRuntimeUatPage())),
            GoRoute(
                path: 'v24-production-redecision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.redecideNosokProductionGate
                        },
                        child: NosokAdminV24ProductionRedecisionPage())),
            GoRoute(
                path: 'v25-evidence-intake',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokV25Evidence
                        },
                        child: NosokAdminV25EvidenceIntakePage())),
            GoRoute(
                path: 'v25-full-merge-application-result',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.intakeNosokFullMergeApplicationResult
                    }, child: NosokAdminV25FullMergeApplicationResultPage())),
            GoRoute(
                path: 'v25-production-candidate-decision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.decideNosokProductionCandidate
                        },
                        child: NosokAdminV25ProductionCandidateDecisionPage())),
            GoRoute(
                path: 'v26-evidence-result-intake',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokV26EvidenceResults
                        },
                        child: NosokAdminV26EvidenceResultIntakePage())),
            GoRoute(
                path: 'v26-full-merge-apply-result',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokFullMergeApplyResult
                        },
                        child: NosokAdminV26FullMergeApplyResultPage())),
            GoRoute(
                path: 'v26-production-candidate-redecision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.redecideNosokProductionCandidate
                        },
                        child:
                            NosokAdminV26ProductionCandidateRedecisionPage())),
            GoRoute(
                path: 'v27-schema-census-result',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokV27SchemaCensus
                        },
                        child: NosokAdminV27SchemaCensusResultPage())),
            GoRoute(
                path: 'v27-existing-object-reconciliation',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.reconcileNosokExistingObjects
                    }, child: NosokAdminV27ExistingObjectReconciliationPage())),
            GoRoute(
                path: 'v27-owner-schema-diff-plan',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.planNosokOwnerSchemaDiff
                        },
                        child: NosokAdminV27OwnerSchemaDiffPlanPage())),
            GoRoute(
                path: 'v27-safe-sql-execution-gate',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.decideNosokSafeSqlExecutionGate
                        },
                        child: NosokAdminV27SafeSqlExecutionGatePage())),
            GoRoute(
                path: 'v28-owner-schema-design',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.designNosokOwnerSchema
                        },
                        child: NosokAdminV28OwnerSchemaDesignPage())),
            GoRoute(
                path: 'v28-guarded-ddl-draft',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.reviewNosokGuardedDdlDraft
                        },
                        child: NosokAdminV28GuardedDdlDraftPage())),
            GoRoute(
                path: 'v28-rls-rpc-matrix',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.planNosokRlsRpcMatrix
                        },
                        child: NosokAdminV28RlsRpcMatrixPage())),
            GoRoute(
                path: 'v28-execution-authorization-gate',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.decideNosokExecutionAuthorizationGate
                    }, child: NosokAdminV28ExecutionAuthorizationGatePage())),
            GoRoute(
                path: 'v29-ddl-authorization-intake',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokV29DdlAuthorization
                        },
                        child: NosokAdminV29DdlAuthorizationIntakePage())),
            GoRoute(
                path: 'v29-staging-apply-gate',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.manageNosokV29StagingApplyGate
                        },
                        child: NosokAdminV29StagingApplyGatePage())),
            GoRoute(
                path: 'v29-rls-rpc-negative-uat-preflight',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.runNosokV29RlsRpcNegativeUatPreflight
                    }, child: NosokAdminV29RlsRpcNegativeUatPreflightPage())),
            GoRoute(
                path: 'v30-authorization-token-intake',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokV30AuthorizationToken
                        },
                        child: NosokAdminV30AuthorizationTokenIntakePage())),
            GoRoute(
                path: 'v30-controlled-ddl-apply-result',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.intakeNosokV30ControlledDdlApplyResult
                    }, child: NosokAdminV30ControlledDdlApplyResultPage())),
            GoRoute(
                path: 'v30-rls-rpc-negative-uat-execution-gate',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .runNosokV30RlsRpcNegativeUatExecutionGate
                        },
                        child:
                            NosokAdminV30RlsRpcNegativeUatExecutionGatePage())),
            GoRoute(
                path: 'v31-authorization-token-evidence',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .intakeNosokV31AuthorizationTokenEvidence
                        },
                        child: NosokAdminV31AuthorizationTokenEvidencePage())),
            GoRoute(
                path: 'v31-controlled-staging-apply-certification',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .certifyNosokV31ControlledStagingApply
                        },
                        child:
                            NosokAdminV31ControlledStagingApplyCertificationPage())),
            GoRoute(
                path: 'v31-post-apply-rls-rpc-negative-uat-closure',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.closeNosokV31PostApplyNegativeUat
                        },
                        child:
                            NosokAdminV31PostApplyRlsRpcNegativeUatClosurePage())),
            GoRoute(
                path: 'v32-controlled-staging-ddl-apply-evidence',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .intakeNosokV32ControlledApplyEvidence
                        },
                        child:
                            NosokAdminV32ControlledStagingDdlApplyEvidencePage())),
            GoRoute(
                path: 'v32-post-apply-census-rls-result-closure',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.closeNosokV32PostApplyCensusRls
                        },
                        child:
                            NosokAdminV32PostApplyCensusRlsResultClosurePage())),
            GoRoute(
                path: 'v32-production-gate-redecision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.redecideNosokV32ProductionGate
                        },
                        child: NosokAdminV32ProductionGateRedecisionPage())),
            GoRoute(
                path: 'v33-post-apply-rls-rpc-negative-uat-execution',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .executeNosokV33PostApplyNegativeUat
                        },
                        child:
                            NosokAdminV33PostApplyRlsRpcNegativeUatExecutionPage())),
            GoRoute(
                path: 'v33-public-wrapper-surface-draft',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.draftNosokV33PublicWrapperSurface
                        },
                        child: NosokAdminV33PublicWrapperSurfaceDraftPage())),
            GoRoute(
                path: 'v33-repository-binding-gate',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.decideNosokV33RepositoryBindingGate
                    }, child: NosokAdminV33RepositoryBindingGatePage())),
            GoRoute(
                path: 'v34-public-wrapper-rpc-authorization',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .authorizeNosokV34PublicWrapperRpcApply
                        },
                        child:
                            NosokAdminV34PublicWrapperRpcAuthorizationPage())),
            GoRoute(
                path: 'v34-browser-role-negative-uat-evidence-intake',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .intakeNosokV34BrowserRoleNegativeUatEvidence
                        },
                        child:
                            NosokAdminV34BrowserRoleNegativeUatEvidenceIntakePage())),
            GoRoute(
                path: 'v34-repository-binding-authorization-gate',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .decideNosokV34RepositoryBindingAuthorizationGate
                        },
                        child:
                            NosokAdminV34RepositoryBindingAuthorizationGatePage())),
            GoRoute(
                path: 'v35-wrapper-rpc-apply-result',
                builder: (context, state) =>
                    const NosokAccessGate(requiredPermissions: {
                      NosokPermissionKeys.intakeNosokV35WrapperRpcApplyResult
                    }, child: NosokAdminV35WrapperRpcApplyResultPage())),
            GoRoute(
                path: 'v35-post-apply-wrapper-rpc-evidence-closure',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.closeNosokV35WrapperRpcEvidence
                        },
                        child:
                            NosokAdminV35PostApplyWrapperRpcEvidenceClosurePage())),
            GoRoute(
                path: 'v35-repository-binding-preflight-decision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .decideNosokV35RepositoryBindingPreflight
                        },
                        child:
                            NosokAdminV35RepositoryBindingPreflightDecisionPage())),
            GoRoute(
                path: 'v36-browser-role-scope-wrapper-uat',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokV36BrowserRoleScopeUat
                        },
                        child: NosokAdminV36BrowserRoleScopeWrapperUatPage())),
            GoRoute(
                path: 'v36-repository-binding-controlled-adapter',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .manageNosokV36RepositoryBindingAdapter
                        },
                        child:
                            NosokAdminV36RepositoryBindingControlledAdapterPage())),
            GoRoute(
                path: 'v36-production-gate-redecision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.redecideNosokV36ProductionGate
                        },
                        child: NosokAdminV36ProductionGateRedecisionPage())),
            GoRoute(
                path: 'v37-public-repository-binding-runtime-switch-candidate',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys
                              .manageNosokV37RuntimeSwitchCandidate
                        },
                        child:
                            NosokAdminV37PublicRepositoryBindingRuntimeSwitchCandidatePage())),
            GoRoute(
                path: 'v37-browser-evidence-result-intake',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.intakeNosokV37BrowserEvidence
                        },
                        child: NosokAdminV37BrowserEvidenceResultIntakePage())),
            GoRoute(
                path: 'v37-production-gate-redecision',
                builder: (context, state) => const NosokAccessGate(
                        requiredPermissions: {
                          NosokPermissionKeys.redecideNosokV37ProductionGate
                        },
                        child: NosokAdminV37ProductionGateRedecisionPage())),
          ],
        ),
      ],
    ),
  ];
}
