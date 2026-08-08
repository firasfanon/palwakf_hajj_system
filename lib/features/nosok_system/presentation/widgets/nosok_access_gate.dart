import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/access/nosok_access_profile.dart';
import '../../system_permissions.dart';
import '../../system_routes.dart';

class NosokAccessGate extends ConsumerWidget {
  const NosokAccessGate({
    super.key,
    required this.requiredPermissions,
    required this.child,
    this.title = 'لا توجد صلاحية تشغيل',
    this.message,
  });

  final Set<String> requiredPermissions;
  final Widget child;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(nosokAccessProfileProvider);
    if (profile.hasAnyPermission(requiredPermissions)) {
      return child;
    }

    final theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              margin: const EdgeInsets.all(24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lock_outline,
                            color: theme.colorScheme.error),
                        const SizedBox(width: 10),
                        Text(title, style: theme.textTheme.titleLarge),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      message ??
                          'هذه الصفحة محمية بعقد RBAC الخاص بمنصة PalWakf. مصدر الصلاحيات هو AccessProfile/admin_users وليس نسك.',
                    ),
                    const SizedBox(height: 12),
                    Text('المصدر الحالي للصلاحيات: ${profile.source}'),
                    const SizedBox(height: 8),
                    Text(
                        'الصلاحيات المطلوبة: ${requiredPermissions.join(', ')}'),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () =>
                              context.go(NosokSystemRoutes.publicHome),
                          icon: const Icon(Icons.public_outlined),
                          label: const Text('واجهة نسك العامة'),
                        ),
                        if (profile.isSuperuser ||
                            profile.permissionKeys.contains(
                                NosokPermissionKeys.viewNosokDashboard))
                          FilledButton.icon(
                            onPressed: () =>
                                context.go(NosokSystemRoutes.adminHome),
                            icon: const Icon(Icons.dashboard_outlined),
                            label: const Text('لوحة نسك'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
