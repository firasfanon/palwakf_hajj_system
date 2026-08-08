import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLotteryEligibilityPage extends ConsumerWidget {
  const NosokAdminLotteryEligibilityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'فحص أهلية قرعة الحج',
            description:
                'الأهلية قابلة للتعديل حسب سياسة الوزارة، لكن يجب توثيق snapshot قبل إدخال الطلب إلى قرعة التجمع.',
            badges: ['eligibility', 'policy-configurable', 'no-hardcode'],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصادر السياسة والأهلية',
            subtitle:
                'هذه القواعد لا تكون hardcoded في الإنتاج؛ يتم تجميدها حسب الموسم.',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PwfSisRuntimeState(
                    label: 'مصدر العنوان',
                    value: state.policy.lguAddressSourceAr,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'مصدر السكان',
                    value: state.policy.populationSourceAr,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'مصدر الحصة',
                    value: state.policy.quotaSourceAr,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'الدفع قبل القرعة',
                    value: state.policy.paymentRequiredBeforeDraw
                        ? 'مطلوب'
                        : 'غير مطلوب',
                    ok: state.policy.paymentRequiredBeforeDraw),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'القواعد القابلة للتعديل',
            subtitle: 'تُدار من سياسة الموسم لا من كود ثابت.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 240,
              children: const [
                PwfSisServiceCard(
                    icon: Icons.badge_outlined,
                    title: 'العنوان/LGU',
                    description:
                        'ربط إلزامي بالعنوان المعتمد في البطاقة الشخصية.'),
                PwfSisServiceCard(
                    icon: Icons.elderly_outlined,
                    title: 'العمر',
                    description: 'الحد الأدنى قابل للتعديل حسب الموسم.'),
                PwfSisServiceCard(
                    icon: Icons.family_restroom_outlined,
                    title: 'المرافقون والمحرم',
                    description: 'عدد المرافقين وشرط المحرم configurable.'),
                PwfSisServiceCard(
                    icon: Icons.payments_outlined,
                    title: 'الدفع',
                    description:
                        'اشتراط الدفع قبل القرعة قابل للتفعيل أو التعطيل.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'عينات مرشحين — staging',
            subtitle:
                'توضح الفرق بين طلب مناسب لاستكمال السعة وطلب يتجاوز السعة المتبقية.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                for (final candidate in state.candidates)
                  PwfSisServiceCard(
                    icon: candidate.eligible
                        ? Icons.check_circle_outline
                        : Icons.cancel_outlined,
                    title:
                        '${candidate.applicationNo} — ${candidate.totalPeopleCount} أفراد',
                    description:
                        '${candidate.lguNameAr}: ${candidate.reasonsAr.join('، ')}',
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
