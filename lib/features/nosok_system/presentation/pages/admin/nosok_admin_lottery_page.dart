import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_lottery_controller.dart';
import '../../../domain/models/nosok_lottery_policy.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLotteryPage extends ConsumerWidget {
  const NosokAdminLotteryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(nosokLotteryDashboardProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'إدارة قرعة الحج — Nosok v27D',
            description:
                'تشغيل حاكم لقرعة الحج حسب LGU المشتق من عنوان البطاقة الشخصية، مع سياسة موسم قابلة للتعديل، قرعة capacity-aware، وقاعدة لجنة الحج للحصص غير المستكملة.',
            badges: [
              'v27D',
              'LGU quota',
              'policy configurable',
              'committee governed'
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'ملخص سياسة الموسم',
            subtitle: state.policy.notesAr,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PwfSisRuntimeState(
                    label: 'الموسم', value: state.policy.seasonCode, ok: true),
                PwfSisRuntimeState(
                    label: 'نسخة السياسة',
                    value: state.policy.policyVersion,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'حصة الحج الوطنية',
                    value:
                        '${state.policy.totalNationalHajjQuota ?? 'غير مثبتة'}',
                    ok: state.policy.totalNationalHajjQuota != null),
                PwfSisRuntimeState(
                    label: 'مصدر العنوان', value: 'البطاقة الشخصية', ok: true),
                PwfSisRuntimeState(
                    label: 'معامل الحصة',
                    value: '1/${state.policy.quotaDivisor}',
                    ok: true),
                PwfSisRuntimeState(
                    label: 'الحصة غير المستكملة',
                    value: state.policy.underfilledQuotaPolicy.labelAr,
                    ok: false),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مؤشرات القرعة',
            subtitle:
                'تعرض ملخصًا فقط؛ التفاصيل في صفحات الأهلية، التنفيذ، الانتظار، اللجنة، والتدقيق.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 220,
              children: [
                PwfSisMetricCard(
                    label: 'إجمالي السعة',
                    value: '${state.totalCapacity}',
                    subtitle: 'أشخاص لا طلبات',
                    icon: Icons.groups_outlined),
                PwfSisMetricCard(
                    label: 'المختارون أفرادًا',
                    value: '${state.selectedPeople}',
                    subtitle: 'حسب LGU',
                    icon: Icons.verified_outlined),
                PwfSisMetricCard(
                    label: 'المتبقي',
                    value: '${state.remainingCapacity}',
                    subtitle: 'يتطلب لجنة عند التعذر',
                    icon: Icons.hourglass_bottom_outlined),
                PwfSisMetricCard(
                    label: 'طلبات انتظار',
                    value: '${state.waitingListCount}',
                    subtitle: 'منفصلة لكل تجمع',
                    icon: Icons.format_list_numbered_outlined),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'حصص التجمعات — snapshot موسمي',
            subtitle:
                'الأرقام قابلة للتعديل قبل التثبيت فقط، ثم تصبح snapshot تدقيقي للموسم.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 270,
              children: [
                for (final quota in state.lguQuotas) _LguQuotaCard(quota: quota)
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Evidence',
            subtitle:
                'لا توجد قرعة إنتاجية هنا. هذه واجهة staging للعقد والحكم التشغيلي.',
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                PwfSisRuntimeState(
                    label: 'run id', value: state.evidence.runId, ok: true),
                PwfSisRuntimeState(
                    label: 'algorithm',
                    value: state.evidence.algorithmVersion,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'policy hash',
                    value: state.evidence.policySnapshotHash,
                    ok: true),
                PwfSisRuntimeState(
                    label: 'committee LGUs',
                    value: '${state.evidence.committeeRequiredLgus}',
                    ok: state.evidence.committeeRequiredLgus == 0),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'بوابة إنتاج مغلقة',
            message:
                'تشغيل القرعة الفعلي يحتاج SQL/RPC إنتاجي مصرح، Role UAT، Browser UAT، وسجل Audit غير قابل للحذف. هذه الدفعة لا تنفذ SQL إنتاجي ولا تعتمد الإنتاج.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}

class _LguQuotaCard extends StatelessWidget {
  const _LguQuotaCard({required this.quota});
  final NosokLguQuotaSnapshot quota;

  @override
  Widget build(BuildContext context) {
    return PwfSisServiceCard(
      icon: quota.requiresCommittee
          ? Icons.gavel_outlined
          : Icons.location_city_outlined,
      title: '${quota.lguNameAr} — ${quota.governorateAr}',
      description:
          'السكان: ${quota.populationSnapshot}. الحصة المحسوبة: ${quota.calculatedQuota}. الحصة النهائية: ${quota.finalCapacity}. المختارون أفرادًا: ${quota.selectedPeople}. المتبقي: ${quota.remainingCapacity}. ${quota.status.labelAr}.',
    );
  }
}
