import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokUmrahPage extends StatelessWidget {
  const NosokUmrahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'خدمات العمرة',
          description:
              'استعرض برامج العمرة والتعليمات والشركات المؤهلة، ثم قدّم طلبك عند توفر البرامج المعتمدة.',
          badges: const ['برامج موسمية', 'شركات مؤهلة', 'متابعة آمنة'],
          icon: Icons.travel_explore_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.apply),
              icon: const Icon(Icons.app_registration_outlined),
              label: const Text('تقديم طلب عمرة')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.companies),
              icon: const Icon(Icons.business_center_outlined),
              label: const Text('الشركات المؤهلة')),
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'ماذا توفر صفحة العمرة؟',
          subtitle:
              'عرض خفيف وموجه للمواطن، مع تأجيل التفاصيل التشغيلية إلى لوحة الموظفين.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 250,
            children: [
              PwfSisServiceCard(
                  icon: Icons.event_available_outlined,
                  title: 'البرامج المتاحة',
                  description:
                      'تظهر البرامج عند اعتمادها للموسم من الجهة المختصة.'),
              PwfSisServiceCard(
                  icon: Icons.fact_check_outlined,
                  title: 'المتطلبات',
                  description:
                      'وثائق السفر والصور والبيانات المطلوبة حسب كل برنامج.'),
              PwfSisServiceCard(
                  icon: Icons.business_center_outlined,
                  title: 'الشركات',
                  description:
                      'عرض الشركات المؤهلة دون تحويل الصفحة إلى سجل إداري.'),
              PwfSisServiceCard(
                  icon: Icons.notifications_active_outlined,
                  title: 'التنبيهات',
                  description:
                      'تعليمات مختصرة للمواطن عند فتح الخدمة أو تحديث الشروط.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisPublicWorkflowStepper(
          steps: [
            'اختر برنامج العمرة',
            'راجع المتطلبات',
            'قدّم الطلب',
            'أرفق الوثائق',
            'تابع الحالة',
            'استكمل النواقص'
          ],
        ),
      ],
    );
  }
}
