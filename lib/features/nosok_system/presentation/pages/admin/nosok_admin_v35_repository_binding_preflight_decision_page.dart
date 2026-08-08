import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v35_wrapper_apply_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV35RepositoryBindingPreflightDecisionPage
    extends ConsumerWidget {
  const NosokAdminV35RepositoryBindingPreflightDecisionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV35WrapperApplyPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل قرار الربط',
        message: 'تعذر تحميل preflight الخاص بربط المستودعات.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v35 — Repository Binding Preflight Decision',
            description:
                'قرار أولي لربط repositories بعد تطبيق public wrappers/RPCs، مع إبقاء platformHosted محجوبًا حتى Browser/Role evidence.',
            badges: ['repository binding', 'preflight', 'platform gate'],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Repository Modes',
            subtitle:
                'لا يوجد direct Flutter access إلى nosok.*. الربط يكون عبر public RPC wrappers فقط.',
            child: PwfSisDataTable(
              columns: const [
                'mode',
                'قبل wrapper apply',
                'بعد post-apply evidence',
                'الدليل المطلوب'
              ],
              rows: [
                for (final item in data.repositoryBindingPreflight)
                  [
                    Text(item.mode),
                    PwfSisStatusBadge(
                        label: item.allowedBeforeWrapperApply
                            ? 'allowed'
                            : 'blocked',
                        tone: item.allowedBeforeWrapperApply
                            ? PwfSisNoticeTone.success
                            : PwfSisNoticeTone.error),
                    PwfSisStatusBadge(
                        label: item.allowedAfterWrapperEvidence
                            ? 'candidate'
                            : 'blocked',
                        tone: item.allowedAfterWrapperEvidence
                            ? PwfSisNoticeTone.warning
                            : PwfSisNoticeTone.error),
                    Text(item.requiredEvidenceAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'المحظور حتى الآن',
            message: data.gateDecision.blockedAr,
            tone: PwfSisNoticeTone.error,
          ),
        ],
      ),
    );
  }
}
