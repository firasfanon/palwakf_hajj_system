import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokInternalCampaignsPage extends StatelessWidget {
  const NosokInternalCampaignsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PwfSisSystemHero(
              title: 'الحملات والمجموعات',
              description:
                  'إدارة حملات الحج/العمرة والمجموعات والسعة دون ازدحام تفاصيل داخل البطاقة.',
              badges: ['campaigns', 'groups']),
          SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(children: [
            PwfSisMetricCard(
                label: 'حملات نشطة',
                value: '3',
                subtitle: 'حسب الموسم',
                icon: Icons.campaign_outlined),
            PwfSisMetricCard(
                label: 'السعة المتاحة',
                value: '210',
                subtitle: 'قابلة للربط',
                icon: Icons.event_seat_outlined),
            PwfSisMetricCard(
                label: 'طلبات غير مربوطة',
                value: '34',
                subtitle: 'تنتظر التخصيص',
                icon: Icons.link_off_outlined),
          ]),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'قائمة الحملات',
            child: PwfSisDataTable(columns: [
              'الحملة',
              'المسجلون',
              'السعة',
              'الحالة',
              'المشرف',
              'تاريخ الانطلاق',
              'مجموعة'
            ], rows: [
              [
                Text('حملة القدس'),
                Text('80'),
                Text('100'),
                PwfSisStatusBadge(label: 'نشطة'),
                Text('مشرف 1'),
                Text('1447/11/01'),
                Text('A')
              ],
              [
                Text('حملة نابلس'),
                Text('64'),
                Text('80'),
                PwfSisStatusBadge(label: 'نشطة'),
                Text('مشرف 2'),
                Text('1447/11/03'),
                Text('B')
              ],
              [
                Text('حملة الخليل'),
                Text('45'),
                Text('60'),
                PwfSisStatusBadge(label: 'تحضير'),
                Text('مشرف 3'),
                Text('1447/11/05'),
                Text('C')
              ],
            ]),
          ),
        ],
      ),
    );
  }
}
