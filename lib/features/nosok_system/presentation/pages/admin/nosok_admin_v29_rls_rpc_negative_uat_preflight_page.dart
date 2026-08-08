import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v29_authorization_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV29RlsRpcNegativeUatPreflightPage extends ConsumerWidget {
  const NosokAdminV29RlsRpcNegativeUatPreflightPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV29AuthorizationPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل preflight',
          message: 'تعذر تحميل RLS/RPC/Negative UAT preflight.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v29 — RLS/RPC/Negative UAT Preflight',
            description:
                'مصفوفة ما يجب إثباته بعد تطبيق staging: RLS، surfaces العامة، واختبارات المنع للأدوار والنطاقات. لا تفتح الإنتاج.',
            badges: ['rls', 'rpc', 'negative uat', 'preflight'],
            actions: [],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قاعدة preflight',
            message:
                'لا يعتبر إنشاء nosok.* كافيًا للإنتاج. يجب إثبات anonymous/wrong-unit/no-role/public-table-scan/waqf-boundary قبل أي candidate decision.',
            tone: PwfSisNoticeTone.info,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RLS/RPC Preflight Rows',
            child: PwfSisDataTable(
              columns: const [
                'السطح/الجدول',
                'النوع',
                'قاعدة التحقق',
                'الحالة'
              ],
              rows: [
                for (final row in data.preflightRows)
                  [
                    Text(row.surfaceOrTable),
                    Text(row.kind),
                    Text(row.preflightRuleAr),
                    PwfSisStatusBadge(
                        label: row.status,
                        tone: row.status.startsWith('deferred')
                            ? PwfSisNoticeTone.warning
                            : PwfSisNoticeTone.info),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Negative UAT Required Cases',
            child: PwfSisDataTable(
              columns: const ['المعرف', 'الفاعل', 'الهدف', 'المتوقع', 'الحالة'],
              rows: [
                for (final testCase in data.negativeUatCases)
                  [
                    Text(testCase.caseKey),
                    Text(testCase.actor),
                    Text(testCase.target),
                    Text(testCase.expectedResultAr),
                    PwfSisStatusBadge(
                        label: testCase.status, tone: PwfSisNoticeTone.warning),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
