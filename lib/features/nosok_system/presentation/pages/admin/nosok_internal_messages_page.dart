import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokInternalMessagesPage extends StatelessWidget {
  const NosokInternalMessagesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PwfSisSystemHero(
              title: 'المراسلات والمتابعة',
              description:
                  'صندوق وارد/صادر مرتبط بالطلبات وقوالب الاستكمال دون كشف ملاحظات داخلية للمواطن.',
              badges: ['messages', 'follow-up', 'templates']),
          SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(children: [
            PwfSisMetricCard(
                label: 'وارد جديد', value: '11', icon: Icons.inbox_outlined),
            PwfSisMetricCard(
                label: 'بانتظار رد',
                value: '6',
                icon: Icons.pending_actions_outlined),
            PwfSisMetricCard(
                label: 'قوالب نشطة',
                value: '4',
                icon: Icons.text_snippet_outlined),
          ]),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'Message Thread Preview',
            child: PwfSisMessageThread(messages: [
              'تم استلام طلب الاستكمال.',
              'يرجى إرفاق صورة أوضح لجواز السفر.',
              'تم تحويل الطلب للمراجعة بعد الاستكمال.'
            ]),
          ),
        ],
      ),
    );
  }
}
