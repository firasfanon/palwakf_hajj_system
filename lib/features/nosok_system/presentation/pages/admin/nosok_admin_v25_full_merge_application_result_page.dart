import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v25_candidate_controller.dart';
import '../../../domain/models/nosok_v25_candidate_models.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV25FullMergeApplicationResultPage extends ConsumerWidget {
  const NosokAdminV25FullMergeApplicationResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV25EvidencePackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
        title: 'تعذر تحميل حزمة v25',
        message:
            'تعذر تحميل بيانات الاستيعاب. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.',
        tone: PwfSisNoticeTone.error,
      ),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v25 — Full PalWakf Merge Application Result Intake',
            description:
                'سطح إداري لتسجيل نتيجة التطبيق الحقيقي داخل منصة PalWakf، وليس داخل بيئة preview.',
            badges: const ['v25', 'real merge', 'palwakf repo'],
            actions: [
              PwfSisStatusBadge(
                  label: data.decision.status,
                  tone: data.decision.isCandidate
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'P0 blockers: ${data.blockers}',
                  tone: data.blockers == 0
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.error),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            children: [
              PwfSisMetricCard(
                  label: 'إجمالي الفحوص',
                  value: '${data.totalChecks}',
                  subtitle: 'جميع محاور v25'),
              PwfSisMetricCard(
                  label: 'Passed',
                  value: '${data.passedChecks}',
                  subtitle: 'أدلة مقبولة أو مستوعبة',
                  icon: Icons.check_circle_outline),
              PwfSisMetricCard(
                  label: 'Pending',
                  value: '${data.pendingChecks}',
                  subtitle: 'تحتاج دليل تشغيل',
                  icon: Icons.pending_actions_outlined),
              PwfSisMetricCard(
                  label: 'Blockers',
                  value: '${data.blockers}',
                  subtitle: 'تمنع production-candidate',
                  icon: Icons.block_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'هذه الصفحة تسجل نتيجة تطبيق الدمج الحقيقي',
            message:
                'لا يمكن اعتبار Full PalWakf Merge مغلقًا من داخل preview host. يجب تنفيذ platform_real_merge_pack داخل ريبو PalWakf الكامل ثم إرفاق سجل التطبيق.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          _V25EvidenceSectionPanel(section: data.mergeApplication),
          const SizedBox(height: 12),
          _V25EvidenceSectionPanel(section: data.supabaseEvidence),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'ترتيب التطبيق داخل PalWakf',
            subtitle:
                'يجب تنفيذ هذه الخطوات بنفس الترتيب لتقليل خطر كسر GoRouter/RBAC.',
            child: const PwfSisTimeline(
              items: [
                'نسخ lib/features/nosok_system إلى ريبو PalWakf الكامل.',
                'ربط nosok route group داخل GoRouter الحقيقي مع الحفاظ على /services/nosok وaliases القديمة.',
                'تطبيق nosokAccessProfileProvider override من AccessProfile الحقيقي.',
                'تسجيل النظام في Dynamic Registry وSystem Sections وصلاحيات RBAC.',
                'تشغيل SQL UAT read-only ثم إرسال النتائج للاستيعاب.',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _V25EvidenceSectionPanel extends StatelessWidget {
  const _V25EvidenceSectionPanel({required this.section});

  final NosokV25EvidenceSection section;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: section.titleAr,
      subtitle: section.descriptionAr,
      actions: [
        PwfSisStatusBadge(
            label: '${section.passedCount}/${section.total} passed',
            tone: section.blockedCount == 0
                ? PwfSisNoticeTone.success
                : PwfSisNoticeTone.warning),
        if (section.blockedCount > 0)
          PwfSisStatusBadge(
              label: '${section.blockedCount} blocked',
              tone: PwfSisNoticeTone.error),
      ],
      child: PwfSisDataTable(
        columns: const ['البند', 'الحالة', 'الأولوية', 'المسؤول', 'الملاحظة'],
        rows: [
          for (final item in section.items)
            [
              Text(item.titleAr),
              PwfSisStatusBadge(
                  label: item.status, tone: _toneForStatus(item.status)),
              Text(item.priority),
              Text(item.ownerAr),
              Text(item.noteAr),
            ],
        ],
      ),
    );
  }
}

PwfSisNoticeTone _toneForStatus(String status) {
  if (status == 'passed' || status == 'ready') return PwfSisNoticeTone.success;
  if (status == 'blocked') return PwfSisNoticeTone.error;
  if (status.startsWith('pending')) return PwfSisNoticeTone.warning;
  return PwfSisNoticeTone.info;
}
