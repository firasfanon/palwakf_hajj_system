import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_notification_dispatch_controller.dart';
import '../../../domain/models/nosok_notification_dispatch.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminNotificationDispatchPage extends ConsumerWidget {
  const NosokAdminNotificationDispatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispatchesAsync = ref.watch(nosokNotificationDispatchesProvider);
    return NosokPageScaffold(
      title: 'جسر إرسال الإشعارات',
      subtitle:
          'طابور إشعارات نسك يجهز الأحداث لإرسالها عبر خدمة إشعارات PalWakf، وليس كمحرك إرسال مستقل داخل نسك.',
      actions: [
        OutlinedButton.icon(
          onPressed: () => ref.invalidate(nosokNotificationDispatchesProvider),
          icon: const Icon(Icons.refresh_outlined),
          label: const Text('تحديث'),
        ),
        FilledButton.icon(
          onPressed: () => _openCreateDialog(context, ref),
          icon: const Icon(Icons.add_alert_outlined),
          label: const Text('إنشاء إشعار تجريبي'),
        ),
      ],
      children: [
        dispatchesAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
              title: 'تعذر تحميل الطابور',
              subtitle: 'تعذر تحميل البيانات حاليًا.',
              child: const Text('تأكد من تطبيق SQL v18.')),
          data: (dispatches) => _DispatchQueue(dispatches: dispatches),
        ),
      ],
    );
  }

  Future<void> _openCreateDialog(BuildContext context, WidgetRef ref) async {
    final eventController = TextEditingController(text: 'manual_admin_notice');
    final templateController =
        TextEditingController(text: 'application_status_changed');
    final entityController = TextEditingController(text: 'application-001');
    final payloadController =
        TextEditingController(text: 'إشعار تجريبي من لوحة نسك.');
    final accepted = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إنشاء إشعار في الطابور'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: eventController,
                  decoration: const InputDecoration(labelText: 'event_key')),
              TextField(
                  controller: templateController,
                  decoration: const InputDecoration(labelText: 'template_key')),
              TextField(
                  controller: entityController,
                  decoration:
                      const InputDecoration(labelText: 'related_entity_id')),
              TextField(
                  controller: payloadController,
                  decoration:
                      const InputDecoration(labelText: 'payload preview')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('إلغاء')),
          FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('إنشاء')),
        ],
      ),
    );
    if (accepted == true) {
      await ref
          .read(nosokNotificationDispatchControllerProvider.notifier)
          .create(
            eventKey: eventController.text.trim(),
            templateKey: templateController.text.trim(),
            relatedEntityType: 'nosok_application',
            relatedEntityId: entityController.text.trim(),
            payloadPreviewAr: payloadController.text.trim(),
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إنشاء الإشعار في الطابور.')));
      }
    }
  }
}

class _DispatchQueue extends ConsumerWidget {
  const _DispatchQueue({required this.dispatches});

  final List<NosokNotificationDispatch> dispatches;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queued = dispatches.where((item) => item.status == 'queued').length;
    final sent = dispatches.where((item) => item.status == 'sent').length;
    final failed = dispatches.where((item) => item.status == 'failed').length;
    return NosokSectionCard(
      title: 'طابور الإشعارات',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              NosokStatCard(label: 'Queued', value: queued.toString()),
              NosokStatCard(label: 'Sent', value: sent.toString()),
              NosokStatCard(label: 'Failed', value: failed.toString()),
            ],
          ),
          const SizedBox(height: 12),
          if (dispatches.isEmpty) const Text('لا توجد إشعارات في الطابور.'),
          for (final dispatch in dispatches)
            Card.outlined(
              child: ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: Text('${dispatch.eventKey} — ${dispatch.templateKey}'),
                subtitle: Text(
                    '${dispatch.relatedEntityType}/${dispatch.relatedEntityId}\n${dispatch.payloadPreviewAr ?? '-'}'),
                trailing: Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(dispatch.status),
                    OutlinedButton(
                      onPressed: dispatch.status == 'sent'
                          ? null
                          : () => ref
                              .read(nosokNotificationDispatchControllerProvider
                                  .notifier)
                              .mark(
                                  dispatchId: dispatch.id,
                                  status: 'sent',
                                  providerReference: 'preview-sent'),
                      child: const Text('Mark sent'),
                    ),
                    OutlinedButton(
                      onPressed: () => ref
                          .read(nosokNotificationDispatchControllerProvider
                              .notifier)
                          .mark(
                              dispatchId: dispatch.id,
                              status: 'failed',
                              errorMessage: 'preview failure'),
                      child: const Text('Fail'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
