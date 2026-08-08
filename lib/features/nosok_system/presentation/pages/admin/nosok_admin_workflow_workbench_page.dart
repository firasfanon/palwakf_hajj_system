import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_workbench_controller.dart';
import '../../../domain/models/nosok_workflow_bucket.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminWorkflowWorkbenchPage extends ConsumerWidget {
  const NosokAdminWorkflowWorkbenchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bucketsValue = ref.watch(nosokWorkflowBucketsProvider);

    return NosokPageScaffold(
      title: 'Workbench التشغيل اليومي',
      subtitle:
          'سطح إنتاجي مربوط بالبيانات يجمع ما يحتاجه الموظف يوميًا: طلبات، وثائق، دفعات، شكاوى، وحدات، وجاهزية.',
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminApplications),
          icon: const Icon(Icons.assignment_outlined),
          label: const Text('الطلبات'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminUnitQueues),
          icon: const Icon(Icons.account_tree_outlined),
          label: const Text('طوابير الوحدات'),
        ),
        OutlinedButton.icon(
          onPressed: () => ref.invalidate(nosokWorkflowBucketsProvider),
          icon: const Icon(Icons.refresh_outlined),
          label: const Text('تحديث'),
        ),
      ],
      children: [
        bucketsValue.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
            title: 'تعذر تحميل Workbench',
            subtitle: 'تعذر تحميل البيانات حاليًا.',
            child: OutlinedButton.icon(
              onPressed: () => ref.invalidate(nosokWorkflowBucketsProvider),
              icon: const Icon(Icons.refresh_outlined),
              label: const Text('إعادة المحاولة'),
            ),
          ),
          data: (buckets) => _DataBoundWorkbench(buckets: buckets),
        ),
      ],
    );
  }
}

class _DataBoundWorkbench extends StatelessWidget {
  const _DataBoundWorkbench({required this.buckets});

  final List<NosokWorkflowBucket> buckets;

  @override
  Widget build(BuildContext context) {
    final totalItems =
        buckets.fold<int>(0, (sum, item) => sum + item.itemCount);
    final blockers =
        buckets.fold<int>(0, (sum, item) => sum + item.blockerCount);
    final warnings =
        buckets.fold<int>(0, (sum, item) => sum + item.warningCount);
    final activeBuckets = buckets.where((item) => item.hasWork).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            NosokStatCard(
                label: 'إجمالي عناصر العمل',
                value: totalItems.toString(),
                subtitle: 'من RPC تشغيلية لا من نص ثابت'),
            NosokStatCard(
                label: 'Blockers',
                value: blockers.toString(),
                subtitle: 'تمنع قرار التشغيل إن لم تُغلق'),
            NosokStatCard(
                label: 'تحذيرات',
                value: warnings.toString(),
                subtitle: 'تحتاج متابعة يومية'),
            NosokStatCard(
                label: 'مسارات نشطة',
                value: activeBuckets.toString(),
                subtitle: 'Buckets فيها عمل فعلي'),
          ],
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'طوابير العمل المربوطة بالبيانات',
          subtitle:
              'كل بطاقة تعرض count وحالة خطورة ومسار فتح مباشر، وتقرأ من RPC v17 أو fallback محلي في وضع المعاينة.',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 780
                  ? 1
                  : constraints.maxWidth < 1160
                      ? 2
                      : 3;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: buckets.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columns == 1 ? 4.2 : 1.55,
                ),
                itemBuilder: (context, index) =>
                    _WorkflowBucketCard(bucket: buckets[index]),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'سياسة التشغيل اليومي',
          subtitle:
              'تمنع الصفحة تضخم المعلومات عبر إظهار ما يحتاج إجراء فقط، مع ربط كل Bucket بسطحه التشغيلي.',
          child: const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _PolicyChip(
                  icon: Icons.filter_alt_outlined,
                  label: 'Role-based surfacing'),
              _PolicyChip(
                  icon: Icons.account_tree_outlined,
                  label: 'Unit-scoped queues'),
              _PolicyChip(
                  icon: Icons.privacy_tip_outlined,
                  label: 'Public tracking privacy'),
              _PolicyChip(
                  icon: Icons.payments_outlined, label: 'Billing bridge first'),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkflowBucketCard extends StatelessWidget {
  const _WorkflowBucketCard({required this.bucket});

  final NosokWorkflowBucket bucket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = bucket.isBlocker
        ? Icons.warning_amber_outlined
        : bucket.hasWork
            ? Icons.pending_actions_outlined
            : Icons.check_circle_outline;
    final status = bucket.isBlocker
        ? 'يتطلب إجراء'
        : bucket.hasWork
            ? 'قيد المتابعة'
            : 'مستقر';

    return Card.outlined(
      child: InkWell(
        onTap: (bucket.routePath ?? '').trim().isEmpty
            ? null
            : () => context.go(bucket.routePath!),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(bucket.titleAr,
                          style: theme.textTheme.titleMedium)),
                  Text(bucket.itemCount.toString(),
                      style: theme.textTheme.headlineSmall),
                ],
              ),
              const SizedBox(height: 8),
              Text(bucket.descriptionAr ?? 'لا يوجد وصف.',
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _PlainBadge(label: status),
                  if (bucket.blockerCount > 0)
                    _PlainBadge(label: 'Blockers: ${bucket.blockerCount}'),
                  if (bucket.warningCount > 0)
                    _PlainBadge(label: 'تحذيرات: ${bucket.warningCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlainBadge extends StatelessWidget {
  const _PlainBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(label, style: Theme.of(context).textTheme.labelMedium),
      ),
    );
  }
}

class _PolicyChip extends StatelessWidget {
  const _PolicyChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label)
        ]),
      ),
    );
  }
}
