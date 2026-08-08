import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_permissions.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminRbacProviderOverridePage extends StatelessWidget {
  const NosokAdminRbacProviderOverridePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NosokPageScaffold(
      title: 'ربط RBAC و AccessProfile',
      subtitle:
          'هذه الصفحة تثبت عقد override المطلوب عند دمج نسك في PalWakf: مصدر الصلاحية هو المنصة، ونسك يقرأ فقط profile مترجمًا.',
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminUsersRoles),
          icon: const Icon(Icons.admin_panel_settings_outlined),
          label: const Text('قوالب الأدوار'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'عقد الـ Provider Override',
          subtitle:
              'الافتراضي في standalone fail-closed، وفي preview فقط يتم override كسوبر يوزر محلي.',
          child: const Column(
            children: [
              _ContractRow(
                title: 'المدخل',
                body:
                    'PalWakf AccessProfile + admin_users + user_system_roles + user_system_permissions + user_scope_assignments',
              ),
              _ContractRow(
                title: 'المخرج',
                body:
                    'NosokAccessProfile(isAuthenticated, isSuperuser, permissionKeys, roleKeys, unitIds, unitSlugs, source=palwakf)',
              ),
              _ContractRow(
                title: 'القاعدة',
                body:
                    'لا يقرر نسك هوية المستخدم ولا ينشئ RBAC محليًا. كل deny يجب أن يكون fail-closed.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'سطوح الصلاحيات الحساسة',
          subtitle:
              'هذه الصلاحيات يجب أن تكون مسجلة في منصة PalWakf قبل اعتماد الإنتاج.',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              _PermissionChip(NosokPermissionKeys.manageNosokApplications),
              _PermissionChip(NosokPermissionKeys.reviewNosokApplications),
              _PermissionChip(
                  NosokPermissionKeys.manageNosokApplicationLifecycle),
              _PermissionChip(NosokPermissionKeys.verifyNosokPayments),
              _PermissionChip(NosokPermissionKeys.executeNosokBillingBridge),
              _PermissionChip(NosokPermissionKeys.manageNosokFollowupInbox),
              _PermissionChip(NosokPermissionKeys.closeNosokProductionUat),
              _PermissionChip(
                  NosokPermissionKeys.manageNosokPlatformIntegrationReadiness),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'كود override المقترح',
          subtitle:
              'الملف الجاهز موجود داخل platform_real_merge_pack، ولا يُشغل داخل preview host.',
          child: const SelectableText(
            "ProviderScope(\n"
            "  overrides: [\n"
            "    nosokAccessProfileProvider.overrideWith((ref) {\n"
            "      final profile = ref.watch(accessProfileProvider);\n"
            "      return NosokPalWakfAccessProfileMapper.fromPlatform(profile);\n"
            "    }),\n"
            "  ],\n"
            "  child: const PalWakfApp(),\n"
            ")",
          ),
        ),
      ],
    );
  }
}

class _ContractRow extends StatelessWidget {
  const _ContractRow({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.shield_outlined),
        title: Text(title),
        subtitle: Text(body),
      ),
    );
  }
}

class _PermissionChip extends StatelessWidget {
  const _PermissionChip(this.permissionKey);
  final String permissionKey;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text(permissionKey));
  }
}
