import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokLotteryObjectionsPage extends ConsumerWidget {
  const NosokLotteryObjectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    return PwfSisPublicServiceShell(
      children: [
        const PwfSisServiceHero(
          title: 'اعتراضات قرعة الحج',
          description:
              'قدّم اعتراضًا على عدم الأهلية، التجمع المعتمد، عدد الأفراد المحتسب، أو نتيجة قائمة الانتظار ضمن نافذة الاعتراض المعلنة.',
          badges: ['objections', 'citizen-safe', 'audit-ready'],
        ),
        const SizedBox(height: 12),
        const PwfSisTransactionLookupPanel(
          title: 'بدء اعتراض على نتيجة أو أهلية',
          subtitle:
              'أدخل بيانات طلبك أولًا، ثم اختر سبب الاعتراض والمرفقات المطلوبة ضمن نافذة الاعتراض المعلنة.',
          primaryLabel: 'بدء الاعتراض',
          icon: Icons.rate_review_outlined,
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'أسباب الاعتراض المقبولة',
          subtitle:
              'الاعتراض لا يغير النتيجة تلقائيًا. أي قبول يحتاج مراجعة وتوثيق.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 270,
            children: [
              for (final reason in state.objectionReasons)
                PwfSisServiceCard(
                  icon: reason.requiresAttachment
                      ? Icons.attach_file_outlined
                      : Icons.rate_review_outlined,
                  title: reason.titleAr,
                  description:
                      '${reason.descriptionAr} ${reason.requiresAttachment ? 'يتطلب مرفقًا داعمًا.' : 'لا يتطلب مرفقًا إلزاميًا.'}',
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const PwfSisPanel(
          title: 'رحلة الاعتراض',
          subtitle: 'تُبنى كنموذج wizard في الإنتاج مع تحقق الهوية والمرفقات.',
          child: PwfSisTimeline(
            items: [
              'إدخال رقم الطلب ورقم الهوية/التحقق.',
              'اختيار سبب الاعتراض.',
              'إرفاق ما يلزم عند الحاجة.',
              'إرسال الاعتراض ضمن النافذة الزمنية.',
              'مراجعة الموظف/اللجنة.',
              'إبلاغ المواطن بالقرار دون كشف سجلات داخلية.',
            ],
          ),
        ),
        const SizedBox(height: 12),
        const PwfSisNotice(
          title: 'حالة التنفيذ',
          message:
              'تقديم الاعتراض يكون ضمن النافذة المعلنة وبحسب القنوات الرسمية المعتمدة، مع متابعة الحالة عبر رقم الطلب أو رمز التتبع.',
          tone: PwfSisNoticeTone.warning,
        ),
      ],
    );
  }
}
