import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v31_apply_certification_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV31PostApplyRlsRpcNegativeUatClosurePage
    extends ConsumerWidget {
  const NosokAdminV31PostApplyRlsRpcNegativeUatClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV31ApplyCertificationPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل UAT v31',
          message: 'تعذر تحميل إغلاق RLS/RPC/Negative UAT.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v31 — Post-Apply RLS/RPC Negative UAT Closure',
            description:
                'إغلاق RLS/RPC/Negative UAT لا يبدأ إلا بعد تطبيق controlled staging DDL وإثبات ظهور nosok schema والجداول وسياسات RLS.',
            badges: const [
              'post-apply',
              'negative UAT',
              'blocked until SQL output'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.blockedNegativeUatCount} blocked',
                  tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RLS/RPC Closure Surfaces',
            subtitle:
                'كل سطح يتطلب دليلاً بعد apply. public يبقى views/RPC فقط.',
            child: PwfSisDataTable(
              columns: const [
                'السطح',
                'النوع',
                'الدليل المطلوب بعد apply',
                'الحالة'
              ],
              rows: [
                for (final item in data.rlsRpcSurfaces)
                  [
                    Text(item.surface),
                    Text(item.surfaceType),
                    Text(item.requiredAfterApplyAr),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.status.startsWith('blocked')
                            ? PwfSisNoticeTone.warning
                            : PwfSisNoticeTone.neutral),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Negative UAT Closure Matrix',
            subtitle: 'الحالات التي يجب تنفيذها بعد ظهور schema والجداول.',
            child: PwfSisDataTable(
              columns: const [
                'الحالة',
                'الممثل',
                'السطح',
                'المتوقع',
                'الحالة الحالية',
                'بوابة الإغلاق'
              ],
              rows: [
                for (final item in data.negativeUatCases)
                  [
                    Text(item.caseKey),
                    Text(item.actorAr),
                    Text(item.surface),
                    Text(item.expectedResultAr),
                    PwfSisStatusBadge(
                        label: item.currentStatus,
                        tone: item.currentStatus.contains('blocked')
                            ? PwfSisNoticeTone.warning
                            : PwfSisNoticeTone.neutral),
                    Text(item.closureGateAr),
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
