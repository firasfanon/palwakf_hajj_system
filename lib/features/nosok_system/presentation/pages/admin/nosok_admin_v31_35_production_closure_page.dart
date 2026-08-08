import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v31_35_production_closure_controller.dart';
import '../../../domain/models/nosok_v31_35_production_closure_contract.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV31ToV35ProductionClosurePage extends ConsumerWidget {
  const NosokAdminV31ToV35ProductionClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV31ToV35ProductionClosureContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v31–v35 — حزمة الإغلاق الكبرى',
            description:
                'تنفيذ موحد لمسار الدمج مع PalWakf، تصميم schema/RPC/RLS، binding candidate، UAT الكامل، وقرار Production Candidate. هذه الحزمة لا تنشئ schema فعليًا ولا تطبق SQL إنتاجيًا لأن قاعدة نسك ستنشأ بعد الدمج الرسمي مع PalWakf.',
            badges: const [
              'v31-v35',
              'single-large-batch',
              'pre-production-candidate',
              'schema-draft-only',
              'production-not-approved',
            ],
            actions: const [
              PwfSisStatusBadge(
                label: 'backend binding disabled',
                icon: Icons.link_off_outlined,
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
            minTileWidth: 230,
            children: [
              PwfSisMetricCard(
                label: 'v31',
                value: '${contract.mergeExecutionCount}',
                subtitle: 'merge execution items',
                icon: Icons.merge_type_outlined,
              ),
              PwfSisMetricCard(
                label: 'v32',
                value: '${contract.schemaCreationCount}',
                subtitle: contract.databaseDecision,
                icon: Icons.storage_outlined,
              ),
              PwfSisMetricCard(
                label: 'v33',
                value: '${contract.backendBindingCount}',
                subtitle: 'binding candidates disabled',
                icon: Icons.sync_alt_outlined,
              ),
              PwfSisMetricCard(
                label: 'v34',
                value: '${contract.uatClosureCount}',
                subtitle: 'role/responsive UAT cases',
                icon: Icons.devices_outlined,
              ),
              PwfSisMetricCard(
                label: 'v35',
                value: '${contract.productionCandidateCount}',
                subtitle: contract.productionDecision,
                icon: Icons.verified_user_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قرار حاكم',
            message:
                'هذه الحزمة تغلق التطوير الأساسي كحزمة مرشح جاهزية، لكنها لا تعتمد الإنتاج. إنشاء schema نسك وBackend binding الحقيقي ينتظران الدمج الفعلي داخل PalWakf وتطبيق SQL sandbox ومراجعة RLS/RPC.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Stage Gates — v31 إلى v35',
            subtitle:
                'ملخص المراحل الخمس التي طلبت تنفيذها دفعة واحدة، مع القرار التشغيلي لكل مرحلة.',
            child: Column(
              children: [
                for (final gate in contract.stageGates)
                  _StageGateTile(gate: gate)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'v31 — PalWakf Merge Execution',
            subtitle:
                'حزمة تطبيق الدمج داخل PalWakf. لا يمكن إثبات التطبيق الخارجي دون ريبو المنصة الكامل، لذلك تُسلّم كـ application-ready pack.',
            child: Column(
              children: [
                for (final item in contract.mergeExecution)
                  _MergeExecutionTile(item: item)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'v32 — Nosok Schema / RPC / RLS Creation Preparation',
            subtitle:
                'تصميم نهائي قابل للتطبيق في sandbox بعد الدمج فقط. لا CREATE/ALTER/DML إنتاجي داخل هذه الحزمة.',
            child: PwfSisDataTable(
              columns: const ['الكائن', 'النوع', 'الغرض', 'RLS', 'الحالة'],
              rows: [
                for (final item in contract.schemaCreation)
                  [
                    Text(item.objectName),
                    Text(item.objectType),
                    Text(item.purposeAr),
                    Text(item.rlsPolicyAr),
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
            title: 'v33 — Backend Runtime Binding Candidate',
            subtitle:
                'ربط candidate عبر RPCs فقط، ولا يتم تفعيله حتى توجد schema/RPC/RLS مثبتة.',
            child: Column(
              children: [
                for (final item in contract.backendBinding)
                  _BackendBindingTile(item: item)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'v34 — Full Browser / Role / Responsive UAT',
            subtitle:
                'مصفوفة اختبار كاملة داخل PalWakf بعد الدمج. نسخة preview لا تكفي وحدها للاعتماد.',
            child: PwfSisDataTable(
              columns: const [
                'الدور',
                'المسارات',
                'الدليل المطلوب',
                'Responsive',
                'الحالة'
              ],
              rows: [
                for (final item in contract.uatClosure)
                  [
                    Text(item.actorAr),
                    Text(item.routesAr),
                    Text(item.requiredEvidenceAr),
                    Text(item.responsiveScope),
                    PwfSisStatusBadge(
                        label: item.status, icon: Icons.fact_check_outlined),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'v35 — Production Candidate Closure',
            subtitle:
                'قرار candidate مؤجل حتى تغلق أدلة الدمج وSQL وUAT. هذه ليست production-ready.',
            child: Column(
              children: [
                for (final item in contract.productionCandidate)
                  _ProductionCandidateTile(item: item)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Acceptance Checklist',
            subtitle: 'ما تم تثبيته في الحزمة وما يبقى شرطًا قبل الاعتماد.',
            child: PwfSisTimeline(items: contract.acceptanceChecklist),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'موانع الإنتاج المتبقية',
            subtitle: contract.productionDecision,
            child: PwfSisTimeline(items: contract.blockers),
          ),
        ],
      ),
    );
  }
}

class _StageGateTile extends StatelessWidget {
  const _StageGateTile({required this.gate});
  final NosokV31ToV35StageGate gate;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(child: Text(gate.stage.replaceAll('v', ''))),
        title: Text('${gate.stage} — ${gate.titleAr}'),
        subtitle: Text('${gate.deliverableAr}\nالقرار: ${gate.decisionAr}'),
        trailing:
            PwfSisStatusBadge(label: gate.status, icon: Icons.rule_outlined),
        isThreeLine: true,
      ),
    );
  }
}

class _MergeExecutionTile extends StatelessWidget {
  const _MergeExecutionTile({required this.item});
  final NosokV31MergeExecutionItem item;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.integration_instructions_outlined),
        title: Text(item.surfaceAr),
        subtitle: Text('${item.palwakfTarget}\n${item.applicationMode}'),
        trailing: PwfSisStatusBadge(
            label: item.status, icon: Icons.pending_actions_outlined),
        isThreeLine: true,
      ),
    );
  }
}

class _BackendBindingTile extends StatelessWidget {
  const _BackendBindingTile({required this.item});
  final NosokV33BackendBindingItem item;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.sync_alt_outlined),
        title: Text(item.repositorySurface),
        subtitle: Text(
            '${item.rpcContract}\n${item.publicSafetyAr}\n${item.bindingMode}'),
        trailing: PwfSisStatusBadge(
            label: item.status, icon: Icons.link_off_outlined),
        isThreeLine: true,
      ),
    );
  }
}

class _ProductionCandidateTile extends StatelessWidget {
  const _ProductionCandidateTile({required this.item});
  final NosokV35ProductionCandidateItem item;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.verified_user_outlined),
        title: Text(item.gateAr),
        subtitle: Text('${item.requiredClosureAr}\n${item.decisionAr}'),
        trailing: PwfSisStatusBadge(
            label: item.status, icon: Icons.gpp_maybe_outlined),
        isThreeLine: true,
      ),
    );
  }
}
