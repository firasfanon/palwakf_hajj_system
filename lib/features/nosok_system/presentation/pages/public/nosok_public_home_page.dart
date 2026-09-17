import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../../application/nosok_v38_public_runtime_controller.dart';
import '../../../data/repositories/nosok_public_wrapper_rpc_adapter.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokPublicHomePage extends ConsumerWidget {
  const NosokPublicHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final publicRuntime = ref.watch(nosokV38PublicRuntimeControllerProvider);
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
        publicRuntime.when(
          data: (state) => _PublicCampaignsRuntimePanel(state: state),
          loading: () => const _PublicRuntimeLoadingPanel(),
          error: (error, stackTrace) => const _PublicRuntimeSafeErrorPanel(),
        ),
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

class _PublicCampaignsRuntimePanel extends StatelessWidget {
  const _PublicCampaignsRuntimePanel({required this.state});

  final NosokV38PublicRuntimeState state;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: 'الحملات العامة النشطة',
      subtitle: state.safeMessageAr,
      actions: [
        PwfSisStatusBadge(
          label: state.loadedFromLiveRpc ? 'RPC مباشر' : 'معاينة آمنة',
          icon: state.loadedFromLiveRpc
              ? Icons.cloud_done_outlined
              : Icons.preview_outlined,
          tone: state.loadedFromLiveRpc
              ? PwfSisNoticeTone.success
              : PwfSisNoticeTone.warning,
        ),
        PwfSisStatusBadge(
          label: state.directNosokTableAccessUsed
              ? 'direct table access'
              : 'no direct nosok.*',
          icon: Icons.storage_outlined,
          tone: state.directNosokTableAccessUsed
              ? PwfSisNoticeTone.error
              : PwfSisNoticeTone.success,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              PwfSisStatusBadge(
                label: state.campaignsRpcName,
                icon: Icons.api_outlined,
                tone: PwfSisNoticeTone.info,
              ),
              PwfSisStatusBadge(
                label: state.requirementsRpcName,
                icon: Icons.fact_check_outlined,
                tone: PwfSisNoticeTone.info,
              ),
              PwfSisStatusBadge(
                label: state.productionDecision,
                icon: Icons.lock_clock_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!state.hasCampaigns)
            const PwfSisNotice(
              title: 'لا توجد حملات منشورة حاليًا',
              message:
                  'سيبقى التسجيل العام معطلًا حتى تنشر الوزارة حملة عامة عبر RPC wrapper.',
              tone: PwfSisNoticeTone.warning,
            )
          else
            PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                for (final campaign in state.campaigns.take(4))
                  PwfSisServiceCard(
                    icon: _campaignIcon(campaign.serviceType),
                    title: campaign.titleAr,
                    description: _campaignDescription(campaign),
                    actionLabel: 'عرض المتطلبات ←',
                    onPressed: () => context.go(NosokSystemRoutes.requirements),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  IconData _campaignIcon(String serviceType) {
    return serviceType == 'umrah'
        ? Icons.travel_explore_outlined
        : Icons.mosque_outlined;
  }

  String _campaignDescription(NosokPublicCampaignDto campaign) {
    final parts = <String>[
      campaign.descriptionAr ?? 'حملة منشورة عبر السطح العام الآمن.',
      'الحالة: ${campaign.status}',
    ];
    if (campaign.seasonYear != null) {
      parts.add('السنة: ${campaign.seasonYear}');
    }
    return parts.join(' • ');
  }
}

class _PublicRuntimeLoadingPanel extends StatelessWidget {
  const _PublicRuntimeLoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const PwfSisPanel(
      title: 'تحميل الحملات العامة',
      subtitle: 'يتم فحص RPC wrappers العامة دون قراءة مباشرة من جداول نسك.',
      child: LinearProgressIndicator(),
    );
  }
}

class _PublicRuntimeSafeErrorPanel extends StatelessWidget {
  const _PublicRuntimeSafeErrorPanel();

  @override
  Widget build(BuildContext context) {
    return const PwfSisNotice(
      title: 'تعذر تحميل الحملات العامة',
      message:
          'تم حجب تفاصيل الخطأ الخام عن الواجهة العامة. راجع Network/RPC evidence من لوحة الإدارة.',
      tone: PwfSisNoticeTone.warning,
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
