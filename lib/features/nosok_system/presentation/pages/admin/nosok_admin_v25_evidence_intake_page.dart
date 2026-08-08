import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v25_candidate_controller.dart';
import '../../../domain/models/nosok_v25_candidate_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV25EvidenceIntakePage extends ConsumerWidget {
  const NosokAdminV25EvidenceIntakePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV25EvidencePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل حزمة v25',
        message:
            'تعذر تحميل بيانات الاستيعاب. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v25 — Evidence Intake',
            description:
                'استيعاب أدلة التشغيل والمتصفح والأدوار والاستجابة بعد استقرار preview، مع إبقاء القرار مشروطًا بالأدلة الحقيقية.',
            badges: const ['v25', 'evidence intake', 'role/browser/responsive'],
            actions: [
              PwfSisStatusBadge(
                  label: data.decision.status,
                  tone: data.decision.isCandidate
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'P0 blockers: ${data.blockers}',
                  tone: data.blockers == 0
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
                  subtitle: 'جميع محاور v25'),
              PwfSisMetricCard(
                  label: 'Passed',
                  value: '${data.passedChecks}',
                  subtitle: 'أدلة مقبولة أو مستوعبة',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'Pending',
                  value: '${data.pendingChecks}',
                  subtitle: 'تحتاج دليل تشغيل',
                  icon: Icons.pending_actions_outlined),
              PwfSisMetricCard(
                  label: 'Blockers',
                  value: '${data.blockers}',
                  subtitle: 'تمنع production-candidate',
                  icon: Icons.block_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'استيعاب الأدلة لا يعني اعتماد الإنتاج',
            message: data.decision.allowedScopeAr,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          _V25EvidenceSectionPanel(section: data.runtimeEvidence),
          const SizedBox(height: 12),
          _V25EvidenceSectionPanel(section: data.browserEvidence),
          const SizedBox(height: 12),
          _V25EvidenceSectionPanel(section: data.roleEvidence),
          const SizedBox(height: 12),
          _V25EvidenceSectionPanel(section: data.responsiveEvidence),
        ],
      ),
    );
  }
}

class _V25EvidenceSectionPanel extends StatelessWidget {
  const _V25EvidenceSectionPanel({required this.section});

  final NosokV25EvidenceSection section;

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
        if (section.blockedCount > 0)
          PwfSisStatusBadge(
              label: '${section.blockedCount} blocked',
              tone: PwfSisNoticeTone.error),
      ],
      child: PwfSisDataTable(
        columns: const ['البند', 'الحالة', 'الأولوية', 'المسؤول', 'الملاحظة'],
        rows: [
          for (final item in section.items)
            [
              Text(item.titleAr),
              PwfSisStatusBadge(
                  label: item.status, tone: _toneForStatus(item.status)),
              Text(item.priority),
              Text(item.ownerAr),
              Text(item.noteAr),
            ],
        ],
      ),
    );
  }
}

PwfSisNoticeTone _toneForStatus(String status) {
  if (status == 'passed' || status == 'ready') return PwfSisNoticeTone.success;
  if (status == 'blocked') return PwfSisNoticeTone.error;
  if (status.startsWith('pending')) return PwfSisNoticeTone.warning;
  return PwfSisNoticeTone.info;
}
