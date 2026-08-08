import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_prejoin_admin_tools_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38DDynamicPagesPrejoinPage extends ConsumerWidget {
  const NosokAdminV38DDynamicPagesPrejoinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokPrejoinAdminToolsContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v38D — منشئ الصفحات والأقسام قبل الانضمام',
            description:
                'دفعة تطوير وتحضير فقط تثبت أن نسك كنظام شبه مستقل يجب أن يمتلك قدرة مستقبلية على إضافة صفحات وأقسام عامة وإدارية من لوحة الإدارة دون الرجوع للمطور، بشرط قوالب معتمدة وصلاحيات ومسارات آمنة وتدقيق كامل.',
            badges: [
              'v38D',
              'dynamic-pages',
              'section-builder',
              'pre-join-only',
              'production-not-approved'
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
                  label: 'Dynamic Pages',
                  value: '${contract.dynamicPages.length}',
                  subtitle: 'قوالب صفحات مستقبلية',
                  icon: Icons.web_stories_outlined),
              PwfSisMetricCard(
                  label: 'Section Library',
                  value: '${contract.dynamicPageSections.length}',
                  subtitle: 'أقسام يعاد استخدامها',
                  icon: Icons.dashboard_customize_outlined),
              PwfSisMetricCard(
                  label: 'Governance Rules',
                  value: '${contract.dynamicPageGovernanceRules.length}',
                  subtitle: 'slug / RBAC / publish / audit',
                  icon: Icons.rule_folder_outlined),
              const PwfSisMetricCard(
                  label: 'Execution',
                  value: 'DEFERRED',
                  subtitle: 'بعد الاستضافة وschema/RPC',
                  icon: Icons.lock_clock_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'أدوات v38D',
            subtitle:
                'هذه الأدوات تحضيرية داخل نسك preview وتتحول إلى أدوات حقيقية بعد الانضمام وربط schema/RPC/RLS.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                PwfSisServiceCard(
                  icon: Icons.auto_awesome_motion_outlined,
                  title: 'منشئ الصفحات والأقسام',
                  description:
                      'سجل صفحات وقوالب وأقسام يسمح بإضافة صفحات مستقبلية دون مطور مع منع المسارات الخطرة والإدارية غير المحكومة.',
                  actionLabel: 'فتح العقد',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminDynamicPages),
                ),
                PwfSisServiceCard(
                  icon: Icons.view_quilt_outlined,
                  title: 'إدارة أقسام الصفحة الرئيسية',
                  description:
                      'إدارة Hero وحالة الموسم والخدمات والثقة والمساعدة من لوحة الإدارة بعد إنشاء nosok.homepage_sections.',
                  actionLabel: 'فتح العقد',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminHomepageSections),
                ),
                PwfSisServiceCard(
                  icon: Icons.account_tree_outlined,
                  title: 'نطاق الموظفين',
                  description:
                      'ضمان أن الصفحات الإدارية الجديدة تظهر حسب صلاحيات المستخدم ونطاقه، لا لمجرد وجودها في route.',
                  actionLabel: 'فتح العقد',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminUnitScopeAccess),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'الحد الفاصل بين المرونة والفوضى',
            message:
                'الاستقلالية لا تعني السماح بإنشاء أي صفحة بأي مسار. الصفحات العامة تُنشأ من قوالب آمنة، والصفحات الإدارية تحتاج permission/RPC/RLS قبل الظهور. التنفيذ الحقيقي مؤجل إلى منصة PalWakf بعد الاستضافة.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
