import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_legal_lottery_regulation_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokLegalRegulationPage extends ConsumerWidget {
  const NosokLegalRegulationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokLegalLotteryRegulationContractProvider);
    return PwfSisPublicServiceShell(
      children: [
        PwfSisServiceHero(
          title: 'القانون المنظم للحج',
          description:
              'ملخص مبسط للمواطن حول أثر ${contract.regulationTitleAr} على التسجيل والقرعة. هذه الصفحة لا تعرض تفاصيل تقنية ولا تغني عن الرجوع للنص الرسمي المنشور.',
          badges: const ['مرجع قانوني', 'شفافية', 'قرعة إلكترونية'],
          primaryAction: const PwfSisStatusBadge(
              label: 'ساري حسب المصدر المنشور',
              icon: Icons.verified_outlined,
              tone: PwfSisNoticeTone.success),
        ),
        const SizedBox(height: 12),
        PwfSisNotice(
          title: 'ماذا يعني هذا للمواطن؟',
          message:
              'التسجيل والقرعة في نسك يجب أن يتبعا سياسة الموسم والنظام القانوني المعتمد. تظهر لك الواجهة الخطوات المسموحة فقط، أما القرار النهائي فيعتمد على التحقق الرسمي والقرعة الإلكترونية وسجلات التدقيق.',
          tone: PwfSisNoticeTone.info,
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'أثر القانون على التسجيل',
          subtitle: 'صياغة مبسطة للمواطن، دون تفاصيل backend أو قواعد داخلية.',
          child: PwfSisDataTable(
            columns: const ['القاعدة', 'ماذا يعني ذلك؟'],
            rows: [
              for (final rule in contract.registrationRules)
                [Text(rule.titleAr), Text(rule.uiImpactAr)],
            ],
          ),
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'أثر القانون على القرعة',
          subtitle:
              'القرعة ليست إعلانًا عشوائيًا فقط؛ يجب أن تتبع خوارزمية قانونية وسياسة موسم معلنة.',
          child: PwfSisDataTable(
            columns: const ['البند', 'المعنى المبسط'],
            rows: [
              for (final rule in contract.algorithmRules)
                [Text(rule.titleAr), Text(rule.ruleAr)],
            ],
          ),
        ),
        const SizedBox(height: 12),
        const PwfSisNotice(
          title: 'تنبيه مهم',
          message:
              'هذه الصفحة تلخص أثر النظام على تجربة نسك فقط. النص الرسمي المنشور هو المرجع القانوني، وقد تصدر تعليمات موسمية إضافية من الوزارة أو لجنة الحج والعمرة.',
          tone: PwfSisNoticeTone.warning,
        ),
      ],
    );
  }
}
