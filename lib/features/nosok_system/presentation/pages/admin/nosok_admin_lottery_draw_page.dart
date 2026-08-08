import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../../application/nosok_legal_lottery_regulation_controller.dart';
import '../../../domain/models/nosok_lottery_policy.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLotteryDrawPage extends ConsumerWidget {
  const NosokAdminLotteryDrawPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    final legal = ref.watch(nosokLegalLotteryRegulationContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'تنفيذ القرعة — خوارزمية قانونية + حصة LGU',
            description:
                'بعد v38E لم يعد عقد القرعة capacity-aware فقط. يجب أن يتبع ${legal.regulationTitleAr} وفروع الخوارزمية القانونية، بما في ذلك حالات الاختيار الأول، وحصة الطلب الواحد، وحالة تبقي مقعدين واختيار طلب بثلاثة أسماء.',
            badges: const [
              'draw',
              'legal-algorithm',
              'LGU-quota',
              'not-production'
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisPanel(
            title: 'تسلسل التنفيذ الحاكم',
            subtitle: 'لا يجوز تجاوز أي مرحلة دون evidence.',
            child: PwfSisTimeline(
              items: [
                'إغلاق التسجيل وتثبيت نافذة الموسم.',
                'تثبيت سياسة الموسم: الشروط، السكان، الحصة، الاستثناءات.',
                'ربط كل طلب بـ LGU حسب عنوان البطاقة الشخصية.',
                'فحص الأهلية والوثائق والتكرار والحج السابق.',
                'تجميد pool لكل تجمع بشكل منفصل.',
                'تشغيل قرعة وفق خوارزمية النظام القانوني النشط لا وفق الحصة فقط.',
                'تسجيل فروع الخوارزمية: الاختيار الأول، حصة الطلب الواحد، تبقي مقعدين، وفرز طلبات الأشخاص.',
                'رفع الحالات التي تحتاج استثناء أو تفسير إلى لجنة الحج دون تحويل تلقائي.',
                'نشر النتائج العامة بلغة المواطن مع حماية الخصوصية.',
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'نتيجة اختيار تجريبية — staging',
            subtitle:
                'توضح الفرق بين الفائز، قائمة الانتظار، الاستبعاد، وتجاوز السعة.',
            child: PwfSisDataTable(
              columns: const ['الطلب', 'التجمع', 'الأفراد', 'القرار', 'السبب'],
              rows: [
                for (final item in state.selectionResults)
                  [
                    Text(item.applicationNo),
                    Text(item.lguNameAr),
                    Text('${item.totalPeopleCount}'),
                    PwfSisStatusBadge(
                      label: item.decision.labelAr,
                      tone: item.decision ==
                              NosokLotteryCandidateDecision.selected
                          ? PwfSisNoticeTone.success
                          : PwfSisNoticeTone.warning,
                    ),
                    Text(item.reasonAr),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'منع التشغيل المزدوج',
            message:
                'تشغيل draw مرتين لنفس الموسم أو التجمع يجب أن يكون ممنوعًا إلا عبر قرار حوكمة صريح وAudit منفصل.',
            tone: PwfSisNoticeTone.error,
          ),
        ],
      ),
    );
  }
}
