import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokCitizenJourneyPage extends StatelessWidget {
  const NosokCitizenJourneyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'رحلة المواطن في نسك',
          description:
              'خطوات واضحة من اختيار الخدمة حتى متابعة النتيجة، دون تحويل الصفحة إلى لوحة تشغيل داخلية.',
          badges: const ['رحلة خدمة', 'خطوات مبسطة', 'Mobile-first'],
          icon: Icons.route_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.apply),
              icon: const Icon(Icons.start_outlined),
              label: const Text('ابدأ الآن')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.track),
              icon: const Icon(Icons.manage_search_outlined),
              label: const Text('متابعة طلب')),
        ),
        const SizedBox(height: 16),
        const PwfSisPublicWorkflowStepper(
          steps: [
            'اختر الخدمة',
            'أدخل البيانات',
            'أرفق الوثائق',
            'أرسل الطلب',
            'تابع الحالة',
            'استكمل النواقص',
            'تابع النتيجة'
          ],
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'قنوات الخدمة',
          subtitle: 'فصل واضح بين المواطن والشركة والموظف.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 240,
            children: [
              PwfSisServiceCard(
                  icon: Icons.person_outline,
                  title: 'المواطن',
                  description:
                      'تقديم الطلب، متابعة الحالة، استكمال النواقص، ومعرفة النتيجة.'),
              PwfSisServiceCard(
                  icon: Icons.business_outlined,
                  title: 'الشركات',
                  description:
                      'استعراض الشركات المؤهلة وبوابة شريك محكومة بالصلاحيات.'),
              PwfSisServiceCard(
                  icon: Icons.support_agent_outlined,
                  title: 'المساعدة',
                  description:
                      'أسئلة شائعة وتواصل وشكاوى دون كشف بيانات داخلية.'),
              PwfSisServiceCard(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'الموظفون',
                  description:
                      'لوحة تشغيل منفصلة لا تظهر للمواطن إلا كمدخل محمي بالصلاحيات.'),
            ],
          ),
        ),
      ],
    );
  }
}
