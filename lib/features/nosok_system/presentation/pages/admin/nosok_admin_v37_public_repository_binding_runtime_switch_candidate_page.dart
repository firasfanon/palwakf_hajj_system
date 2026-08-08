import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v37_runtime_switch_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV37PublicRepositoryBindingRuntimeSwitchCandidatePage
    extends ConsumerWidget {
  const NosokAdminV37PublicRepositoryBindingRuntimeSwitchCandidatePage(
      {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV37RuntimeSwitchPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل v37',
        message:
            'تعذر تحميل حزمة Runtime Switch Candidate. راجع Console وسجل Riverpod.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title:
                'Nosok v37 — Public Repository Binding Runtime Switch Candidate',
            description:
                'دفعة تطوير تشغيلية تجهز switch candidate للقراءة العامة عبر public RPC wrappers مع fallback آمن، دون تفعيل platformHosted أو submit/track بعد.',
            badges: [
              'runtime switch candidate',
              'fallback-safe',
              'repository binding'
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 220,
            children: [
              PwfSisMetricCard(
                  label: 'أدلة مقبولة',
                  value: '${data.acceptedEvidenceCount}',
                  icon: Icons.fact_check_outlined),
              PwfSisMetricCard(
                  label: 'مرشحات ربط',
                  value: '${data.candidateSwitchCount}',
                  icon: Icons.sync_alt_outlined),
              PwfSisMetricCard(
                  label: 'حالات معلقة',
                  value: '${data.pendingCaseCount}',
                  icon: Icons.pending_actions_outlined),
              PwfSisMetricCard(
                  label: 'محجوب',
                  value: '${data.blockedSwitchCount}',
                  icon: Icons.block_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصفوفة Runtime Switch Candidate',
            subtitle:
                'هذه ليست production switch. الربط العام يتم كمرشح تشغيل قابل للفشل الآمن فقط.',
            child: PwfSisDataTable(
              columns: const [
                'السطح',
                'المصدر الحالي',
                'المصدر المرشح',
                'النمط',
                'القرار',
                'الدليل المطلوب'
              ],
              rows: [
                for (final item in data.switchCandidates)
                  [
                    Text(item.surface),
                    Text(item.currentSource),
                    Text(item.candidateSource),
                    Text(item.switchMode),
                    PwfSisStatusBadge(
                      label: item.decision,
                      tone: item.allowed
                          ? PwfSisNoticeTone.warning
                          : item.blocked
                              ? PwfSisNoticeTone.error
                              : PwfSisNoticeTone.info,
                    ),
                    Text(item.requiredEvidenceAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v37',
            message: data.repositoryBindingDecision.summaryAr,
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
