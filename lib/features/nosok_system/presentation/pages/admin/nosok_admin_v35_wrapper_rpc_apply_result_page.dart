import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v35_wrapper_apply_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV35WrapperRpcApplyResultPage extends ConsumerWidget {
  const NosokAdminV35WrapperRpcApplyResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV35WrapperApplyPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل v35',
        message: 'تعذر تحميل نتيجة تطبيق public wrapper/RPC.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title:
                'Nosok v35 — Public Wrapper/RPC Controlled Staging Apply Result',
            description:
                'بوابة استيعاب نتيجة تطبيق public views/RPC على staging فقط، دون إنشاء أي public base tables.',
            badges: const ['v35', 'controlled apply', 'staging only'],
            actions: [
              PwfSisStatusBadge(
                  label: data.gateDecision.decision,
                  tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'accepted',
                  value: '${data.acceptedCount}',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'ready',
                  value: '${data.readyCount}',
                  icon: Icons.play_circle_outline),
              PwfSisMetricCard(
                  label: 'wrappers/RPC',
                  value: '${data.wrapperCount}',
                  icon: Icons.api_outlined),
              PwfSisMetricCard(
                  label: 'pending UAT',
                  value: '${data.pendingCount}',
                  icon: Icons.pending_actions_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v35',
            message: data.gateDecision.summaryAr,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Apply Result Intake Matrix',
            subtitle:
                'هذه اللوحة تفرق بين التفويض، التشغيل، ونتيجة ما بعد التشغيل.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'العنوان',
                'الحالة',
                'الدليل',
                'القرار'
              ],
              rows: [
                for (final item in data.applyResultItems)
                  [
                    Text(item.key),
                    Text(item.titleAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      tone: item.accepted
                          ? PwfSisNoticeTone.success
                          : item.blocked
                              ? PwfSisNoticeTone.error
                              : PwfSisNoticeTone.warning,
                    ),
                    Text(item.evidenceAr),
                    Text(item.decisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'SQL التالي',
            subtitle: 'لا يعمل production، ولا يغيّر waqf/awqaf_system.',
            child: Text(data.gateDecision.nextSqlAr),
          ),
        ],
      ),
    );
  }
}
