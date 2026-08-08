import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v36_binding_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV36ProductionGateRedecisionPage extends ConsumerWidget {
  const NosokAdminV36ProductionGateRedecisionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV36BindingPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل v36',
        message: 'تعذر تحميل حزمة Nosok v36. راجع console وسجل Riverpod.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v36 — Production Gate Re-decision',
            description:
                'إعادة قرار الإنتاج بعد تطبيق owner schema وpublic wrappers/RPCs، مع فصل staging readiness عن production approval.',
            badges: [
              'production gate',
              'staging only',
              'no public base tables'
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'ملخص القرار',
            subtitle: data.productionGateDecision.decision,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PwfSisNotice(
                  title: 'المقبول',
                  message: data.productionGateDecision.acceptedAr,
                  tone: PwfSisNoticeTone.success,
                ),
                const SizedBox(height: 8),
                PwfSisNotice(
                  title: 'المحجوب',
                  message: data.productionGateDecision.blockedAr,
                  tone: PwfSisNoticeTone.error,
                ),
                const SizedBox(height: 8),
                PwfSisNotice(
                  title: 'الخطوة التالية',
                  message: data.productionGateDecision.nextStepAr,
                  tone: PwfSisNoticeTone.info,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مؤشرات v36',
            child: PwfSisAdaptiveWorkspace(
              children: [
                PwfSisMetricCard(
                    label: 'أدلة SQL مقبولة',
                    value: '${data.acceptedEvidenceCount}',
                    subtitle: 'من أصل ${data.evidenceItems.length}',
                    icon: Icons.fact_check_outlined),
                PwfSisMetricCard(
                    label: 'حالات UAT pending',
                    value: '${data.pendingRuntimeCaseCount}',
                    subtitle: 'Browser/Role/Scope',
                    icon: Icons.rule_folder_outlined),
                PwfSisMetricCard(
                    label: 'Adapter methods',
                    value: '${data.adapterMethodCount}',
                    subtitle: 'public wrapper only',
                    icon: Icons.api_outlined),
                PwfSisMetricCard(
                    label: 'Binding candidates',
                    value: '${data.bindingCandidateCount}',
                    subtitle: 'staging candidates only',
                    icon: Icons.sync_alt_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
