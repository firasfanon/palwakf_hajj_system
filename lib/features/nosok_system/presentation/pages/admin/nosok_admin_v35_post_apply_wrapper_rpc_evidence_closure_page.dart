import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v35_wrapper_apply_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV35PostApplyWrapperRpcEvidenceClosurePage
    extends ConsumerWidget {
  const NosokAdminV35PostApplyWrapperRpcEvidenceClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV35WrapperApplyPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل أدلة v35',
        message: 'تعذر تحميل إغلاق أدلة wrapper/RPC.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v35 — Post-Apply Wrapper/RPC Evidence Closure',
            description:
                'إغلاق أدلة وجود views/RPCs العامة، صلاحيات التنفيذ، search_path، وعدم وجود public base tables جديدة.',
            badges: [
              'post-apply',
              'read-only evidence',
              'no public base tables'
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Expected Public Wrapper/RPC Objects',
            subtitle:
                'هذه الأسطح يجب أن تظهر بعد تشغيل SQL v35 operator-ready.',
            child: PwfSisDataTable(
              columns: const [
                'الكائن',
                'النوع',
                'الحالة المتوقعة',
                'حدود البيانات',
                'قرار الربط'
              ],
              rows: [
                for (final item in data.wrapperRpcObjects)
                  [
                    Text(item.objectName),
                    Text(item.objectType),
                    PwfSisStatusBadge(
                        label: item.expectedPostApplyStatus,
                        tone: PwfSisNoticeTone.warning),
                    Text(item.dataBoundaryAr),
                    Text(item.bindingDecisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Browser/Role Negative UAT Cases',
            subtitle:
                'لا يغلق الربط قبل إرسال أدلة Network/Console/Role لهذه الحالات.',
            child: PwfSisDataTable(
              columns: const ['الحالة', 'الممثل', 'السطح', 'المتوقع', 'الحالة'],
              rows: [
                for (final item in data.uatCases)
                  [
                    Text(item.caseKey),
                    Text(item.actorAr),
                    Text(item.surfaceAr),
                    Text(item.expectedAr),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.accepted
                            ? PwfSisNoticeTone.success
                            : PwfSisNoticeTone.warning),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
