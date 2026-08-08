import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v26_result_controller.dart';
import '../../../domain/models/nosok_v26_result_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV26FullMergeApplyResultPage extends ConsumerWidget {
  const NosokAdminV26FullMergeApplyResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV26ResultPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل نتيجة الدمج',
        message:
            'تعذر تحميل نتيجة تطبيق الدمج الحقيقي. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v26 — Full PalWakf Merge Apply Result',
            description:
                'استيعاب نتيجة تطبيق حزمة الدمج داخل ريبو PalWakf الكامل، وفصل ما أُغلق في preview عما لا يغلق إلا داخل المنصة الأم.',
            badges: const [
              'full repo apply',
              'RBAC override',
              'dynamic registry'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'Full merge pending', tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'RBAC override blocked', tone: PwfSisNoticeTone.error),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'حكم الدمج الحقيقي',
            message:
                'لم تُرفق بعد نتيجة تطبيق platform_real_merge_pack داخل ريبو PalWakf الكامل. لذلك تبقى هذه البوابة مانعًا قبل production-candidate.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          _V26MergeSection(section: data.fullMergeApplyResult),
          const SizedBox(height: 12),
          _V26MergeSection(section: data.supabaseRuntimeResult),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Runbook التطبيق الحقيقي',
            subtitle:
                'هذه الخطوات يجب تنفيذها داخل PalWakf الكامل وليس داخل preview host.',
            child: PwfSisDataTable(
              columns: const ['الخطوة', 'الموقع', 'الحالة'],
              rows: const [
                [
                  Text('نسخ feature'),
                  Text('lib/features/nosok_system'),
                  PwfSisStatusBadge(
                      label: 'pending', tone: PwfSisNoticeTone.warning)
                ],
                [
                  Text('ربط route group'),
                  Text('GoRouter الحقيقي'),
                  PwfSisStatusBadge(
                      label: 'pending', tone: PwfSisNoticeTone.warning)
                ],
                [
                  Text('AccessProfile override'),
                  Text('core/access داخل PalWakf'),
                  PwfSisStatusBadge(
                      label: 'blocked', tone: PwfSisNoticeTone.error)
                ],
                [
                  Text('Dynamic Registry'),
                  Text('platform.system_registry'),
                  PwfSisStatusBadge(
                      label: 'pending', tone: PwfSisNoticeTone.warning)
                ],
                [
                  Text('System Sections'),
                  Text('platform.system_sections'),
                  PwfSisStatusBadge(
                      label: 'pending', tone: PwfSisNoticeTone.warning)
                ],
                [
                  Text('SQL UAT'),
                  Text('Supabase SQL Editor'),
                  PwfSisStatusBadge(
                      label: 'pending', tone: PwfSisNoticeTone.warning)
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _V26MergeSection extends StatelessWidget {
  const _V26MergeSection({required this.section});

  final NosokV26ResultSection section;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: section.titleAr,
      subtitle: section.descriptionAr,
      child: PwfSisDataTable(
        columns: const ['البند', 'الحالة', 'الأولوية', 'الملاحظة'],
        rows: [
          for (final item in section.items)
            [
              Text(item.titleAr),
              PwfSisStatusBadge(
                  label: item.status, tone: _toneForStatus(item.status)),
              Text(item.priority),
              Text(item.noteAr),
            ],
        ],
      ),
    );
  }
}

PwfSisNoticeTone _toneForStatus(String status) {
  if (status == 'passed' || status == 'accepted' || status == 'ready')
    return PwfSisNoticeTone.success;
  if (status == 'blocked') return PwfSisNoticeTone.error;
  if (status.startsWith('pending') ||
      status == 'warning' ||
      status == 'partial') return PwfSisNoticeTone.warning;
  return PwfSisNoticeTone.info;
}
