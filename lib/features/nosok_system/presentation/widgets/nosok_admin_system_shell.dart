import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/access/nosok_access_profile.dart';
import '../../system_navigation.dart';
import '../../system_routes.dart';

class NosokAdminSystemShell extends StatelessWidget {
  const NosokAdminSystemShell({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final activeItem = NosokSystemNavigation.adminItemForPath(location);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1040;
          final sidebar = _NosokAdminSidebar(location: location);
          return Scaffold(
            appBar: wide
                ? null
                : AppBar(
                    title: Text(activeItem?.titleAr ?? 'نسك'),
                    actions: [
                      IconButton(
                        tooltip: 'الرئيسية العامة',
                        onPressed: () =>
                            context.go(NosokSystemRoutes.publicHome),
                        icon: const Icon(Icons.public_outlined),
                      ),
                    ],
                  ),
            drawer: wide ? null : Drawer(child: sidebar),
            body: Row(
              children: [
                if (wide)
                  SizedBox(
                    width: 292,
                    child: Material(
                      elevation: 1,
                      child: sidebar,
                    ),
                  ),
                Expanded(
                  child: Column(
                    children: [
                      if (wide)
                        _NosokAdminTopStrip(
                          title: activeItem?.titleAr ?? 'نسك',
                          location: location,
                        ),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NosokAdminTopStrip extends StatelessWidget {
  const _NosokAdminTopStrip({
    required this.title,
    required this.location,
  });

  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border:
            Border(bottom: BorderSide(color: theme.dividerColor.withAlpha(80))),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.hub_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(title, style: theme.textTheme.titleMedium),
            const Spacer(),
            OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.publicHome),
              icon: const Icon(Icons.public_outlined, size: 18),
              label: const Text('فتح واجهة نسك العامة'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NosokAdminSidebar extends ConsumerWidget {
  const _NosokAdminSidebar({required this.location});

  final String location;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profile = ref.watch(nosokAccessProfileProvider);
    final visibleItems = NosokSystemNavigation.visibleAdminItems(profile);
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: const Icon(Icons.travel_explore_outlined),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('نظام نسك',
                                style: theme.textTheme.titleMedium),
                            const Text('نظام شبه مستقل تحت PalWakf'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'الهوية والصلاحيات من المنصة، والعمليات والصفحات الخاصة داخل نسك.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            dense: true,
            leading: Icon(profile.isSuperuser
                ? Icons.verified_user_outlined
                : Icons.person_outline),
            title: Text(profile.isSuperuser
                ? 'Superuser / Platform override'
                : 'صلاحيات مفلترة'),
            subtitle: Text('source: ${profile.source}'),
          ),
          const SizedBox(height: 8),
          if (!profile.isPlatformBound)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(Icons.warning_amber_outlined),
                title: Text('AccessProfile غير مربوط'),
                subtitle: Text(
                    'يجب على المنصة override لـ nosokAccessProfileProvider عند الدمج الفعلي.'),
              ),
            ),
          if (visibleItems.isEmpty)
            const ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('لا توجد أسطح مصرح بها'),
              subtitle: Text('راجع RBAC أو ربط AccessProfile من المنصة.'),
            )
          else
            for (final group
                in _NosokSidebarGroups.fromItems(visibleItems)) ...[
              _NosokSidebarGroupHeader(title: group.title),
              for (final item in group.items)
                _NosokSidebarTile(
                  title: item.titleAr,
                  icon: item.icon,
                  route: item.route,
                  selected: location == item.route ||
                      location.startsWith('${item.route}/'),
                ),
              const SizedBox(height: 6),
            ],
        ],
      ),
    );
  }
}

class _NosokSidebarGroup {
  const _NosokSidebarGroup({
    required this.title,
    required this.items,
  });

  final String title;
  final List<NosokSystemNavItem> items;
}

class _NosokSidebarGroups {
  const _NosokSidebarGroups._();

  static List<_NosokSidebarGroup> fromItems(List<NosokSystemNavItem> items) {
    const order = <String>[
      'التشغيل اليومي',
      'مكتب الخدمة والقيادة',
      'الموسم والخدمات',
      'الدفع والخصوصية',
      'الوحدات والواجهة',
      'الحوكمة والجاهزية',
    ];

    final grouped = <String, List<NosokSystemNavItem>>{
      for (final title in order) title: <NosokSystemNavItem>[],
    };

    for (final item in items) {
      grouped[_groupTitleForKey(item.key)]!.add(item);
    }

    return <_NosokSidebarGroup>[
      for (final title in order)
        if (grouped[title]!.isNotEmpty)
          _NosokSidebarGroup(
              title: title,
              items: List<NosokSystemNavItem>.unmodifiable(grouped[title]!)),
    ];
  }

  static String _groupTitleForKey(String key) {
    switch (key) {
      case 'dashboard':
      case 'operations':
      case 'workflow_workbench':
      case 'applications':
      case 'applications_legacy':
      case 'requests':
      case 'review':
      case 'documents':
      case 'messages':
      case 'application_lifecycle':
      case 'unit_queues':
      case 'application_operations':
      case 'complaints':
        return 'التشغيل اليومي';
      case 'season_command':
      case 'service_desk':
      case 'campaigns':
      case 'groups':
      case 'follow_up_inbox':
        return 'مكتب الخدمة والقيادة';
      case 'seasons':
      case 'programs':
      case 'companies':
      case 'content':
      case 'notifications':
      case 'notification_dispatch':
      case 'notification_provider_uat':
      case 'reports':
        return 'الموسم والخدمات';
      case 'payment_bridge':
      case 'billing_adapters':
      case 'tracking_privacy':
        return 'الدفع والخصوصية';
      case 'units':
      case 'sidebar':
      case 'settings':
      case 'visual_governance':
        return 'الوحدات والواجهة';
      case 'role_uat':
      case 'users_roles':
      case 'readiness_evidence':
      case 'production_uat_closure':
      case 'platform_integration_readiness':
      case 'real_platform_merge':
      case 'rbac_provider_override':
      case 'sql_uat_intake':
      case 'browser_role_evidence':
      case 'production_gate_decision':
      case 'remaining_work':
      case 'v24_uat_evidence':
      case 'v24_responsive_uat':
      case 'v24_merge_closure':
      case 'v24_supabase_uat':
      case 'v24_production_redecision':
      case 'health':
        return 'الحوكمة والجاهزية';
      default:
        return 'التشغيل اليومي';
    }
  }
}

class _NosokSidebarGroupHeader extends StatelessWidget {
  const _NosokSidebarGroupHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 8, end: 8, top: 14, bottom: 6),
      child: Row(
        children: [
          Expanded(child: Divider(color: theme.dividerColor.withAlpha(90))),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Divider(color: theme.dividerColor.withAlpha(90))),
        ],
      ),
    );
  }
}

class _NosokSidebarTile extends StatelessWidget {
  const _NosokSidebarTile({
    required this.title,
    required this.icon,
    required this.route,
    required this.selected,
  });

  final String title;
  final IconData icon;
  final String route;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        selected: selected,
        selectedTileColor:
            Theme.of(context).colorScheme.primaryContainer.withAlpha(140),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Icon(icon),
        title: Text(title),
        onTap: () => context.go(route),
      ),
    );
  }
}
