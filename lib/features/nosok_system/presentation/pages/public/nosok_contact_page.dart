import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokContactPage extends StatelessWidget {
  const NosokContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'المساعدة والتواصل',
          description:
              'اختر قناة الدعم المناسبة: متابعة طلب، شكوى، أسئلة شائعة، أو تواصل عام مع فريق الخدمة.',
          badges: const ['دعم عام', 'أسئلة شائعة', 'شكاوى'],
          icon: Icons.support_agent_outlined,
          primaryAction: FilledButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.track),
              icon: const Icon(Icons.manage_search_outlined),
              label: const Text('متابعة طلب')),
          secondaryAction: OutlinedButton.icon(
              onPressed: () => context.go(NosokSystemRoutes.complaints),
              icon: const Icon(Icons.report_problem_outlined),
              label: const Text('تقديم شكوى')),
        ),
        const SizedBox(height: 16),
        const PwfSisPanel(
          title: 'معلومات التواصل الرسمية',
          subtitle: 'بيانات مرجعية قابلة للتحديث عند الدمج مع منصة PalWakf.',
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              PwfSisStatusBadge(
                  label: 'رام الله',
                  icon: Icons.location_on_outlined,
                  tone: PwfSisNoticeTone.info),
              PwfSisStatusBadge(
                  label: '22411939',
                  icon: Icons.phone_outlined,
                  tone: PwfSisNoticeTone.info),
              PwfSisStatusBadge(
                  label: 'Haj@pal-wakf.ps',
                  icon: Icons.email_outlined,
                  tone: PwfSisNoticeTone.info),
              PwfSisStatusBadge(
                  label: 'www.pal-wakf.ps',
                  icon: Icons.public_outlined,
                  tone: PwfSisNoticeTone.info),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PwfSisPanel(
          title: 'كيف نساعدك؟',
          subtitle: 'اختصرنا قنوات المساعدة حتى تصل للمسار الصحيح بسرعة.',
          child: PwfSisAdaptiveWorkspace(
            minTileWidth: 240,
            children: [
              PwfSisServiceCard(
                  icon: Icons.track_changes_outlined,
                  title: 'متابعة طلب',
                  description:
                      'عرض الحالة العامة والنواقص دون كشف سجلات داخلية.',
                  actionLabel: 'فتح التتبع',
                  onPressed: () => context.go(NosokSystemRoutes.track)),
              PwfSisServiceCard(
                  icon: Icons.quiz_outlined,
                  title: 'الأسئلة الشائعة',
                  description: 'إجابات مختصرة عن التسجيل والوثائق والقرعة.',
                  actionLabel: 'عرض الأسئلة',
                  onPressed: () => context.go(NosokSystemRoutes.faq)),
              PwfSisServiceCard(
                  icon: Icons.report_problem_outlined,
                  title: 'الشكاوى',
                  description: 'تقديم ملاحظة أو شكوى عامة ضمن قناة منفصلة.',
                  actionLabel: 'فتح الشكاوى',
                  onPressed: () => context.go(NosokSystemRoutes.complaints)),
              const PwfSisServiceCard(
                  icon: Icons.phone_iphone_outlined,
                  title: 'تطبيق مناسكنا',
                  description: 'قناة إرشادية مساندة عند اعتماد الربط النهائي.',
                  disabled: true),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const PwfSisNotice(
          title: 'حماية بياناتك',
          message:
              'متابعة الطلبات تتم برقم مرجعي أو رمز تتبع. لا ترسل بيانات الهوية أو المرفقات الحساسة عبر قنوات عامة.',
          tone: PwfSisNoticeTone.warning,
        ),
      ],
    );
  }
}
