import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v28_owner_schema_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV28ExecutionAuthorizationGatePage extends ConsumerWidget {
  const NosokAdminV28ExecutionAuthorizationGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV28OwnerSchemaDesignPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل بوابة التفويض',
          message: 'تعذر تحميل gate v28.',
          tone: PwfSisNoticeTone.error),
      data: (data) {
        final gate = data.executionGate;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PwfSisSystemHero(
              title: 'Nosok v28 — Execution Authorization Gate',
              description:
                  'بوابة تمنع تشغيل SQL قبل تفويض مستقل لإنشاء nosok.* فقط. الإنتاج والقرعة والدفع الحقيقي تبقى مغلقة.',
              badges: const [
                'authorization gate',
                'production blocked',
                'nosok.* only'
              ],
              actions: [
                PwfSisStatusBadge(
                    label: gate.decision,
                    tone: gate.executionAllowed
                        ? PwfSisNoticeTone.success
                        : PwfSisNoticeTone.error)
              ],
            ),
            const SizedBox(height: 12),
            PwfSisNotice(
                title: 'قرار البوابة',
                message: gate.summaryAr,
                tone: gate.executionAllowed
                    ? PwfSisNoticeTone.success
                    : PwfSisNoticeTone.error),
            const SizedBox(height: 12),
            PwfSisAdaptiveWorkspace(
              children: [
                PwfSisPanel(
                    title: 'المسموح الآن', child: Text(gate.allowedNowAr)),
                PwfSisPanel(
                    title: 'الممنوع الآن', child: Text(gate.blockedNowAr)),
                PwfSisPanel(
                    title: 'التفويض المطلوب',
                    child: Text(gate.requiredAuthorizationAr)),
              ],
            ),
            const SizedBox(height: 12),
            const PwfSisNotice(
              title: 'قرار v28',
              message:
                  'GUARDED_DDL_DRAFT_PREPARED_NOT_APPLIED — لا CREATE SCHEMA، لا CREATE TABLE، لا GRANT، لا DML، ولا public base tables في هذه الحزمة.',
              tone: PwfSisNoticeTone.warning,
            ),
          ],
        );
      },
    );
  }
}
