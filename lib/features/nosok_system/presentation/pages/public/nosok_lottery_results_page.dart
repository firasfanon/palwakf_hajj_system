import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokLotteryResultsPage extends ConsumerWidget {
  const NosokLotteryResultsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    return PwfSisPublicServiceShell(
      children: [
        PwfSisServiceHero(
          title: 'نتائج قرعة الحج حسب التجمع المعتمد',
          description:
              'اعرض نتيجة طلبك فقط بعد التحقق من الرقم المرجعي ورقم الهوية. تعتمد القرعة على العنوان المثبت في البطاقة الشخصية وربطه بالتجمع/LGU وحصة الموسم.',
          badges: const ['قرعة الحج', 'LGU quota', 'خصوصية المواطن'],
          primaryAction: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.search),
              label: const Text('استعلام عن النتيجة')),
        ),
        const SizedBox(height: 12),
        const PwfSisTransactionLookupPanel(
          title: 'استعلام آمن عن نتيجة الطلب',
          subtitle:
              'أدخل رقم الطلب ورقم الهوية/رمز التحقق لعرض نتيجتك فقط دون كشف بيانات الآخرين.',
          primaryLabel: 'عرض النتيجة',
          icon: Icons.emoji_events_outlined,
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'ما الذي يظهر للمواطن؟',
          subtitle: 'لا تظهر بيانات الآخرين أو سجلات التدقيق الداخلية.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 230,
            children: const [
              PwfSisServiceCard(
                  icon: Icons.location_city_outlined,
                  title: 'التجمع المعتمد',
                  description:
                      'يظهر التجمع المستخرج من عنوان البطاقة الشخصية وليس اختيارًا حرًا من المستخدم.'),
              PwfSisServiceCard(
                  icon: Icons.confirmation_number_outlined,
                  title: 'حصة التجمع',
                  description:
                      'تظهر الحصة النهائية للموسم بعد تثبيت سياسة الوزارة وقرار لجنة الحج عند الحاجة.'),
              PwfSisServiceCard(
                  icon: Icons.verified_outlined,
                  title: 'نتيجة الطلب',
                  description:
                      'مختار، قائمة انتظار، غير مؤهل، أو قيد الاعتراض بلغة واضحة للمواطن.'),
              PwfSisServiceCard(
                  icon: Icons.privacy_tip_outlined,
                  title: 'حماية الخصوصية',
                  description:
                      'لا تظهر أسماء الفائزين الآخرين أو تفاصيل القرعة الداخلية.'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'أمثلة توضيحية لشكل النتيجة',
          subtitle:
              'هذه أمثلة واجهة فقط؛ الإنتاج يجب أن يرجع نتيجة الطلب بعد تحقق الهوية/الرمز.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 270,
            children: [
              for (final item in state.citizenResults)
                PwfSisServiceCard(
                  icon: Icons.how_to_vote_outlined,
                  title: '${item.trackingCode} — ${item.resultLabelAr}',
                  description:
                      '${item.lguNameAr}، ${item.peopleCount} أفراد. ${item.publicMessageAr} ${item.nextStepAr}',
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'سياسة الموسم المنشورة للمواطن',
          subtitle: state.policy.notesAr,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              PwfSisRuntimeState(
                  label: 'الحد الأدنى للعمر',
                  value: '${state.policy.minAge}+',
                  ok: true),
              PwfSisRuntimeState(
                  label: 'المرافقون',
                  value: 'حتى ${state.policy.maxCompanions}',
                  ok: true),
              PwfSisRuntimeState(
                  label: 'معامل الحصة',
                  value: '1 / ${state.policy.quotaDivisor}',
                  ok: true),
              PwfSisRuntimeState(
                  label: 'نقل الحصة', value: 'قرار لجنة فقط', ok: false),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const PwfSisNotice(
          title: 'تنبيه حاكم',
          message:
              'تظهر نتيجة الطلب بعد اعتماد القرعة رسميًا. لا تُعرض بيانات المتقدمين الآخرين أو تفاصيل التشغيل الداخلي في الصفحة العامة.',
          tone: PwfSisNoticeTone.warning,
        ),
      ],
    );
  }
}
