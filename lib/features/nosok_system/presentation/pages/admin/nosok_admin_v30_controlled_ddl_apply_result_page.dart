import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v30_apply_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV30ControlledDdlApplyResultPage extends ConsumerWidget {
  const NosokAdminV30ControlledDdlApplyResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV30ApplyGatePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل نتيجة DDL',
          message: 'تعذر تحميل بوابة استيعاب نتيجة تطبيق DDL.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v30 — Controlled DDL Apply Result Intake',
            description:
                'استيعاب نتيجة تطبيق DDL المحروس. الحالة الحالية: لم تُرفق نتيجة تشغيل DDL، ولم يتم إنشاء nosok schema أو nosok tables ضمن هذه الحزمة.',
            badges: const ['apply result', 'not applied', 'staging only'],
            actions: const [
              PwfSisStatusBadge(
                  label: 'apply-not-authorized', tone: PwfSisNoticeTone.error)
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'لا يوجد تطبيق DDL مثبت',
            message:
                'نتيجة v29 preflight تقرأ nosok_present=false. لذلك تعد هذه الصفحة intake/gate فقط وليست إثبات تطبيق.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Controlled DDL Apply Result Matrix',
            subtitle:
                'كل نتيجة apply يجب أن تأتي من DBA/operator بعد تشغيل guarded SQL على staging فقط.',
            child: PwfSisDataTable(
              columns: const ['البند', 'المتوقع', 'الفعلي', 'الحالة'],
              rows: [
                for (final item in data.applyResults)
                  [
                    Text(item.labelAr),
                    Text(item.expectedAr),
                    Text(item.actualAr),
                    PwfSisStatusBadge(
                        label: item.status,
                        tone: item.accepted
                            ? PwfSisNoticeTone.success
                            : item.blocked
                                ? PwfSisNoticeTone.error
                                : PwfSisNoticeTone.warning),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisPanel(
            title: 'SQL Result Intake Rule',
            subtitle: 'لا تقبل نتيجة تشغيل بدون أدلة.',
            child: Text(
                'المطلوب لإغلاق هذه الصفحة: owner_authorization_id، staging target، backup evidence، full SQL output، counts بعد التطبيق، RLS enabled proof، no-public-base-table proof، وrollback readiness.'),
          ),
        ],
      ),
    );
  }
}
