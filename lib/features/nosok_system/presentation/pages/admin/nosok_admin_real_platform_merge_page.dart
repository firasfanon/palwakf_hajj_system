import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminRealPlatformMergePage extends StatelessWidget {
  const NosokAdminRealPlatformMergePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return NosokPageScaffold(
      title: 'حزمة الدمج الفعلي داخل PalWakf',
      subtitle:
          'تحويل نسك من preview host إلى نظام شبه مستقل داخل المنصة الأم عبر خطوات دمج قابلة للتنفيذ، لا مجرد مقترحات توثيقية.',
      actions: [
        FilledButton.icon(
          onPressed: () =>
              context.go(NosokSystemRoutes.adminRbacProviderOverride),
          icon: const Icon(Icons.verified_user_outlined),
          label: const Text('ربط RBAC'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminSqlUatIntake),
          icon: const Icon(Icons.storage_outlined),
          label: const Text('استيعاب SQL UAT'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'وضع الدمج الحاكم',
          subtitle:
              'نسك يبقى تحت PalWakf؛ لا يملك Auth أو RBAC أو Shell مستقلًا في الإنتاج.',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: const [
              _MergeBadge(label: 'feature path: lib/features/nosok_system'),
              _MergeBadge(
                  label: 'public entry: /switch/nosok → /systems/nosok'),
              _MergeBadge(label: 'admin entry: /admin/systems/nosok'),
              _MergeBadge(label: 'RBAC source: PalWakf AccessProfile'),
              _MergeBadge(label: 'unit source: core.org_units'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'قائمة الدمج الفعلي',
          subtitle: 'هذه القائمة هي معيار التطبيق داخل الريبو الكامل للمنصة.',
          child: Column(
            children: const [
              _MergeStep(
                no: '01',
                title: 'نسخ نظام نسك',
                body:
                    'نسخ lib/features/nosok_system كما هو، دون نقل main.dart أو pubspec.yaml الخاصة بالمعاينة.',
                status: 'جاهز',
              ),
              _MergeStep(
                no: '02',
                title: 'تسجيل المسارات',
                body:
                    'استيراد NosokRoutes.publicRoutes وNosokRoutes.adminRoutes داخل route groups الحقيقية للمنصة.',
                status: 'جاهز كملف merge-ready',
              ),
              _MergeStep(
                no: '03',
                title: 'ربط AccessProfile',
                body:
                    'عمل override لـ nosokAccessProfileProvider من accessProfileProvider الحقيقي في PalWakf.',
                status: 'يلزم تطبيق داخل المنصة',
              ),
              _MergeStep(
                no: '04',
                title: 'تسجيل Dynamic Registry',
                body:
                    'تسجيل system_key=nosok مع route_base=/systems/nosok وadmin_route_base=/admin/systems/nosok.',
                status: 'SQL جاهز',
              ),
              _MergeStep(
                no: '05',
                title: 'تسجيل الصلاحيات والأدوار',
                body:
                    'إدخال permission keys وقوالب الأدوار داخل RBAC المنصة، لا داخل جدول محلي لنسك.',
                status: 'SQL جاهز',
              ),
              _MergeStep(
                no: '06',
                title: 'تشغيل SQL UAT',
                body:
                    'تشغيل rpc_nosok_v21_runtime_contract_uat_v1 ثم حفظ النتيجة في سجل أدلة الجاهزية.',
                status: 'ينتظر Supabase',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        NosokSectionCard(
          title: 'مخرجات الحزمة الجديدة',
          subtitle:
              'v21 أضافت مجلدًا منفصلًا للدمج الحقيقي لا يدخل في تحليل standalone preview.',
          child: DecoratedBox(
            decoration: BoxDecoration(
              color:
                  colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: SelectableText(
                'platform_real_merge_pack/\n'
                '  README_APPLY_TO_PALWAKF.md\n'
                '  lib/app/routing/route_groups/nosok_system_routes_group.dart\n'
                '  lib/core/access/nosok_access_profile_override.dart\n'
                '  sql/01_register_nosok_system_registry.sql\n'
                '  sql/02_register_nosok_rbac_permissions.sql\n'
                '  sql/03_register_nosok_system_sections.sql',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MergeStep extends StatelessWidget {
  const _MergeStep(
      {required this.no,
      required this.title,
      required this.body,
      required this.status});

  final String no;
  final String title;
  final String body;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(child: Text(no)),
        title: Text(title),
        subtitle: Text(body),
        trailing: Chip(label: Text(status)),
      ),
    );
  }
}

class _MergeBadge extends StatelessWidget {
  const _MergeBadge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.check_circle_outline, size: 18),
      label: Text(label),
    );
  }
}
