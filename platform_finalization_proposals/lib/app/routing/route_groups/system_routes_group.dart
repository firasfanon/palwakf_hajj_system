part of '../go_router_config.dart';

List<RouteBase> buildSystemRoutesGroup() {
  return <RouteBase>[
    GoRoute(
      path: AppRoutes.nosok,
      builder: (context, state) => const NosokPublicHomePage(),
      routes: <RouteBase>[
        GoRoute(
            path: 'hajj', builder: (context, state) => const NosokHajjPage()),
        GoRoute(
            path: 'umrah', builder: (context, state) => const NosokUmrahPage()),
        GoRoute(
            path: 'companies',
            builder: (context, state) => const NosokCompaniesPage()),
        GoRoute(
            path: 'complaints',
            builder: (context, state) => const NosokComplaintsPage()),
        GoRoute(path: 'faq', builder: (context, state) => const NosokFaqPage()),
        GoRoute(
            path: 'application-status',
            builder: (context, state) => const NosokApplicationStatusPage()),
        GoRoute(
            path: 'apply', builder: (context, state) => const NosokApplyPage()),
      ],
    ),
  ];
}
