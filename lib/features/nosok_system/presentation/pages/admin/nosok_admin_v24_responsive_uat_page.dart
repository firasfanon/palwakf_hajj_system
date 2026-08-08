import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v24_uat_controller.dart';
import '../../../domain/models/nosok_v24_uat_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV24ResponsiveUatPage extends ConsumerWidget {
  const NosokAdminV24ResponsiveUatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV24UatPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل فحص الاستجابة',
          message:
              'ظهرت مشكلة في تحميل فحص الاستجابة. لا يتم عرض أخطاء backend خام.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Responsive + Anti-Overload UAT',
            description:
                'فحص تحول الجداول إلى بطاقات، والنماذج الطويلة إلى wizard، ومنع الازدحام البصري على الأجهزة الصغيرة.',
            badges: ['PWF-SIS', 'RTL', 'mobile first', 'anti-overload'],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(children: const [
            PwfSisMetricCard(
                label: 'Desktop',
                value: 'Ready',
                subtitle: 'Chrome preview',
                icon: Icons.desktop_windows_outlined),
            PwfSisMetricCard(
                label: 'Tablet',
                value: 'Pending',
                subtitle: 'لقطة مطلوبة',
                icon: Icons.tablet_mac_outlined),
            PwfSisMetricCard(
                label: 'Mobile',
                value: 'Pending',
                subtitle: 'لا overflow قبل الاعتماد',
                icon: Icons.phone_android_outlined),
            PwfSisMetricCard(
                label: 'Density',
                value: 'Controlled',
                subtitle: 'لا حشر للصفحات',
                icon: Icons.view_comfy_alt_outlined),
          ]),
          const SizedBox(height: 12),
          for (final group in data.responsiveGroups) ...[
            _V24EvidenceGroupPanel(group: group),
            const SizedBox(height: 12),
          ],
          const PwfSisPanel(
            title: 'مسارات Responsive الحرجة',
            subtitle:
                'هذه المسارات يجب تصويرها على desktop/tablet/mobile قبل production-candidate.',
            child: PwfSisDataTable(
              columns: ['المسار', 'سبب الأهمية', 'نمط العرض المتوقع'],
              rows: [
                [
                  Text('/services/nosok/apply'),
                  Text('نموذج طويل'),
                  Text('Wizard خطوة واحدة على mobile')
                ],
                [
                  Text('/services/nosok/track'),
                  Text('تتبع عام'),
                  Text('بطاقة حالة دون بيانات حساسة')
                ],
                [
                  Text('/admin/systems/nosok/requests'),
                  Text('قائمة تشغيلية'),
                  Text('Table على desktop وcards على mobile')
                ],
                [
                  Text('/admin/systems/nosok/review'),
                  Text('قرار مراجعة'),
                  Text('Queue + Decision Panel دون تزاحم')
                ],
                [
                  Text('/admin/systems/nosok/documents'),
                  Text('وثائق ومعاينة'),
                  Text('Tabs/sections بدل أعمدة كثيرة')
                ],
              ],
            ),
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
