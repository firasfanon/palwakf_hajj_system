import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminSettingsPage extends StatelessWidget {
  const NosokAdminSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: PwfSisPublicServiceShell(
        children: [
          PwfSisSystemHero(
            title: 'إعدادات نظام نسك',
            description:
                'إعدادات تشغيلية محكومة بالمنصة، ولا تحتوي على أسرار أو مفاتيح API داخل Flutter أو seed عام.',
            badges: ['settings', 'restricted', 'platform-owned-rbac'],
          ),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'إعدادات أساسية',
            subtitle:
                'كل خيار هنا read-only داخل preview حتى لا نغيّر runtime قبل RBAC وSQL UAT النهائي.',
            child: Column(
              children: [
                SwitchListTile(
                  value: true,
                  onChanged: null,
                  title: Text('تفعيل الواجهة العامة'),
                  subtitle: Text(
                      'يتحكم بها النظام والمنصة معًا عبر عقود التسجيل والصلاحيات.'),
                ),
                SwitchListTile(
                  value: false,
                  onChanged: null,
                  title: Text('وضع الصيانة لنظام نسك'),
                  subtitle: Text(
                      'يتطلب ربطًا مع مركز الصحة والصيانة في PalWakf قبل تفعيله.'),
                ),
                ListTile(
                  leading: Icon(Icons.storage_outlined),
                  title: Text('Storage bucket'),
                  subtitle: Text(
                      'nosok-documents — يخضع لسياسات Supabase Storage بعد UAT.'),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          PwfSisNotice(
            title: 'حدود الإعدادات',
            message:
                'أي أسرار مزودي الدفع أو مفاتيح الربط يجب أن تكون في backend آمن أو vault، لا داخل Flutter ولا SQL seed عام.',
            tone: PwfSisNoticeTone.warning,
          ),
        ],
      ),
    );
  }
}
