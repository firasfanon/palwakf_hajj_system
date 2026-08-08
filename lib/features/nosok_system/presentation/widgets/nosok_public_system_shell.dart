import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../system_routes.dart';

class _NosokPublicUiPalette {
  const _NosokPublicUiPalette._();

  static const deepBlue = Color(0xFF0A3B5A);
  static const gold = Color(0xFFB68B40);
  static const border = Color(0xFFDCE3EB);
  static const text = Color(0xFF102A43);
  static const white = Color(0xFFFFFFFF);
}

class NosokPublicSystemShell extends StatelessWidget {
  const NosokPublicSystemShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  bool _isActive(String route) =>
      location == route || location.startsWith('$route/');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            Material(
              elevation: 2,
              color: scheme.surface,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final compact = constraints.maxWidth < 760;
                      final nav = _NosokPublicNavigation(isActive: _isActive);
                      if (compact) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                const Expanded(child: _NosokPublicBrand()),
                                FilledButton(
                                  onPressed: () =>
                                      context.go(NosokSystemRoutes.apply),
                                  style: FilledButton.styleFrom(
                                    backgroundColor:
                                        _NosokPublicUiPalette.deepBlue,
                                    foregroundColor:
                                        _NosokPublicUiPalette.white,
                                    textStyle: theme.textTheme.labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w900),
                                  ),
                                  child: const Text('تقديم'),
                                ),
                                const SizedBox(width: 6),
                                const _PublicMoreMenu(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SingleChildScrollView(
                                scrollDirection: Axis.horizontal, child: nav),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          const _NosokPublicBrand(),
                          const SizedBox(width: 18),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: nav,
                            ),
                          ),
                          const SizedBox(width: 10),
                          FilledButton.icon(
                            onPressed: () =>
                                context.go(NosokSystemRoutes.apply),
                            icon: const Icon(Icons.app_registration_outlined,
                                size: 18),
                            label: const Text('تقديم طلب'),
                            style: FilledButton.styleFrom(
                              backgroundColor: _NosokPublicUiPalette.deepBlue,
                              foregroundColor: _NosokPublicUiPalette.white,
                              textStyle: theme.textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: () =>
                                context.go(NosokSystemRoutes.track),
                            icon: const Icon(Icons.manage_search_outlined,
                                size: 18),
                            label: const Text('متابعة'),
                            style: TextButton.styleFrom(
                              foregroundColor: _NosokPublicUiPalette.deepBlue,
                              textStyle: theme.textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const _PublicMoreMenu(),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () =>
                                context.go(NosokSystemRoutes.adminHome),
                            icon: const Icon(
                                Icons.admin_panel_settings_outlined,
                                size: 18),
                            label: const Text('دخول الموظفين'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _NosokPublicUiPalette.deepBlue,
                              side: const BorderSide(
                                  color: _NosokPublicUiPalette.border),
                              textStyle: theme.textTheme.labelLarge
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                type: MaterialType.transparency,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NosokPublicNavigation extends StatelessWidget {
  const _NosokPublicNavigation({required this.isActive});

  final bool Function(String route) isActive;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _NavChip(
            route: NosokSystemRoutes.publicHome,
            icon: Icons.home_outlined,
            label: 'الرئيسية',
            selected: isActive(NosokSystemRoutes.publicHome)),
        _NavChip(
            route: NosokSystemRoutes.apply,
            icon: Icons.app_registration_outlined,
            label: 'تقديم طلب',
            selected: isActive(NosokSystemRoutes.apply)),
        _NavChip(
            route: NosokSystemRoutes.track,
            icon: Icons.manage_search_outlined,
            label: 'متابعة طلب',
            selected: isActive(NosokSystemRoutes.track)),
        _NavChip(
            route: NosokSystemRoutes.lotteryResults,
            icon: Icons.emoji_events_outlined,
            label: 'نتائج القرعة',
            selected: isActive(NosokSystemRoutes.lotteryResults)),
        _NavChip(
            route: NosokSystemRoutes.companies,
            icon: Icons.business_center_outlined,
            label: 'الشركات',
            selected: isActive(NosokSystemRoutes.companies)),
        _NavChip(
            route: NosokSystemRoutes.contact,
            icon: Icons.support_agent_outlined,
            label: 'المساعدة',
            selected: isActive(NosokSystemRoutes.contact) ||
                isActive(NosokSystemRoutes.complaints) ||
                isActive(NosokSystemRoutes.faq)),
      ],
    );
  }
}

class _NavChip extends StatelessWidget {
  const _NavChip(
      {required this.route,
      required this.icon,
      required this.label,
      required this.selected});

  final String route;
  final IconData icon;
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background =
        selected ? _NosokPublicUiPalette.deepBlue : _NosokPublicUiPalette.white;
    final foreground =
        selected ? _NosokPublicUiPalette.white : _NosokPublicUiPalette.text;
    final border = selected
        ? _NosokPublicUiPalette.deepBlue
        : _NosokPublicUiPalette.border;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: () => context.go(route),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            constraints: const BoxConstraints(minHeight: 42),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: border),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: _NosokPublicUiPalette.deepBlue
                            .withValues(alpha: .14),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 7),
                Text(
                  label,
                  overflow: TextOverflow.visible,
                  softWrap: false,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PublicMoreMenu extends StatelessWidget {
  const _PublicMoreMenu();

  @override
  Widget build(BuildContext context) {
    final routeItems = <_MenuRouteItem>[
      const _MenuRouteItem(
          'خدمة الحج', NosokSystemRoutes.hajj, Icons.flag_outlined),
      const _MenuRouteItem('خدمة العمرة', NosokSystemRoutes.umrah,
          Icons.travel_explore_outlined),
      const _MenuRouteItem('الشروط والمتطلبات', NosokSystemRoutes.requirements,
          Icons.fact_check_outlined),
      const _MenuRouteItem('قائمة الانتظار', NosokSystemRoutes.waitingList,
          Icons.list_alt_outlined),
      const _MenuRouteItem(
          'الاعتراضات', NosokSystemRoutes.objections, Icons.gavel_outlined),
      const _MenuRouteItem('بوابة الشركات', NosokSystemRoutes.companyLogin,
          Icons.business_outlined),
      const _MenuRouteItem(
          'الأسئلة الشائعة', NosokSystemRoutes.faq, Icons.quiz_outlined),
      const _MenuRouteItem('الشكاوى', NosokSystemRoutes.complaints,
          Icons.report_problem_outlined),
      const _MenuRouteItem('القانون المنظم', NosokSystemRoutes.legalRegulation,
          Icons.gavel_outlined),
    ];
    return PopupMenuButton<String>(
      tooltip: 'المزيد من الخدمات',
      onSelected: (route) => context.go(route),
      itemBuilder: (context) => [
        for (final item in routeItems)
          PopupMenuItem<String>(
            value: item.route,
            child: Row(
              children: [
                Icon(item.icon, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(item.label)),
              ],
            ),
          ),
      ],
      child: Builder(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _NosokPublicUiPalette.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: _NosokPublicUiPalette.border),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_open_outlined, size: 18),
                SizedBox(width: 6),
                Text('المزيد'),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MenuRouteItem {
  const _MenuRouteItem(this.label, this.route, this.icon);

  final String label;
  final String route;
  final IconData icon;
}

class _NosokPublicBrand extends StatelessWidget {
  const _NosokPublicBrand();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _NosokPublicUiPalette.deepBlue,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: _NosokPublicUiPalette.deepBlue.withValues(alpha: .16),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.travel_explore_outlined,
              color: _NosokPublicUiPalette.white),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('نسك',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w900)),
            Text('خدمات الحج والعمرة',
                style: theme.textTheme.labelSmall
                    ?.copyWith(color: _NosokPublicUiPalette.gold)),
          ],
        ),
      ],
    );
  }
}
