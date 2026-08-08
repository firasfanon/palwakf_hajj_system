import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_followup_inbox_controller.dart';
import '../../../domain/models/nosok_followup_inbox_item.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminFollowupInboxPage extends ConsumerWidget {
  const NosokAdminFollowupInboxPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(nosokFollowupInboxProvider);
    final statusFilter = ref.watch(nosokFollowupInboxStatusFilterProvider);

    return NosokPageScaffold(
      title: 'صندوق متابعة المواطن',
      subtitle:
          'سطح إداري يستقبل طلبات الاستكمال والاعتراض وتحديث البيانات القادمة من صفحة التتبع العامة، مع إبقاء الخصوصية العامة منفصلة عن البحث الإداري.',
      children: [
        NosokSectionCard(
          title: 'فلاتر التشغيل',
          subtitle:
              'استخدم الفلاتر لتوزيع العمل على الموظفين أو الوحدات دون كشف بيانات غير لازمة.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: const Text('الكل'),
                selected: statusFilter == null,
                onSelected: (_) => ref
                    .read(nosokFollowupInboxStatusFilterProvider.notifier)
                    .state = null,
              ),
              for (final status in const [
                'submitted',
                'in_progress',
                'needs_response',
                'resolved',
                'closed'
              ])
                ChoiceChip(
                  label: Text(_statusLabel(status)),
                  selected: statusFilter == status,
                  onSelected: (_) => ref
                      .read(nosokFollowupInboxStatusFilterProvider.notifier)
                      .state = status,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        inboxAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => NosokSectionCard(
              title: 'تعذر تحميل الصندوق',
              child: const Text(
                  'تعذر تحميل البيانات حاليًا. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.')),
          data: (items) {
            final open = items.where((item) => item.isOpen).length;
            final high = items.where((item) => item.priority == 'high').length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    NosokStatCard(
                        label: 'طلبات المتابعة',
                        value: items.length.toString()),
                    NosokStatCard(label: 'مفتوحة', value: open.toString()),
                    NosokStatCard(
                        label: 'عالية الأولوية', value: high.toString()),
                  ],
                ),
                const SizedBox(height: 16),
                if (items.isEmpty)
                  const NosokSectionCard(
                      title: 'لا توجد طلبات متابعة',
                      child: Text('لا توجد عناصر مطابقة للفلاتر الحالية.'))
                else
                  Column(
                      children: items
                          .map((item) => _FollowupInboxCard(item: item))
                          .toList()),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _FollowupInboxCard extends ConsumerWidget {
  const _FollowupInboxCard({required this.item});

  final NosokFollowupInboxItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(item.actionTitleAr, style: theme.textTheme.titleLarge),
                _Badge(label: _statusLabel(item.status)),
                if (item.priority == 'high')
                  const _Badge(label: 'أولوية عالية'),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _Meta(label: 'رقم الطلب', value: item.applicationNo),
                _Meta(label: 'المراجع', value: item.applicantMaskedName ?? '-'),
                _Meta(label: 'الوحدة', value: item.assignedUnitNameAr ?? '-'),
                if (item.createdAt != null)
                  _Meta(
                      label: 'تاريخ الورود',
                      value: _formatDate(item.createdAt!)),
              ],
            ),
            if ((item.noteAr ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(item.noteAr!),
            ],
            if ((item.resolutionNoteAr ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('إغلاق/معالجة: ${item.resolutionNoteAr!}',
                  style: theme.textTheme.bodyMedium),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: item.applicationId.trim().isEmpty
                      ? null
                      : () => context.go(
                          NosokSystemRoutes.adminApplicationDetails(
                              item.applicationId)),
                  icon: const Icon(Icons.open_in_new_outlined),
                  label: const Text('فتح الطلب'),
                ),
                FilledButton.tonal(
                  onPressed: () => _update(context, ref, 'in_progress'),
                  child: const Text('بدء المعالجة'),
                ),
                FilledButton(
                  onPressed: () => _resolve(context, ref),
                  child: const Text('إغلاق المعالجة'),
                ),
                TextButton(
                  onPressed: () => _update(context, ref, 'needs_response'),
                  child: const Text('طلب رد من المواطن'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _update(
      BuildContext context, WidgetRef ref, String status) async {
    await ref
        .read(nosokFollowupInboxControllerProvider.notifier)
        .updateFollowupInboxItem(followupId: item.id, status: status);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديث طلب المتابعة.')));
    }
  }

  Future<void> _resolve(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final note = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إغلاق طلب المتابعة'),
        content: TextField(
          controller: controller,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'ملاحظات المعالجة'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('إغلاق')),
        ],
      ),
    );
    controller.dispose();
    if (note == null) return;
    await ref
        .read(nosokFollowupInboxControllerProvider.notifier)
        .updateFollowupInboxItem(
          followupId: item.id,
          status: 'resolved',
          resolutionNoteAr: note,
        );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إغلاق طلب المتابعة.')));
    }
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
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
        child: Text(label),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Text('$label: $value');
}

String _statusLabel(String value) {
  switch (value) {
    case 'submitted':
      return 'وارد';
    case 'in_progress':
      return 'قيد المعالجة';
    case 'needs_response':
      return 'بحاجة رد';
    case 'resolved':
      return 'مغلق';
    case 'closed':
      return 'مؤرشف';
    default:
      return value;
  }
}

String _formatDate(DateTime value) =>
    '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
