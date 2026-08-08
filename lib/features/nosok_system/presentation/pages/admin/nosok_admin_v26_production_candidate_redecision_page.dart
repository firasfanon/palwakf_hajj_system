import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v26_result_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV26ProductionCandidateRedecisionPage extends ConsumerWidget {
  const NosokAdminV26ProductionCandidateRedecisionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV26ResultPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل قرار v26',
        message:
            'تعذر تحميل قرار production-candidate. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v26 — Production Candidate Re-decision',
            description:
                'إعادة القرار بعد استيعاب نتائج التشغيل المحلي والتحذير المتبقي، مع إبقاء الإنتاج محجوبًا حتى إغلاق الدمج الحقيقي وSQL/Role/Responsive evidence.',
            badges: const ['v26', 're-decision', 'production-not-approved'],
            actions: [
              PwfSisStatusBadge(
                  label: data.productionDecision.status,
                  tone: data.productionDecision.isCandidate
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.error),
              PwfSisStatusBadge(
                  label: 'Blockers ${data.blockedChecks}',
                  tone: data.blockedChecks == 0
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.error),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'Passed',
                  value: '${data.passedChecks}',
                  subtitle: 'مقبولة أو مغلقة',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'Pending',
                  value: '${data.pendingChecks}',
                  subtitle: 'تحتاج دليل',
                  icon: Icons.pending_actions_outlined),
              PwfSisMetricCard(
                  label: 'Warnings',
                  value: '${data.warningChecks}',
                  subtitle: 'جزئية أو تحذيرية',
                  icon: Icons.warning_amber_outlined),
              PwfSisMetricCard(
                  label: 'Blockers',
                  value: '${data.blockedChecks}',
                  subtitle: 'مانعة للترشيح',
                  icon: Icons.block_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'القرار النهائي لهذه الدفعة',
            message: data.productionDecision.reasonAr,
            tone: data.productionDecision.isCandidate
                ? PwfSisNoticeTone.success
                : PwfSisNoticeTone.error,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'ملخص الموانع',
            subtitle: data.productionDecision.nextActionAr,
            actions: [
              PwfSisStatusBadge(
                  label: data.productionDecision.status,
                  tone: data.productionDecision.isCandidate
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.error)
            ],
            child: Text(data.productionDecision.blockerSummaryAr),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قرار المحاور',
            subtitle: data.productionDecision.allowedScopeAr,
            child: PwfSisDataTable(
              columns: const [
                'المحور',
                'Passed',
                'Pending',
                'Warnings',
                'Blocked'
              ],
              rows: [
                for (final section in data.allSections)
                  [
                    Text(section.titleAr),
                    Text('${section.passedCount}'),
                    Text('${section.pendingCount}'),
                    Text('${section.warningCount}'),
                    Text('${section.blockedCount}'),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'حدود v26',
            message:
                'هذه الدفعة Evidence/Decision/Readiness فقط. لا SQL إنتاجي، لا DML، ولا تعديل على waqf_assets أو schema waqf أو awqaf_system.',
            tone: PwfSisNoticeTone.success,
          ),
        ],
      ),
    );
  }
}
