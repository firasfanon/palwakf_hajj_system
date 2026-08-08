import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokPublicHomePage extends StatelessWidget {
  const NosokPublicHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PwfSisPublicServiceShell(
      children: [
        PwfSisPremiumPublicHero(
          title: 'رحلتك إلى',
          highlight: 'بيت الله تبدأ من هنا',
          description:
              'قدّم طلبك، تابع حالته، واستكمل متطلبات الحج والعمرة من مكان واحد وبخطوات واضحة.',
          badges: const ['موسم 1446 هـ', 'التسجيل حسب إعلان الوزارة'],
          icon: Icons.mosque_outlined,
          statusItems: const [
            (
              Icons.check_circle_outline,
              'الموسم نشط',
              PwfSisNoticeTone.success
            ),
            (
              Icons.event_outlined,
              'آخر موعد يظهر عند إعلان الوزارة',
              PwfSisNoticeTone.info
            ),
            (
              Icons.groups_outlined,
              'المقاعد حسب حصة التجمع',
              PwfSisNoticeTone.warning
            ),
          ],
          primaryAction: FilledButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.apply),
            icon: const Icon(Icons.app_registration_outlined),
            label: const Text('تقديم طلب جديد'),
          ),
          secondaryAction: OutlinedButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.track),
            icon: const Icon(Icons.search_outlined),
            label: const Text('متابعة طلب'),
          ),
          tertiaryAction: TextButton.icon(
            onPressed: () => context.go(NosokSystemRoutes.requirements),
            icon: const Icon(Icons.fact_check_outlined),
            label: const Text('الشروط والمتطلبات'),
          ),
        ),
        const SizedBox(height: 12),
        const _SeasonalLandingBanner(),
        const SizedBox(height: 14),
        _PrimaryServices(context: context),
        const SizedBox(height: 14),
        _SecondaryServices(context: context),
        const SizedBox(height: 14),
        const _CitizenJourney(),
        const SizedBox(height: 14),
        const PwfSisTrustTransparencyBox(
          body:
              'التسجيل يتم حسب العنوان المسجل في البطاقة الشخصية. وتتم القرعة وفق حصة التجمع السكاني المعتمدة للموسم، بما يحافظ على تكافؤ الفرص دون كشف بيانات المتقدمين الآخرين.',
        ),
        const SizedBox(height: 14),
        _CompaniesAndHelp(context: context),
        const SizedBox(height: 14),
        _CompactAdminEntry(
            onAdmin: () => context.go(NosokSystemRoutes.adminHome)),
      ],
    );
  }
}

class _SeasonalLandingBanner extends StatelessWidget {
  const _SeasonalLandingBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F3E7),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFD7B56D)),
      ),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.campaign_outlined, color: scheme.primary, size: 18),
              const SizedBox(width: 6),
              Text('حالة الموسم',
                  style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900, color: scheme.primary)),
            ],
          ),
          const PwfSisStatusBadge(
              label: 'التسجيل يظهر عند فتح الموسم',
              icon: Icons.check_circle_outline,
              tone: PwfSisNoticeTone.success),
          const PwfSisStatusBadge(
              label: 'الموعد النهائي حسب إعلان الوزارة',
              icon: Icons.calendar_month_outlined,
              tone: PwfSisNoticeTone.warning),
          const PwfSisStatusBadge(
              label: 'الحصة حسب العنوان المعتمد',
              icon: Icons.location_city_outlined,
              tone: PwfSisNoticeTone.info),
        ],
      ),
    );
  }
}

class _PrimaryServices extends StatelessWidget {
  const _PrimaryServices({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return PwfSisPanel(
      title: 'ابدأ خدمتك الآن',
      subtitle: 'ثلاثة إجراءات رئيسية تظهر أولًا لأن المواطن يحتاجها فورًا.',
      child: PwfSisAdaptiveWorkspace(
        minTileWidth: 285,
        children: [
          PwfSisPremiumServiceCard(
            icon: Icons.app_registration_outlined,
            title: 'تقديم طلب',
            description:
                'ابدأ طلب الحج أو العمرة بخطوات قصيرة: بياناتك، المرافقون، المرفقات، ثم المراجعة قبل الإرسال.',
            actionLabel: 'ابدأ الآن ←',
            priority: true,
            tone: PwfSisNoticeTone.info,
            onPressed: () => context.go(NosokSystemRoutes.apply),
          ),
          PwfSisPremiumServiceCard(
            icon: Icons.manage_search_outlined,
            title: 'متابعة طلب',
            description:
                'اعرف حالة طلبك، النواقص المطلوبة، والخطوة التالية باستخدام رقم الطلب أو رمز التتبع.',
            actionLabel: 'تابع طلبك ←',
            priority: true,
            onPressed: () => context.go(NosokSystemRoutes.track),
          ),
          PwfSisPremiumServiceCard(
            icon: Icons.emoji_events_outlined,
            title: 'نتائج القرعة',
            description:
                'تحقق من نتيجة القرعة أو ترتيبك في قائمة الانتظار دون كشف بيانات المتقدمين الآخرين.',
            actionLabel: 'تحقق من النتيجة ←',
            priority: true,
            tone: PwfSisNoticeTone.warning,
            onPressed: () => context.go(NosokSystemRoutes.lotteryResults),
          ),
        ],
      ),
    );
  }
}

class _SecondaryServices extends StatelessWidget {
  const _SecondaryServices({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return PwfSisPanel(
      title: 'خدمات مساندة',
      subtitle:
          'روابط مختصرة للشروط، الانتظار، الاعتراضات، الشركات، والمساعدة.',
      child: PwfSisAdaptiveWorkspace(
        minTileWidth: 230,
        children: [
          PwfSisServiceCard(
              icon: Icons.flag_outlined,
              title: 'التسجيل للحج',
              description: 'تعرف على مسار الحج وشروط التسجيل عند فتح الموسم.',
              actionLabel: 'فتح',
              onPressed: () => context.go(NosokSystemRoutes.hajj)),
          PwfSisServiceCard(
              icon: Icons.travel_explore_outlined,
              title: 'التسجيل للعمرة',
              description:
                  'اطلع على تعليمات العمرة والبرامج المتاحة عند اعتمادها.',
              actionLabel: 'فتح',
              onPressed: () => context.go(NosokSystemRoutes.umrah)),
          PwfSisServiceCard(
              icon: Icons.list_alt_outlined,
              title: 'قائمة الانتظار',
              description: 'تابع ترتيب الانتظار حسب تجمعك وحصة الموسم.',
              actionLabel: 'عرض',
              onPressed: () => context.go(NosokSystemRoutes.waitingList)),
          PwfSisServiceCard(
              icon: Icons.gavel_outlined,
              title: 'الاعتراضات',
              description: 'قدّم اعتراضًا عند فتح النافذة وراجع حالته لاحقًا.',
              actionLabel: 'تقديم',
              onPressed: () => context.go(NosokSystemRoutes.objections)),
          PwfSisServiceCard(
              icon: Icons.business_center_outlined,
              title: 'الشركات المؤهلة',
              description: 'اطلع على الشركات المؤهلة وتعليمات التعامل معها.',
              actionLabel: 'عرض',
              onPressed: () => context.go(NosokSystemRoutes.companies)),
          PwfSisServiceCard(
              icon: Icons.support_agent_outlined,
              title: 'المساعدة',
              description: 'راجع الأسئلة الشائعة أو تواصل مع الدعم.',
              actionLabel: 'مساعدة',
              onPressed: () => context.go(NosokSystemRoutes.contact)),
        ],
      ),
    );
  }
}

class _CitizenJourney extends StatelessWidget {
  const _CitizenJourney();

  @override
  Widget build(BuildContext context) {
    return const PwfSisPublicWorkflowStepper(
      steps: [
        'اختر الخدمة',
        'أدخل البيانات',
        'أرفق الوثائق',
        'أرسل الطلب',
        'تابع الحالة',
        'استكمل النواقص',
        'تابع النتيجة',
      ],
    );
  }
}

class _CompaniesAndHelp extends StatelessWidget {
  const _CompaniesAndHelp({required this.context});
  final BuildContext context;

  @override
  Widget build(BuildContext _) {
    return PwfSisPanel(
      title: 'الشركات والمساعدة',
      subtitle: 'وصول سريع للجهات المؤهلة وقنوات الدعم العامة.',
      child: PwfSisAdaptiveWorkspace(
        minTileWidth: 260,
        children: [
          PwfSisServiceCard(
              icon: Icons.verified_outlined,
              title: 'الشركات المؤهلة',
              description:
                  'استعرض الشركات المعتمدة وفق إعلان الوزارة لكل موسم.',
              actionLabel: 'عرض الشركات',
              onPressed: () => context.go(NosokSystemRoutes.companies)),
          PwfSisServiceCard(
              icon: Icons.business_outlined,
              title: 'بوابة الشركات',
              description:
                  'مدخل شركاء التشغيل، ويبقى محكومًا بالصلاحيات عند الدمج.',
              actionLabel: 'دخول الشركات',
              onPressed: () => context.go(NosokSystemRoutes.companyLogin)),
          PwfSisServiceCard(
              icon: Icons.help_outline,
              title: 'الأسئلة والمساعدة',
              description: 'إجابات مختصرة وقنوات تواصل دون كشف بيانات حساسة.',
              actionLabel: 'فتح المساعدة',
              onPressed: () => context.go(NosokSystemRoutes.faq)),
        ],
      ),
    );
  }
}

class _CompactAdminEntry extends StatelessWidget {
  const _CompactAdminEntry({required this.onAdmin});

  final VoidCallback onAdmin;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: 'دخول الموظفين ولوحة التحكم',
      subtitle:
          'هذا المدخل مخصص للموظفين والمشرفين فقط، ولا يغيّر صلاحيات المستخدمين.',
      actions: [
        OutlinedButton.icon(
            onPressed: onAdmin,
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('دخول الموظفين'))
      ],
      child: const Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          PwfSisStatusBadge(
              label: 'مدخل موظفين',
              icon: Icons.lock_outline,
              tone: PwfSisNoticeTone.info),
          PwfSisStatusBadge(
              label: 'رحلة المواطن منفصلة',
              icon: Icons.visibility_off_outlined,
              tone: PwfSisNoticeTone.neutral),
        ],
      ),
    );
  }
}
