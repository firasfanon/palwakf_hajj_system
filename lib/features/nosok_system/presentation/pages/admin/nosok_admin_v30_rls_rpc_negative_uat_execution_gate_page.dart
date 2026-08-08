import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v30_apply_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV30RlsRpcNegativeUatExecutionGatePage extends ConsumerWidget {
  const NosokAdminV30RlsRpcNegativeUatExecutionGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV30ApplyGatePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل UAT gate',
          message: 'تعذر تحميل بوابة RLS/RPC/Negative UAT.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v30 — RLS/RPC/Negative UAT Execution Result Gate',
            description:
                'بوابة نتائج UAT بعد تطبيق staging. لا يمكن إغلاق حالات RLS/RPC/Negative UAT قبل وجود nosok schema وجداولها وسياساتها.',
            badges: const ['RLS', 'RPC', 'negative UAT', 'blocked until apply'],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.blockedUatCaseCount} blocked',
                  tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RLS/RPC Surface Gate',
            subtitle:
                'الأسطح المطلوبة بعد apply. public يبقى views/RPC فقط وليس base tables.',
            child: PwfSisDataTable(
              columns: const ['السطح', 'النوع', 'الدليل المطلوب', 'الحالة'],
              rows: [
                for (final surface in data.rlsRpcSurfaces)
                  [
                    Text(surface.surface),
                    Text(surface.surfaceType),
                    Text(surface.requiredEvidenceAr),
                    PwfSisStatusBadge(
                        label: surface.status,
                        tone: surface.status.contains('blocked')
                            ? PwfSisNoticeTone.warning
                            : PwfSisNoticeTone.neutral),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Negative UAT Execution Matrix',
            subtitle: 'هذه الحالات تصبح قابلة للتنفيذ بعد تطبيق staging فقط.',
            child: PwfSisDataTable(
              columns: const [
                'الحالة',
                'الممثل',
                'الهدف',
                'المتوقع',
                'حالة التنفيذ',
                'قرار البوابة'
              ],
              rows: [
                for (final item in data.negativeUatCases)
                  [
                    Text(item.caseKey),
                    Text(item.actor),
                    Text(item.target),
                    Text(item.expectedResultAr),
                    PwfSisStatusBadge(
                        label: item.executionStatus,
                        tone: item.executionStatus.startsWith('accepted')
                            ? PwfSisNoticeTone.success
                            : PwfSisNoticeTone.warning),
                    Text(item.gateDecision),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
              title: 'قرار الإنتاج',
              message: data.decision.blockedAr,
              tone: PwfSisNoticeTone.error),
        ],
      ),
    );
  }
}
