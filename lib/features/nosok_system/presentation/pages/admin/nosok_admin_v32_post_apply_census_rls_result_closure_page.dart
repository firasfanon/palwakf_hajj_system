import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v32_apply_evidence_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV32PostApplyCensusRlsResultClosurePage extends ConsumerWidget {
  const NosokAdminV32PostApplyCensusRlsResultClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV32ApplyEvidencePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل v32',
        message: 'تعذر تحميل بوابة أدلة v32.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v32 — Post-Apply Census/RLS Result Closure',
            description:
                'إغلاق نتائج post-apply مشروط بتنفيذ apply ثم تشغيل فحص read-only بعده.',
            badges: const ['v32', 'apply evidence', 'production blocked'],
            actions: [
              PwfSisStatusBadge(
                label: data.productionGate.decision,
                tone: PwfSisNoticeTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'accepted',
                  value: '${data.acceptedEvidenceCount}',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'pending',
                  value: '${data.pendingEvidenceCount}',
                  icon: Icons.pending_actions_outlined),
              PwfSisMetricCard(
                  label: 'blocked',
                  value: '${data.blockedEvidenceCount}',
                  icon: Icons.block_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v32',
            message: data.productionGate.summaryAr,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Evidence Matrix',
            subtitle: 'استيعاب أدلة v31 والقرار التشغيلي قبل/بعد apply.',
            child: PwfSisDataTable(
              columns: const ['البند', 'المشاهدة', 'الحالة', 'القرار'],
              rows: [
                for (final item in data.evidenceItems)
                  [
                    Text(item.labelAr),
                    Text(item.observedAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      tone: item.accepted
                          ? PwfSisNoticeTone.success
                          : item.blocked
                              ? PwfSisNoticeTone.error
                              : PwfSisNoticeTone.warning,
                    ),
                    Text(item.decisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Operator File Order',
            subtitle: 'قرار واضح حول الملفات الأربعة التي سألت عنها.',
            child: PwfSisDataTable(
              columns: const ['الملف', 'متى يشغّل', 'مسموح الآن', 'ملاحظات'],
              rows: [
                for (final item in data.operatorFileDecisions)
                  [
                    Text(item.filePath),
                    Text(item.whenToRunAr),
                    PwfSisStatusBadge(
                      label: item.allowedNow ? 'allowed' : 'not-now',
                      tone: item.allowedNow
                          ? PwfSisNoticeTone.success
                          : PwfSisNoticeTone.warning,
                    ),
                    Text(item.notesAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisPanel(
                  title: 'المسموح التالي',
                  child: Text(data.productionGate.allowedNextStepAr)),
              PwfSisPanel(
                  title: 'المحظور', child: Text(data.productionGate.blockedAr)),
            ],
          ),
        ],
      ),
    );
  }
}
