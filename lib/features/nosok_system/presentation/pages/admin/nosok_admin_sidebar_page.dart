import 'package:flutter/material.dart';

import '../../../system_navigation.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminSidebarPage extends StatelessWidget {
  const NosokAdminSidebarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NosokPageScaffold(
      title: 'سايدبار نسك الداخلي',
      subtitle:
          'السايدبار هنا يخص Body النظام داخل PlatformAdminShell. لا يستبدل سايدبار المنصة ولا يتجاوز حراسة المسارات.',
      children: [
        NosokSectionCard(
          title: 'عناصر السايدبار',
          subtitle:
              'كل عنصر مرتبط بمسار وصلاحيات مقترحة. الإخفاء النهائي يجب أن يتم عبر AccessProfile/RouteGuard.',
          child: Column(
            children: [
              for (final item in NosokSystemNavigation.adminItems)
                ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.titleAr),
                  subtitle: Text(
                      '${item.route}\npermissions: ${item.permissionKeys.join(', ')}'),
                  isThreeLine: true,
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const NosokSectionCard(
          title: 'مبدأ الرؤية',
          child: Text(
            'إظهار العنصر في السايدبار ليس صلاحية بحد ذاته. الرؤية يجب أن تتطابق مع route guard وsystem registry وRBAC، وإلا يظهر تعارض شبيه بحالات superuser/forbidden السابقة.',
          ),
        ),
      ],
    );
  }
}
