import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_backend_controller.dart';
import '../../../domain/models/nosok_lottery_backend_contract.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV28LotteryBackendReadinessPage extends ConsumerWidget {
  const NosokAdminV28LotteryBackendReadinessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokLotteryBackendContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v28B — Sandbox SQL Apply Evidence Intake',
            description:
                'استيعاب نتيجة تطبيق SQL sandbox وReadiness RPC وقرار بوابة الربط. سجل Flutter المحلي ناجح، لكن لا توجد نتيجة SQL apply فعلية مرفقة في v28B، لذلك يبقى الربط مؤجلًا.',
            badges: [
              'v28B',
              'flutter-retest-passed',
              'actual-sql-evidence-missing',
              'readiness-rpc-pending',
              'binding-deferred',
              'production-not-approved'
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 240,
            children: [
              PwfSisMetricCard(
                  label: 'Schema',
                  value: contract.schemaName,
                  subtitle: contract.status,
                  icon: Icons.storage_outlined),
              PwfSisMetricCard(
                  label: 'الجداول',
                  value: '${contract.requiredTables}',
                  subtitle: 'draft contracts',
                  icon: Icons.table_chart_outlined),
              PwfSisMetricCard(
                  label: 'RPCs',
                  value: '${contract.requiredRpcs}',
                  subtitle: 'public/admin wrappers',
                  icon: Icons.api_outlined),
              PwfSisMetricCard(
                  label: 'موانع الإنتاج',
                  value: '${contract.unresolvedBlockers}',
                  subtitle: 'لا اعتماد إنتاج',
                  icon: Icons.gpp_maybe_outlined),
              const PwfSisMetricCard(
                  label: 'قرار الربط',
                  value: 'مؤجل',
                  subtitle: 'لا توجد نتيجة SQL apply/readiness RPC',
                  icon: Icons.link_off_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مخطط الجداول المقترح',
            subtitle:
                'هذه عقود backend draft. التطبيق الفعلي يجب أن يتم أولًا في sandbox وبعد مراجعة RLS/RPC.',
            child: PwfSisDataTable(
              columns: const [
                'الجدول',
                'الغرض',
                'المفاتيح',
                'RLS/Privacy',
                'الحالة'
              ],
              rows: [
                for (final table in contract.tables)
                  [
                    Text(table.name),
                    Text(table.purposeAr),
                    Text(table.keyColumns.join('، ')),
                    Text('${table.privacyGateAr}\n${table.rlsContractAr}'),
                    PwfSisStatusBadge(
                        label: table.stage,
                        icon: Icons.pending_actions_outlined),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'RPC Contracts',
            subtitle:
                'كل RPC مصنف حسب الظهور، سياسة mutation، الدور المطلوب، وسلامة المخرجات.',
            child: Column(
              children: [
                for (final rpc in contract.rpcs) _RpcContractTile(rpc: rpc),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'خطة دمج Supabase الحقيقية',
            subtitle:
                'لا يتم الانتقال من preview إلى repository حقيقي قبل نجاح sandbox + SQL UAT + Role UAT.',
            child: PwfSisTimeline(
              items: [
                for (final step in contract.integrationSteps)
                  '${step.titleAr} — ${step.status}: ${step.descriptionAr}',
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'SQL UAT Matrix',
            subtitle:
                'ملف UAT في هذه الدفعة read-only، أما schema draft فينتهي افتراضيًا بـ ROLLBACK.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 300,
              children: [
                for (final check in contract.uatChecks)
                  _UatCheckCard(check: check),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'موانع الإنتاج',
            subtitle:
                'هذه القائمة تبقى مانعة حتى وصول أدلة Supabase وBrowser/Role UAT بعد الربط الحقيقي.',
            child: PwfSisTimeline(items: contract.productionBlockers),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قرار v28B',
            message:
                'تم قبول نتيجة Flutter المحلية: analyzer clean وChrome startup passed. لم تُرفق نتيجة SQL sandbox apply أو readiness RPC output في v28B، لذلك لا backend binding ولا Production Gate حتى إرفاق SQL UAT وRLS/RPC evidence.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}

class _RpcContractTile extends StatelessWidget {
  const _RpcContractTile({required this.rpc});
  final NosokLotteryBackendRpcContract rpc;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.api_outlined),
        title: Text(rpc.name),
        subtitle: Text(
            '${rpc.purposeAr}\nالظهور: ${rpc.visibility} — السياسة: ${rpc.mutationPolicyAr}\nالدور: ${rpc.requiredRoleAr}\nسلامة المخرجات: ${rpc.outputSafetyAr}'),
        isThreeLine: true,
      ),
    );
  }
}

class _UatCheckCard extends StatelessWidget {
  const _UatCheckCard({required this.check});
  final NosokLotteryBackendUatCheck check;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PwfSisStatusBadge(
                label: check.status, icon: Icons.fact_check_outlined),
            const SizedBox(height: 10),
            Text(check.titleAr, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(check.sqlSurfaceAr),
            const SizedBox(height: 8),
            Text(check.expectedResultAr),
          ],
        ),
      ),
    );
  }
}
