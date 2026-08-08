import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v37_runtime_switch_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV37ProductionGateRedecisionPage extends ConsumerWidget {
  const NosokAdminV37ProductionGateRedecisionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV37RuntimeSwitchPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل قرار v37',
        message: 'تعذر تحميل Production Gate Re-decision. راجع Console.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v37 — Production Gate Re-decision',
            description:
                'إعادة قرار الإنتاج بعد أدلة browser وSQL، مع إبقاء الإنتاج محجوبًا لأن runtime repository switch لم يثبت عبر Network بعد.',
            badges: [
              'production deferred',
              'binding pending',
              'no waqf mutation'
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قرار الإنتاج',
            subtitle: data.repositoryBindingDecision.decision,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PwfSisNotice(
                  title: 'المسموح الآن',
                  message: data.repositoryBindingDecision.allowedNowAr,
                  tone: PwfSisNoticeTone.info,
                ),
                const SizedBox(height: 10),
                PwfSisNotice(
                  title: 'المحجوب',
                  message: data.repositoryBindingDecision.blockedAr,
                  tone: PwfSisNoticeTone.error,
                ),
                const SizedBox(height: 10),
                PwfSisNotice(
                  title: 'الخطوة التالية',
                  message: data.repositoryBindingDecision.nextStepAr,
                  tone: PwfSisNoticeTone.warning,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'Production not approved',
            message:
                'لا production approval، لا platformHosted binding، لا public submit/track switch، ولا Admin RPC binding حتى إغلاق v38/v39 evidence.',
            tone: PwfSisNoticeTone.error,
          ),
        ],
      ),
    );
  }
}
