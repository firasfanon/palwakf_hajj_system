import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v27_schema_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV27SafeSqlExecutionGatePage extends ConsumerWidget {
  const NosokAdminV27SafeSqlExecutionGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV27SchemaGatePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل بوابة SQL',
          message: 'تعذر تحميل قرار بوابة التنفيذ الآمن.',
          tone: PwfSisNoticeTone.error),
      data: (data) {
        final decision = data.safeSqlGateDecision;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PwfSisSystemHero(
              title: 'Nosok v27 — Safe SQL Execution Gate',
              description:
                  'قرار صريح بشأن ما يسمح وما يمنع بعد الجرد: لا تنفيذ DDL/DML قبل تفويض مستقل وتصميم owner schema كامل.',
              badges: const [
                'safe sql gate',
                'blocked until authorization',
                'read-only proof'
              ],
              actions: [
                PwfSisStatusBadge(
                    label: decision.status,
                    tone: decision.executionAllowed
                        ? PwfSisNoticeTone.success
                        : PwfSisNoticeTone.error)
              ],
            ),
            const SizedBox(height: 12),
            PwfSisNotice(
                title: 'قرار البوابة',
                message: decision.reasonAr,
                tone: decision.executionAllowed
                    ? PwfSisNoticeTone.success
                    : PwfSisNoticeTone.error),
            const SizedBox(height: 12),
            PwfSisAdaptiveWorkspace(
              children: [
                PwfSisPanel(
                    title: 'المسموح الآن', child: Text(decision.allowedNowAr)),
                PwfSisPanel(
                    title: 'الممنوع الآن', child: Text(decision.blockedNowAr)),
                PwfSisPanel(
                    title: 'التفويض التالي المطلوب',
                    child: Text(decision.nextAuthorizationAr)),
              ],
            ),
            const SizedBox(height: 12),
            const PwfSisNotice(
              title: 'Read-only SQL Pack',
              message:
                  'الملف sql/25_nosok_v27_schema_census_owner_diff_safe_gate_read_only.sql مخصص للتحقق فقط: لا CREATE ولا ALTER ولا INSERT ولا UPDATE ولا DELETE.',
              tone: PwfSisNoticeTone.info,
            ),
          ],
        );
      },
    );
  }
}
