import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_dashboard_controller.dart';
import '../../widgets/nosok_async_view.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminReportsPage extends ConsumerWidget {
  const NosokAdminReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(nosokDashboardControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'تقارير نسك',
            description:
                'مؤشرات تشغيلية موسمية منفصلة عن الصفحة الرئيسية، مع تقليل الحمل البصري وإبقاء التصدير والرسوم المتقدمة كتوسعات لاحقة.',
            badges: ['reports', 'role-scoped', 'no-heavy-homepage'],
          ),
          const SizedBox(height: 12),
          NosokAsyncView(
            value: summaryAsync,
            dataBuilder: (summary) {
              return Column(
                children: [
                  PwfSisAdaptiveWorkspace(
                    minTileWidth: 210,
                    children: [
                      PwfSisMetricCard(
                          label: 'المواسم النشطة',
                          value: summary.activeSeasonsCount.toString(),
                          icon: Icons.event_available_outlined),
                      PwfSisMetricCard(
                          label: 'البرامج النشطة',
                          value: summary.activeProgramsCount.toString(),
                          icon: Icons.route_outlined),
                      PwfSisMetricCard(
                          label: 'الشركات المنشورة',
                          value: summary.publishedCompaniesCount.toString(),
                          icon: Icons.business_outlined),
                      PwfSisMetricCard(
                          label: 'الشكاوى المفتوحة',
                          value: summary.openComplaintsCount.toString(),
                          icon: Icons.report_problem_outlined),
                      PwfSisMetricCard(
                          label: 'الطلبات المعلقة',
                          value: summary.pendingApplicationsCount.toString(),
                          icon: Icons.pending_actions_outlined),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const PwfSisPanel(
                    title: 'مصادر التقارير المتوقعة',
                    subtitle:
                        'لا تُحمّل تقارير ثقيلة في الصفحة الرئيسية. هذه الصفحة هي السطح المناسب للتوسع.',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        PwfSisStatusBadge(
                            label: 'طلبات حسب الحالة',
                            icon: Icons.fact_check_outlined),
                        PwfSisStatusBadge(
                            label: 'طلبات حسب الخدمة',
                            icon: Icons.category_outlined),
                        PwfSisStatusBadge(
                            label: 'النواقص حسب النوع',
                            icon: Icons.rule_folder_outlined),
                        PwfSisStatusBadge(
                            label: 'الحملات حسب السعة',
                            icon: Icons.groups_outlined),
                        PwfSisStatusBadge(
                            label: 'نشاط الموظفين حسب الصلاحية',
                            icon: Icons.admin_panel_settings_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const PwfSisNotice(
                    title: 'حدود التصدير',
                    message:
                        'تصدير CSV/PDF لا يُفعّل هنا إلا عند توفر backend وصلاحيات معتمدة؛ لا توجد بيانات وهمية منتجة.',
                    tone: PwfSisNoticeTone.warning,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
