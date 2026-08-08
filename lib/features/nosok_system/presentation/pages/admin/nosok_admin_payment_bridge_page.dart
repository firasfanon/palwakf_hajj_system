import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_payment_bridge_controller.dart';
import '../../../domain/models/nosok_payment_bridge_request.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminPaymentBridgePage extends ConsumerStatefulWidget {
  const NosokAdminPaymentBridgePage({super.key});

  @override
  ConsumerState<NosokAdminPaymentBridgePage> createState() =>
      _NosokAdminPaymentBridgePageState();
}

class _NosokAdminPaymentBridgePageState
    extends ConsumerState<NosokAdminPaymentBridgePage> {
  final _applicationIdController = TextEditingController();
  final _paymentIdController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _applicationIdController.dispose();
    _paymentIdController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(nosokPaymentBridgeRequestsProvider);
    final commandState = ref.watch(nosokPaymentBridgeControllerProvider);

    ref.listen<AsyncValue<void>>(nosokPaymentBridgeControllerProvider,
        (previous, next) {
      if (!mounted) return;
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل إجراء جسر الدفع: ${next.error}')));
      } else if (previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('تم تحديث جسر الدفع.')));
        _applicationIdController.clear();
        _paymentIdController.clear();
        _amountController.clear();
        _notesController.clear();
      }
    });

    return NosokPageScaffold(
      title: 'جسر الدفع والفوترة',
      subtitle:
          'تنفيذ جسر أولي مع billing_system. نسك لا يخزن بيانات بطاقة ولا ينفذ بوابة دفع مستقلة؛ هو يفتح طلب دفع ويراقب حالته من منصة PalWakf.',
      children: [
        NosokSectionCard(
          title: 'إنشاء طلب جسر',
          subtitle:
              'ينشئ bridge request قابلًا للإرسال إلى billing_system عبر RPC العقد.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _field(_applicationIdController, 'Application ID',
                      width: 280),
                  _field(_paymentIdController, 'Payment ID اختياري',
                      width: 260),
                  _field(_amountController, 'المبلغ',
                      width: 160, keyboardType: TextInputType.number),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                    labelText: 'ملاحظات', border: OutlineInputBorder()),
                minLines: 2,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: commandState.isLoading ? null : _createBridgeRequest,
                icon: commandState.isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.add_link_outlined),
                label: const Text('إنشاء طلب جسر'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NosokAsyncView(
          value: requestsAsync,
          dataBuilder: (requests) => NosokSectionCard(
            title: 'طلبات الجسر والتنفيذ',
            subtitle:
                'execute يرسل العقد إلى billing_system أو محاكاته، و sync يستوعب مرجع المزود/التسوية عند توفره.',
            child: Column(
              children: [
                for (final request in requests)
                  _BridgeRequestTile(
                      request: request, isBusy: commandState.isLoading),
                if (requests.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('لا توجد طلبات جسر بعد'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _field(TextEditingController controller, String label,
      {double width = 220, TextInputType? keyboardType}) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Future<void> _createBridgeRequest() async {
    final applicationId = _applicationIdController.text.trim();
    if (applicationId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Application ID مطلوب.')));
      return;
    }
    await ref.read(nosokPaymentBridgeControllerProvider.notifier).createRequest(
          applicationId: applicationId,
          paymentId: _paymentIdController.text.trim().isEmpty
              ? null
              : _paymentIdController.text.trim(),
          amount: double.tryParse(_amountController.text.trim()),
          paymentMethod: 'manual_receipt_bridge',
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );
  }
}

class _BridgeRequestTile extends ConsumerWidget {
  const _BridgeRequestTile({required this.request, required this.isBusy});

  final NosokPaymentBridgeRequest request;
  final bool isBusy;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.applicationNo ?? request.applicationId,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text(request.bridgeStatus)),
                if (request.amount != null)
                  Chip(
                      label: Text(
                          '${request.amount!.toStringAsFixed(2)} ${request.currencyCode}')),
                if ((request.billingReference ?? '').trim().isNotEmpty)
                  Chip(label: Text('Billing: ${request.billingReference}')),
                if ((request.providerReference ?? '').trim().isNotEmpty)
                  Chip(label: Text('Provider: ${request.providerReference}')),
                Chip(label: Text(request.paymentMethod ?? 'manual/bridge')),
              ],
            ),
            if ((request.notes ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(request.notes!),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: isBusy
                      ? null
                      : () => ref
                          .read(nosokPaymentBridgeControllerProvider.notifier)
                          .executeRequest(
                            bridgeRequestId: request.id,
                            providerKey: 'billing_system',
                            paymentChannel: request.paymentMethod ??
                                'manual_receipt_bridge',
                            notes: 'تنفيذ من شاشة جسر نسك v12.',
                          ),
                  icon: const Icon(Icons.send_outlined),
                  label: const Text('إرسال للفوترة'),
                ),
                OutlinedButton.icon(
                  onPressed: isBusy
                      ? null
                      : () => ref
                          .read(nosokPaymentBridgeControllerProvider.notifier)
                          .syncRequest(
                            bridgeRequestId: request.id,
                            providerReference:
                                'SYNC-${DateTime.now().millisecondsSinceEpoch}',
                            notes: 'استيعاب حالة/مرجع من billing_system.',
                          ),
                  icon: const Icon(Icons.sync_outlined),
                  label: const Text('استيعاب/Sync'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
