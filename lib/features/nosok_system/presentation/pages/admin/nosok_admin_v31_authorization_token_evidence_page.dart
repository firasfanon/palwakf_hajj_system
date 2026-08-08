import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v31_apply_certification_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV31AuthorizationTokenEvidencePage extends ConsumerWidget {
  const NosokAdminV31AuthorizationTokenEvidencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV31ApplyCertificationPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل v31',
          message: 'تعذر تحميل أدلة التفويض.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v31 — Owner Authorization Token Evidence Intake',
            description:
                'استيعاب تفويض المستخدم كدليل نية وربطه ببوابة تشغيل staging. لا يعني ذلك أن DDL نُفذ أو أن schema أُنشئت؛ الاعتماد يحتاج نتيجة SQL لاحقة.',
            badges: const [
              'v31',
              'authorization evidence',
              'operator binding required'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: data.decision.decision, tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'accepted evidence',
                  value: '${data.acceptedAuthorizationEvidenceCount}',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'pending/blocking',
                  value: '${data.pendingAuthorizationEvidenceCount}',
                  icon: Icons.lock_clock_outlined),
              const PwfSisMetricCard(
                  label: 'DDL execution',
                  value: 'not certified',
                  icon: Icons.storage_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
              title: 'قرار v31',
              message: data.decision.summaryAr,
              tone: PwfSisNoticeTone.warning),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Authorization Token Evidence Matrix',
            subtitle:
                'تمييز بين تفويض المستخدم، وربط operator، وشرط staging/backup قبل أي apply.',
            child: PwfSisDataTable(
              columns: const [
                'البند',
                'الدليل/القيمة',
                'الحالة',
                'القرار',
                'ملاحظات'
              ],
              rows: [
                for (final item in data.authorizationEvidence)
                  [
                    Text(item.labelAr),
                    Text(item.evidenceValue),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.accepted
                            ? PwfSisNoticeTone.success
                            : item.blocked
                                ? PwfSisNoticeTone.error
                                : PwfSisNoticeTone.warning),
                    Text(item.decision),
                    Text(item.notesAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisPanel(
                  title: 'المسموح التالي',
                  child: Text(data.decision.allowedNextStepAr)),
              PwfSisPanel(
                  title: 'المحظور', child: Text(data.decision.blockedAr)),
            ],
          ),
        ],
      ),
    );
  }
}
