import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../../domain/models/nosok_lottery_policy.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokWaitingListPage extends ConsumerWidget {
  const NosokWaitingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    return PwfSisPublicServiceShell(
      children: [
        const PwfSisServiceHero(
          title: 'قائمة انتظار الحج حسب التجمع',
          description:
              'قائمة الانتظار تُدار لكل تجمع/LGU بصورة منفصلة. لا يتم نقل مقعد من تجمع إلى آخر تلقائيًا عند تعذر استكمال الحصة.',
          badges: ['waiting-list', 'per-LGU', 'committee-governed'],
        ),
        const SizedBox(height: 12),
        const PwfSisTransactionLookupPanel(
          title: 'تحقق من ترتيبك في الانتظار',
          subtitle:
              'تعرض الصفحة ترتيب طلبك داخل تجمعك المعتمد فقط، ولا تعرض قوائم المتقدمين الآخرين.',
          primaryLabel: 'عرض ترتيب الانتظار',
          icon: Icons.hourglass_bottom_outlined,
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'مؤشرات السعة المتبقية',
          subtitle:
              'إذا تعذر العثور على طلب مناسب داخل نفس التجمع لاستكمال السعة، ينتقل الملف إلى لجنة الحج.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 250,
            children: [
              for (final item in state.lguQuotas)
                PwfSisServiceCard(
                  icon: item.status ==
                          NosokLguQuotaStatus.committeeDecisionRequired
                      ? Icons.gavel_outlined
                      : Icons.check_circle_outline,
                  title: item.lguNameAr,
                  description:
                      'الحصة: ${item.finalCapacity}، المختارون أفرادًا: ${item.selectedPeople}، المتبقي: ${item.remainingCapacity}. الحالة: ${item.status.labelAr}.',
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const PwfSisNotice(
          title: 'لا تحويل تلقائي للحصص',
          message:
              'أي إعادة توزيع أو إبقاء مقعد شاغر أو ترحيل استثنائي يجب أن يصدر بقرار موثق من لجنة الحج مع سبب وأثر تدقيقي.',
          tone: PwfSisNoticeTone.info,
        ),
      ],
    );
  }
}
