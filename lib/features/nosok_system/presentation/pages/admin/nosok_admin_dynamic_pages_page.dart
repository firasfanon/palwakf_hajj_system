import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_prejoin_admin_tools_controller.dart';
import '../../../domain/models/nosok_prejoin_admin_tools_contract.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminDynamicPagesPage extends ConsumerWidget {
  const NosokAdminDynamicPagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokPrejoinAdminToolsContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'منشئ الصفحات والأقسام — عقد تحضيري',
            description:
                'لأن نسك نظام شبه مستقل، يجب أن يمتلك قدرة مستقبلية على إضافة صفحات عامة وأقسام جديدة من لوحة الإدارة دون الرجوع للمطور. هذه الصفحة تثبت العقد الإداري وقواعد القوالب والمسارات والصلاحيات، دون إنشاء schema أو تنفيذ SQL قبل الانضمام إلى PalWakf.',
            badges: [
              'dynamic-pages',
              'section-builder',
              'template-based',
              'pre-join-only',
              'no-sql-apply'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'content pages without developer',
                  icon: Icons.auto_awesome_motion_outlined,
                  tone: PwfSisNoticeTone.success),
              PwfSisStatusBadge(
                  label: 'admin pages require RBAC/RPC',
                  icon: Icons.admin_panel_settings_outlined,
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قاعدة حاكمة',
            message:
                'إضافة صفحات عامة مستقبلية تتم من قوالب معتمدة وسجل صفحات وأقسام ونوافذ نشر. أما الصفحات الإدارية الجديدة فلا تكفي كصفحات محتوى؛ يجب أن تملك permission key وroute contract وRPC/RLS ونطاق وحدة قبل تشغيلها داخل PalWakf.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 220,
            children: [
              PwfSisMetricCard(
                  label: 'قوالب صفحات',
                  value: '${contract.dynamicPages.length}',
                  subtitle: 'عام / موسم / شركة / إداري',
                  icon: Icons.web_stories_outlined),
              PwfSisMetricCard(
                  label: 'أقسام قابلة لإعادة الاستخدام',
                  value: '${contract.dynamicPageSections.length}',
                  subtitle: 'Blocks / Cards / FAQ / Tables',
                  icon: Icons.dashboard_customize_outlined),
              PwfSisMetricCard(
                  label: 'قواعد حوكمة',
                  value: '${contract.dynamicPageGovernanceRules.length}',
                  subtitle: 'slug / publish / RBAC / audit',
                  icon: Icons.rule_folder_outlined),
              const PwfSisMetricCard(
                  label: 'تنفيذ SQL',
                  value: 'NO',
                  subtitle: 'schema مؤجل حتى الاستضافة',
                  icon: Icons.storage_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'سجل الصفحات الديناميكية المقترح',
            subtitle:
                'هذه القوالب تسمح لمدير المحتوى بإضافة صفحات عامة مستقبلاً دون كود، وتمنع الصفحات الإدارية من الظهور دون RBAC/RPC.',
            child: _DynamicPagesTable(pages: contract.dynamicPages),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مكتبة الأقسام القابلة لإعادة الاستخدام',
            subtitle:
                'الأقسام تكون من أنواع معتمدة فقط، ولا تسمح بحقن كود أو HTML غير محكوم.',
            child:
                _DynamicSectionsTable(sections: contract.dynamicPageSections),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قواعد الأمان والنشر',
            subtitle:
                'القواعد التي تمنع التوسع العشوائي في الصفحات وتضمن أن النظام شبه مستقل دون أن يصبح غير محكوم.',
            child: _DynamicGovernanceTable(
                rules: contract.dynamicPageGovernanceRules),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'تصميم الجداول المستقبلية',
            subtitle:
                'Draft فقط. لا يتم إنشاء هذه الجداول الآن، بل تُسلّم لمنصة PalWakf ضمن schema creation pack بعد الاستضافة.',
            child: PwfSisDataTable(
              columns: const ['الكائن', 'الغرض', 'موانع الحوكمة'],
              rows: const [
                [
                  Text('nosok.page_registry'),
                  Text('سجل الصفحات العامة والإدارية الديناميكية'),
                  Text('slug آمن، route آمن، template معتمد، publish workflow')
                ],
                [
                  Text('nosok.page_sections'),
                  Text('أقسام الصفحات وترتيبها ومحتواها'),
                  Text('أنواع أقسام معتمدة فقط ولا HTML حر')
                ],
                [
                  Text('nosok.page_actions'),
                  Text('الأزرار والروابط المرتبطة بالصفحات'),
                  Text('روابط داخلية مصرح بها أو external allowlist')
                ],
                [
                  Text('nosok.page_templates'),
                  Text('قوالب صفحات وأقسام معتمدة'),
                  Text('أي قالب جديد يحتاج اعتماد فني/حوكمي قبل الاستخدام')
                ],
                [
                  Text('nosok.page_audit_events'),
                  Text('سجل إنشاء/نشر/إخفاء/أرشفة الصفحات'),
                  Text('إلزامي قبل الإنتاج ولا يجوز حذفه')
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DynamicPagesTable extends StatelessWidget {
  const _DynamicPagesTable({required this.pages});

  final List<NosokDynamicPageContract> pages;

  @override
  Widget build(BuildContext context) {
    return PwfSisDataTable(
      columns: const [
        'الصفحة',
        'نمط المسار',
        'الجمهور',
        'تحكم الإدارة',
        'الحالة'
      ],
      rows: [
        for (final page in pages)
          [
            Text(page.titleAr),
            Text(page.routePattern),
            Text(page.allowedAudience),
            Text(page.adminControl),
            PwfSisStatusBadge(
                label: page.status,
                icon: Icons.pending_actions_outlined,
                tone: PwfSisNoticeTone.warning),
          ],
      ],
      cardBuilder: (row) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row[0],
          const SizedBox(height: 6),
          row[1],
          const SizedBox(height: 6),
          row[2],
          const SizedBox(height: 6),
          row[3],
          const SizedBox(height: 6),
          row[4],
        ],
      ),
    );
  }
}

class _DynamicSectionsTable extends StatelessWidget {
  const _DynamicSectionsTable({required this.sections});

  final List<NosokDynamicPageSectionContract> sections;

  @override
  Widget build(BuildContext context) {
    return PwfSisDataTable(
      columns: const [
        'القسم',
        'النوع',
        'يعاد استخدامه في',
        'الحقول',
        'الحوكمة'
      ],
      rows: [
        for (final section in sections)
          [
            Text(section.titleAr),
            Text(section.componentType),
            Text(section.reusableOn),
            Text(section.contentFields),
            Text(section.governanceNoteAr),
          ],
      ],
      cardBuilder: (row) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row[0],
          const SizedBox(height: 6),
          row[1],
          const SizedBox(height: 6),
          row[2],
          const SizedBox(height: 6),
          row[3],
          const SizedBox(height: 6),
          row[4],
        ],
      ),
    );
  }
}

class _DynamicGovernanceTable extends StatelessWidget {
  const _DynamicGovernanceTable({required this.rules});

  final List<NosokDynamicPageGovernanceRuleContract> rules;

  @override
  Widget build(BuildContext context) {
    return PwfSisDataTable(
      columns: const ['القاعدة', 'التفصيل', 'طبقة الأمان', 'الحالة'],
      rows: [
        for (final rule in rules)
          [
            Text(rule.titleAr),
            Text(rule.ruleAr),
            Text(rule.securityLayer),
            PwfSisStatusBadge(
                label: rule.status,
                icon: Icons.rule_outlined,
                tone: PwfSisNoticeTone.info),
          ],
      ],
      cardBuilder: (row) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row[0],
          const SizedBox(height: 6),
          row[1],
          const SizedBox(height: 6),
          row[2],
          const SizedBox(height: 6),
          row[3],
        ],
      ),
    );
  }
}
