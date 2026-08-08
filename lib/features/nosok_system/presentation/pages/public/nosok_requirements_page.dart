import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokRequirementsPage extends StatelessWidget {
  const NosokRequirementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'شروط ومتطلبات الحج والعمرة',
          description:
              'مرجع مختصر للمواطن قبل بدء الطلب. تظهر الشروط النهائية حسب إعلان الوزارة وسياسة كل موسم.',
          badges: const ['شروط واضحة', 'مرفقات', 'موسمية'],
          icon: Icons.fact_check_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.apply),
              icon: const Icon(Icons.app_registration_outlined),
              label: const Text('تقديم طلب')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.faq),
              icon: const Icon(Icons.quiz_outlined),
              label: const Text('الأسئلة الشائعة')),
        ),
        const SizedBox(height: 16),
        const PwfSisRequirementsPanel(
          items: [
            'هوية سارية',
            'جواز سفر ساري',
            'صورة شخصية',
            'رقم هاتف قابل للتحقق',
            'عنوان حسب البطاقة الشخصية',
            'مرفقات إضافية حسب نوع الخدمة',
          ],
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'قواعد مهمة قبل التقديم',
          subtitle:
              'هذه القواعد تظهر بلغة المواطن وتبقى قابلة للتحديث حسب سياسة الوزارة.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 250,
            children: [
              PwfSisServiceCard(
                  icon: Icons.looks_one_outlined,
                  title: 'طلب واحد',
                  description:
                      'يجب تجنب التسجيل المكرر، وقد يخضع الطلب المكرر للاستبعاد حسب السياسة.'),
              PwfSisServiceCard(
                  icon: Icons.cake_outlined,
                  title: 'العمر',
                  description:
                      'حد العمر وشروط الأهلية تُحدد لكل موسم عند إعلان الوزارة.'),
              PwfSisServiceCard(
                  icon: Icons.home_outlined,
                  title: 'العنوان',
                  description:
                      'يعتمد التجمع السكاني على العنوان المثبت في البطاقة الشخصية.'),
              PwfSisServiceCard(
                  icon: Icons.groups_outlined,
                  title: 'المرافقون',
                  description:
                      'عدد المرافقين وضوابط المحرم قابلة للتعديل حسب الموسم.'),
              PwfSisServiceCard(
                  icon: Icons.payments_outlined,
                  title: 'الدفع',
                  description:
                      'أي رسوم أو كود دفع يظهر فقط عند اعتماد الربط الرسمي مع نظام الفوترة.'),
              PwfSisServiceCard(
                  icon: Icons.health_and_safety_outlined,
                  title: 'الإرشادات الصحية',
                  description:
                      'تظهر التعليمات الصحية النهائية ضمن إعلان الموسم والتعليمات الرسمية.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisPublicHelpCard(),
      ],
    );
  }
}
