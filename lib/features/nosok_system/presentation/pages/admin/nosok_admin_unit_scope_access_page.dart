import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_prejoin_admin_tools_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminUnitScopeAccessPage extends ConsumerWidget {
  const NosokAdminUnitScopeAccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokPrejoinAdminToolsContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'نطاق الموظفين حسب المديرية والتجمعات',
            description:
                'تجهيز عقد دخول الموظفين بحسب slug/وحدة إدارية. موظف مديرية بيت لحم مثلًا يجب أن يفتح على سجلات تجمعات بيت لحم فقط عند التسجيل أو التعديل أو المراجعة، وفق AccessProfile الحقيقي في PalWakf لاحقًا.',
            badges: [
              'unitSlug-scope',
              'LGU-filtering',
              'RBAC-required',
              'pre-join-contract'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'UI is not the security layer',
                  icon: Icons.security_outlined,
                  tone: PwfSisNoticeTone.warning),
              PwfSisStatusBadge(
                  label: 'backend/RPC enforcement required',
                  icon: Icons.rule_outlined,
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 230,
            children: const [
              PwfSisMetricCard(
                  label: 'مصدر النطاق',
                  value: 'AccessProfile',
                  subtitle: 'من PalWakf بعد الانضمام',
                  icon: Icons.badge_outlined),
              PwfSisMetricCard(
                  label: 'فلترة البيانات',
                  value: 'LGU',
                  subtitle: 'حسب العنوان/التجمع المعتمد',
                  icon: Icons.location_city_outlined),
              PwfSisMetricCard(
                  label: 'مثال',
                  value: 'بيت لحم',
                  subtitle: 'موظف المديرية يرى تجمعاتها فقط',
                  icon: Icons.account_tree_outlined),
              PwfSisMetricCard(
                  label: 'السوبر يوزر',
                  value: 'ALL',
                  subtitle: 'مع سجل تدقيق',
                  icon: Icons.admin_panel_settings_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قواعد نطاق الوحدة',
            subtitle:
                'هذه العقود يجب تنفيذها لاحقًا في RPC/RLS ولا تكفي كإخفاء بصري داخل الواجهة.',
            child: PwfSisDataTable(
              columns: const [
                'المفتاح',
                'القاعدة',
                'مصدر الحقيقة',
                'فلتر البيانات',
                'الأثر على الدور',
                'الحالة'
              ],
              rows: [
                for (final rule in contract.unitScopeRules)
                  [
                    Text(rule.key),
                    Text(rule.titleAr),
                    Text(rule.sourceOfTruth),
                    Text(rule.filterContract),
                    Text(rule.roleImpact),
                    PwfSisStatusBadge(
                        label: rule.status,
                        icon: Icons.pending_actions_outlined,
                        tone: PwfSisNoticeTone.warning),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisPanel(
            title: 'مثال تشغيلي: موظف مديرية بيت لحم',
            subtitle:
                'المثال يوضح سلوك ما قبل الانضمام كعقد واجهة لا كفلترة إنتاجية.',
            child: PwfSisTimeline(
              items: [
                'الموظف يسجل الدخول عبر PalWakf لاحقًا ويحمل AccessProfile فيه unitSlug=bethlehem أو org_unit_id خاص بالمديرية.',
                'نسك يترجم unitSlug إلى قائمة LGUs مسموحة عبر core.org_units / قاموس LGU المعتمد.',
                'صفحات الطلبات والمراجعة والتعديل تعرض فقط طلبات المواطنين الذين عنوان بطاقتهم الشخصية ضمن LGUs المسموحة.',
                'أي محاولة فتح طلب خارج النطاق تعطي Forbidden أو read-only حسب السياسة، وليس إخفاءً بصريًا فقط.',
                'أي تعديل بعد إغلاق التسجيل يخضع لقواعد registration governance ولا يتم إلا عبر استثناء موثق.',
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'متطلب قبل الانضمام للمنصة',
            message:
                'يجب أن توفر PalWakf عند الاستضافة خريطة unitSlug/org_units/LGU، وصلاحيات الدور، وسلوك forbidden/read-only. نسك يجهز العقد والواجهات فقط في هذا المسار.',
            tone: PwfSisNoticeTone.info,
          ),
        ],
      ),
    );
  }
}
