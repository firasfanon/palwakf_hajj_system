import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_legal_lottery_regulation_controller.dart';
import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminLegalCompliancePage extends ConsumerWidget {
  const NosokAdminLegalCompliancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokLegalLotteryRegulationContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title:
                'الامتثال القانوني للحج — ${contract.regulationNumber}/${contract.regulationYear}',
            description:
                'صفحة قانونية داخل نسك لتثبيت أثر ${contract.regulationTitleAr} على التسجيل والقرعة. هذه الصفحة لا تنشئ schema ولا تنفذ SQL، لكنها تجعل القانون جزءًا من عقد التطوير قبل الانضمام إلى PalWakf.',
            badges: const [
              'legal-compliance',
              'regulation-15-2025',
              'lottery-algorithm',
              'pre-join-only'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: contract.statusAr,
                  icon: Icons.gavel_outlined,
                  tone: PwfSisNoticeTone.success),
              const PwfSisStatusBadge(
                  label: 'No SQL apply',
                  icon: Icons.storage_outlined,
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قرار v38E الحاكم',
            message: contract.prejoinDecisionAr,
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 220,
            children: [
              PwfSisMetricCard(
                  label: 'قواعد التسجيل',
                  value: '${contract.registrationRules.length}',
                  subtitle: 'سياسات مرتبطة بالقانون والموسم',
                  icon: Icons.app_registration_outlined),
              PwfSisMetricCard(
                  label: 'فروع الخوارزمية',
                  value: '${contract.algorithmRules.length}',
                  subtitle: 'قرعة قانونية لا اختيار عام فقط',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'جداول Draft',
                  value: '${contract.requiredTables.length}',
                  subtitle: 'غير مطبقة قبل الاستضافة',
                  icon: Icons.table_chart_outlined),
              PwfSisMetricCard(
                  label: 'RPC Draft',
                  value: '${contract.requiredRpcs.length}',
                  subtitle: 'تنفيذ حقيقي مؤجل',
                  icon: Icons.api_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مرجع القانون داخل نسك',
            subtitle:
                'هذا ملخص تشغيلي. المرجع النهائي يبقى النص الرسمي المنشور عند الاعتماد القانوني النهائي.',
            actions: [
              OutlinedButton.icon(
                onPressed: () => context.go(NosokSystemRoutes.legalRegulation),
                icon: const Icon(Icons.public_outlined),
                label: const Text('فتح الصفحة العامة'),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    context.go(NosokSystemRoutes.adminRegistrationGovernance),
                icon: const Icon(Icons.lock_clock_outlined),
                label: const Text('قيود التسجيل'),
              ),
            ],
            child: PwfSisDataTable(
              columns: const ['البند', 'القيمة'],
              rows: [
                [const Text('العنوان'), Text(contract.regulationTitleAr)],
                [
                  const Text('الرقم/السنة'),
                  Text(
                      '${contract.regulationNumber} / ${contract.regulationYear}')
                ],
                [const Text('المصدر'), Text(contract.sourceNameAr)],
                [const Text('النشر'), Text(contract.publicationReferenceAr)],
                [
                  const Text('الحالة'),
                  PwfSisStatusBadge(
                      label: contract.statusAr,
                      icon: Icons.verified_outlined,
                      tone: PwfSisNoticeTone.success)
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'أثر النظام على شروط التسجيل',
            subtitle:
                'هذه القواعد يجب أن تتحول لاحقًا إلى registration_policy_versions وRPC تحقق، لا إلى نصوص ثابتة في الواجهة فقط.',
            child: PwfSisDataTable(
              columns: const ['القاعدة', 'العقد', 'أثر الواجهة', 'أثر backend'],
              rows: [
                for (final rule in contract.registrationRules)
                  [
                    Text(rule.titleAr),
                    Text(rule.contractAr),
                    Text(rule.uiImpactAr),
                    Text(rule.backendImpactAr)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'خوارزمية القرعة القانونية',
            subtitle:
                'هذه الفروع تصحح نموذج capacity-aware السابق وتجعله تابعًا للنظام القانوني الجديد.',
            child: PwfSisDataTable(
              columns: const [
                'الفرع',
                'القاعدة',
                'أثرها على النموذج السابق',
                'حارس التنفيذ'
              ],
              rows: [
                for (final rule in contract.algorithmRules)
                  [
                    Text(rule.titleAr),
                    Text(rule.ruleAr),
                    Text(rule.previousModelImpactAr),
                    Text(rule.requiredRuntimeGuardAr)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قرارات الأثر على نسك',
            subtitle:
                'ما يجب تغييره في عقد نسك قبل أي حديث عن الانضمام إلى المنصة.',
            child: PwfSisDataTable(
              columns: const [
                'المجال',
                'العقد السابق',
                'العقد بعد v38E',
                'الحالة'
              ],
              rows: [
                for (final item in contract.impactDecisions)
                  [
                    Text(item.areaAr),
                    Text(item.oldContractAr),
                    Text(item.newContractAr),
                    PwfSisStatusBadge(
                        label: item.statusAr,
                        icon: Icons.rule_outlined,
                        tone: PwfSisNoticeTone.warning)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Schema/RPC Draft المطلوب لاحقًا',
            subtitle:
                'لا يتم إنشاء هذه الكائنات الآن. تُسلّم كحزمة تصميم إلى مسار المنصة بعد الاستضافة.',
            child: PwfSisDataTable(
              columns: const ['الكائن', 'النوع', 'الغرض', 'الحالة'],
              rows: [
                for (final item in [
                  ...contract.requiredTables,
                  ...contract.requiredRpcs
                ])
                  [
                    Text(item.name),
                    Text(item.type),
                    Text(item.purposeAr),
                    PwfSisStatusBadge(
                        label: item.statusAr,
                        icon: Icons.pending_actions_outlined,
                        tone: PwfSisNoticeTone.warning)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'بوابات التنفيذ قبل الانضمام',
            subtitle:
                'تمنع هذه البوابات تنفيذ قرعة أو انضمام قبل تصحيح العقد القانوني بالكامل.',
            child: PwfSisTimeline(items: contract.implementationGates),
          ),
        ],
      ),
    );
  }
}
