import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_unit_scopes_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_section_card.dart';

class NosokPublicUnitPage extends ConsumerWidget {
  const NosokPublicUnitPage({
    super.key,
    required this.unitSlug,
  });

  final String unitSlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scopeAsync = ref.watch(nosokPublicUnitScopeProvider(unitSlug));
    return Directionality(
      textDirection: TextDirection.rtl,
      child: NosokAsyncView(
        value: scopeAsync,
        dataBuilder: (scope) {
          final title = scope?.publicTitleAr ?? 'نسك في نطاق الوحدة';
          final subtitle = scope?.publicIntroAr ??
              'واجهة خدمات عامة مخصصة لنطاق وحدة/مديرية دون إنشاء مصدر وحدات بديل عن core.org_units.';
          final unitName = scope?.unitNameAr.isNotEmpty == true
              ? scope!.unitNameAr
              : unitSlug;
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              _UnitHero(
                  title: title,
                  subtitle: subtitle,
                  unitName: unitName,
                  unitSlug: unitSlug,
                  isPublished: scope != null),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _UnitActions(unitSlug: unitSlug),
                    const SizedBox(height: 16),
                    _UnitServiceGrid(isPublished: scope != null),
                    const SizedBox(height: 16),
                    NosokSectionCard(
                      title: 'نطاق الصفحة ومصدر البيانات',
                      subtitle:
                          'هذه الصفحة تعرض سطح خدمة نسك للوحدة فقط؛ لا تنشئ وحدة ولا تغيّر مصدر الوحدات السيادي.',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PolicyLine(
                              icon: Icons.account_tree_outlined,
                              text: 'مصدر الوحدات الحاكم: core.org_units.'),
                          _PolicyLine(
                              icon: Icons.hub_outlined,
                              text:
                                  'سطح الخدمة الخاص بنسك: nosok.unit_service_scopes.'),
                          _PolicyLine(
                              icon: Icons.security_outlined,
                              text:
                                  'الصلاحيات الإدارية حسب AccessProfile ونطاق الوحدة من المنصة.'),
                          if (scope == null)
                            const _PolicyLine(
                                icon: Icons.info_outline,
                                text:
                                    'لا يوجد سطح منشور لهذه الوحدة؛ لذلك لا تُعرض بيانات افتراضية حاكمة.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _UnitCitizenJourney(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UnitHero extends StatelessWidget {
  const _UnitHero(
      {required this.title,
      required this.subtitle,
      required this.unitName,
      required this.unitSlug,
      required this.isPublished});

  final String title;
  final String subtitle;
  final String unitName;
  final String unitSlug;
  final bool isPublished;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            scheme.primaryContainer,
            scheme.surfaceContainerHighest,
            scheme.surface
          ],
        ),
      ),
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 26),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 820;
              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _UnitHeroBadge(
                          icon: Icons.location_city_outlined, label: unitName),
                      _UnitHeroBadge(
                          icon: isPublished
                              ? Icons.check_circle_outline
                              : Icons.info_outline,
                          label:
                              isPublished ? 'سطح خدمة منشور' : 'سطح غير منشور'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(title,
                      style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w800, height: 1.15)),
                  const SizedBox(height: 10),
                  Text(subtitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                          height: 1.7, color: scheme.onSurfaceVariant)),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                          onPressed: () => context.go(NosokSystemRoutes.apply),
                          icon: const Icon(Icons.app_registration_outlined),
                          label: const Text('تقديم طلب')),
                      OutlinedButton.icon(
                          onPressed: () =>
                              context.go(NosokSystemRoutes.applicationStatus),
                          icon: const Icon(Icons.track_changes_outlined),
                          label: const Text('متابعة الطلب')),
                      TextButton.icon(
                          onPressed: () =>
                              context.go(NosokSystemRoutes.companies),
                          icon: const Icon(Icons.business_outlined),
                          label: const Text('الشركات المؤهلة')),
                    ],
                  ),
                ],
              );
              final visual = _UnitVisualCard(unitSlug: unitSlug);
              if (compact) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [copy, const SizedBox(height: 18), visual]);
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 7, child: copy),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: visual)
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _UnitHeroBadge extends StatelessWidget {
  const _UnitHeroBadge({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surface.withAlpha(220),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 7, 12, 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: scheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitVisualCard extends StatelessWidget {
  const _UnitVisualCard({required this.unitSlug});

  final String unitSlug;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Icon(Icons.account_tree_outlined, color: scheme.primary),
              const SizedBox(width: 8),
              Expanded(
                  child: Text('واجهة وحدة مرتبطة',
                      style: Theme.of(context).textTheme.titleMedium))
            ]),
            const SizedBox(height: 14),
            _UnitVisualLine(label: 'unitSlug', value: unitSlug),
            const _UnitVisualLine(
                label: 'المصدر السيادي', value: 'core.org_units'),
            const _UnitVisualLine(
                label: 'سطح نسك', value: 'unit_service_scopes'),
            const _UnitVisualLine(
                label: 'العمليات المحمية', value: 'AccessProfile + RBAC'),
          ],
        ),
      ),
    );
  }
}

class _UnitVisualLine extends StatelessWidget {
  const _UnitVisualLine({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(child: Text(label)),
        Text(value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w700))
      ]),
    );
  }
}

class _UnitActions extends StatelessWidget {
  const _UnitActions({required this.unitSlug});
  final String unitSlug;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _ActionCard(
            icon: Icons.campaign_outlined,
            title: 'إعلانات الوحدة',
            subtitle: 'تنبيهات ومواعيد الموسم حسب النطاق.',
            route: NosokSystemRoutes.hajj),
        _ActionCard(
            icon: Icons.assignment_outlined,
            title: 'تقديم ومتابعة',
            subtitle: 'بدء طلب جديد أو متابعة طلب قائم.',
            route: NosokSystemRoutes.apply),
        _ActionCard(
            icon: Icons.support_agent_outlined,
            title: 'الشكاوى',
            subtitle: 'قناة ملاحظات وشكاوى مرتبطة بالخدمة.',
            route: NosokSystemRoutes.complaints),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.route});
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 340,
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: scheme.outlineVariant)),
          child: Row(children: [
            CircleAvatar(
                backgroundColor: scheme.primaryContainer,
                child: Icon(icon, color: scheme.primary)),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall)
                ])),
            const Icon(Icons.arrow_back_rounded)
          ]),
        ),
      ),
    );
  }
}

class _UnitServiceGrid extends StatelessWidget {
  const _UnitServiceGrid({required this.isPublished});
  final bool isPublished;

  @override
  Widget build(BuildContext context) {
    final items = [
      const _ServiceItem(Icons.event_available_outlined, 'موسم الحج والعمرة',
          'عرض المواسم والبرامج المفتوحة للجمهور.'),
      const _ServiceItem(Icons.file_present_outlined, 'الوثائق والدفعات',
          'إرشاد المواطن للوثائق وسندات الدفع المطلوبة.'),
      const _ServiceItem(Icons.business_center_outlined, 'الشركات المؤهلة',
          'استعراض الشركات المؤهلة حسب الموسم والنطاق.'),
      _ServiceItem(
          isPublished ? Icons.verified_outlined : Icons.info_outline,
          isPublished ? 'نطاق منشور' : 'نطاق قيد التهيئة',
          isPublished
              ? 'هذه الوحدة جاهزة للعرض العام.'
              : 'تحتاج تفعيلًا من لوحة نسك.'),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cardWidth = width >= 1000
            ? (width - 36) / 4
            : width >= 640
                ? (width - 12) / 2
                : width;
        return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: items
                .map((item) => _ServiceCard(width: cardWidth, item: item))
                .toList(growable: false));
      },
    );
  }
}

class _ServiceItem {
  const _ServiceItem(this.icon, this.title, this.subtitle);
  final IconData icon;
  final String title;
  final String subtitle;
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.width, required this.item});
  final double width;
  final _ServiceItem item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Icon(item.icon, color: scheme.primary),
            const SizedBox(height: 12),
            Text(item.title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(item.subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(height: 1.5))
          ]),
        ),
      ),
    );
  }
}

class _PolicyLine extends StatelessWidget {
  const _PolicyLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(child: Text(text))
      ]),
    );
  }
}

class _UnitCitizenJourney extends StatelessWidget {
  const _UnitCitizenJourney();

  @override
  Widget build(BuildContext context) {
    return const NosokSectionCard(
      title: 'رحلة المواطن داخل الوحدة',
      subtitle: 'تصميم الصفحة يجب أن يسهّل الخدمة لا أن يكرر نصوصًا إدارية.',
      child: Column(
        children: [
          ListTile(
              leading: Icon(Icons.filter_1),
              title: Text('قراءة الإعلان والمواعيد'),
              subtitle: Text('المواطن يبدأ من واجهة واضحة لخدمة الحج/العمرة.')),
          ListTile(
              leading: Icon(Icons.looks_two_outlined),
              title: Text('تقديم الطلب والوثائق'),
              subtitle: Text(
                  'النموذج متعدد الخطوات يلتقط البيانات والوثائق والدفعات.')),
          ListTile(
              leading: Icon(Icons.looks_3_outlined),
              title: Text('المتابعة الآمنة'),
              subtitle:
                  Text('تتبع بواسطة tracking_token دون كشف الهوية أو الهاتف.')),
        ],
      ),
    );
  }
}
