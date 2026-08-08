import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v33_uat_binding_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV33PublicWrapperSurfaceDraftPage extends ConsumerWidget {
  const NosokAdminV33PublicWrapperSurfaceDraftPage({super.key});

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
            title: 'Nosok v33 — Public Wrapper Surface Draft',
            description:
                'مسودة views/RPC wrappers العامة دون إنشاء public base tables ودون apply.',
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
            title: 'Public Wrapper/RPC Drafts',
            subtitle:
                'Draft-only. public remains compatibility/RPC surface and not an owner schema.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'السطح',
                'النوع',
                'المصدر',
                'الحالة',
                'ملاحظات أمنية'
              ],
              rows: [
                for (final item in data.wrapperDrafts)
                  [
                    Text(item.surfaceKey),
                    Text(item.objectName),
                    Text(item.surfaceType),
                    Text(item.sourceAr),
                    PwfSisStatusBadge(
                        label: item.status, tone: PwfSisNoticeTone.warning),
                    Text(item.securityNotesAr),
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
