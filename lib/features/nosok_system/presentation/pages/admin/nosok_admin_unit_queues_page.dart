import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_unit_queue_controller.dart';
import '../../../domain/models/nosok_unit_application_queue_item.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminUnitQueuesPage extends ConsumerStatefulWidget {
  const NosokAdminUnitQueuesPage({super.key});

  @override
  ConsumerState<NosokAdminUnitQueuesPage> createState() =>
      _NosokAdminUnitQueuesPageState();
}

class _NosokAdminUnitQueuesPageState
    extends ConsumerState<NosokAdminUnitQueuesPage> {
  final _unitSlugController = TextEditingController();
  String? _status;

  @override
  void dispose() {
    _unitSlugController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queueAsync = ref.watch(nosokUnitApplicationQueueProvider);
    return NosokPageScaffold(
      title: 'طوابير الطلبات حسب الوحدة',
      subtitle:
          'طابور تشغيلي يربط الطلبات بنطاق الوحدة/المديرية. يعتمد في الإنتاج على core.org_units وAccessProfile unit scope، وليس على مستخدمين داخل نسك.',
      actions: [
        OutlinedButton.icon(
          onPressed: _applyFilter,
          icon: const Icon(Icons.filter_alt_outlined),
          label: const Text('تطبيق الفلتر'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'فلاتر الطابور',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 260,
                child: TextField(
                  controller: _unitSlugController,
                  decoration: const InputDecoration(
                      labelText: 'unitSlug اختياري',
                      border: OutlineInputBorder()),
                  onSubmitted: (_) => _applyFilter(),
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String?>(
                  value: _status,
                  decoration: const InputDecoration(
                      labelText: 'حالة الطلب', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('كل الحالات')),
                    DropdownMenuItem(
                        value: 'submitted', child: Text('submitted')),
                    DropdownMenuItem(
                        value: 'under_review', child: Text('under_review')),
                    DropdownMenuItem(
                        value: 'needs_action', child: Text('needs_action')),
                    DropdownMenuItem(
                        value: 'approved', child: Text('approved')),
                    DropdownMenuItem(
                        value: 'rejected', child: Text('rejected')),
                  ],
                  onChanged: (value) => setState(() => _status = value),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  _unitSlugController.clear();
                  setState(() => _status = null);
                  ref.read(nosokUnitQueueFilterProvider.notifier).state =
                      const NosokUnitQueueFilter();
                },
                icon: const Icon(Icons.refresh_outlined),
                label: const Text('إعادة ضبط'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        NosokAsyncView(
          value: queueAsync,
          dataBuilder: (items) => NosokSectionCard(
            title: 'قائمة الطابور',
            subtitle: 'الفتح التفصيلي يتم على صفحة الطلب الإدارية الكاملة.',
            child: Column(
              children: [
                for (final item in items) _QueueCard(item: item),
                if (items.isEmpty)
                  const ListTile(
                    leading: Icon(Icons.inbox_outlined),
                    title: Text('لا توجد طلبات ضمن هذا النطاق.'),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _applyFilter() {
    final unitSlug = _unitSlugController.text.trim();
    ref.read(nosokUnitQueueFilterProvider.notifier).state =
        NosokUnitQueueFilter(
      unitSlug: unitSlug.isEmpty ? null : unitSlug,
      status: _status,
    );
  }
}

class _QueueCard extends StatelessWidget {
  const _QueueCard({required this.item});

  final NosokUnitApplicationQueueItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(item.needsAction
            ? Icons.warning_amber_outlined
            : Icons.assignment_outlined),
        title: Text('${item.applicationNo} — ${item.applicantFullName}'),
        subtitle: Text([
          item.unitNameAr ?? item.unitSlug ?? 'نطاق غير محدد',
          item.applicationStatus,
          if ((item.eligibilityStatus ?? '').trim().isNotEmpty)
            'الأهلية: ${item.eligibilityStatus}',
          if (item.pendingDocumentsCount != null)
            'وثائق معلقة: ${item.pendingDocumentsCount}',
          if (item.pendingPaymentsCount != null)
            'دفعات معلقة: ${item.pendingPaymentsCount}',
        ].join(' • ')),
        trailing: FilledButton.icon(
          onPressed: () =>
              context.push(NosokSystemRoutes.adminApplicationDetails(item.id)),
          icon: const Icon(Icons.open_in_new),
          label: const Text('فتح'),
        ),
      ),
    );
  }
}
