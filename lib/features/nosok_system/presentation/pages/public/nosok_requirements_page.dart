import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_v38_public_runtime_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokRequirementsPage extends ConsumerWidget {
  const NosokRequirementsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicRuntime = ref.watch(nosokV38PublicRuntimeControllerProvider);

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
        publicRuntime.when(
          data: (state) => _RuntimeRequirementsPanel(state: state),
          loading: () => const _RuntimeRequirementsLoadingPanel(),
          error: (error, stackTrace) => const _RuntimeRequirementsSafePanel(),
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

class _RuntimeRequirementsPanel extends StatelessWidget {
  const _RuntimeRequirementsPanel({required this.state});

  final NosokV38PublicRuntimeState state;

  @override
  Widget build(BuildContext context) {
    final items = state.hasRequirements
        ? state.requirements.map((item) => item.titleAr).toList(growable: false)
        : const [
            'هوية سارية',
            'جواز سفر ساري',
            'صورة شخصية',
            'رقم هاتف قابل للتحقق',
            'عنوان حسب البطاقة الشخصية',
            'مرفقات إضافية حسب نوع الخدمة',
          ];

    return PwfSisPanel(
      title: 'المتطلبات الأساسية',
      subtitle: state.safeMessageAr,
      actions: [
        PwfSisStatusBadge(
          label: state.loadedFromLiveRpc ? 'RPC requirements' : 'preview safe',
          icon: Icons.api_outlined,
          tone: state.loadedFromLiveRpc
              ? PwfSisNoticeTone.success
              : PwfSisNoticeTone.warning,
        ),
        PwfSisStatusBadge(
          label: state.productionDecision,
          icon: Icons.lock_clock_outlined,
          tone: PwfSisNoticeTone.warning,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PwfSisRequirementsPanel(items: items),
          if (state.hasRequirements) ...[
            const SizedBox(height: 12),
            PwfSisAdaptiveWorkspace(
              minTileWidth: 270,
              children: [
                for (final requirement in state.requirements.take(6))
                  PwfSisServiceCard(
                    icon: requirement.isMandatory
                        ? Icons.check_circle_outline
                        : Icons.info_outline,
                    title: requirement.titleAr,
                    description: requirement.descriptionAr ??
                        'متطلب منشور عبر RPC wrapper العام.',
                    actionLabel: requirement.isMandatory ? 'إلزامي' : 'إرشادي',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _RuntimeRequirementsLoadingPanel extends StatelessWidget {
  const _RuntimeRequirementsLoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const PwfSisPanel(
      title: 'تحميل المتطلبات',
      subtitle: 'قراءة آمنة من RPC wrapper العام.',
      child: LinearProgressIndicator(),
    );
  }
}

class _RuntimeRequirementsSafePanel extends StatelessWidget {
  const _RuntimeRequirementsSafePanel();

  @override
  Widget build(BuildContext context) {
    return const PwfSisRequirementsPanel(
      items: [
        'هوية سارية',
        'جواز سفر ساري',
        'صورة شخصية',
        'رقم هاتف قابل للتحقق',
        'عنوان حسب البطاقة الشخصية',
        'مرفقات إضافية حسب نوع الخدمة',
      ],
    );
  }
}
