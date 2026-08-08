import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v30_merge_pack_controller.dart';
import '../../../domain/models/nosok_v30_merge_pack_contract.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV30PalWakfMergeApplicationPage extends ConsumerWidget {
  const NosokAdminV30PalWakfMergeApplicationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV30MergePackContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v30 — تطبيق حزمة الدمج مع PalWakf',
            description:
                'هذه الصفحة تغلق blocker صفحة v29 وتثبت خطة تطبيق الدمج داخل PalWakf: Registry، RBAC، AccessProfile override، UAT داخل المنصة، وتحضير إنشاء schema نسك بعد الدمج فقط. لا SQL إنتاجي ولا إنشاء جداول في هذه المرحلة.',
            badges: const [
              'v30',
              'merge-pack-application',
              'v29-compile-blocker-closed',
              'pre-database',
              'production-not-approved',
            ],
            actions: const [
              PwfSisStatusBadge(
                  label: 'schema not created by design',
                  icon: Icons.storage_outlined,
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
                  label: 'Merge Steps',
                  value: '${contract.mergeStepCount}',
                  subtitle: 'application instructions',
                  icon: Icons.merge_type_outlined),
              PwfSisMetricCard(
                  label: 'Registry',
                  value: '${contract.registryEntryCount}',
                  subtitle: 'platform entries',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'RBAC',
                  value: '${contract.rbacClosureCount}',
                  subtitle: 'role closures',
                  icon: Icons.admin_panel_settings_outlined),
              PwfSisMetricCard(
                  label: 'UAT',
                  value: '${contract.uatSurfaceCount}',
                  subtitle: 'inside PalWakf',
                  icon: Icons.fact_check_outlined),
              PwfSisMetricCard(
                  label: 'Schema Prep',
                  value: '${contract.schemaPreparationCount}',
                  subtitle: contract.databaseState,
                  icon: Icons.storage_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v30 الحاكم',
            message:
                'يتم تجهيز الدمج مع PalWakf دون إنشاء جداول نسك الآن. إنشاء nosok schema يأتي بعد الدمج الرسمي، داخل sandbox، ثم UAT، ثم repository binding تدريجيًا. الإنتاج غير معتمد.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Full PalWakf Merge Pack Application',
            subtitle:
                'خطوات التطبيق داخل ريبو المنصة. الحالة هنا readiness/application contract وليست دليل دمج فعلي داخل ريبو PalWakf.',
            child: Column(children: [
              for (final step in contract.mergeApplicationSteps)
                _MergeStepTile(step: step)
            ]),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Platform Registry Entry',
            subtitle: 'مدخلات السجل الديناميكي والأقسام والصحة العامة للنظام.',
            child: PwfSisDataTable(
              columns: const ['المفتاح', 'كائن المنصة', 'العقد', 'الحالة'],
              rows: [
                for (final entry in contract.registryEntries)
                  [
                    Text(entry.key),
                    Text(entry.platformObject),
                    Text(entry.valueContract),
                    PwfSisStatusBadge(
                        label: entry.status, icon: Icons.rule_outlined),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'AccessProfile Override Closure',
            subtitle:
                'لا RBAC مستقل داخل نسك. كل الأدوار النهائية تقرأ من منصة PalWakf بعد الدمج.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 330,
              children: [
                for (final role in contract.rbacClosures)
                  _RbacClosureCard(role: role)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Browser / Role / Responsive UAT داخل PalWakf',
            subtitle:
                'هذه الأدلة مطلوبة بعد الدمج داخل المنصة، لا تكفي نسخة preview وحدها.',
            child: Column(children: [
              for (final surface in contract.palwakfUatSurfaces)
                _UatSurfaceTile(surface: surface)
            ]),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Nosok Schema Creation Preparation',
            subtitle:
                'تحضير عائلات الجداول دون إنشاء فعلي. كل العناصر Draft فقط حتى تصريح الدمج والـ sandbox.',
            child: PwfSisDataTable(
              columns: const ['العائلة', 'التحضير', 'توقيت التنفيذ', 'الحالة'],
              rows: [
                for (final item in contract.schemaPreparationItems)
                  [
                    Text(item.family),
                    Text(item.preparationAr),
                    Text(item.applyTiming),
                    PwfSisStatusBadge(
                        label: item.status,
                        icon: Icons.pending_actions_outlined),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'موانع الإنتاج',
            subtitle: contract.productionDecision,
            child: PwfSisTimeline(items: contract.blockers),
          ),
        ],
      ),
    );
  }
}

class _MergeStepTile extends StatelessWidget {
  const _MergeStepTile({required this.step});
  final NosokV30MergeStep step;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.integration_instructions_outlined),
        title: Text(step.titleAr),
        subtitle: Text('${step.actionAr}\nالمسار: ${step.targetPath}'),
        trailing: PwfSisStatusBadge(
            label: step.status, icon: Icons.pending_actions_outlined),
        isThreeLine: true,
      ),
    );
  }
}

class _RbacClosureCard extends StatelessWidget {
  const _RbacClosureCard({required this.role});
  final NosokV30RbacClosure role;

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
            Text('الصلاحيات: ${role.permissions}'),
            const SizedBox(height: 8),
            Text('سطح الحماية: ${role.guardSurface}'),
            const SizedBox(height: 8),
            PwfSisStatusBadge(
                label: role.status, icon: Icons.verified_user_outlined),
          ],
        ),
      ),
    );
  }
}

class _UatSurfaceTile extends StatelessWidget {
  const _UatSurfaceTile({required this.surface});
  final NosokV30UatSurface surface;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.devices_outlined),
        title: Text(surface.route),
        subtitle: Text(
            'الدور: ${surface.actorAr}\nالدليل المطلوب: ${surface.requiredEvidenceAr}'),
        trailing: PwfSisStatusBadge(
            label: surface.status, icon: Icons.fact_check_outlined),
        isThreeLine: true,
      ),
    );
  }
}
