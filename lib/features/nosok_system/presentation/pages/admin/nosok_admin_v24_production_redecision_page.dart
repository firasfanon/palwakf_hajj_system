import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v24_uat_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV24ProductionRedecisionPage extends ConsumerWidget {
  const NosokAdminV24ProductionRedecisionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = ref.watch(nosokV24UatPackProvider);
    return pack.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const PwfSisNotice(
          title: 'تعذر تحميل قرار الإنتاج',
          message: 'تعذر تحميل قرار بوابة الإنتاج. أعد المحاولة.',
          tone: PwfSisNoticeTone.error),
      data: (data) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Production Gate Re-decision',
            description: data.decision.reasonAr,
            badges: const [
              'gate decision',
              'evidence-based',
              'no automatic approval'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: data.decision.status,
                  tone: data.decision.approved
                      ? PwfSisNoticeTone.success
                      : PwfSisNoticeTone.warning)
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(children: [
            PwfSisMetricCard(
                label: 'إجمالي الفحوص',
                value: '${data.totalChecks}',
                subtitle: 'Browser + Role + Responsive + Merge + Supabase'),
            PwfSisMetricCard(
                label: 'مغلق',
                value: '${data.passedChecks}',
                subtitle: 'أدلة مستوعبة'),
            PwfSisMetricCard(
                label: 'Blockers',
                value: '${data.blockers}',
                subtitle: 'P0 قبل الإنتاج',
                icon: Icons.block_outlined),
            PwfSisMetricCard(
                label: 'القرار',
                value: data.decision.approved ? 'Approved' : 'Not approved',
                subtitle: data.decision.nextGateAr,
                icon: Icons.verified_user_outlined),
          ]),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'الحكم التنفيذي',
            message:
                'يبقى نسك production-not-approved حتى إغلاق Full PalWakf Merge وSQL UAT وRole/Responsive evidence. لا يوجد أي تعديل على waqf_assets أو schema waqf.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'المتبقي قبل production-candidate',
            subtitle: 'هذه ليست إضافات واجهة، بل بوابات تشغيل حاكمة.',
            child: PwfSisDataTable(
              columns: const ['البوابة', 'الحالة', 'الإجراء التالي'],
              rows: const [
                [
                  Text('Full PalWakf Merge'),
                  Text('P0'),
                  Text('تطبيق platform_real_merge_pack داخل ريبو المنصة الكامل')
                ],
                [
                  Text('AccessProfile Override'),
                  Text('P0'),
                  Text('ربط provider بمصدر RBAC الحقيقي')
                ],
                [
                  Text('SQL UAT'),
                  Text('P0'),
                  Text('تشغيل read-only UAT وإرفاق النتائج')
                ],
                [
                  Text('Role UAT'),
                  Text('P0'),
                  Text('إثبات زائر/مواطن/موظف/مشرف/مدير/Superuser/مقيد')
                ],
                [
                  Text('Responsive UAT'),
                  Text('P1'),
                  Text('لقطات desktop/tablet/mobile بلا overflow')
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
