import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v27_schema_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV27ExistingObjectReconciliationPage extends ConsumerWidget {
  const NosokAdminV27ExistingObjectReconciliationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV27SchemaGatePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل Matrix المطابقة',
          message: 'تعذر تحميل مصفوفة مطابقة الكائنات الموجودة.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v27 — Existing Object Reconciliation Matrix',
            description:
                'مصفوفة مطابقة تمنع بناء جداول مكررة وتوجه نسك إلى استخدام core وbilling_system وplatform_access كمالكين فعليين للبيانات المشتركة.',
            badges: const [
              'reconciliation',
              'no duplicate tables',
              'owner review required'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.reconciliationItems.length} objects',
                  tone: PwfSisNoticeTone.info),
              PwfSisStatusBadge(
                  label: '${data.blockedReconciliation} blocked',
                  tone: data.blockedReconciliation == 0
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.error),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قاعدة المطابقة',
            message:
                'أي كائن موجود في core/platform_access/billing_system لا يعاد بناؤه داخل نسك كمصدر حقيقة. نسك يخزن مفاتيح مرجعية فقط ويقرأ عبر wrappers آمنة.',
            tone: PwfSisNoticeTone.info,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Existing Object Reconciliation Matrix',
            subtitle:
                'القرار هنا يحكم تصميم SQL القادم قبل إنشاء nosok schema.',
            child: PwfSisDataTable(
              columns: const [
                'الكائن',
                'المالك الحالي',
                'استخدام نسك المقترح',
                'القرار',
                'المخاطر',
                'السبب'
              ],
              rows: [
                for (final item in data.reconciliationItems)
                  [
                    Text(item.objectName),
                    Text(item.currentOwner),
                    Text(item.proposedNosokUse),
                    PwfSisStatusBadge(
                        label: item.decision, tone: _tone(item.decision)),
                    Text(item.risk),
                    Text(item.reasonAr),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

PwfSisNoticeTone _tone(String decision) {
  if (decision.contains('blocked')) return PwfSisNoticeTone.error;
  if (decision.contains('reuse')) return PwfSisNoticeTone.success;
  return PwfSisNoticeTone.warning;
}
