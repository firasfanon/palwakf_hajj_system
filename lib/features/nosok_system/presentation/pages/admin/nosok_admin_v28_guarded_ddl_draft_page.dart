import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v28_owner_schema_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV28GuardedDdlDraftPage extends ConsumerWidget {
  const NosokAdminV28GuardedDdlDraftPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV28OwnerSchemaDesignPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل DDL draft',
          message: 'تعذر تحميل حزمة SQL draft.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v28 — Guarded DDL Draft Pack',
            description:
                'حزمة SQL محروسة ومعدة للمراجعة فقط. لا يوجد تنفيذ DDL داخل هذه الدفعة ولا إنشاء فعلي لـ nosok schema.',
            badges: const [
              'DDL draft',
              'not applied',
              'explicit authorization required'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: data.executionGate.decision,
                  tone: PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisPanel(
                  title: 'ملف التحقق read-only',
                  child: const Text(
                      'sql/26_nosok_v28_owner_schema_design_read_only.sql')),
              PwfSisPanel(
                  title: 'DDL draft محروس',
                  child: const Text(
                      'sql/guarded_not_applied/nosok_v28/01_nosok_owner_schema_guarded_ddl_DRAFT_NOT_RUN.sql')),
              PwfSisPanel(
                  title: 'Rollback draft',
                  child: const Text(
                      'sql/guarded_not_applied/nosok_v28/02_nosok_owner_schema_rollback_DRAFT_NOT_RUN.sql')),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
              title: 'ملخص التنفيذ',
              message: data.executionGate.summaryAr,
              tone: PwfSisNoticeTone.warning),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'الحارس التنفيذي',
            message:
                'ملف DDL يحتوي blocker افتراضي. يجب إزالة/تعديل الحارس فقط بعد owner authorization مكتوب ومراجعة RLS/RPC/UAT/rollback.',
            tone: PwfSisNoticeTone.error,
          ),
        ],
      ),
    );
  }
}
