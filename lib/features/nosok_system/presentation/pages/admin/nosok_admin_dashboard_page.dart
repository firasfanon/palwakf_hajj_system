import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminDashboardPage extends StatelessWidget {
  const NosokAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'نظام نسك',
            description:
                'إدارة طلبات الحج والعمرة والحملات والمتابعة من واجهة تشغيل داخلية منفصلة عن واجهة المواطن، ومحكومة بصلاحيات PalWakf.',
            badges: const [
              'internal',
              'restricted',
              'runtime source: PalWakf',
              'role scope'
            ],
            actions: [
              FilledButton.icon(
                  onPressed: () => context.go(NosokSystemRoutes.adminRequests),
                  icon: const Icon(Icons.inbox_outlined),
                  label: const Text('فتح الطلبات')),
              OutlinedButton.icon(
                  onPressed: () => context.go(NosokSystemRoutes.adminReview),
                  icon: const Icon(Icons.rate_review_outlined),
                  label: const Text('مراجعة النواقص')),
            ],
          ),
          const SizedBox(height: 14),
          const PwfSisAdaptiveWorkspace(
            minTileWidth: 180,
            children: [
              PwfSisMetricCard(
                  label: 'الطلبات الجديدة',
                  value: '18',
                  subtitle: 'تحتاج فرز أولي',
                  icon: Icons.new_releases_outlined),
              PwfSisMetricCard(
                  label: 'قيد المراجعة',
                  value: '42',
                  subtitle: 'ضمن نطاق الموظفين',
                  icon: Icons.manage_search_outlined),
              PwfSisMetricCard(
                  label: 'نواقص حرجة',
                  value: '7',
                  subtitle: 'مطلوب استكمال',
                  icon: Icons.warning_amber_outlined),
              PwfSisMetricCard(
                  label: 'حملات نشطة',
                  value: '3',
                  subtitle: 'قابلة للربط',
                  icon: Icons.groups_outlined),
              PwfSisMetricCard(
                  label: 'مراسلات واردة',
                  value: '11',
                  subtitle: 'صندوق المتابعة',
                  icon: Icons.mark_email_unread_outlined),
              PwfSisMetricCard(
                  label: 'مهامي',
                  value: '9',
                  subtitle: 'حسب AccessProfile',
                  icon: Icons.task_alt_outlined),
            ],
          ),
          const SizedBox(height: 14),
          PwfSisPanel(
            title: 'منطقة الإجراءات الأساسية',
            subtitle:
                'مسارات تشغيل مباشرة بدل حشر الجداول الثقيلة في الصفحة الرئيسية.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 230,
              children: [
                PwfSisServiceCard(
                    icon: Icons.inbox_outlined,
                    title: 'الطلبات',
                    description:
                        'فتح طابور الطلبات مع فلترة حسب الحالة والموسم والمديرية.',
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminRequests)),
                PwfSisServiceCard(
                    icon: Icons.rate_review_outlined,
                    title: 'المراجعة',
                    description:
                        'Decision Panel للنواقص والقبول الأولي والرفض والتحويل.',
                    onPressed: () => context.go(NosokSystemRoutes.adminReview)),
                PwfSisServiceCard(
                    icon: Icons.campaign_outlined,
                    title: 'الحملات',
                    description: 'إدارة الحملات والمجموعات والسعة والمشرفين.',
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminCampaigns)),
                PwfSisServiceCard(
                    icon: Icons.mail_outline,
                    title: 'المراسلات',
                    description: 'صندوق الوارد والصادر وقوالب الاستكمال.',
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminMessages)),
                PwfSisServiceCard(
                    icon: Icons.description_outlined,
                    title: 'المرفقات',
                    description:
                        'متابعة جودة الوثائق والتحقق وربط Document Intelligence.',
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminDocuments)),
                PwfSisServiceCard(
                    icon: Icons.query_stats_outlined,
                    title: 'التقارير',
                    description: 'مؤشرات موسمية منفصلة عن الصفحة الرئيسية.',
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminReports)),
                PwfSisServiceCard(
                    icon: Icons.view_quilt_outlined,
                    title: 'أقسام الصفحة الرئيسية',
                    description:
                        'تحضير إدارة ما يظهر للجمهور: Hero، حالة الموسم، الخدمات، الثقة، والدعم.',
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminHomepageSections)),
                PwfSisServiceCard(
                    icon: Icons.account_tree_outlined,
                    title: 'نطاق الموظفين',
                    description:
                        'تجهيز دخول الموظف حسب المديرية وLGU/slug حتى يرى سجلات نطاقه فقط.',
                    onPressed: () =>
                        context.go(NosokSystemRoutes.adminUnitScopeAccess)),
                PwfSisServiceCard(
                    icon: Icons.lock_clock_outlined,
                    title: 'قيود التسجيل',
                    description:
                        'قواعد الإغلاق القانوني، الاستكمال، وتجميد القرعة لمنع أي تعديل غير موثق.',
                    onPressed: () => context
                        .go(NosokSystemRoutes.adminRegistrationGovernance)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const PwfSisPanel(
            title: 'معاينة طابور المراجعة',
            subtitle:
                'آخر العناصر فقط؛ الجدول الكامل في صفحة الطلبات/المراجعة.',
            child: PwfSisReviewQueue(items: [
              (
                'NSK-1447-00018',
                'طلب حج — نواقص في جواز السفر',
                'needs_completion'
              ),
              ('NSK-1447-00021', 'طلب عمرة — جاهز للمراجعة', 'under_review'),
              ('NSK-1447-00025', 'اعتراض مواطن — يحتاج رد', 'in_followup'),
            ]),
          ),
          const SizedBox(height: 14),
          const PwfSisPanel(
            title: 'سير العمل التشغيلي',
            child: PwfSisTimeline(items: [
              'submitted',
              'received',
              'under_review',
              'needs_completion',
              'approved',
              'assigned_to_campaign',
              'in_followup',
              'completed',
              'closed'
            ]),
          ),
          const SizedBox(height: 14),
          const PwfSisPanel(
            title: 'Access-Aware UI',
            subtitle:
                'السوبر يوزر يرى الإدارة والإعدادات وaudit، موظف نسك يرى طلباته ومراجعاته، والمستخدم المقيد read-only أو forbidden.',
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              PwfSisStatusBadge(
                  label: 'superuser: all + audit',
                  icon: Icons.admin_panel_settings_outlined),
              PwfSisStatusBadge(
                  label: 'employee: assigned queues',
                  icon: Icons.manage_search_outlined),
              PwfSisStatusBadge(
                  label: 'restricted: read-only/forbidden',
                  icon: Icons.lock_outline),
            ]),
          ),
          const SizedBox(height: 14),
          const PwfSisPanel(
            title: 'Evidence / Governance Strip',
            child: Wrap(spacing: 8, runSpacing: 8, children: [
              PwfSisRuntimeState(
                  label: 'runtime', value: 'preview/fallback', ok: true),
              PwfSisRuntimeState(
                  label: 'health', value: 'pending Supabase UAT', ok: false),
              PwfSisRuntimeState(
                  label: 'storage', value: 'policy pending', ok: false),
              PwfSisRuntimeState(
                  label: 'permissions',
                  value: 'AccessProfile override required',
                  ok: false),
            ]),
          ),
        ],
      ),
    );
  }
}
