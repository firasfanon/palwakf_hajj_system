import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v27_schema_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV27OwnerSchemaDiffPlanPage extends ConsumerWidget {
  const NosokAdminV27OwnerSchemaDiffPlanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV27SchemaGatePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل Diff Plan',
          message: 'تعذر تحميل خطة الفروقات المقترحة لـ nosok.*.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v27 — Owner Schema Diff Plan',
            description:
                'خطة فروقات بين الجرد الحالي والتصميم المقترح: ما الذي يرشح داخل nosok.*، وما الذي يرفض، وما الذي يؤجل إلى تفويض مستقل.',
            badges: const ['owner schema', 'diff plan', 'guarded-not-applied'],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.createCandidates} create candidates',
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: '${data.wrapperCandidates} public surfaces later',
                  tone: PwfSisNoticeTone.info),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'تنبيه تنفيذي',
            message:
                'هذه الصفحة لا تعني تنفيذ CREATE SCHEMA أو CREATE TABLE. هي خطة owner review فقط، وكل كائن يحتاج RLS/RPC/UAT/rollback قبل SQL.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Owner Schema Diff Plan',
            subtitle:
                'الأسطح العامة اللاحقة تكون views/RPC فقط، وليست base tables.',
            child: PwfSisDataTable(
              columns: const [
                'الكائن المقترح',
                'الإجراء',
                'Owner schema',
                'Public surface',
                'قاعدة core',
                'بوابة التنفيذ'
              ],
              rows: [
                for (final item in data.diffItems)
                  [
                    Text(item.proposedObject),
                    PwfSisStatusBadge(
                        label: item.proposedAction,
                        tone: _tone(item.proposedAction)),
                    Text(item.ownerSchema),
                    Text(item.publicSurface),
                    Text(item.coreReferenceRule),
                    Text(item.executionGate),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

PwfSisNoticeTone _tone(String action) {
  if (action == 'reject' || action.contains('defer'))
    return PwfSisNoticeTone.error;
  if (action.contains('candidate')) return PwfSisNoticeTone.warning;
  return PwfSisNoticeTone.info;
}
