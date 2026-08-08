import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v37_runtime_switch_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV37BrowserEvidenceResultIntakePage extends ConsumerWidget {
  const NosokAdminV37BrowserEvidenceResultIntakePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV37RuntimeSwitchPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل أدلة v37',
        message: 'تعذر تحميل Browser Evidence Result Intake. راجع Console.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v37 — Browser Evidence Result Intake',
            description:
                'استيعاب لقطات الواجهة العامة والداخلية وصفحة الأدوار مع تمييز ما يثبت render وما لا يثبت بعد RPC runtime switch.',
            badges: ['browser evidence', 'console clean', 'network pending'],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'أدلة v37 المستلمة',
            subtitle:
                'اللقطات تثبت render/console startup، أما Network RPC calls فما زالت مطلوبة قبل الاعتماد.',
            child: PwfSisDataTable(
              columns: const ['البند', 'الحالة', 'الدليل', 'القرار'],
              rows: [
                for (final item in data.evidenceItems)
                  [
                    Text(item.titleAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      tone: item.accepted
                          ? PwfSisNoticeTone.success
                          : item.pending
                              ? PwfSisNoticeTone.warning
                              : PwfSisNoticeTone.error,
                    ),
                    Text(item.evidenceAr),
                    Text(item.decisionAr),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصفوفة Browser/Network/Role Evidence',
            subtitle:
                'هذه المصفوفة تحدد ما أغلقته اللقطات وما يحتاج أدلة إضافية.',
            child: PwfSisDataTable(
              columns: const [
                'case',
                'actor',
                'surface',
                'observed evidence',
                'network evidence',
                'status'
              ],
              rows: [
                for (final item in data.browserEvidenceCases)
                  [
                    Text(item.caseKey),
                    Text(item.actorAr),
                    Text(item.surface),
                    Text(item.observedEvidenceAr),
                    Text(item.networkEvidenceAr),
                    PwfSisStatusBadge(
                      label: item.status,
                      tone: item.accepted
                          ? PwfSisNoticeTone.success
                          : item.pending
                              ? PwfSisNoticeTone.warning
                              : PwfSisNoticeTone.error,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'حد الدليل',
            message:
                'ظهور الصفحة لا يعني أن repository binding يعمل عبر RPC. يجب إظهار Network calls للـ RPCs أو تنفيذ فحص adapter مخصص في v38.',
            tone: PwfSisNoticeTone.info,
          ),
        ],
      ),
    );
  }
}
