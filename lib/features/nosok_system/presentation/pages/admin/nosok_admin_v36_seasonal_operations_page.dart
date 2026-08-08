import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v36_seasonal_operations_controller.dart';
import '../../../domain/models/nosok_v36_seasonal_operations_contract.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV36SeasonalOperationsPage extends ConsumerWidget {
  const NosokAdminV36SeasonalOperationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV36SeasonalOperationsContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v36 — تحسينات التشغيل الموسمي',
            description:
                'دفعة تشغيل موسمي كبيرة تغطي التقارير المتقدمة، جسر الدفع، document intelligence، مساعد نسك، تحسين الشركات والحملات، تجربة المستخدم، وإضافات سياسة الوزارة. هذه الصفحة تعرض contracts وbridges جاهزة، لكنها لا تفعل أي ربط إنتاجي قبل دمج PalWakf وإنشاء schema نسك.',
            badges: const [
              'v36',
              'seasonal-operations',
              'bridges-disabled',
              'policy-configurable',
              'production-not-approved',
            ],
            actions: const [
              PwfSisStatusBadge(
                label: 'no SQL apply',
                icon: Icons.storage_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
              PwfSisStatusBadge(
                label: 'no waqf_assets mutation',
                icon: Icons.verified_user_outlined,
                tone: PwfSisNoticeTone.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 220,
            children: [
              PwfSisMetricCard(
                label: 'تقارير',
                value: '${contract.reportsCount}',
                subtitle: 'advanced seasonal reporting contracts',
                icon: Icons.query_stats_outlined,
              ),
              PwfSisMetricCard(
                label: 'الدفع',
                value: '${contract.paymentCount}',
                subtitle: 'billing bridge candidates disabled',
                icon: Icons.account_balance_wallet_outlined,
              ),
              PwfSisMetricCard(
                label: 'الوثائق',
                value: '${contract.documentCount}',
                subtitle: 'document intelligence bridge',
                icon: Icons.description_outlined,
              ),
              PwfSisMetricCard(
                label: 'المساعد',
                value: '${contract.assistantCount}',
                subtitle: 'public/internal assistant scopes',
                icon: Icons.smart_toy_outlined,
              ),
              PwfSisMetricCard(
                label: 'الشركات والحملات',
                value: '${contract.campaignCompanyCount}',
                subtitle: 'partner workspace enhancements',
                icon: Icons.business_center_outlined,
              ),
              PwfSisMetricCard(
                label: 'السياسة',
                value: '${contract.policyCount}',
                subtitle: 'ministry-configurable policy addons',
                icon: Icons.policy_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v36 الحاكم',
            message:
                '${contract.databaseDecision}\n${contract.productionDecision}',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          _CapabilityPanel(
            title: 'التقارير المتقدمة',
            subtitle:
                'تقارير موسمية وتجميعية لا تكشف بيانات حساسة ولا تعتمد backend قبل schema.',
            capabilities: contract.advancedReports,
          ),
          const SizedBox(height: 12),
          _CapabilityPanel(
            title: 'ربط الدفع',
            subtitle:
                'Bridge مع billing_system يبقى disabled حتى اعتماد مزود الدفع وRLS/Audit.',
            capabilities: contract.paymentBridge,
          ),
          const SizedBox(height: 12),
          _CapabilityPanel(
            title: 'ربط document intelligence',
            subtitle:
                'مساعد جودة وثائق وتصنيف/OCR لا يقرر بدل الموظف ولا يكتب فوق البيانات الرسمية.',
            capabilities: contract.documentIntelligence,
          ),
          const SizedBox(height: 12),
          _CapabilityPanel(
            title: 'ربط assistant',
            subtitle:
                'نطاق مساعد عام وداخلي محكوم بالسياسة والصلاحيات لا بالذاكرة العامة.',
            capabilities: contract.assistantBridge,
          ),
          const SizedBox(height: 12),
          _CapabilityPanel(
            title: 'تحسين الحملات والشركات',
            subtitle:
                'تحسين Partner Workspace، تخطيط السعة، وبطاقات أداء الشركات دون كشف داخلي للعامة.',
            capabilities: contract.campaignCompanyEnhancements,
          ),
          const SizedBox(height: 12),
          _CapabilityPanel(
            title: 'تحسين تجربة المستخدم',
            subtitle:
                'Anti-Overload UX، mobile cards، ورسائل تشغيل آمنة ضمن PWF-SIS.',
            capabilities: contract.uxEnhancements,
          ),
          const SizedBox(height: 12),
          _CapabilityPanel(
            title: 'إضافات سياسة الوزارة',
            subtitle:
                'كل شرط موسمي قابل للتعديل حسب قرار الوزارة ولا يوجد hardcoding للسياسات.',
            capabilities: contract.ministryPolicyAddons,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Runtime Gates',
            subtitle:
                'بوابات لا يجوز تجاوزها قبل تشغيل التحسينات فعليًا داخل PalWakf.',
            child: Column(
              children: [
                for (final gate in contract.runtimeGates)
                  _RuntimeGateTile(gate: gate)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Acceptance Checklist',
            subtitle: 'ما أنجزته v36 كحزمة تطوير موسمية كبيرة.',
            child: PwfSisTimeline(items: contract.acceptanceChecklist),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'موانع التشغيل الفعلي',
            subtitle:
                'هذه البنود تمنع production candidate ولا تمنع استمرار التطوير قبل الدمج.',
            child: PwfSisTimeline(items: contract.remainingBlockers),
          ),
        ],
      ),
    );
  }
}

class _CapabilityPanel extends StatelessWidget {
  const _CapabilityPanel({
    required this.title,
    required this.subtitle,
    required this.capabilities,
  });

  final String title;
  final String subtitle;
  final List<NosokV36Capability> capabilities;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: title,
      subtitle: subtitle,
      child: PwfSisDataTable(
        columns: const ['العنصر', 'النمط', 'التكامل', 'الأمان', 'الحالة'],
        rows: [
          for (final item in capabilities)
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.titleAr,
                      style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(item.descriptionAr),
                ],
              ),
              Text(item.runtimeMode),
              Text(item.integrationTarget),
              Text(item.securityNoteAr),
              PwfSisStatusBadge(
                  label: item.status, icon: Icons.fact_check_outlined),
            ],
        ],
        cardBuilder: (row) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: row),
      ),
    );
  }
}

class _RuntimeGateTile extends StatelessWidget {
  const _RuntimeGateTile({required this.gate});
  final NosokV36RuntimeGate gate;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.rule_folder_outlined),
        title: Text(gate.titleAr),
        subtitle:
            Text('${gate.requiredEvidenceAr}\nالقرار: ${gate.decisionAr}'),
        trailing: PwfSisStatusBadge(
            label: gate.status, icon: Icons.pending_actions_outlined),
        isThreeLine: true,
      ),
    );
  }
}
