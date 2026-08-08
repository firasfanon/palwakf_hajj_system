import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_prejoin_admin_tools_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38CAdminToolsPrejoinPage extends ConsumerWidget {
  const NosokAdminV38CAdminToolsPrejoinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokPrejoinAdminToolsContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v38C — أدوات الإدارة قبل الانضمام للمنصة',
            description:
                'دفعة تطوير وتحضير فقط. تضيف عقودًا وصفحات إدارية مطلوبة لأن نسك نظام شبه مستقل: إدارة أقسام الصفحة الرئيسية، نطاق الموظفين حسب slug/LGU، وقيود التسجيل بعد انتهاء الفترة القانونية. لا يتم إنشاء جداول ولا تنفيذ SQL ولا ربط backend حقيقي في هذه المرحلة.',
            badges: [
              'v38C',
              'admin-tools',
              'pre-join-only',
              'no-schema-apply',
              'production-not-approved'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'development/preparation-only',
                  icon: Icons.construction_outlined,
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
                  label: 'Homepage Sections',
                  value: '${contract.homepageSections.length}',
                  subtitle: 'أقسام قابلة للإدارة لاحقًا',
                  icon: Icons.view_quilt_outlined),
              PwfSisMetricCard(
                  label: 'Unit Scope Rules',
                  value: '${contract.unitScopeRules.length}',
                  subtitle: 'slug/LGU/AccessProfile',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'Registration Locks',
                  value: '${contract.registrationGovernanceRules.length}',
                  subtitle: 'فتح/إغلاق/استكمال/تجميد',
                  icon: Icons.lock_clock_outlined),
              PwfSisMetricCard(
                  label: 'Draft DB Objects',
                  value: '${contract.requiredTables.length}',
                  subtitle: 'جداول مطلوبة غير مطبقة',
                  icon: Icons.table_chart_outlined),
              PwfSisMetricCard(
                  label: 'Draft RPCs',
                  value: '${contract.requiredRpcs.length}',
                  subtitle: 'واجهات مؤجلة للمنصة',
                  icon: Icons.api_outlined),
              const PwfSisMetricCard(
                  label: 'Production',
                  value: 'NO',
                  subtitle: 'مؤجل حتى الاستضافة والـ backend',
                  icon: Icons.gpp_maybe_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'أدوات الإدارة المضافة في v38C',
            subtitle:
                'هذه صفحات تحضيرية داخل نسك preview، وتتحول إلى أدوات فعلية بعد الانضمام وربط RBAC/RPC.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                PwfSisServiceCard(
                  icon: Icons.view_quilt_outlined,
                  title: 'إدارة أقسام الصفحة الرئيسية',
                  description:
                      'تصميم جدول nosok.homepage_sections وما تتحكم به الإدارة للجمهور: الترتيب، النشر، النطاق، نصوص الخدمة، والأزرار.',
                  actionLabel: 'فتح العقد',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminHomepageSections),
                ),
                PwfSisServiceCard(
                  icon: Icons.account_tree_outlined,
                  title: 'نطاق الموظفين حسب slug/LGU',
                  description:
                      'تجهيز دخول موظف المديرية إلى سجلات التجمعات التابعة له فقط حسب AccessProfile وLGU mapping.',
                  actionLabel: 'فتح العقد',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminUnitScopeAccess),
                ),
                PwfSisServiceCard(
                  icon: Icons.lock_clock_outlined,
                  title: 'قيود التسجيل والنزاهة',
                  description:
                      'منع أو تقييد تعديل المواطن والموظف بعد انتهاء الفترة القانونية أو تجميد القرعة إلا بقرار موثق.',
                  actionLabel: 'فتح العقد',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminRegistrationGovernance),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'الحد الفاصل بين التحضير والتنفيذ',
            message:
                'v38C لا ينفذ الجداول. هو يجهز العقود والصفحات التي يجب أن تكون موجودة لأن نسك شبه مستقل. عند انتقال المسار إلى منصة PalWakf، يتم تنفيذ هذه العقود كـ schema/RPC/RLS حقيقية بعد موافقة sandbox وRBAC.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Gates المطلوبة قبل الانضمام الفعلي',
            subtitle:
                'هذه البنود يجب أن يتحقق منها مسار PalWakf قبل تشغيل أدوات الإدارة حقيقيًا.',
            child: PwfSisTimeline(items: contract.joinReadinessGates),
          ),
        ],
      ),
    );
  }
}
