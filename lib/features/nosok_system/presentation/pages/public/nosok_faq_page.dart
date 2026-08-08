import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokFaqPage extends StatelessWidget {
  const NosokFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'الأسئلة الشائعة',
          description:
              'إجابات مختصرة بلغة المواطن عن التسجيل والمتابعة والقرعة والشركات، دون مصطلحات تشغيلية داخلية.',
          badges: const ['FAQ', 'مواطن', 'مختصر'],
          icon: Icons.quiz_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.apply),
              icon: const Icon(Icons.app_registration_outlined),
              label: const Text('تقديم طلب')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.contact),
              icon: const Icon(Icons.support_agent_outlined),
              label: const Text('المساعدة')),
        ),
        const SizedBox(height: 16),
        const PwfSisFAQAccordion(
          items: [
            (
              'كيف يبدأ التسجيل؟',
              'يبدأ التسجيل بعد إعلان الموسم وفتح الخدمة من الجهة المختصة، ثم تعبئة نموذج الطلب ورفع المرفقات المطلوبة.'
            ),
            (
              'كيف أتابع حالة الطلب؟',
              'استخدم صفحة متابعة الطلب ورقم الطلب أو رمز التتبع المخصص. لا تحتاج إلى الدخول إلى شاشة الموظف.'
            ),
            (
              'كيف تظهر نتيجة القرعة؟',
              'تظهر نتيجة طلبك فقط بعد اعتماد القرعة، دون كشف بيانات المتقدمين الآخرين.'
            ),
            (
              'هل الحصة حسب المحافظة أم العنوان؟',
              'الحصة تعتمد على التجمع/LGU المرتبط بالعنوان المثبت في البطاقة الشخصية حسب سياسة الموسم.'
            ),
            (
              'ماذا أفعل إذا ظهرت نواقص؟',
              'ستظهر لك حالة مطلوب استكمال مع توجيه واضح للمرفقات أو البيانات المطلوبة.'
            ),
            (
              'هل بوابة الشركات للمواطن؟',
              'بوابة الشركات مخصصة للشركات المؤهلة، أما المواطن فيستخدم صفحة الشركات العامة للاطلاع فقط.'
            ),
          ],
        ),
        const SizedBox(height: 16),
        const PwfSisPublicHelpCard(),
      ],
    );
  }
}
