part of '../go_router_config.dart';

RouteBase _buildAdminShellRoute(Ref ref) {
  return ShellRoute(
    builder: (context, state, child) => PlatformAdminShell(
      location: state.uri.path,
      child: child,
    ),
    routes: [
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (context, state) => const UsersManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminProfile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminMyActivity,
        builder: (context, state) => const MyActivityScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminWaqfLands,
        builder: (context, state) => const WaqfLandsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminCases,
        builder: (context, state) => const CasesScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDocuments,
        builder: (context, state) => const DocumentsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminHomeManagement,
        builder: (context, state) =>
            const HomeManagementScreen(initialSurface: 'home'),
      ),
      GoRoute(
        path: AppRoutes.adminUnitSurfacesManagement,
        builder: (context, state) =>
            const HomeManagementScreen(initialSurface: 'unit'),
      ),
      GoRoute(
        path: AppRoutes.adminSystemSurfacesManagement,
        builder: (context, state) =>
            const HomeManagementScreen(initialSurface: 'system'),
      ),
      GoRoute(
        path: AppRoutes.adminSharedContent,
        builder: (context, state) => const SharedContentManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminHeroSlider,
        builder: (context, state) => const HeroSliderManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminBreakingNews,
        builder: (context, state) => const BreakingNewsManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminAssistant,
        builder: (context, state) => InternalAssistantPage(
          contextSeed: GoRouterConfig._buildAssistantSeed(ref, state),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminChatbot,
        builder: (context, state) => const PublicChatbotPage(
          unitId: 'home',
        ),
      ),
      GoRoute(
        path: AppRoutes.adminActivitiesManagement,
        builder: (context, state) => const SharedContentManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminFridaySermons,
        builder: (context, state) => const FridaySermonsManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminMosques,
        builder: (context, state) => const MosquesManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminOrgUnits,
        builder: (context, state) => const OrgUnitsManagementScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminComplaints,
        builder: (context, state) => const PwfAdminComplaintsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminPublicPagesHub,
        builder: (context, state) => const PwfPublicPagesAdminHubScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminAboutPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config: pwfPublicPageAdminConfigByRoute(AppRoutes.adminAboutPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminMinisterPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminMinisterPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminVisionMissionPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config: pwfPublicPageAdminConfigByRoute(
                AppRoutes.adminVisionMissionPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminStructurePage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminStructurePage)!),
      ),
      GoRoute(
        path: AppRoutes.adminFormerMinistersPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config: pwfPublicPageAdminConfigByRoute(
                AppRoutes.adminFormerMinistersPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminServicesPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminServicesPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminEServicesPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminEServicesPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminSocialServicesPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config: pwfPublicPageAdminConfigByRoute(
                AppRoutes.adminSocialServicesPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminProjectsPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminProjectsPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminContactPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminContactPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminPrivacyPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminPrivacyPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminTermsPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config: pwfPublicPageAdminConfigByRoute(AppRoutes.adminTermsPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminSitemapPage,
        builder: (context, state) => PwfPublicPageAdminScreen(
            config:
                pwfPublicPageAdminConfigByRoute(AppRoutes.adminSitemapPage)!),
      ),
      GoRoute(
        path: AppRoutes.adminZakat,
        builder: (context, state) => const PwfZakatAdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminPrayerTimes,
        builder: (context, state) => const PwfPrayerTimesAdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminQuran,
        builder: (context, state) => const PwfQuranAdminDashboardScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) => NosokAdminSystemShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
              path: AppRoutes.adminNosok,
              builder: (context, state) => const NosokAdminDashboardPage()),
          GoRoute(
              path: AppRoutes.adminNosokSeasons,
              builder: (context, state) => const NosokAdminSeasonsPage()),
          GoRoute(
              path: AppRoutes.adminNosokCompanies,
              builder: (context, state) => const NosokAdminCompaniesPage()),
          GoRoute(
              path: AppRoutes.adminNosokApplications,
              builder: (context, state) => const NosokAdminApplicationsPage()),
          GoRoute(
            path: AppRoutes.adminNosokApplicationDetails,
            builder: (context, state) => NosokAdminApplicationDetailsPage(
              applicationId: state.pathParameters['applicationId'] ?? '',
            ),
          ),
          GoRoute(
              path: AppRoutes.adminNosokComplaints,
              builder: (context, state) => const NosokAdminComplaintsPage()),
          GoRoute(
              path: AppRoutes.adminNosokContent,
              builder: (context, state) => const NosokAdminContentPage()),
          GoRoute(
              path: AppRoutes.adminNosokPrograms,
              builder: (context, state) => const NosokAdminProgramsPage()),
          GoRoute(
              path: AppRoutes.adminNosokReports,
              builder: (context, state) => const NosokAdminReportsPage()),
          GoRoute(
              path: AppRoutes.adminNosokUnits,
              builder: (context, state) => const NosokAdminUnitsPage()),
          GoRoute(
            path: '${AppRoutes.adminNosokUnits}/:unitId',
            builder: (context, state) => NosokAdminUnitPage(
              unitId: state.pathParameters['unitId'] ?? 'home',
            ),
          ),
          GoRoute(
              path: AppRoutes.adminNosokUsersRoles,
              builder: (context, state) => const NosokAdminUsersRolesPage()),
          GoRoute(
              path: AppRoutes.adminNosokSidebar,
              builder: (context, state) => const NosokAdminSidebarPage()),
          GoRoute(
              path: AppRoutes.adminNosokSettings,
              builder: (context, state) => const NosokAdminSettingsPage()),
          GoRoute(
              path: AppRoutes.adminNosokHealth,
              builder: (context, state) => const NosokAdminHealthPage()),
          GoRoute(
              path: AppRoutes.adminNosokOperations,
              builder: (context, state) => const NosokAdminOperationsPage()),
          GoRoute(
              path: AppRoutes.adminNosokPaymentBridge,
              builder: (context, state) => const NosokAdminPaymentBridgePage()),
          GoRoute(
              path: AppRoutes.adminNosokUnitQueues,
              builder: (context, state) => const NosokAdminUnitQueuesPage()),
          GoRoute(
              path: AppRoutes.adminNosokRoleUat,
              builder: (context, state) => const NosokAdminRoleUatPage()),
          GoRoute(
              path: AppRoutes.adminNosokNotifications,
              builder: (context, state) => const NosokAdminNotificationsPage()),
          GoRoute(
              path: AppRoutes.adminNosokBillingAdapters,
              builder: (context, state) =>
                  const NosokAdminBillingAdaptersPage()),
          GoRoute(
              path: AppRoutes.adminNosokTrackingPrivacy,
              builder: (context, state) =>
                  const NosokAdminTrackingPrivacyPage()),
          GoRoute(
              path: AppRoutes.adminNosokReadinessEvidence,
              builder: (context, state) =>
                  const NosokAdminReadinessEvidencePage()),
          GoRoute(
              path: AppRoutes.adminNosokApplicationLifecycle,
              builder: (context, state) =>
                  const NosokAdminApplicationLifecyclePage()),
          GoRoute(
              path: AppRoutes.adminNosokNotificationDispatch,
              builder: (context, state) =>
                  const NosokAdminNotificationDispatchPage()),
        ],
      ),
      // Legacy compatibility redirects from earlier Nosok patch stages.
      GoRoute(
          path: '/admin/nosok',
          redirect: (context, state) => AppRoutes.adminNosok),
      GoRoute(
          path: '/admin/nosok/seasons',
          redirect: (context, state) => AppRoutes.adminNosokSeasons),
      GoRoute(
          path: '/admin/nosok/programs',
          redirect: (context, state) => AppRoutes.adminNosokPrograms),
      GoRoute(
          path: '/admin/nosok/companies',
          redirect: (context, state) => AppRoutes.adminNosokCompanies),
      GoRoute(
          path: '/admin/nosok/applications',
          redirect: (context, state) => AppRoutes.adminNosokApplications),
      GoRoute(
          path: '/admin/nosok/complaints',
          redirect: (context, state) => AppRoutes.adminNosokComplaints),
      GoRoute(
          path: '/admin/nosok/content',
          redirect: (context, state) => AppRoutes.adminNosokContent),
      GoRoute(
          path: '/admin/nosok/reports',
          redirect: (context, state) => AppRoutes.adminNosokReports),
      GoRoute(
          path: '/admin/nosok/unit-queues',
          redirect: (context, state) => AppRoutes.adminNosokUnitQueues),
      GoRoute(
          path: '/admin/nosok/billing-adapters',
          redirect: (context, state) => AppRoutes.adminNosokBillingAdapters),
      GoRoute(
          path: '/admin/nosok/tracking-privacy',
          redirect: (context, state) => AppRoutes.adminNosokTrackingPrivacy),
      GoRoute(
          path: '/admin/nosok/readiness-evidence',
          redirect: (context, state) => AppRoutes.adminNosokReadinessEvidence),
      GoRoute(
          path: '/admin/nosok/application-lifecycle',
          redirect: (context, state) =>
              AppRoutes.adminNosokApplicationLifecycle),
      GoRoute(
          path: '/admin/nosok/notification-dispatch',
          redirect: (context, state) =>
              AppRoutes.adminNosokNotificationDispatch),
      GoRoute(
        path: AppRoutes.adminUsageGuide,
        builder: (context, state) => const UsageGuideScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminTasks,
        builder: (context, state) => const TasksDashboardPage(adminScope: true),
      ),
      GoRoute(
        path: AppRoutes.adminTaskForm,
        builder: (context, state) => const TaskFormPage(adminScope: true),
      ),
      GoRoute(
        path: '/admin/tasks/:taskId/edit',
        builder: (context, state) => TaskFormPage(
          taskId: state.pathParameters['taskId'],
          adminScope: true,
        ),
      ),
      GoRoute(
        path: '/admin/tasks/:taskId',
        builder: (context, state) => TaskDetailPage(
          taskId: state.pathParameters['taskId'] ?? '',
          adminScope: true,
        ),
      ),
      GoRoute(
        path: AppRoutes.adminSettings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDeveloper,
        builder: (context, state) => const DeveloperToolsScreen(),
      ),
    ],
  );
}
