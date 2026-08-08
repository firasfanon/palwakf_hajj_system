import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_operations_controller.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminOperationsPage extends ConsumerWidget {
  const NosokAdminOperationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readinessAsync = ref.watch(nosokOperationalReadinessProvider);

    return NosokPageScaffold(
      title: 'مركز التشغيل الإنتاجي',
      subtitle:
          'مركز عملي لتجميع جاهزية الطلبات، الدفع، الوثائق، الأدوار، الوحدات، والصحة التشغيلية قبل اعتماد الإنتاج.',
      actions: [
        OutlinedButton.icon(
          onPressed: () => ref.invalidate(nosokOperationalReadinessProvider),
          icon: const Icon(Icons.refresh_outlined),
          label: const Text('تحديث'),
        ),
      ],
      children: [
        NosokAsyncView(
          value: readinessAsync,
          dataBuilder: (items) {
            final blockers = items.where((item) => item.isBlocking).length;
            final warnings =
                items.where((item) => item.severity == 'warning').length;
            return Column(
              children: [
                NosokSectionCard(
                  title: 'ملخص التشغيل',
                  subtitle:
                      'لا يُرفع النظام إلى production-ready إذا بقيت blockers أو role/browser UAT غير مغلقة.',
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      Chip(label: Text('الفحوص: ${items.length}')),
                      Chip(label: Text('Blockers: $blockers')),
                      Chip(label: Text('Warnings: $warnings')),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                NosokSectionCard(
                  title: 'قائمة الجاهزية',
                  child: Column(
                    children: [
                      for (final item in items)
                        ListTile(
                          leading: Icon(item.isBlocking
                              ? Icons.error_outline
                              : Icons.fact_check_outlined),
                          title: Text(item.titleAr),
                          subtitle: Text([
                            item.key,
                            item.status,
                            if ((item.detailsAr ?? '').trim().isNotEmpty)
                              item.detailsAr!,
                          ].join(' — ')),
                          trailing: Chip(label: Text(item.severity)),
                        ),
                      if (items.isEmpty)
                        const ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text('لا توجد فحوص تشغيلية بعد'),
                          subtitle: Text(
                              'شغل SQL v11 أو استخدم مستودع المعاينة للحصول على checklist أولي.'),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
