import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v30_apply_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV30AuthorizationTokenIntakePage extends ConsumerWidget {
  const NosokAdminV30AuthorizationTokenIntakePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV30ApplyGatePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل v30',
          message: 'تعذر تحميل استيعاب تفويض DDL.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title:
                'Nosok v30 — Owner Schema Staging Apply Authorization Token Intake',
            description:
                'استيعاب تفويض تشغيل DDL على staging. لا يتم اعتبار عنوان الدفعة تفويضًا تنفيذيًا؛ يلزم owner_authorization_id وbackup وstaging target قبل أي CREATE SCHEMA أو CREATE TABLE.',
            badges: const ['v30', 'authorization token', 'ddl blocked'],
            actions: [
              PwfSisStatusBadge(
                  label: data.decision.decision, tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'accepted tokens',
                  value: '${data.acceptedTokenCount}',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'blocked tokens',
                  value: '${data.blockedTokenCount}',
                  icon: Icons.lock_outline),
              const PwfSisMetricCard(
                  label: 'nosok schema',
                  value: 'not created',
                  subtitle: 'حسب v29 preflight',
                  icon: Icons.schema_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
              title: 'قرار v30',
              message: data.decision.summaryAr,
              tone: PwfSisNoticeTone.warning),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Authorization Token Intake Matrix',
            subtitle:
                'هذه المصفوفة تفرّق بين طلب تجهيز الحزمة وبين تفويض تشغيل DDL الفعلي.',
            child: PwfSisDataTable(
              columns: const ['البند', 'القيمة', 'الحالة', 'القرار', 'الدليل'],
              rows: [
                for (final item in data.authorizationTokens)
                  [
                    Text(item.labelAr),
                    Text(item.value),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.accepted
                            ? PwfSisNoticeTone.success
                            : item.blocked
                                ? PwfSisNoticeTone.error
                                : PwfSisNoticeTone.warning),
                    Text(item.decision),
                    Text(item.evidenceAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisPanel(
                  title: 'المسموح التالي',
                  child: Text(data.decision.nextAllowedStepAr)),
              PwfSisPanel(
                  title: 'المحظور الآن', child: Text(data.decision.blockedAr)),
            ],
          ),
        ],
      ),
    );
  }
}
