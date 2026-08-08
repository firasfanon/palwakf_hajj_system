import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokComplaintsPage extends StatelessWidget {
  const NosokComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'الشكاوى والملاحظات',
          description:
              'قدّم ملاحظة أو شكوى مرتبطة بخدمات الحج والعمرة دون إرسال بيانات حساسة عبر قنوات عامة.',
          badges: const ['قناة عامة', 'خصوصية', 'متابعة منفصلة'],
          icon: Icons.report_problem_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.track),
              icon: const Icon(Icons.manage_search_outlined),
              label: const Text('متابعة طلب')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.contact),
              icon: const Icon(Icons.support_agent_outlined),
              label: const Text('التواصل والدعم')),
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'أنواع الشكاوى',
          subtitle: 'تصنيف مبسط يساعد المواطن على اختيار القناة المناسبة.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 250,
            children: [
              PwfSisServiceCard(
                  icon: Icons.assignment_outlined,
                  title: 'شكوى مرتبطة بطلب',
                  description:
                      'يمكن ربطها برقم الطلب عند اعتماد قناة الشكاوى الرسمية.'),
              PwfSisServiceCard(
                  icon: Icons.business_outlined,
                  title: 'شكوى على شركة',
                  description: 'تُراجع ضمن سياسات الشركات المؤهلة والحملات.'),
              PwfSisServiceCard(
                  icon: Icons.support_agent_outlined,
                  title: 'ملاحظة عامة',
                  description:
                      'ملاحظات حول الخدمة أو التعليمات أو تجربة الاستخدام.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisNotice(
          title: 'تنبيه خصوصية',
          message:
              'لا ترسل رقم الهوية أو مرفقات حساسة في نص الشكوى العامة. استخدم متابعة الطلب أو القنوات الرسمية عند الحاجة.',
          tone: PwfSisNoticeTone.warning,
        ),
      ],
    );
  }
}
