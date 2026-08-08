part of '../go_router_config.dart';

RouteBase _buildPublicShellRoute() {
  return ShellRoute(
    builder: (context, state, child) => PublicShell(child: child),
    routes: [
      GoRoute(
        path: AppRoutes.root,
        redirect: (context, state) => AppRoutes.home,
      ),

      // Aliases for legacy /services links (public homepage cards)
      GoRoute(
        path: '/e-services',
        redirect: (context, state) => AppRoutes.eservices,
      ),
      GoRoute(
        path: '/services/prayer-times',
        redirect: (context, state) => AppRoutes.prayerTimes,
      ),
      GoRoute(
        path: '/services/donations',
        redirect: (context, state) => AppRoutes.zakat,
      ),
      GoRoute(
        path: '/donations',
        redirect: (context, state) => AppRoutes.zakat,
      ),
      GoRoute(
        path: '/donate',
        redirect: (context, state) => AppRoutes.zakat,
      ),

      // Legacy "system" aliases kept after reclassifying these as platform services.
      GoRoute(
        path: AppRoutes.zakatSystem,
        redirect: (context, state) => AppRoutes.zakat,
      ),
      GoRoute(
        path: AppRoutes.prayerTimesSystem,
        redirect: (context, state) => AppRoutes.prayerTimes,
      ),
      GoRoute(
        path: AppRoutes.quranSystem,
        redirect: (context, state) => AppRoutes.quran,
      ),

      GoRoute(
        path: AppRoutes.underConstruction,
        // Use a single implementation so users can always reach the
        // completed pages from the fallback screen.
        builder: (context, state) => const UnderConstructionScreen(),
      ),
      GoRoute(
        path: AppRoutes.news,
        redirect: (context, state) => UnitRoutes.news('home'),
      ),
      GoRoute(
        path: AppRoutes.newsDetail,
        redirect: (context, state) => UnitRoutes.news('home'),
      ),
      GoRoute(
        path: AppRoutes.announcements,
        redirect: (context, state) => UnitRoutes.announcements('home'),
      ),
      GoRoute(
        path: AppRoutes.activities,
        redirect: (context, state) => UnitRoutes.activities('home'),
      ),
      GoRoute(
        path: AppRoutes.services,
        builder: (context, state) => kIsWeb
            ? const PwfServicesWebScreen(unitSlug: 'home')
            : const ServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.eservices,
        builder: (context, state) => kIsWeb
            ? const PwfEServicesWebScreen(unitSlug: 'home')
            : const EServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.socialServices,
        builder: (context, state) => kIsWeb
            ? const PwfSocialServicesWebScreen(unitSlug: 'home')
            : const SocialServicesScreen(),
      ),
      GoRoute(
        path: AppRoutes.mosques,
        builder: (context, state) => kIsWeb
            ? const PwfMosquesAwqafWebScreen(unitSlug: 'home')
            : const MosquesScreen(),
      ),
      GoRoute(
        path: AppRoutes.projects,
        builder: (context, state) => kIsWeb
            ? const PwfProjectsWebScreen(unitSlug: 'home')
            : const ProjectsScreen(),
      ),
      GoRoute(
        path: AppRoutes.about,
        builder: (context, state) => kIsWeb
            ? const PwfAboutWebScreen(unitSlug: 'home')
            : const AboutScreen(),
      ),
      GoRoute(
        path: AppRoutes.minister,
        builder: (context, state) => const MinisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.visionMission,
        builder: (context, state) => kIsWeb
            ? const PwfVisionMissionWebScreen(unitSlug: 'home')
            : const VisionMissionScreen(),
      ),
      GoRoute(
        path: AppRoutes.structure,
        builder: (context, state) => kIsWeb
            ? const PwfOrgStructureWebScreen(unitSlug: 'home')
            : const StructureScreen(),
      ),
      GoRoute(
        path: AppRoutes.formerMinisters,
        builder: (context, state) => kIsWeb
            ? const PwfFormerMinistersWebScreen(unitSlug: 'home')
            : const FormerMinistersScreen(),
      ),
      GoRoute(
        path: AppRoutes.contact,
        builder: (context, state) => kIsWeb
            ? const PwfContactWebScreen(unitSlug: 'home')
            : const ContactScreen(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (context, state) =>
            const PwfPrivacyPolicyWebScreen(unitSlug: 'home'),
      ),
      GoRoute(
        path: AppRoutes.terms,
        builder: (context, state) =>
            const PwfTermsOfUseWebScreen(unitSlug: 'home'),
      ),
      GoRoute(
        path: AppRoutes.sitemap,
        builder: (context, state) =>
            const PwfSiteMapWebScreen(unitSlug: 'home'),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.fridaySermon,
        builder: (context, state) => const FridaySermonScreen(),
      ),

      // Zakat / Prayer Times / Quran (Public)
      GoRoute(
        path: AppRoutes.zakat,
        builder: (context, state) =>
            const PwfZakatPublicScreen(unitSlug: 'home'),
      ),
      GoRoute(
        path: AppRoutes.prayerTimes,
        builder: (context, state) =>
            const PwfPrayerTimesPublicScreen(unitSlug: 'home'),
      ),
      GoRoute(
        path: AppRoutes.quran,
        builder: (context, state) =>
            const PwfQuranPublicScreen(unitSlug: 'home'),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) {
          final sid = state.uri.queryParameters['sid'];
          if (kIsWeb) {
            return PwfWebPageScaffold(
              unitSlug: 'home',
              child: PublicChatbotPage(
                unitId: 'home',
                publicSessionId: sid,
                embedInPublicShell: true,
              ),
            );
          }
          return PublicChatbotPage(unitId: 'home', publicSessionId: sid);
        },
      ),

      // Complaints (Public) — use the completed screen (not the placeholder)
      GoRoute(
        path: AppRoutes.complaints,
        builder: (context, state) => const PwfComplaintsScreen(
          unitSlug: 'home',
          embedInPublicShell: true,
        ),
      ),

      // Aliases for old links (keep quick-links/buttons working)
      GoRoute(
        path: '/services/complaints',
        redirect: (context, state) => AppRoutes.complaints,
      ),
      GoRoute(
        path: '/complaints-system',
        redirect: (context, state) => AppRoutes.complaints,
      ),

      // Nosok public entry is a semi-independent system body under the public platform shell.
      // The internal Nosok public shell provides Nosok navigation only; it does not replace Platform Chrome.
      GoRoute(
        path: '/switch/nosok',
        redirect: (context, state) => AppRoutes.nosok,
      ),
      ShellRoute(
        builder: (context, state, child) => NosokPublicSystemShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: AppRoutes.nosok,
            builder: (context, state) => const NosokPublicHomePage(),
            routes: [
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
                  path: 'faq',
                  builder: (context, state) => const NosokFaqPage()),
              GoRoute(
                  path: 'application-status',
                  builder: (context, state) =>
                      const NosokApplicationStatusPage()),
              GoRoute(
                  path: 'follow-up',
                  builder: (context, state) =>
                      const NosokCitizenFollowupPage()),
              GoRoute(
                  path: 'apply',
                  builder: (context, state) => const NosokApplyPage()),
              GoRoute(
                path: 'units/:unitSlug',
                builder: (context, state) => NosokPublicUnitPage(
                  unitSlug: state.pathParameters['unitSlug'] ?? 'home',
                ),
              ),
              GoRoute(
                  path: 'news',
                  builder: (context, state) => NewsScreen(unitSlug: 'home')),
              GoRoute(
                  path: 'announcements',
                  builder: (context, state) =>
                      AnnouncementsScreen(unitSlug: 'home')),
              GoRoute(
                  path: 'activities',
                  builder: (context, state) =>
                      ActivitiesScreen(unitSlug: 'home')),
            ],
          ),
        ],
      ),

      // Unit-scoped public routes (/:unitSlug/*)
      GoRoute(
        path: '/:unitSlug',
        redirect: (context, state) {
          final slug =
              (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
          if (slug == 'admin') return AppRoutes.adminDashboard;
          return null;
        },
        builder: (context, state) {
          final slug =
              (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
          return UnitHomeScreen(unitSlug: slug);
        },
        routes: [
          GoRoute(
            path: 'news',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return kIsWeb
                  ? PwfNewsListWebScreen(unitSlug: slug)
                  : NewsScreen(unitSlug: slug);
            },
          ),
          GoRoute(
            path: 'news/:id',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              final extra = state.extra is NewsArticle
                  ? state.extra as NewsArticle
                  : null;
              return kIsWeb
                  ? PwfNewsDetailWebScreen(
                      unitSlug: slug, id: id, extraArticle: extra)
                  : NewsDetailRouteScreen(
                      unitSlug: slug, id: id, extraArticle: extra);
            },
          ),
          GoRoute(
            path: 'announcements',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return kIsWeb
                  ? PwfAnnouncementsListWebScreen(unitSlug: slug)
                  : AnnouncementsScreen(unitSlug: slug);
            },
          ),
          GoRoute(
            path: 'announcements/:id',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return kIsWeb
                  ? PwfAnnouncementDetailWebScreen(unitSlug: slug, id: id)
                  : const UnderConstructionScreen();
            },
          ),
          GoRoute(
            path: 'activities',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return kIsWeb
                  ? PwfActivitiesListWebScreen(unitSlug: slug)
                  : ActivitiesScreen(unitSlug: slug);
            },
          ),
          GoRoute(
            path: 'activities/:id',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return kIsWeb
                  ? PwfActivityDetailWebScreen(unitSlug: slug, id: id)
                  : const UnderConstructionScreen();
            },
          ),
          GoRoute(
            path: 'media',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return kIsWeb
                  ? PwfMediaGalleryWebScreen(unitSlug: slug)
                  : const UnderConstructionScreen();
            },
          ),
          GoRoute(
            path: 'friday-sermons',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return kIsWeb
                  ? PwfFridaySermonsWebScreen(unitSlug: slug)
                  : const UnderConstructionScreen();
            },
          ),
          GoRoute(
            path: 'chat',
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              final sid = state.uri.queryParameters['sid'];
              if (kIsWeb) {
                return PwfWebPageScaffold(
                  unitSlug: slug,
                  child: PublicChatbotPage(
                    unitId: slug,
                    publicSessionId: sid,
                    embedInPublicShell: true,
                  ),
                );
              }
              return PublicChatbotPage(unitId: slug, publicSessionId: sid);
            },
          ),
          GoRoute(
            path: 'complaints',
            redirect: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              if (slug == 'admin') return AppRoutes.adminComplaints;
              return null;
            },
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return PwfComplaintsScreen(
                unitSlug: slug,
                embedInPublicShell: true,
              );
            },
          ),
          GoRoute(
            path: 'zakat',
            redirect: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              if (slug == 'admin') return AppRoutes.adminZakat;
              return null;
            },
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return PwfZakatPublicScreen(unitSlug: slug);
            },
          ),
          GoRoute(
            path: 'prayer-times',
            redirect: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              if (slug == 'admin') return AppRoutes.adminPrayerTimes;
              return null;
            },
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return PwfPrayerTimesPublicScreen(unitSlug: slug);
            },
          ),
          GoRoute(
            path: 'quran',
            redirect: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              if (slug == 'admin') return AppRoutes.adminQuran;
              return null;
            },
            builder: (context, state) {
              final slug =
                  (state.pathParameters['unitSlug'] ?? 'home').toLowerCase();
              return PwfQuranPublicScreen(unitSlug: slug);
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.notFound,
        builder: (context, state) => const NotFoundScreen(),
      ),
    ],
  );
}
