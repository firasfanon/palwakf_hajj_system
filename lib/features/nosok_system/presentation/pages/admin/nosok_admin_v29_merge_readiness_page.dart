import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v29_merge_readiness_controller.dart';
import '../../../domain/models/nosok_merge_readiness_contract.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV29MergeReadinessPage extends ConsumerWidget {
  const NosokAdminV29MergeReadinessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV29MergeReadinessContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v29 — جاهزية الدمج مع PalWakf',
            description:
                'تثبيت حزمة ما قبل قاعدة البيانات: تصميم schema نسك، خطة Platform Registry/RBAC، إغلاق أسطح frontend runtime، وتجهيز Pre-Database Integration Pack. لا يوجد SQL apply مطلوب الآن لأن الجداول ستُنشأ بعد الدمج الرسمي مع PalWakf.',
            badges: const [
              'v29',
              'pre-platform-merge',
              'database-not-created-by-design',
              'schema-design-finalized',
              'rbac-binding-plan-ready',
              'production-not-approved',
            ],
            actions: const [
              PwfSisStatusBadge(
                  label: 'لا SQL apply الآن',
                  icon: Icons.block_outlined,
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'no waqf_assets mutation',
                  icon: Icons.verified_user_outlined,
                  tone: PwfSisNoticeTone.success),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 230,
            children: [
              PwfSisMetricCard(
                  label: 'الحالة',
                  value: 'جاهزية دمج',
                  subtitle: contract.status,
                  icon: Icons.merge_type_outlined),
              PwfSisMetricCard(
                  label: 'قاعدة البيانات',
                  value: 'غير منشأة',
                  subtitle: contract.databaseState,
                  icon: Icons.storage_outlined),
              PwfSisMetricCard(
                  label: 'Registry',
                  value: '${contract.registryBindingCount}',
                  subtitle: 'binding contracts',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'Schema',
                  value: '${contract.schemaTableCount}',
                  subtitle: 'design finalized',
                  icon: Icons.table_chart_outlined),
              PwfSisMetricCard(
                  label: 'RBAC',
                  value: '${contract.rbacBindingCount}',
                  subtitle: 'role bindings',
                  icon: Icons.admin_panel_settings_outlined),
              PwfSisMetricCard(
                  label: 'Frontend',
                  value: '${contract.frontendSurfaceCount}',
                  subtitle: 'runtime surfaces',
                  icon: Icons.web_asset_outlined),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قرار v29 الحاكم',
            message:
                'لا يتم طلب Actual SQL Apply ولا Readiness RPC الآن. نسك ينتظر الدمج مع PalWakf أولًا، ثم إنشاء schema nosok في Supabase. كل SQL/RPC في هذه المرحلة عقود وتصميم وجاهزية فقط.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Platform Registry / Sections / Access Binding',
            subtitle:
                'هذه العقود تحدد كيف ينضم نسك إلى المنصة كنظام شبه مستقل تحت سجل الأنظمة لا كنظام منفصل خارجها.',
            child: PwfSisDataTable(
              columns: const ['العقد', 'سطح المنصة', 'الربط المتوقع', 'الحالة'],
              rows: [
                for (final item in contract.registryBindings)
                  [
                    Text(item.titleAr),
                    Text(item.platformSurface),
                    Text(item.expectedBinding),
                    PwfSisStatusBadge(
                        label: item.status, icon: Icons.rule_outlined),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Nosok Schema Design Finalization',
            subtitle:
                'تصميم نهائي قبل الإنشاء. لا توجد جداول منفذة الآن، ولا يتم إنشاء schema قبل الدمج مع PalWakf.',
            child: PwfSisDataTable(
              columns: const [
                'الجدول/العائلة',
                'الغرض',
                'العلاقات',
                'الخصوصية',
                'الحالة'
              ],
              rows: [
                for (final table in contract.schemaTables)
                  [
                    Text(table.name),
                    Text(table.purposeAr),
                    Text(table.primaryRelations.join('، ')),
                    Text(table.privacyPolicyAr),
                    PwfSisStatusBadge(
                        label: table.status,
                        icon: Icons.pending_actions_outlined),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RBAC Binding Plan',
            subtitle:
                'لا RBAC مستقل داخل نسك. كل الصلاحيات النهائية تأتي من AccessProfile وPlatform RBAC بعد الدمج.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 320,
              children: [
                for (final role in contract.rbacBindings)
                  _RbacBindingCard(role: role)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Frontend Runtime Completion',
            subtitle:
                'الأسطح الأمامية تعمل كـ preview/contract قبل قاعدة البيانات، وتصبح runtime بعد repository binding لاحقًا.',
            child: Column(children: [
              for (final surface in contract.frontendSurfaces)
                _FrontendSurfaceTile(surface: surface)
            ]),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Pre-Database Integration Pack',
            subtitle: 'ما يمكن تسليمه قبل إنشاء الجداول رسميًا.',
            child: PwfSisTimeline(items: contract.preDatabasePack),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'خطوات الدمج التالية',
            subtitle:
                'تُنفذ بعد نقل الحزمة إلى ريبو PalWakf وليس داخل نسخة preview فقط.',
            child: Column(children: [
              for (final step in contract.integrationSteps)
                _IntegrationStepTile(step: step)
            ]),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'موانع الإنتاج',
            subtitle:
                'تبقى production gate مغلقة حتى إغلاق هذه البنود بعد الدمج.',
            child: PwfSisTimeline(items: contract.productionBlockers),
          ),
        ],
      ),
    );
  }
}

class _RbacBindingCard extends StatelessWidget {
  const _RbacBindingCard({required this.role});
  final NosokRbacBindingContract role;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PwfSisStatusBadge(
                label: role.roleAr, icon: Icons.manage_accounts_outlined),
            const SizedBox(height: 10),
            Text('المتاح: ${role.allowedSurfacesAr}'),
            const SizedBox(height: 8),
            Text('الممنوع: ${role.deniedSurfacesAr}'),
            const SizedBox(height: 8),
            Text('عقد المنصة: ${role.platformPermissionContract}'),
          ],
        ),
      ),
    );
  }
}

class _FrontendSurfaceTile extends StatelessWidget {
  const _FrontendSurfaceTile({required this.surface});
  final NosokFrontendRuntimeSurface surface;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.web_asset_outlined),
        title: Text(surface.route),
        subtitle: Text(
            '${surface.surfaceAr}\nالحالة: ${surface.runtimeState}\nالربط: ${surface.bindingMode}'),
        trailing: PwfSisStatusBadge(
            label: surface.status, icon: Icons.fact_check_outlined),
        isThreeLine: true,
      ),
    );
  }
}

class _IntegrationStepTile extends StatelessWidget {
  const _IntegrationStepTile({required this.step});
  final NosokMergeIntegrationStep step;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.integration_instructions_outlined),
        title: Text(step.titleAr),
        subtitle: Text('${step.descriptionAr}\nالمالك: ${step.owner}'),
        trailing: PwfSisStatusBadge(
            label: step.status, icon: Icons.pending_actions_outlined),
        isThreeLine: true,
      ),
    );
  }
}
