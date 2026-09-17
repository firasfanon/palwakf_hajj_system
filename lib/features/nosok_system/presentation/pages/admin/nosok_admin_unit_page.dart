import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/access/nosok_access_profile.dart';
import '../../../application/nosok_administrative_unit_scope_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminUnitPage extends ConsumerWidget {
  const NosokAdminUnitPage({
    super.key,
    required this.unitId,
  });

  final String unitId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(nosokAccessProfileProvider);
    final resolutionAsync =
        ref.watch(nosokAdministrativeUnitScopeProvider(unitId));
    if (!profile.canAccessUnit(unitId: unitId)) {
      return NosokPageScaffold(
        title: 'خارج نطاق الوحدة',
        subtitle: 'الحساب الحالي لا يملك نطاق تشغيل لهذه الوحدة.',
        children: [
          NosokSectionCard(
            title: 'وصول مرفوض حسب نطاق الوحدة',
            child: Text('unit=$unitId • source=${profile.source}'),
          ),
        ],
      );
    }

    return NosokPageScaffold(
      title: 'إدارة وحدة نسك',
      subtitle:
          'نطاق الوحدة: $unitId. هذه صفحة تشغيلية لوحدة/مديرية داخل نظام نسك، وليست مصدرًا بديلًا للوحدات.',
      actions: [
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.publicUnit(unitId)),
          icon: const Icon(Icons.public_outlined),
          label: const Text('عرض الصفحة العامة'),
        ),
      ],
      children: [
        resolutionAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => const NosokSectionCard(
            title: 'مرجع الوحدة الإدارية',
            child: Text(
                'تعذر حل الوحدة من المرجع المركزي. الوصول يبقى fail-closed.'),
          ),
          data: (resolution) => NosokSectionCard(
            title: 'مرجع الوحدة الإدارية',
            child: Text(resolution == null
                ? 'الوحدة غير موجودة في المرجع المركزي.'
                : 'orgUnitId=${resolution.unitId} • slug=${resolution.canonicalSlug} • governorateId=${resolution.governorateId ?? 'none'} • LGU=${resolution.lguScopeStatus}'),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: const [
            _UnitMetric(label: 'طلبات قيد المراجعة', value: '—'),
            _UnitMetric(label: 'شكاوى مفتوحة', value: '—'),
            _UnitMetric(label: 'شركات ضمن النطاق', value: '—'),
            _UnitMetric(label: 'إعلانات منشورة', value: '—'),
          ],
        ),
        const SizedBox(height: 12),
        const NosokSectionCard(
          title: 'تشغيل الوحدة',
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.visibility_outlined),
                title: Text('ظهور الصفحة العامة'),
                subtitle: Text(
                    'يعتمد الظهور على سياسة سطح نسك، بينما تبقى هوية الوحدة من core.org_units عبر RPC معتمد.'),
              ),
              ListTile(
                leading: Icon(Icons.rule_outlined),
                title: Text('نطاق الصلاحيات'),
                subtitle: Text(
                    'لا يعتمد على هذا الجدول وحده؛ يجب فحص AccessProfile وRBAC من المنصة.'),
              ),
              ListTile(
                leading: Icon(Icons.content_paste_outlined),
                title: Text('المحتوى المحلي'),
                subtitle: Text(
                    'يرتبط بالموسم والوحدة ولا يغيّر المحتوى المركزي إلا بصلاحية.'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _UnitMetric extends StatelessWidget {
  const _UnitMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
