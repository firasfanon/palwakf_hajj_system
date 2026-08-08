import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokHajjPage extends StatelessWidget {
  const NosokHajjPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'التسجيل للحج',
          description:
              'تعرف على شروط الحج، ثم ابدأ الطلب عند فتح باب التسجيل رسميًا من الوزارة.',
          badges: const ['خدمة موسمية', 'عنوان حسب الهوية', 'قرعة حسب الحصة'],
          icon: Icons.travel_explore_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.apply),
              icon: const Icon(Icons.app_registration_outlined),
              label: const Text('بدء طلب حج')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.track),
              icon: const Icon(Icons.manage_search_outlined),
              label: const Text('متابعة طلب')),
        ),
        const SizedBox(height: 16),
        const PwfSisNotice(
          title: 'حالة التسجيل',
          message:
              'يظهر فتح أو إغلاق التسجيل حسب إعلان الوزارة وسياسة الموسم. لا تُعد هذه الصفحة قرارًا منفصلًا عن بيانات الموسم المعتمدة.',
          tone: PwfSisNoticeTone.info,
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'أهم شروط الحج للمواطن',
          subtitle:
              'صياغة مبسطة قابلة للتحديث حسب سياسة وزارة الأوقاف لكل موسم.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 250,
            children: [
              PwfSisServiceCard(
                  icon: Icons.manage_search_outlined,
                  title: 'لمَن تنطبق عليهم الشروط',
                  description:
                      'الدخول الفعلي للقرعة يكون للطلبات المستوفية للشروط بعد التحقق.'),
              PwfSisServiceCard(
                  icon: Icons.badge_outlined,
                  title: 'العنوان المعتمد',
                  description:
                      'يعتمد النظام على العنوان المثبت في البطاقة الشخصية لربط الطلب بالتجمع/LGU.'),
              PwfSisServiceCard(
                  icon: Icons.groups_outlined,
                  title: 'المرافقون والمحرم',
                  description:
                      'عدد المرافقين وضوابط المحرم تُدار كقواعد موسم قابلة للتعديل.'),
              PwfSisServiceCard(
                  icon: Icons.payments_outlined,
                  title: 'رسوم التسجيل',
                  description:
                      'أي رسوم أو كود دفع يتم ربطه لاحقًا بنظام الفوترة بعد الدمج الرسمي.'),
              PwfSisServiceCard(
                  icon: Icons.emoji_events_outlined,
                  title: 'القرعة',
                  description:
                      'تتم القرعة حسب حصة كل تجمع، وبما لا يتجاوز عدد الأشخاص المخصص للحصة.'),
              PwfSisServiceCard(
                  icon: Icons.gavel_outlined,
                  title: 'قرار اللجنة',
                  description:
                      'الحصص غير المستكملة لا تنتقل تلقائيًا؛ تحتاج قرارًا موثقًا من لجنة الحج.'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisPublicWorkflowStepper(
          steps: [
            'راجع إعلان الموسم',
            'تأكد من الشروط',
            'أدخل بياناتك',
            'أضف المرافقين',
            'أرفق الوثائق',
            'أرسل الطلب',
            'تابع النتيجة',
          ],
        ),
      ],
    );
  }
}
