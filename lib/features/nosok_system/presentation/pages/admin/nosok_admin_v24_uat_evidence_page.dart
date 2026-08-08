import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v24_uat_controller.dart';
import '../../../domain/models/nosok_v24_uat_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV24UatEvidencePage extends ConsumerWidget {
  const NosokAdminV24UatEvidencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV24UatPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل أدلة UAT',
        message:
            'تعذر تحميل أدلة نسك حاليًا. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'إغلاق أدلة Browser / Role UAT',
            description:
                'سطح موحد لتجميع حالة فتح مسارات الجمهور والموظفين وفصل الواجهات حسب الدور قبل أي قرار إنتاجي.',
            badges: const ['v24', 'UAT evidence', 'production gate input'],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.passedChecks}/${data.totalChecks} check',
                  tone: data.blockers == 0
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'blockers: ${data.blockers}',
                  tone: data.blockers == 0
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.error),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قاعدة حاكمة',
            message:
                'هذه الصفحة تستوعب الأدلة ولا تعتمد الإنتاج. الاعتماد يبقى مشروطًا بدمج PalWakf الكامل وSQL/Role/Responsive UAT.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          for (final group in [...data.browserGroups, ...data.roleGroups]) ...[
            _V24EvidenceGroupPanel(group: group),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _V24EvidenceGroupPanel extends StatelessWidget {
  const _V24EvidenceGroupPanel({required this.group});
  final NosokV24EvidenceGroup group;
  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: group.titleAr,
      subtitle: group.descriptionAr,
      actions: [
        PwfSisStatusBadge(
            label: '${group.passedCount}/${group.items.length} passed',
            tone: group.blockersCount == 0
                ? PwfSisNoticeTone.success
                : PwfSisNoticeTone.warning),
      ],
      child: Column(
        children: [for (final item in group.items) _V24CheckTile(item: item)],
      ),
    );
  }
}

class _V24CheckTile extends StatelessWidget {
  const _V24CheckTile({required this.item});
  final NosokV24CheckItem item;
  @override
  Widget build(BuildContext context) {
    final tone = switch (item.status) {
      'passed' => PwfSisNoticeTone.success,
      'blocked' => PwfSisNoticeTone.error,
      'ready' => PwfSisNoticeTone.info,
      _ => PwfSisNoticeTone.warning,
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(item.blocked
          ? Icons.block_outlined
          : item.passed
              ? Icons.check_circle_outline
              : Icons.pending_actions_outlined),
      title: Text(item.titleAr),
      subtitle: Text(item.noteAr),
      trailing: Wrap(spacing: 6, children: [
        PwfSisStatusBadge(label: item.status, tone: tone),
        PwfSisStatusBadge(label: item.priority),
      ]),
    );
  }
}
