import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/access/nosok_access_profile.dart';
import '../../../application/nosok_unit_scopes_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminUnitsPage extends ConsumerWidget {
  const NosokAdminUnitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scopesAsync = ref.watch(nosokAdminUnitScopesProvider);
    final profile = ref.watch(nosokAccessProfileProvider);

    return NosokPageScaffold(
      title: 'وحدات ومديريات نسك',
      subtitle:
          'إدارة سطح الخدمة حسب الوحدة/المديرية مع التزام كامل بأن core.org_units هو مصدر الوحدات الحاكم.',
      actions: [
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminUnitQueues),
          icon: const Icon(Icons.inbox_outlined),
          label: const Text('طوابير الوحدات'),
        ),
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminSidebar),
          icon: const Icon(Icons.view_sidebar_outlined),
          label: const Text('ضبط السطح'),
        ),
      ],
      children: [
        _UnitGovernanceHero(profileSource: profile.source),
        const SizedBox(height: 12),
        NosokAsyncView(
          value: scopesAsync,
          dataBuilder: (scopes) {
            final enabled = scopes.where((scope) => scope.isEnabled).length;
            final disabled = scopes.length - enabled;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _UnitStats(
                    total: scopes.length, enabled: enabled, disabled: disabled),
                const SizedBox(height: 12),
                NosokSectionCard(
                  title: 'سطوح الوحدات المسجلة',
                  subtitle:
                      'كل بطاقة تمثل سطح خدمة لنسك فقط. الصلاحيات وإسناد المستخدمين لا تُدار من هنا.',
                  child: scopes.isEmpty
                      ? const _EmptyUnitsState()
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final cardWidth = width >= 1100
                                ? (width - 24) / 3
                                : width >= 720
                                    ? (width - 12) / 2
                                    : width;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: scopes
                                  .map(
                                    (scope) => _UnitScopeCard(
                                      width: cardWidth,
                                      unitId: scope.unitId,
                                      unitSlug: scope.unitSlug,
                                      title: scope.unitNameAr.isEmpty
                                          ? scope.unitSlug
                                          : scope.unitNameAr,
                                      isEnabled: scope.isEnabled,
                                      canAccess: profile.canAccessUnit(
                                          unitId: scope.unitId,
                                          unitSlug: scope.unitSlug),
                                      profileSource: profile.source,
                                    ),
                                  )
                                  .toList(growable: false),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        const NosokSectionCard(
          title: 'قواعد التشغيل الحاكمة',
          subtitle:
              'هذه القواعد تمنع تحول نسك إلى مصدر وحدات أو مستخدمين بديل.',
          child: Column(
            children: [
              ListTile(
                  leading: Icon(Icons.account_tree_outlined),
                  title: Text('الوحدات من core.org_units'),
                  subtitle: Text(
                      'نسك يحتفظ بسطح خدمة فقط عبر nosok.unit_service_scopes.')),
              ListTile(
                  leading: Icon(Icons.verified_user_outlined),
                  title: Text('الصلاحيات من PalWakf'),
                  subtitle: Text(
                      'AccessProfile وRBAC هما مصدر التفويض، مع دعم superuser override.')),
              ListTile(
                  leading: Icon(Icons.visibility_outlined),
                  title: Text('الصفحة العامة لا تكشف بيانات تشغيلية'),
                  subtitle: Text(
                      'تُعرض معلومات الخدمة فقط، ولا تعرض طوابير أو بيانات طلبات.')),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitGovernanceHero extends StatelessWidget {
  const _UnitGovernanceHero({required this.profileSource});
  final String profileSource;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            scheme.primaryContainer,
            scheme.surfaceContainerHighest,
            scheme.surface
          ],
        ),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 860;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(spacing: 8, runSpacing: 8, children: [
                Chip(
                    avatar: const Icon(Icons.account_tree_outlined, size: 18),
                    label: const Text('Unit-scoped runtime')),
                Chip(
                    avatar: const Icon(Icons.security_outlined, size: 18),
                    label: Text('Access source: $profileSource')),
              ]),
              const SizedBox(height: 14),
              Text('تشغيل نسك حسب الوحدة دون فصل النظام عن المنصة',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                'هذه الصفحة تضبط الواجهة والخدمات المنشورة للوحدات، بينما تبقى الهوية والصلاحيات والوحدات الأساسية داخل PalWakf.',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(height: 1.7, color: scheme.onSurfaceVariant),
              ),
            ],
          );
          const visual = _UnitGovernanceVisual();
          if (compact) {
            return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [copy, const SizedBox(height: 16), visual]);
          }
          return Row(children: [
            Expanded(flex: 7, child: copy),
            const SizedBox(width: 18),
            Expanded(flex: 4, child: visual)
          ]);
        },
      ),
    );
  }
}

class _UnitGovernanceVisual extends StatelessWidget {
  const _UnitGovernanceVisual();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          children: [
            ListTile(
                leading: Icon(Icons.source_outlined),
                title: Text('core.org_units'),
                subtitle: Text('مصدر الوحدات')),
            ListTile(
                leading: Icon(Icons.hub_outlined),
                title: Text('nosok.unit_service_scopes'),
                subtitle: Text('سطح الخدمة')),
            ListTile(
                leading: Icon(Icons.lock_outline),
                title: Text('AccessProfile'),
                subtitle: Text('نطاق الوصول')),
          ],
        ),
      ),
    );
  }
}

class _UnitStats extends StatelessWidget {
  const _UnitStats(
      {required this.total, required this.enabled, required this.disabled});
  final int total;
  final int enabled;
  final int disabled;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _MiniStat(
            label: 'إجمالي السطوح',
            value: total.toString(),
            icon: Icons.dashboard_customize_outlined),
        _MiniStat(
            label: 'مفعلة',
            value: enabled.toString(),
            icon: Icons.check_circle_outline),
        _MiniStat(
            label: 'غير مفعلة',
            value: disabled.toString(),
            icon: Icons.block_outlined),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat(
      {required this.label, required this.value, required this.icon});
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 230,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: scheme.outlineVariant)),
      child: Row(children: [
        Icon(icon, color: scheme.primary),
        const SizedBox(width: 10),
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.titleLarge)
      ]),
    );
  }
}

class _UnitScopeCard extends StatelessWidget {
  const _UnitScopeCard(
      {required this.width,
      required this.unitId,
      required this.unitSlug,
      required this.title,
      required this.isEnabled,
      required this.canAccess,
      required this.profileSource});

  final double width;
  final String unitId;
  final String unitSlug;
  final String title;
  final bool isEnabled;
  final bool canAccess;
  final String profileSource;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Icon(
                    isEnabled
                        ? Icons.account_tree_outlined
                        : Icons.block_outlined,
                    color: isEnabled ? scheme.primary : scheme.error),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(title,
                        style: Theme.of(context).textTheme.titleMedium))
              ]),
              const SizedBox(height: 8),
              Text('unitSlug: $unitSlug',
                  style: Theme.of(context).textTheme.bodySmall),
              Text(
                  'access: ${canAccess ? 'ضمن نطاق المستخدم' : 'خارج نطاق المستخدم'}',
                  style: Theme.of(context).textTheme.bodySmall),
              Text('source: $profileSource',
                  style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                FilledButton.tonal(
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminUnit(unitId)),
                    child: const Text('إدارة')),
                OutlinedButton(
                    onPressed: () =>
                        context.go(NosokSystemRoutes.publicUnit(unitSlug)),
                    child: const Text('فتح العام')),
                OutlinedButton(
                    onPressed: () => context.go(
                        '${NosokSystemRoutes.adminUnitQueues}?unitSlug=$unitSlug'),
                    child: const Text('الطابور')),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyUnitsState extends StatelessWidget {
  const _EmptyUnitsState();

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.info_outline),
      title: Text('لا توجد وحدات مفعّلة بعد'),
      subtitle: Text(
          'شغّل SQL 09/15 أو اربط RPC core.org_units ثم أعد اختبار الصفحة.'),
    );
  }
}
