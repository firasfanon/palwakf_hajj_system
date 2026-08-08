import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38f_prejoin_operational_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminPublicResponsiveUatPage extends ConsumerWidget {
  const NosokAdminPublicResponsiveUatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38FPrejoinOperationalContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Public/Responsive UAT Evidence Intake — v38F',
            description:
                'مصفوفة فحص واجهات الجمهور والاستجابة قبل تسليم حزمة نسك لمسار منصة PalWakf. هذه الصفحة لا تغني عن لقطات المتصفح والسجل المحلي، لكنها تثبت المطلوب فحصه.',
            badges: ['public-uat', 'responsive', 'console-review', 'pre-join'],
            actions: [
              PwfSisStatusBadge(
                  label: 'Analyzer clean required',
                  icon: Icons.checklist_outlined,
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'Browser screenshots required',
                  icon: Icons.screenshot_monitor_outlined,
                  tone: PwfSisNoticeTone.neutral),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصفوفة الفحص العام',
            subtitle:
                'المعيار: لا صفحة بيضاء، لا overflow، لا لغة تقنية، لا ألوان وردية، ولا أخطاء console حمراء.',
            child: PwfSisDataTable(
              columns: const [
                'المسار',
                'Desktop',
                'Mobile',
                'Console',
                'الحالة'
              ],
              rows: [
                for (final item in contract.publicResponsiveUatItems)
                  [
                    Text(item.route),
                    Text(item.desktopExpectationAr),
                    Text(item.mobileExpectationAr),
                    Text(item.consoleExpectationAr),
                    PwfSisStatusBadge(
                        label: item.statusAr,
                        icon: Icons.fact_check_outlined,
                        tone: item.statusAr == 'retest-required'
                            ? PwfSisNoticeTone.warning
                            : PwfSisNoticeTone.success)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'شروط الإغلاق',
            message:
                'لا تعتبر v38F مغلقة نهائيًا قبل تشغيل dart format وflutter analyze وflutter run، ثم إرفاق لقطات للصفحة الرئيسية، التقديم، المتابعة، النتائج، قائمة الانتظار، الاعتراضات، والشركات على الأقل.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
