import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38f_prejoin_operational_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminCompanyWorkspaceClosurePage extends ConsumerWidget {
  const NosokAdminCompanyWorkspaceClosurePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38FPrejoinOperationalContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'إغلاق تحضيري لبوابة الشركات والشركاء',
            description:
                'بوابة الشركات جزء أساسي من نسك، لكنها قبل الانضمام تبقى عقدًا وتحضيرًا. لا يتم تمكين وصول شركة حقيقي قبل وجود RBAC/RLS وشركة مرتبطة بممثلها داخل منصة PalWakf.',
            badges: [
              'company-workspace',
              'partner-scope',
              'pre-join-only',
              'rls-required'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'Company scope required',
                  icon: Icons.business_center_outlined,
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'No backend binding',
                  icon: Icons.cloud_off_outlined,
                  tone: PwfSisNoticeTone.neutral),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 260,
            children: [
              for (final item in contract.companyWorkspaceItems)
                PwfSisServiceCard(
                  icon: Icons.business_outlined,
                  title: item.titleAr,
                  description:
                      '${item.descriptionAr}\n\n${item.runtimePreviewAr}',
                  actionLabel: item.statusAr,
                ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'حدود بيانات الشركات',
            subtitle:
                'المهم أن الشركة لا ترى إلا نطاقها، ولا تتحول بوابة الشركة إلى مدخل عام لبيانات المتقدمين.',
            child: PwfSisDataTable(
              columns: ['المجال', 'المسموح', 'الممنوع'],
              rows: [
                [
                  Text('ممثل الشركة'),
                  Text('ملف الشركة والحملات المسندة له'),
                  Text('طلبات شركات أخرى أو بيانات غير لازمة')
                ],
                [
                  Text('الحملات'),
                  Text('السعة، المجموعة، النواقص، حالة الاعتماد'),
                  Text('تعديل نتائج القرعة أو تغيير الحصص')
                ],
                [
                  Text('الوثائق'),
                  Text('رفع/مراجعة ما يطلب من الشركة ضمن نطاقها'),
                  Text('الوصول لوثائق مواطن خارج الحملة')
                ],
                [
                  Text('المراسلات'),
                  Text('رسائل موثقة مع الوزارة'),
                  Text('حذف سجلات التدقيق أو تجاوز RBAC')
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
