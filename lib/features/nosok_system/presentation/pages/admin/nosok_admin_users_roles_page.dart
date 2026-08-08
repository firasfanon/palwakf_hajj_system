import 'package:flutter/material.dart';

import '../../../system_permissions.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminUsersRolesPage extends StatelessWidget {
  const NosokAdminUsersRolesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NosokPageScaffold(
      title: 'المستخدمون والأدوار والصلاحيات',
      subtitle:
          'نسك لا يملك جدول مستخدمين مستقل. الهوية من admin_users وAccessProfile في المنصة، وهذه الصفحة تعرض قالب الصلاحيات المطلوب لتسجيله في RBAC.',
      children: [
        const NosokSectionCard(
          title: 'قاعدة حاكمة',
          child: Text(
            'لا يتم إنشاء مستخدمين داخل nosok schema. أي تعيين دور أو صلاحية يجب أن يمر عبر منصة PalWakf: admin_users + user_system_roles/user_system_permissions + route guards. superuser/platformAdmin يملكان override أعلى من أدوار نسك المحلية.',
          ),
        ),
        const SizedBox(height: 12),
        NosokSectionCard(
          title: 'قوالب الأدوار المقترحة',
          subtitle: 'تُستخدم لتسجيل الدور في المنصة، وليست مصدر صلاحية مستقل.',
          child: Column(
            children: [
              for (final template in NosokRolePermissionTemplates.templates)
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: Text(template.titleAr),
                  subtitle: Text(template.roleKey),
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final permission in template.permissionKeys)
                            Chip(label: Text(permission)),
                        ],
                      ),
                    ),
                    if ((template.notesAr ?? '').isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 12),
                          child: Text(template.notesAr!),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
