import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_v38g_platform_schema_binding_controller.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38GPlatformSchemaBindingPage extends ConsumerWidget {
  const NosokAdminV38GPlatformSchemaBindingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contract = ref.watch(nosokV38GPlatformSchemaBindingContractProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const PwfSisSystemHero(
            title: 'Nosok v38G — تجهيز schema وربط مصادر المنصة',
            description:
                'دفعة تحضيرية تستفيد من قراءة ملفات PalWakf في محاولة v39 لاستخراج عقود الارتباط الصحيحة: المستخدمون من public.admin_users، نطاق الوحدات من core.org_units/RPC wrappers، والهيئات المحلية والمحافظات عبر مرجع GIS/Snapshot موسمي. لا يتم إنشاء schema أو تشغيل SQL هنا.',
            badges: [
              'v38G',
              'platform-aware',
              'schema-draft',
              'org-units',
              'admin-users',
              'homepage-sections'
            ],
            actions: [
              PwfSisStatusBadge(
                label: 'No SQL apply',
                icon: Icons.storage_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
              PwfSisStatusBadge(
                label: 'No waqf_assets mutation',
                icon: Icons.verified_user_outlined,
                tone: PwfSisNoticeTone.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisAdaptiveWorkspace(
            minTileWidth: 210,
            children: [
              PwfSisMetricCard(
                label: 'Platform sources',
                value: '${contract.platformSources.length}',
                subtitle: 'مصادر من ملفات PalWakf',
                icon: Icons.hub_outlined,
              ),
              PwfSisMetricCard(
                label: 'Nosok objects',
                value: '${contract.nosokSchemaObjects.length}',
                subtitle: 'جداول schema مقترحة',
                icon: Icons.table_chart_outlined,
              ),
              PwfSisMetricCard(
                label: 'Homepage objects',
                value: '${contract.homepageContentObjects.length}',
                subtitle: 'محتوى ديناميكي',
                icon: Icons.view_quilt_outlined,
              ),
              PwfSisMetricCard(
                label: 'Binding rules',
                value: '${contract.bindingRules.length}',
                subtitle: 'قواعد ربط أمنية',
                icon: Icons.link_outlined,
              ),
              const PwfSisMetricCard(
                label: 'Execution',
                value: 'DEFERRED',
                subtitle: 'بعد الاستضافة داخل PalWakf',
                icon: Icons.lock_clock_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'مصادر المنصة التي سيعتمد عليها نسك',
            subtitle:
                'هذه ليست قراءة runtime من قاعدة البيانات، بل عقود مستخلصة من ملفات PalWakf التي تمت مراجعتها في مسار v39 الملغى لمسار نسك.',
            child: PwfSisDataTable(
              columns: const ['المصدر', 'عقد PalWakf', 'استخدام نسك', 'الحالة'],
              rows: [
                for (final source in contract.platformSources)
                  [
                    Text(source.sourceName),
                    Text(source.platformContract),
                    Text(source.nosokUsage),
                    PwfSisStatusBadge(
                      label: source.bindingStatus,
                      icon: Icons.info_outline,
                      tone: source.bindingStatus.contains('required')
                          ? PwfSisNoticeTone.warning
                          : PwfSisNoticeTone.info,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Schema نسك المقترح المرتبط بالمنصة',
            subtitle:
                'يُنشأ لاحقًا داخل Supabase بعد اعتماد الاستضافة، مع shape discovery قبل أي تطبيق.',
            child: PwfSisDataTable(
              columns: const [
                'الكائن',
                'النوع',
                'الوظيفة',
                'اعتماد المنصة',
                'الحالة'
              ],
              rows: [
                for (final object in contract.nosokSchemaObjects)
                  [
                    Text(object.objectName),
                    Text(object.objectType),
                    Text(object.purposeAr),
                    Text(object.platformDependency),
                    PwfSisStatusBadge(
                      label: object.statusAr,
                      icon: Icons.pending_actions_outlined,
                      tone: PwfSisNoticeTone.warning,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'جدول أقسام الموقع والصفحات الديناميكية',
            subtitle:
                'هذا هو الجزء الذي يسمح لإدارة نسك بتعديل محتوى الصفحة الرئيسية وإضافة صفحات عامة دون الرجوع للمطور بعد تفعيل backend.',
            child: PwfSisDataTable(
              columns: const [
                'الكائن',
                'النوع',
                'الغرض',
                'الشرط الأمني',
                'الحالة'
              ],
              rows: [
                for (final object in contract.homepageContentObjects)
                  [
                    Text(object.objectName),
                    Text(object.objectType),
                    Text(object.purposeAr),
                    Text(object.platformDependency),
                    PwfSisStatusBadge(
                      label: object.statusAr,
                      icon: Icons.rule_folder_outlined,
                      tone: PwfSisNoticeTone.warning,
                    ),
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'قواعد الربط الحاكمة',
            subtitle:
                'هذه القواعد تمنع تكرار الهوية أو تجاوز نطاق الوحدة أو كشف محتوى غير منشور للجمهور.',
            child: PwfSisDataTable(
              columns: const ['القاعدة', 'النص الحاكم', 'آلية التنفيذ لاحقًا'],
              rows: [
                for (final rule in contract.bindingRules)
                  [
                    Text(rule.titleAr),
                    Text(rule.ruleAr),
                    Text(rule.enforcementAr)
                  ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'بوابات الأمان قبل تطبيق schema',
            subtitle:
                'لا يتحول هذا التصميم إلى تنفيذ إلا بعد اجتياز هذه البوابات داخل منصة PalWakf.',
            child: PwfSisTimeline(items: contract.securityGates),
          ),
        ],
      ),
    );
  }
}
