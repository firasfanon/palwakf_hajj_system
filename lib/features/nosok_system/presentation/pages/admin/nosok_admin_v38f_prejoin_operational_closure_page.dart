import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_v38f_prejoin_operational_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38FPrejoinOperationalClosurePage extends ConsumerWidget {
  const NosokAdminV38FPrejoinOperationalClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38FPrejoinOperationalContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v38F — إغلاق الأدوات التشغيلية قبل الانضمام',
            description:
                'دفعة تطوير وتحضير فقط. تغلق أدوات الإدارة التشغيلية بصيغة preview، وتضيف محاكاة قانونية لخوارزمية القرعة، وتثبت جاهزية بوابة الشركات ومصفوفة UAT العامة قبل تسليم حزمة الانضمام لمسار منصة PalWakf.',
            badges: [
              'v38F',
              'pre-join-only',
              'admin-tooling',
              'legal-simulation',
              'company-workspace',
              'public-uat'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'No schema apply',
                  icon: Icons.storage_outlined,
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'No waqf_assets mutation',
                  icon: Icons.verified_user_outlined,
                  tone: PwfSisNoticeTone.success),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 220,
            children: [
              PwfSisMetricCard(
                  label: 'Admin tools',
                  value: '${contract.adminToolingItems.length}',
                  subtitle: 'أدوات preview مكتملة',
                  icon: Icons.admin_panel_settings_outlined),
              PwfSisMetricCard(
                  label: 'Legal simulation',
                  value: '${contract.legalSimulationScenarios.length}',
                  subtitle: 'سيناريوهات خوارزمية',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'Company workspace',
                  value: '${contract.companyWorkspaceItems.length}',
                  subtitle: 'عقود الشريك',
                  icon: Icons.business_center_outlined),
              PwfSisMetricCard(
                  label: 'Public UAT',
                  value: '${contract.publicResponsiveUatItems.length}',
                  subtitle: 'مسارات جمهور',
                  icon: Icons.devices_outlined),
              const PwfSisMetricCard(
                  label: 'Production',
                  value: 'NO',
                  subtitle: 'مؤجل حتى الاستضافة',
                  icon: Icons.gpp_maybe_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'محاور v38F',
            subtitle:
                'هذه الصفحات لا تنفذ backend، لكنها تجعل الحزمة جاهزة لاستقبال منصة PalWakf لاحقًا.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                PwfSisServiceCard(
                  icon: Icons.rule_folder_outlined,
                  title: 'محاكاة خوارزمية الحج القانونية',
                  description:
                      'عرض سيناريوهات اختيار قانونية قبل تحويلها لاحقًا إلى RPC مدقق داخل nosok schema.',
                  actionLabel: 'فتح المحاكاة',
                  onPressed: () => context
                      .go(NosokSystemRoutes.adminLegalAlgorithmSimulation),
                ),
                PwfSisServiceCard(
                  icon: Icons.business_outlined,
                  title: 'إغلاق بوابة الشركات',
                  description:
                      'تثبيت نطاق ممثل الشركة والحملات والوثائق والمراسلات كعقود تحضيرية لا كتشغيل حقيقي.',
                  actionLabel: 'فتح بوابة الشركات',
                  onPressed: () => context
                      .go(NosokSystemRoutes.adminCompanyWorkspaceClosure),
                ),
                PwfSisServiceCard(
                  icon: Icons.devices_outlined,
                  title: 'أدلة الجمهور والاستجابة',
                  description:
                      'مصفوفة فحص public/responsive routes قبل تسليم حزمة الانضمام لمسار المنصة.',
                  actionLabel: 'فتح UAT',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminPublicResponsiveUat),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'إغلاق الأدوات الإدارية',
            subtitle:
                'تحويل الصفحات الإدارية من عرض عقود فقط إلى تصور تشغيل preview قابل للتحويل إلى backend لاحقًا.',
            child: PwfSisDataTable(
              columns: const ['الأداة', 'Preview', 'متطلب backend', 'الحالة'],
              rows: [
                for (final item in contract.adminToolingItems)
                  [
                    Text(item.titleAr),
                    Text(item.runtimePreviewAr),
                    Text(item.backendRequirementAr),
                    PwfSisStatusBadge(
                        label: item.statusAr,
                        icon: Icons.check_circle_outline,
                        tone: PwfSisNoticeTone.success)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Gates قبل تسليم حزمة الانضمام',
            subtitle:
                'تبقى هذه الدفعة داخل نسك فقط؛ التنفيذ الحقيقي في منصة PalWakf مؤجل.',
            child: PwfSisTimeline(items: contract.prejoinGates),
          ),
        ],
      ),
    );
  }
}
