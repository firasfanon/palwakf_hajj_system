import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_operations_controller.dart';
import '../../../application/nosok_readiness_evidence_controller.dart';
import '../../../application/nosok_role_uat_evidence_controller.dart';
import '../../../application/nosok_tracking_privacy_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import '../../widgets/nosok_stat_card.dart';

class NosokAdminProductionUatClosurePage extends ConsumerWidget {
  const NosokAdminProductionUatClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final operations = ref.watch(nosokOperationalReadinessProvider);
    final readiness = ref.watch(nosokProductionReadinessEvidenceProvider);
    final roles = ref.watch(nosokRoleUatEvidenceProvider);
    final privacy = ref.watch(nosokTrackingPrivacyChecksProvider);

    return NosokPageScaffold(
      title: 'إغلاق UAT الإنتاجي',
      subtitle:
          'بوابة أدلة تشغيلية تجمع فحوص المتصفح، SQL، الأدوار، الخصوصية، الدفع، والجاهزية قبل أي قرار اعتماد إنتاجي.',
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminReadinessEvidence),
          icon: const Icon(Icons.verified_outlined),
          label: const Text('أدلة الجاهزية'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminOperations),
          icon: const Icon(Icons.rule_folder_outlined),
          label: const Text('مركز التشغيل'),
        ),
      ],
      children: [
        _UatSnapshotRow(
          operationsCount: operations.valueOrNull?.length ?? 0,
          readinessCount: readiness.valueOrNull?.length ?? 0,
          roleEvidenceCount: roles.valueOrNull?.length ?? 0,
          privacyCount: privacy.valueOrNull?.length ?? 0,
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'مصفوفة بوابة الإنتاج',
          subtitle:
              'هذه المصفوفة لا تعتمد الإنتاج تلقائيًا؛ هي تقفل الأدلة المطلوبة وتمنع إعلان الجاهزية قبل إغلاق الفجوات.',
          child: Column(
            children: [
              _GateTile(
                title: 'Browser UAT للواجهات العامة والإدارية',
                note:
                    'اختبار /systems/nosok وواجهات التقديم والتتبع والمتابعة ولوحة الإدارة.',
                route: NosokSystemRoutes.adminReadinessEvidence,
                icon: Icons.web_asset_outlined,
              ),
              _GateTile(
                title: 'Role UAT للأدوار والصلاحيات',
                note:
                    'إثبات superuser، مدير نسك، مراجع الطلبات، موظف الدفعات، موظف الوحدة، والمطلع.',
                route: NosokSystemRoutes.adminRoleUat,
                icon: Icons.admin_panel_settings_outlined,
              ),
              _GateTile(
                title: 'خصوصية التتبع العام',
                note:
                    'عدم كشف الاسم/الهوية/الجوال في صفحات التتبع العامة، وحصر البحث الإداري داخل RBAC.',
                route: NosokSystemRoutes.adminTrackingPrivacy,
                icon: Icons.privacy_tip_outlined,
              ),
              _GateTile(
                title: 'SQL UAT وعقود RPC',
                note:
                    'تشغيل rpc_nosok_v20_runtime_contract_uat_v1 بعد تطبيق SQL v20.',
                route: NosokSystemRoutes.adminOperations,
                icon: Icons.storage_outlined,
              ),
              _GateTile(
                title: 'إثبات تكامل الدفع والإشعارات',
                note:
                    'لا توجد بوابة دفع داخل نسك؛ يتم التحقق من bridge/adapters/provider UAT.',
                route: NosokSystemRoutes.adminBillingAdapters,
                icon: Icons.hub_outlined,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'حكم البوابة الحالي',
          subtitle:
              'حتى مع نظافة analyzer والتشغيل المحلي، يبقى الاعتماد الإنتاجي مشروطًا بإرفاق الأدلة وليس بمجرد نجاح التشغيل.',
          child: const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _StatusPill(
                  label: 'Analyzer clean', icon: Icons.check_circle_outline),
              _StatusPill(
                  label: 'Chrome startup passed',
                  icon: Icons.check_circle_outline),
              _StatusPill(
                  label: 'Evidence required',
                  icon: Icons.pending_actions_outlined),
              _StatusPill(
                  label: 'Production not approved', icon: Icons.lock_outline),
            ],
          ),
        ),
      ],
    );
  }
}

class _UatSnapshotRow extends StatelessWidget {
  const _UatSnapshotRow(
      {required this.operationsCount,
      required this.readinessCount,
      required this.roleEvidenceCount,
      required this.privacyCount});
  final int operationsCount;
  final int readinessCount;
  final int roleEvidenceCount;
  final int privacyCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        NosokStatCard(
            label: 'فحوص التشغيل',
            value: operationsCount.toString(),
            subtitle: 'Operational readiness'),
        NosokStatCard(
            label: 'أدلة الجاهزية',
            value: readinessCount.toString(),
            subtitle: 'Production evidence'),
        NosokStatCard(
            label: 'أدلة الأدوار',
            value: roleEvidenceCount.toString(),
            subtitle: 'Role UAT'),
        NosokStatCard(
            label: 'فحوص الخصوصية',
            value: privacyCount.toString(),
            subtitle: 'Public tracking privacy'),
      ],
    );
  }
}

class _GateTile extends StatelessWidget {
  const _GateTile(
      {required this.title,
      required this.note,
      required this.route,
      required this.icon});
  final String title;
  final String note;
  final String route;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(note),
      trailing: const Icon(Icons.chevron_left),
      onTap: () => context.go(route),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label)
        ]),
      ),
    );
  }
}
