import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../../domain/models/nosok_lottery_policy.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLotteryAuditPage extends ConsumerWidget {
  const NosokAdminLotteryAuditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'أدلة تدقيق قرعة الحج',
            description:
                'تجميع أدلة السياسة، LGU snapshot، تشغيل القرعة، الحصة غير المستكملة، وقرارات اللجنة قبل أي اعتماد إنتاجي.',
            badges: ['audit', 'evidence', 'immutable-required'],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Draw Evidence Snapshot',
            subtitle: 'مؤشرات staging فقط — ليست تنفيذًا إنتاجيًا.',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PwfSisRuntimeState(
                    label: 'run', value: state.evidence.runId, ok: true),
                PwfSisRuntimeState(
                    label: 'status', value: state.evidence.status, ok: false),
                PwfSisRuntimeState(
                    label: 'operator',
                    value: state.evidence.operatorScope,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'started',
                    value: state.evidence.startedAtLabel,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'algorithm',
                    value: state.evidence.algorithmVersion,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'audit mode',
                    value: state.evidence.auditModeAr,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'LGUs',
                    value: '${state.evidence.totalLgus}',
                    ok: true),
                PwfSisRuntimeState(
                    label: 'committee required',
                    value: '${state.evidence.committeeRequiredLgus}',
                    ok: state.evidence.committeeRequiredLgus == 0),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'سجل قرارات staging',
            subtitle:
                'يجب أن يتحول إنتاجيًا إلى append-only audit table/RPC بدون حذف أو تعديل صامت.',
            child: PwfSisDataTable(
              columns: const ['الطلب', 'التجمع', 'القرار', 'الأثر'],
              rows: [
                for (final item in state.selectionResults)
                  [
                    Text(item.applicationNo),
                    Text(item.lguNameAr),
                    Text(item.decision.labelAr),
                    Text(item.reasonAr),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قاعدة عدم الحذف',
            message:
                'سجل القرعة وقرارات اللجنة يجب أن يكون غير قابل للحذف إنتاجيًا، وأي تصحيح يجب أن يتم بإدخال تدقيقي جديد لا بتعديل صامت.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
