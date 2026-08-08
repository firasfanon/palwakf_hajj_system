import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../../domain/models/nosok_lottery_policy.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLotteryCommitteePage extends ConsumerWidget {
  const NosokAdminLotteryCommitteePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'قرارات لجنة الحج للحصص غير المستكملة',
            description:
                'أي مقعد لا يمكن استكماله من نفس التجمع بسبب سعة الأشخاص أو عدم وجود طلب مؤهل ينتقل إلى قرار لجنة الحج مع سبب وأثر تدقيقي.',
            badges: ['committee', 'no-auto-transfer', 'audit-required'],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'ملفات تتطلب قرار لجنة',
            subtitle:
                'هذه ملفات staging توضح شكل الملف الذي يجب أن يُرفع للجنة الحج عند تعذر استكمال الحصة من نفس LGU.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 300,
              children: [
                for (final decision in state.committeeDecisions)
                  PwfSisServiceCard(
                    icon: Icons.gavel_outlined,
                    title:
                        '${decision.lguNameAr} — متبقٍ ${decision.remainingCapacity}',
                    description:
                        '${decision.reasonAr} ${decision.auditRequirementAr}',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'خيارات القرار الموثق',
            subtitle:
                'لا ينفذ أي خيار تلقائيًا في الواجهة. هذه قائمة خيارات حاكمة لقرار رسمي.',
            child: PwfSisTimeline(
              items: state.committeeDecisions.isEmpty
                  ? const ['لا توجد حصص غير مستكملة في هذا snapshot.']
                  : state.committeeDecisions.first.allowedDecisionTypes
                      .map((item) => item.labelAr)
                      .toList(growable: false),
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قيد حاكم',
            message:
                'لا يجوز نقل حصة من LGU إلى LGU آخر عبر منطق برمجي صامت. القرار يجب أن يكون Committee Decision + Audit Evidence + Reason.',
            tone: PwfSisNoticeTone.error,
          ),
        ],
      ),
    );
  }
}
