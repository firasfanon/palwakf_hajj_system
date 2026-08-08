import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_legal_lottery_regulation_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38ELegalLotteryAlignmentPage extends ConsumerWidget {
  const NosokAdminV38ELegalLotteryAlignmentPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokLegalLotteryRegulationContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v38E — مواءمة القانون وخوارزمية القرعة',
            description:
                'دفعة تحضيرية إلزامية قبل أي انضمام للمنصة. تم اعتماد أثر ${contract.regulationTitleAr} داخل عقد نسك، وتحديث نموذج القرعة من capacity-aware فقط إلى legal-algorithm-aware.',
            badges: const [
              'v38E',
              'legal-intake',
              'lottery-algorithm',
              'pre-join-only',
              'no-schema-apply'
            ],
            actions: const [
              PwfSisStatusBadge(
                  label: 'No waqf_assets mutation',
                  icon: Icons.verified_user_outlined,
                  tone: PwfSisNoticeTone.success),
              PwfSisStatusBadge(
                  label: 'Production not approved',
                  icon: Icons.lock_clock_outlined,
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 240,
            children: [
              PwfSisMetricCard(
                  label: 'Regulation',
                  value:
                      '${contract.regulationNumber}/${contract.regulationYear}',
                  subtitle: contract.statusAr,
                  icon: Icons.gavel_outlined),
              PwfSisMetricCard(
                  label: 'Algorithm branches',
                  value: '${contract.algorithmRules.length}',
                  subtitle: 'فروع قانونية للقرعة',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'Registration rules',
                  value: '${contract.registrationRules.length}',
                  subtitle: 'شروط تسجيل قانونية',
                  icon: Icons.fact_check_outlined),
              const PwfSisMetricCard(
                  label: 'Join gate',
                  value: 'BLOCKED',
                  subtitle: 'حتى إغلاق المواءمة القانونية',
                  icon: Icons.lock_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'لماذا v38E قبل الانضمام؟',
            message:
                'عقد القرعة السابق في نسك كان مبنيًا على حصة LGU وسعة الأشخاص. النظام الجديد يفرض فروعًا قانونية محددة للخوارزمية، منها حالات لا تتطابق مع منع تجاوز الحصة بصورة مطلقة؛ لذلك يجب تحديث العقد قبل أن تستقبله منصة PalWakf.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'الصفحات الجديدة المعتمدة في v38E',
            subtitle:
                'القانون أصبح له صفحة عامة وصفحة امتثال إدارية داخل المشروع.',
            child: PwfSisAdaptiveWorkspace(
              minTileWidth: 260,
              children: [
                PwfSisServiceCard(
                  icon: Icons.public_outlined,
                  title: 'صفحة القانون العامة',
                  description:
                      'ملخص مبسط للمواطن حول أثر نظام 15/2025 على التسجيل والقرعة دون تفاصيل تقنية.',
                  actionLabel: 'فتح الصفحة',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.legalRegulation),
                ),
                PwfSisServiceCard(
                  icon: Icons.gavel_outlined,
                  title: 'الامتثال القانوني الإداري',
                  description:
                      'صفحة داخل الإدارة تعرض أثر القانون على التسجيل والخوارزمية وSchema/RPC draft.',
                  actionLabel: 'فتح الصفحة',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminLegalCompliance),
                ),
                PwfSisServiceCard(
                  icon: Icons.rule_folder_outlined,
                  title: 'قيود التسجيل',
                  description:
                      'ربط نوافذ التسجيل والتجميد والاستثناءات بالنظام القانوني لا بمجرد إعدادات واجهة.',
                  actionLabel: 'فتح القيود',
                  onPressed: () =>
                      context.go(NosokSystemRoutes.adminRegistrationGovernance),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'تصحيح نموذج القرعة السابق',
            subtitle:
                'مقارنة مباشرة بين العقد السابق والعقد القانوني بعد v38E.',
            child: PwfSisDataTable(
              columns: const ['المجال', 'قبل v38E', 'بعد v38E', 'الحالة'],
              rows: [
                for (final decision in contract.impactDecisions)
                  [
                    Text(decision.areaAr),
                    Text(decision.oldContractAr),
                    Text(decision.newContractAr),
                    PwfSisStatusBadge(
                        label: decision.statusAr,
                        icon: Icons.update_outlined,
                        tone: PwfSisNoticeTone.warning)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'بوابات التنفيذ',
            subtitle:
                'هذه البوابات تمنع أي انضمام أو تنفيذ قرعة قبل إغلاق الامتثال القانوني.',
            child: PwfSisTimeline(items: contract.implementationGates),
          ),
        ],
      ),
    );
  }
}
