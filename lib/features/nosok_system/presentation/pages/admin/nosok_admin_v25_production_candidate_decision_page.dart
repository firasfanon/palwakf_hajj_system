import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v25_candidate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV25ProductionCandidateDecisionPage extends ConsumerWidget {
  const NosokAdminV25ProductionCandidateDecisionPage({super.key});

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
            title: 'Nosok v25 — Production Candidate Decision',
            description:
                'إعادة قرار الإنتاج وفق الأدلة المستوعبة، مع فصل واضح بين staging-stable وproduction-candidate.',
            badges: const ['v25', 'candidate decision', 'not approved'],
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
            title: 'الحكم التنفيذي الحالي',
            message: data.decision.reasonAr,
            tone: data.decision.isCandidate
                ? PwfSisNoticeTone.success
                : PwfSisNoticeTone.error,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قرار production-candidate',
            subtitle: data.decision.nextActionAr,
            actions: [
              PwfSisStatusBadge(
                  label: data.decision.status,
                  tone: data.decision.isCandidate
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.warning)
            ],
            child: PwfSisDataTable(
              columns: const ['المحور', 'Passed', 'Pending', 'Blocked'],
              rows: [
                for (final section in data.allSections)
                  [
                    Text(section.titleAr),
                    Text('${section.passedCount}'),
                    Text('${section.pendingCount}'),
                    Text('${section.blockedCount}'),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'عدم المساس بالأصول الوقفية',
            message:
                'v25 لا تنفذ SQL إنتاجي، ولا تعدل waqf_assets أو schema waqf أو awqaf_system. نطاقها Evidence/Decision/Readiness فقط.',
            tone: PwfSisNoticeTone.success,
          ),
        ],
      ),
    );
  }
}
