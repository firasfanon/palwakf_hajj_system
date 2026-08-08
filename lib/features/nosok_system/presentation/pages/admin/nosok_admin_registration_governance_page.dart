import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_prejoin_admin_tools_controller.dart';
import '../../../application/nosok_legal_lottery_regulation_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminRegistrationGovernancePage extends ConsumerWidget {
  const NosokAdminRegistrationGovernancePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokPrejoinAdminToolsContractProvider);
    final legal = ref.watch(nosokLegalLotteryRegulationContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'قيود التسجيل والنزاهة بعد انتهاء الفترة القانونية',
            description:
                'أداة إدارية تحضيرية لتوضيح ما يحدث عند فتح التسجيل، إغلاقه، فتح نافذة استكمال النواقص، ثم تجميد Pool القرعة. الهدف منع التلاعب وضمان أن المواطن والموظف لا يستطيعان تغيير ما يؤثر على الأهلية أو الحصة بعد الموعد القانوني إلا بقرار موثق.',
            badges: [
              'registration-governance',
              'integrity-locks',
              'committee-overrides',
              'audit-required'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'policy-configurable',
                  icon: Icons.tune_outlined,
                  tone: PwfSisNoticeTone.info),
              PwfSisStatusBadge(
                  label: 'committee decision required',
                  icon: Icons.gavel_outlined,
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisNotice(
            title: 'قاعدة النزاهة وفق ${legal.regulationTitleAr}',
            message:
                'بعد انتهاء الفترة القانونية للتسجيل لا يجوز للمواطن أو الموظف تعديل بيانات تؤثر على الأهلية أو LGU أو عدد الأشخاص أو الحصة إلا عبر مسار استثناء موثق من لجنة الحج أو صلاحية عليا مع سبب وسجل تدقيق. شروط التسجيل يجب أن ترتبط بنسخة سياسة قانونية لا بنص ثابت داخل الواجهة.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قواعد الحوكمة الموسمية',
            subtitle:
                'كل قاعدة قابلة للتهيئة حسب سياسة الوزارة، لكنها يجب أن تطبق في backend/RPC قبل الإنتاج.',
            child: PwfSisDataTable(
              columns: const [
                'المرحلة',
                'أثر المواطن',
                'أثر الموظف',
                'مسار الاستثناء',
                'التدقيق'
              ],
              rows: [
                for (final rule in contract.registrationGovernanceRules)
                  [
                    Text(rule.titleAr),
                    Text(rule.publicEffect),
                    Text(rule.adminEffect),
                    Text(rule.exceptionPath),
                    Text(rule.auditRequirement),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisPanel(
            title: 'تطبيق القاعدة على صفحات نسك',
            subtitle:
                'هذه القيود يجب أن تنعكس في UI، لكنها لا تعتمد على UI وحده.',
            child: PwfSisTimeline(
              items: [
                '/services/nosok/apply: عند الإغلاق يظهر التسجيل مغلق ولا يسمح ببدء طلب جديد.',
                '/services/nosok/track: المواطن يرى حالته وما إذا كان مسموحًا له باستكمال النواقص فقط.',
                '/admin/systems/nosok/requests: الموظف يرى نطاقه ويمكنه الفرز دون تغيير بيانات مغلقة.',
                '/admin/systems/nosok/review: قرارات الاستكمال/الرفض/الاعتماد تحكمها حالة الموسم وصلاحية الدور.',
                '/admin/systems/nosok/lottery: بعد تجميد pool لا تعديل يؤثر على القرعة إلا بقرار لجنة الحج.',
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'الجداول والـ RPC المطلوبة لاحقًا',
            subtitle:
                'Draft فقط. لا إنشاء schema ولا SQL apply ضمن مسار نسك الحالي.',
            child: PwfSisDataTable(
              columns: const ['الكائن', 'المالك', 'الغرض', 'الحالة'],
              rows: [
                for (final object in [
                  ...contract.requiredTables,
                  ...contract.requiredRpcs
                ])
                  [
                    Text(object.name),
                    Text(object.owner),
                    Text(object.purposeAr),
                    PwfSisStatusBadge(
                        label: object.status,
                        icon: Icons.pending_actions_outlined,
                        tone: PwfSisNoticeTone.warning),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'لا نقل تلقائي للحصص',
            message:
                'عند نقص الحصة داخل LGU وعدم وجود طلب يناسب السعة المتبقية، لا ينتقل النظام تلقائيًا إلى تجمع آخر. تُرفع الحالة إلى لجنة الحج مع evidence، وتقرر اللجنة وفق سياسة موثقة.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
