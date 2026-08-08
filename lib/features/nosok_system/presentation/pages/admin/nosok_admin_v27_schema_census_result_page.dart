import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v27_schema_gate_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV27SchemaCensusResultPage extends ConsumerWidget {
  const NosokAdminV27SchemaCensusResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV27SchemaGatePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل جرد v27',
        message:
            'تعذر تحميل حزمة جرد السكيما. أعد المحاولة أو راجع ملف الجرد المرفق.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v27 — Database Schema Census Result Intake',
            description:
                'استيعاب الجرد الفعلي المخفف لقاعدة البيانات قبل أي بناء جداول، مع تثبيت أن public ليس owner schema وأن core مصدر البيانات السيادية.',
            badges: const [
              'v27',
              'schema census',
              'read-only intake',
              'no DDL/DML'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: '${data.acceptedFacts} accepted',
                  tone: PwfSisNoticeTone.success),
              PwfSisStatusBadge(
                  label: '${data.pendingFacts} pending',
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: '${data.blockedFacts} blocked boundaries',
                  tone: PwfSisNoticeTone.error),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: const [
              PwfSisMetricCard(
                  label: 'core',
                  value: '37 / 22',
                  subtitle: 'base tables / views — sovereign reference',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'public',
                  value: '9 / 159',
                  subtitle: 'existing base tables / views — wrappers only',
                  icon: Icons.hub_outlined),
              PwfSisMetricCard(
                  label: 'billing_system',
                  value: '4',
                  subtitle: 'payment bridge owner',
                  icon: Icons.payments_outlined),
              PwfSisMetricCard(
                  label: 'nosok',
                  value: 'غير ظاهر',
                  subtitle: 'owner schema requires authorization',
                  icon: Icons.schema_outlined),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قرار الجرد',
            message:
                'LIGHT_GLOBAL_SCHEMA_CENSUS_COMPLETED_READ_ONLY — لا يسمح ببناء جداول جديدة قبل owner review، ولا يسمح بأي base table جديد داخل public.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'حقائق الجرد المعتمدة',
            subtitle:
                'هذه ليست نتيجة إنتاج، بل بوابة منع تكرار الجداول والبيانات السيادية قبل تصميم nosok.*.',
            child: PwfSisDataTable(
              columns: const [
                'البند',
                'القيمة',
                'القرار',
                'الحالة',
                'الملاحظة'
              ],
              rows: [
                for (final fact in data.censusFacts)
                  [
                    Text(fact.titleAr),
                    Text(fact.value),
                    Text(fact.decision),
                    PwfSisStatusBadge(
                        label: fact.status, tone: _tone(fact.status)),
                    Text(fact.noteAr),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

PwfSisNoticeTone _tone(String status) {
  if (status == 'accepted' || status == 'passed')
    return PwfSisNoticeTone.success;
  if (status == 'blocked') return PwfSisNoticeTone.error;
  if (status.startsWith('pending')) return PwfSisNoticeTone.warning;
  return PwfSisNoticeTone.info;
}
