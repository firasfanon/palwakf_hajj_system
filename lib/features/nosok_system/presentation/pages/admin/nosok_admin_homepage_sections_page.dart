import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_prejoin_admin_tools_controller.dart';
import '../../../domain/models/nosok_prejoin_admin_tools_contract.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminHomepageSectionsPage extends ConsumerWidget {
  const NosokAdminHomepageSectionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokPrejoinAdminToolsContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'إدارة أقسام الصفحة الرئيسية — عقد تحضيري',
            description:
                'صفحة إدارية تحضيرية لنموذج إدارة أقسام الصفحة الرئيسية في نسك. تعرض تصميم جدول nosok.homepage_sections وكيف تتحكم الإدارة بما يظهر للجمهور حسب الموسم والنطاق، دون إنشاء الجدول أو تطبيق SQL قبل الانضمام إلى PalWakf.',
            badges: [
              'admin-tool',
              'homepage-sections',
              'draft-table-only',
              'no-sql-apply'
            ],
            actions: [
              PwfSisStatusBadge(
                  label: 'public-safe content only',
                  icon: Icons.public_outlined,
                  tone: PwfSisNoticeTone.success),
              PwfSisStatusBadge(
                  label: 'schema not created',
                  icon: Icons.storage_outlined,
                  tone: PwfSisNoticeTone.warning),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قرار حاكم',
            message:
                'هذه الصفحة لا تعتمد محتوى من قاعدة بيانات الآن. هي تجهيز إداري لما يجب أن يصبح جدولًا داخل schema نسك لاحقًا بعد الانضمام للمنصة. الواجهة العامة تستمر بقراءة fallback آمن إلى أن يتم إنشاء nosok.homepage_sections وRPC عام منشور فقط.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 230,
            children: [
              PwfSisMetricCard(
                  label: 'أقسام عامة',
                  value: '${contract.homepageSections.length}',
                  subtitle: 'Hero / موسم / خدمات / ثقة / دعم',
                  icon: Icons.view_quilt_outlined),
              const PwfSisMetricCard(
                  label: 'جدول مقترح',
                  value: '1',
                  subtitle: 'nosok.homepage_sections',
                  icon: Icons.table_chart_outlined),
              const PwfSisMetricCard(
                  label: 'RPC عام',
                  value: '1',
                  subtitle: 'published-only surface',
                  icon: Icons.public_outlined),
              const PwfSisMetricCard(
                  label: 'RPC إداري',
                  value: '1',
                  subtitle: 'RBAC protected admin surface',
                  icon: Icons.admin_panel_settings_outlined),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصفوفة أقسام الصفحة الرئيسية',
            subtitle:
                'ما يجب أن تتحكم به لوحة الإدارة مستقبلًا: إظهار/إخفاء، ترتيب، نافذة نشر، نطاق وحدة/موسم، نصوص وأزرار.',
            child: _HomepageSectionsTable(sections: contract.homepageSections),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'تصميم الجدول المقترح',
            subtitle:
                'لا يُنفذ الآن. يُسلّم للمنصة كجزء من schema creation pack بعد نجاح الاستضافة.',
            child: PwfSisDataTable(
              columns: const ['الحقل', 'الغرض', 'ملاحظات الحوكمة'],
              rows: const [
                [Text('id'), Text('معرّف القسم'), Text('UUID / generated')],
                [
                  Text('section_key'),
                  Text('مفتاح القسم'),
                  Text('hero, season_status, primary_services...')
                ],
                [
                  Text('title_ar / body_ar'),
                  Text('النص العام'),
                  Text('محتوى عربي فقط للجمهور في المرحلة الحالية')
                ],
                [
                  Text('route_path / cta_label_ar'),
                  Text('زر الإجراء'),
                  Text('يجب أن يطابق routes نسك العامة')
                ],
                [
                  Text('display_order'),
                  Text('الترتيب'),
                  Text('قابل للتعديل من الإدارة')
                ],
                [
                  Text('visibility_scope'),
                  Text('نطاق الظهور'),
                  Text('public / unit / season / company حسب السياسة')
                ],
                [
                  Text('unit_slug / season_key'),
                  Text('تقييد اختياري'),
                  Text('لا يستخدم لعزل بيانات حساسة بدون RBAC')
                ],
                [
                  Text('is_published'),
                  Text('النشر'),
                  Text('RPC العام يعرض المنشور فقط')
                ],
                [
                  Text('published_from/to'),
                  Text('نافذة النشر'),
                  Text('مرتبطة بسياسة الموسم')
                ],
                [
                  Text('audit fields'),
                  Text('من عدّل ومتى ولماذا'),
                  Text('مطلوب قبل الإنتاج')
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'الصفحات الإدارية تظهر حسب الصلاحيات',
            message:
                'إدارة المحتوى العام تحتاج manageNosokContent/manageNosokSurface. أما صفحات التشغيل الأخرى فتظهر حسب صلاحيات المستخدم، وليس لمجرد وجود route. عند الدمج يجب أن يحكم PalWakf AccessProfile الظهور والانتقال.',
            tone: PwfSisNoticeTone.info,
          ),
        ],
      ),
    );
  }
}

class _HomepageSectionsTable extends StatelessWidget {
  const _HomepageSectionsTable({required this.sections});

  final List<NosokHomepageSectionContract> sections;

  @override
  Widget build(BuildContext context) {
    return PwfSisDataTable(
      columns: const ['القسم', 'السطح', 'النطاق', 'الحالة', 'تحكم الإدارة'],
      rows: [
        for (final section in sections)
          [
            Text(section.titleAr),
            Text(section.surface),
            Text(section.visibilityScope),
            PwfSisStatusBadge(
                label: section.defaultState,
                icon: Icons.visibility_outlined,
                tone: PwfSisNoticeTone.success),
            Text(section.adminControl),
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
