import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_billing_adapters_controller.dart';
import '../../../domain/models/nosok_billing_provider_adapter.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminBillingAdaptersPage extends ConsumerWidget {
  const NosokAdminBillingAdaptersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adaptersAsync = ref.watch(nosokBillingProviderAdaptersProvider);
    final commandState = ref.watch(nosokBillingAdapterCommandProvider);

    ref.listen<AsyncValue<void>>(nosokBillingAdapterCommandProvider,
        (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل فحص Adapter الدفع: ${next.error}')));
      } else if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تحديث حالة Adapter الدفع.')));
      }
    });

    return NosokPageScaffold(
      title: 'Billing Provider Adapters',
      subtitle:
          'تقوية عقود مزودي الدفع دون تحويل نسك إلى بوابة دفع مستقلة. التنفيذ النهائي يبقى عبر billing_system وخدمة الدفع المركزية في PalWakf.',
      children: [
        NosokSectionCard(
          title: 'قواعد التقوية المطلوبة',
          subtitle:
              'لا يعتبر أي Adapter جاهزًا إلا إذا أغلق التوقيع، idempotency، callback contract، وhealth check.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('عدم تخزين بيانات البطاقة')),
              Chip(label: Text('Signature verification')),
              Chip(label: Text('Idempotency key')),
              Chip(label: Text('Webhook callback contract')),
              Chip(label: Text('Reconciliation-ready')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NosokAsyncView(
          value: adaptersAsync,
          dataBuilder: (adapters) => NosokSectionCard(
            title: 'Adapters المسجلة',
            subtitle:
                'هذه القائمة تمثل عقود ربط مرشحة/جاهزة مع مزودي الدفع عبر billing_system.',
            child: Column(
              children: [
                for (final adapter in adapters)
                  _AdapterTile(
                      adapter: adapter, isBusy: commandState.isLoading),
                if (adapters.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(
                        'لا توجد adapters مسجلة بعد. شغّل SQL v13 seed أو اربطها من billing_system.'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AdapterTile extends ConsumerWidget {
  const _AdapterTile({required this.adapter, required this.isBusy});

  final NosokBillingProviderAdapter adapter;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(adapter.titleAr,
                        style: theme.textTheme.titleMedium)),
                Icon(adapter.isOperational
                    ? Icons.verified_outlined
                    : Icons.warning_amber_outlined),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(adapter.providerKey)),
                Chip(label: Text('الحالة: ${adapter.adapterStatus}')),
                Chip(label: Text('الوضع: ${adapter.adapterMode}')),
                Chip(label: Text('Health: ${adapter.healthStatus}')),
                Chip(
                    label: Text(adapter.requiresSignature
                        ? 'Signature مطلوب'
                        : 'Signature غير مفعل')),
                Chip(label: Text('Idempotency: ${adapter.idempotencyPolicy}')),
                if (adapter.supportsWebhook) const Chip(label: Text('Webhook')),
              ],
            ),
            if ((adapter.callbackUrlPath ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Callback: ${adapter.callbackUrlPath}'),
            ],
            if ((adapter.notesAr ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(adapter.notesAr!),
            ],
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: isBusy
                  ? null
                  : () => ref
                      .read(nosokBillingAdapterCommandProvider.notifier)
                      .runHealthCheck(adapter.id),
              icon: const Icon(Icons.health_and_safety_outlined),
              label: const Text('فحص Adapter'),
            ),
          ],
        ),
      ),
    );
  }
}
