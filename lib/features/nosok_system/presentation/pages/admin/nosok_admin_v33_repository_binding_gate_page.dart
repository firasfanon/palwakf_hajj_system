import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v33_uat_binding_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV33RepositoryBindingGatePage extends ConsumerWidget {
  const NosokAdminV33RepositoryBindingGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV33UatBindingPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل v33',
        message: 'تعذر تحميل بوابة v33.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v33 — Repository Binding Gate',
            description:
                'بوابة ربط Flutter repository modes بعد post-apply وwrapper/RPC evidence.',
            badges: const ['v33', 'post-apply', 'production blocked'],
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
                  value: '${data.acceptedCount}',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'pending',
                  value: '${data.pendingCount}',
                  icon: Icons.pending_actions_outlined),
              PwfSisMetricCard(
                  label: 'wrappers',
                  value: '${data.wrapperDraftCount}',
                  icon: Icons.api_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v33',
            message: data.productionGate.summaryAr,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Negative UAT Matrix',
            subtitle:
                'SQL evidence accepted and browser/role/scope evidence still tracked explicitly.',
            child: PwfSisDataTable(
              columns: const [
                'الحالة',
                'النطاق',
                'المتوقع',
                'الدليل',
                'القرار'
              ],
              rows: [
                for (final item in data.negativeUatCases)
                  [
                    Text(item.key),
                    Text(item.scopeAr),
                    Text(item.expectedAr),
                    PwfSisStatusBadge(
                      label: item.evidenceStatus,
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
            title: 'Repository Binding Gate',
            subtitle:
                'Controls preview / standaloneSupabaseDevelopment / platformHosted binding.',
            child: PwfSisDataTable(
              columns: const [
                'mode',
                'مسموح الآن',
                'هدف الربط',
                'الأدلة المطلوبة'
              ],
              rows: [
                for (final item in data.repositoryBindingGates)
                  [
                    Text(item.mode),
                    PwfSisStatusBadge(
                        label: item.allowedNow ? 'allowed' : 'blocked',
                        tone: item.allowedNow
                            ? PwfSisNoticeTone.success
                            : PwfSisNoticeTone.error),
                    Text(item.bindingTargetAr),
                    Text(item.requiredEvidenceAr),
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
