import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v29_authorization_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV29StagingApplyGatePage extends ConsumerWidget {
  const NosokAdminV29StagingApplyGatePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV29AuthorizationPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل بوابة staging',
          message: 'تعذر تحميل خطوات تطبيق staging.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v29 — Staging Apply Gate',
            description:
                'بوابة تنفيذ محروسة. الملف الوحيد المسموح الآن هو read-only preflight؛ ملفات CREATE SCHEMA/CREATE TABLE بقيت داخل guarded_not_applied.',
            badges: const [
              'staging gate',
              'guarded-not-applied',
              'read-only first'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: data.productionGateDecision.decision,
                  tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
              title: 'قرار البوابة',
              message: data.productionGateDecision.summaryAr,
              tone: PwfSisNoticeTone.warning),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisPanel(
                  title: 'المسموح التالي',
                  child: Text(data.productionGateDecision.nextAllowedStepAr)),
              PwfSisPanel(
                  title: 'المحظور',
                  child: Text(data.productionGateDecision.blockedAr)),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Staging Apply Order',
            subtitle:
                'ترتيب التشغيل المقترح. لا تشغّل ملفات guarded قبل استبدال authorization placeholders وتوثيق النسخة الاحتياطية.',
            child: PwfSisDataTable(
              columns: const [
                '#',
                'الخطوة',
                'الوضع',
                'الملف',
                'مسموح الآن',
                'المطلوب قبل التشغيل'
              ],
              rows: [
                for (final step in data.applySteps)
                  [
                    Text('${step.order}'),
                    Text(step.titleAr),
                    Text(step.executionMode),
                    Text(step.filePath),
                    PwfSisStatusBadge(
                        label: step.allowed ? 'yes' : 'no',
                        tone: step.allowed
                            ? PwfSisNoticeTone.success
                            : PwfSisNoticeTone.error),
                    Text(step.requiredBeforeRunAr),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
