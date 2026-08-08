import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v26_result_controller.dart';
import '../../../domain/models/nosok_v26_result_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV26EvidenceResultIntakePage extends ConsumerWidget {
  const NosokAdminV26EvidenceResultIntakePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV26ResultPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل أدلة v26',
        message:
            'تعذر تحميل حزمة الاستيعاب. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v26 — Evidence Result Intake',
            description:
                'استيعاب نتائج SQL/Browser/Role/Responsive وفق السجل المرسل، مع إغلاق تحذير analyzer المتبقي من v25 دون إعلان إنتاج.',
            badges: const ['v26', 'evidence result intake', 'staging-stable'],
            actions: [
              PwfSisStatusBadge(
                  label: 'Passed ${data.passedChecks}/${data.totalChecks}',
                  tone: PwfSisNoticeTone.success),
              PwfSisStatusBadge(
                  label: 'Pending ${data.pendingChecks}',
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'Blocked ${data.blockedChecks}',
                  tone: data.blockedChecks == 0
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.error),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'إجمالي الفحوص',
                  value: '${data.totalChecks}',
                  subtitle: 'Runtime + Browser + Roles + Merge + Supabase'),
              PwfSisMetricCard(
                  label: 'Passed / Accepted',
                  value: '${data.passedChecks}',
                  subtitle: 'مقبولة أو مغلقة',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'Pending',
                  value: '${data.pendingChecks}',
                  subtitle: 'تحتاج أدلة إضافية',
                  icon: Icons.pending_actions_outlined),
              PwfSisMetricCard(
                  label: 'Blockers',
                  value: '${data.blockedChecks}',
                  subtitle: 'تمنع production-candidate',
                  icon: Icons.block_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'نتيجة الاستيعاب الحالية',
            message: data.productionDecision.reasonAr,
            tone: data.productionDecision.isCandidate
                ? PwfSisNoticeTone.success
                : PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          _V26SectionPanel(section: data.localRuntimeResult),
          const SizedBox(height: 12),
          _V26SectionPanel(section: data.browserResult),
          const SizedBox(height: 12),
          _V26SectionPanel(section: data.roleResult),
          const SizedBox(height: 12),
          _V26SectionPanel(section: data.responsiveResult),
        ],
      ),
    );
  }
}

class _V26SectionPanel extends StatelessWidget {
  const _V26SectionPanel({required this.section});

  final NosokV26ResultSection section;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: section.titleAr,
      subtitle: section.descriptionAr,
      actions: [
        PwfSisStatusBadge(
            label: '${section.passedCount}/${section.total} passed',
            tone: section.blockedCount == 0
                ? PwfSisNoticeTone.success
                : PwfSisNoticeTone.warning),
        if (section.pendingCount > 0)
          PwfSisStatusBadge(
              label: '${section.pendingCount} pending',
              tone: PwfSisNoticeTone.warning),
        if (section.blockedCount > 0)
          PwfSisStatusBadge(
              label: '${section.blockedCount} blocked',
              tone: PwfSisNoticeTone.error),
      ],
      child: PwfSisDataTable(
        columns: const ['البند', 'الحالة', 'الأولوية', 'الدليل', 'الملاحظة'],
        rows: [
          for (final item in section.items)
            [
              Text(item.titleAr),
              PwfSisStatusBadge(
                  label: item.status, tone: _toneForStatus(item.status)),
              Text(item.priority),
              Text(item.evidenceRefAr),
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
