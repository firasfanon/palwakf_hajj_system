import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokInternalGroupsPage extends StatelessWidget {
  const NosokInternalGroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PwfSisSystemHero(
            title: 'مجموعات نسك',
            description:
                'إدارة المجموعات المرتبطة بالحملات، مع إبقاء التفاصيل في صفحة/Drawer لاحقًا بدل ازدحام البطاقات.',
            badges: ['groups', 'campaign-linked', 'role-scoped'],
          ),
          SizedBox(height: 12),
          PwfSisNotice(
            title: 'حالة التكامل',
            message:
                'هذه الواجهة جاهزة بصريًا ومحكومة بـ PWF-SIS. لا يتم إنشاء backend جديد للحملات/المجموعات في هذه الدفعة.',
            tone: PwfSisNoticeTone.warning,
          ),
          SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 210,
            children: [
              PwfSisMetricCard(
                  label: 'مجموعات نشطة',
                  value: '8',
                  subtitle: 'حسب الموسم',
                  icon: Icons.groups_outlined),
              PwfSisMetricCard(
                  label: 'أفراد مرتبطون',
                  value: '189',
                  subtitle: 'ضمن الحملات',
                  icon: Icons.person_pin_circle_outlined),
              PwfSisMetricCard(
                  label: 'بحاجة مشرف',
                  value: '2',
                  subtitle: 'مانع تشغيلي',
                  icon: Icons.supervisor_account_outlined),
            ],
          ),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'قائمة المجموعات',
            subtitle:
                'Desktop table / Mobile cards. التفاصيل التشغيلية تفتح لاحقًا كصفحة تفصيلية أو Drawer.',
            child: PwfSisDataTable(
              columns: [
                'المجموعة',
                'الحملة',
                'عدد الأفراد',
                'المشرف',
                'الحالة',
                'ملاحظات المتابعة',
                'طلبات مرتبطة'
              ],
              rows: [
                [
                  Text('مجموعة A'),
                  Text('حملة القدس'),
                  Text('42'),
                  Text('مشرف 1'),
                  PwfSisStatusBadge(label: 'جاهزة'),
                  Text('اكتمال وثائق مرتفع'),
                  Text('42')
                ],
                [
                  Text('مجموعة B'),
                  Text('حملة نابلس'),
                  Text('31'),
                  Text('مشرف 2'),
                  PwfSisStatusBadge(label: 'متابعة'),
                  Text('توجد نواقص محدودة'),
                  Text('31')
                ],
                [
                  Text('مجموعة C'),
                  Text('حملة الخليل'),
                  Text('18'),
                  Text('غير مسند'),
                  PwfSisStatusBadge(label: 'بحاجة مشرف'),
                  Text('يتطلب إسناد'),
                  Text('18')
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
