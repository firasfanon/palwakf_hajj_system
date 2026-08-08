import 'package:flutter/material.dart';

import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminHealthPage extends StatelessWidget {
  const NosokAdminHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    const checks = [
      ('schema', 'nosok schema موجودة'),
      ('rpc_public', 'RPC العامة تعمل'),
      ('rpc_admin', 'RPC الإدارة تعمل'),
      ('storage', 'Storage bucket وسياسات الرفع'),
      ('rbac', 'RBAC/Route guards متطابقة'),
      ('unit_scope', 'نطاق الوحدات من core.org_units'),
    ];

    return NosokPageScaffold(
      title: 'صحة وتشغيل نسك',
      subtitle:
          'صفحة مراقبة تشغيلية لنظام شبه مستقل. لا تعلن production-ready إلا بعد SQL UAT وBrowser UAT وRole UAT.',
      children: [
        NosokSectionCard(
          title: 'Health Matrix',
          subtitle:
              'هذه القائمة baseline UI؛ القراءة الحقيقية تأتي لاحقًا من nosok.system_health_checks أو RPC readiness.',
          child: Column(
            children: [
              for (final check in checks)
                ListTile(
                  leading: const Icon(Icons.pending_actions_outlined),
                  title: Text(check.$2),
                  subtitle: Text(check.$1),
                  trailing: const Chip(label: Text('pending UAT')),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const NosokSectionCard(
          title: 'بوابات الاعتماد',
          child: Text(
            'المطلوب قبل الإنتاج: flutter analyze، تشغيل Chrome، SQL UAT لكل RPC، Browser UAT عام/إداري، Role-based UAT لمستخدم محدود ومستخدم superuser، ومراجعة console/security.',
          ),
        ),
      ],
    );
  }
}
