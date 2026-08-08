import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../../domain/models/nosok_lottery_policy.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLotteryWaitingListPage extends ConsumerWidget {
  const NosokAdminLotteryWaitingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    final waitingItems = state.selectionResults
        .where((item) =>
            item.decision == NosokLotteryCandidateDecision.waitingList ||
            item.decision == NosokLotteryCandidateDecision.capacityOverflow)
        .toList(growable: false);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'قوائم الانتظار حسب التجمع',
            description:
                'قائمة الانتظار منفصلة لكل LGU. الترقية لا تتم إلا ضمن نفس التجمع وبما لا يتجاوز السعة المتبقية.',
            badges: ['waiting-list', 'per-LGU', 'capacity-gap'],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'حالات السعة',
            subtitle:
                'عند نقص الحصة، يبحث النظام عن طلب مناسب داخل نفس التجمع. إذا تعذر ذلك تُطلب لجنة الحج.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                for (final quota in state.lguQuotas)
                  PwfSisServiceCard(
                    icon: quota.status ==
                            NosokLguQuotaStatus.committeeDecisionRequired
                        ? Icons.gavel_outlined
                        : Icons.playlist_add_check_outlined,
                    title: quota.lguNameAr,
                    description:
                        'المتبقي: ${quota.remainingCapacity}. الحالة: ${quota.status.labelAr}. لا تحويل تلقائي إلى تجمع آخر.',
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'طلبات الانتظار/السعة',
            subtitle:
                'تُستخدم لترقية نفس التجمع فقط، أو لتجهيز ملف لجنة الحج عند عدم وجود طلب يلائم السعة.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 270,
              children: [
                for (final item in waitingItems)
                  PwfSisServiceCard(
                    icon: item.decision ==
                            NosokLotteryCandidateDecision.waitingList
                        ? Icons.format_list_numbered_outlined
                        : Icons.warning_amber_outlined,
                    title: '${item.applicationNo} — ${item.lguNameAr}',
                    description:
                        '${item.totalPeopleCount} أفراد. ${item.decision.labelAr}. ${item.reasonAr}',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
