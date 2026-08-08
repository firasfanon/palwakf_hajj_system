import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v24_uat_controller.dart';
import '../../../domain/models/nosok_v24_uat_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV24MergeReadinessClosurePage extends ConsumerWidget {
  const NosokAdminV24MergeReadinessClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV24UatPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل جاهزية الدمج',
          message: 'تعذر تحميل سجل جاهزية الدمج. راجع الحزمة أو أعد المحاولة.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'PalWakf Merge Readiness Closure',
            description:
                'تجهيز نسك للانتقال من preview host إلى ريبو PalWakf الكامل دون تحويله إلى منتج مستقل.',
            badges: [
              'under platform',
              'real merge pack',
              'RBAC override required'
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'لا اعتماد دون الريبو الكامل',
            message:
                'هذه الصفحة تغلق جاهزية الدمج فقط. التطبيق الفعلي يتطلب ريبو PalWakf الكامل وربط AccessProfile وDynamic Registry داخل المنصة الأم.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          for (final group in data.mergeGroups) ...[
            _V24EvidenceGroupPanel(group: group),
            const SizedBox(height: 12),
          ],
          PwfSisPanel(
            title: 'خطوات الدمج الفعلي',
            subtitle: 'تنفذ داخل PalWakf فقط، وليس داخل preview host.',
            child: PwfSisTimeline(items: const [
              'نسخ lib/features/nosok_system إلى ريبو المنصة الكامل.',
              'ربط NosokRoutes داخل route groups الحقيقية دون كسر unitSlug.',
              'تطبيق nosokAccessProfileProvider override من AccessProfile السيادي.',
              'تسجيل system_registry وsystem_sections وpermissions عبر scripts المصرح بها.',
              'تشغيل SQL UAT read-only قبل أي seed أو DML.',
              'تسليم Browser/Role/Responsive evidence قبل production-candidate.',
            ]),
          ),
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
