import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38ReadinessConsolidationPage extends StatelessWidget {
  const NosokAdminV38ReadinessConsolidationPage({super.key});

  static const _publicRoutes = [
    '/services/nosok',
    '/services/nosok/apply',
    '/services/nosok/track',
    '/services/nosok/lottery-results',
    '/services/nosok/waiting-list',
    '/services/nosok/objections',
    '/services/nosok/companies',
    '/services/nosok/contact',
    '/services/nosok/complaints',
    '/services/nosok/faq',
  ];

  static const _operationalAdminRoutes = [
    '/admin/systems/nosok',
    '/admin/systems/nosok/requests',
    '/admin/systems/nosok/review',
    '/admin/systems/nosok/lottery',
    '/admin/systems/nosok/campaigns',
    '/admin/systems/nosok/companies',
    '/admin/systems/nosok/documents',
    '/admin/systems/nosok/messages',
    '/admin/systems/nosok/reports',
    '/admin/systems/nosok/settings',
  ];

  static const _schemaTables = [
    'nosok.seasons',
    'nosok.applications',
    'nosok.applicants',
    'nosok.companions',
    'nosok.documents',
    'nosok.companies',
    'nosok.campaigns',
    'nosok.lottery_policies',
    'nosok.lgu_quota_snapshots',
    'nosok.lottery_draw_runs',
    'nosok.lottery_draw_results',
    'nosok.lottery_committee_decisions',
    'nosok.lottery_objections',
    'nosok.lottery_audit_events',
  ];

  static const _roleRows = [
    [
      'visitor',
      'يرى البوابة العامة والشروط والمساعدة فقط',
      'لا يرى الطلبات أو لوحة الموظفين'
    ],
    [
      'citizen',
      'يتابع طلبه ونتيجته واعتراضه فقط',
      'لا يرى بيانات الآخرين أو audit داخلي'
    ],
    [
      'company_rep',
      'يرى نطاق الشركة والحملات المسندة فقط',
      'لا يرى إدارة الوزارة أو شركات أخرى'
    ],
    [
      'nosok_employee',
      'يراجع الطلبات المسندة ونواقصها',
      'لا يدير السياسات أو القرعة'
    ],
    [
      'nosok_supervisor',
      'يدير نطاقه والقرعة/الانتظار حسب الصلاحية',
      'لا يتجاوز نطاقه دون تفويض'
    ],
    [
      'system_admin',
      'يدير الإعدادات والتقارير والصلاحيات المحددة',
      'لا يعتمد الإنتاج وحده'
    ],
    ['superuser', 'يرى كل المسارات مع audit', 'كل override يحتاج سببًا'],
    ['restricted', 'read-only أو forbidden', 'لا إجراءات تشغيلية'],
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v38 — إغلاق جاهزية staging قبل دمج PalWakf',
            description:
                'حزمة تجميع نهائية قبل الدمج الفعلي داخل منصة PalWakf. تستوعب نتيجة التشغيل المحلية النظيفة، تنظّف عرض لوحة الموظف من صفحات الأدلة التاريخية، وتجمع مسارات الدمج وUAT وschema creation pack في مركز أدلة واحد. لا تنشئ هذه الدفعة جداول ولا تطبق SQL ولا تعتمد الإنتاج.',
            badges: const [
              'v38',
              'final-staging-consolidation',
              'analyzer-clean',
              'chrome-startup-passed',
              'schema-not-created-by-design',
              'production-not-approved',
            ],
            actions: const [
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
            minTileWidth: 220,
            children: const [
              PwfSisMetricCard(
                label: 'Flutter Retest',
                value: 'PASS',
                subtitle:
                    'format 0 changed / analyze clean / Chrome startup passed',
                icon: Icons.verified_outlined,
              ),
              PwfSisMetricCard(
                label: 'Public Runtime',
                value: '10',
                subtitle: 'مسارات عامة مطلوبة للفحص النهائي',
                icon: Icons.public_outlined,
              ),
              PwfSisMetricCard(
                label: 'Admin Ops',
                value: '10',
                subtitle: 'مسارات تشغيلية تظهر في لوحة الموظف',
                icon: Icons.admin_panel_settings_outlined,
              ),
              PwfSisMetricCard(
                label: 'Schema Pack',
                value: '14',
                subtitle: 'جداول مصممة وغير منشأة عمدًا',
                icon: Icons.schema_outlined,
              ),
              PwfSisMetricCard(
                label: 'Role Matrix',
                value: '8',
                subtitle: 'أدوار UAT قبل الإنتاج',
                icon: Icons.groups_2_outlined,
              ),
              PwfSisMetricCard(
                label: 'Production',
                value: 'NO',
                subtitle: 'مؤجل حتى الدمج والـ backend الحقيقي',
                icon: Icons.gpp_maybe_outlined,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'قرار v38 الحاكم',
            message:
                'v38 يغلق مرحلة staging المتقدمة فقط. الدمج الفعلي داخل PalWakf وإنشاء schema نسك وربط Supabase الحقيقي ما زالت مراحل لاحقة تحتاج ريبو المنصة وبيئة قاعدة البيانات وتصريح SQL منفصل.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          _RoutePanel(
            title: 'Public Runtime Retest Closure Matrix',
            subtitle:
                'هذه المسارات يجب فحصها في المتصفح وعلى الموبايل قبل الانتقال للدمج داخل PalWakf.',
            routes: _publicRoutes,
            status: 'browser/console UAT required',
          ),
          const SizedBox(height: 12),
          _RoutePanel(
            title: 'Admin Operations Cleanup',
            subtitle:
                'هذه هي المسارات التشغيلية التي يجب أن تبقى ظاهرة في لوحة الموظف. صفحات v24–v36 والـ SQL/merge evidence لا تظهر في sidebar التشغيلي، بل تُجمع في مركز الأدلة.',
            routes: _operationalAdminRoutes,
            status: 'operational sidebar target',
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Evidence Center Consolidation',
            subtitle:
                'المركز الواحد المقترح للأدلة والجاهزية وسجلات UAT بدل تشتيتها في لوحة الموظفين.',
            child: PwfSisTimeline(
              items: const [
                'إتاحة /admin/systems/nosok/evidence-center كمدخل واحد للأدلة.',
                'إبقاء routes التاريخية v24–v36 موجودة للتدقيق، لكن خارج sidebar التشغيلي.',
                'تجميع: merge readiness، SQL/RPC/RLS drafts، browser evidence، role UAT، production gate، error records.',
                'قصر الوصول على superuser أو صلاحيات readiness/platform integration.',
              ],
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Nosok Schema Creation Ready Pack',
            subtitle:
                'تصميم نهائي غير مطبّق. لا يتم إنشاء schema إلا بعد دمج نسك داخل PalWakf.',
            child: PwfSisDataTable(
              columns: const ['الجدول', 'الملكية', 'حالة v38'],
              rows: [
                for (final table in _schemaTables)
                  [
                    Text(table),
                    const Text('nosok schema'),
                    const PwfSisStatusBadge(
                      label: 'draft-ready / not applied',
                      icon: Icons.pending_actions_outlined,
                      tone: PwfSisNoticeTone.warning,
                    ),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Role/Responsive UAT Matrix',
            subtitle: 'مصفوفة إلزامية قبل production candidate داخل PalWakf.',
            child: PwfSisDataTable(
              columns: const ['الدور', 'المسموح', 'المحظور/القيد'],
              rows: [
                for (final row in _roleRows)
                  [Text(row[0]), Text(row[1]), Text(row[2])],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: row),
            ),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Production Blockers',
            subtitle: 'هذه البنود لا تزال تمنع إعلان production-ready.',
            child: PwfSisTimeline(
              items: const [
                'Actual PalWakf repo merge لم يثبت بعد.',
                'Dynamic System Registry entry داخل المنصة لم يطبق فعليًا.',
                'AccessProfile الحقيقي وRBAC route guards داخل PalWakf لم يغلقا بأدلة أدوار.',
                'nosok schema لم تُنشأ عمدًا قبل الدمج.',
                'Supabase RLS/RPC/storage policies ما زالت draft/readiness فقط.',
                'Browser/role/responsive UAT داخل PalWakf ما زال مطلوبًا.',
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoutePanel extends StatelessWidget {
  const _RoutePanel({
    required this.title,
    required this.subtitle,
    required this.routes,
    required this.status,
  });

  final String title;
  final String subtitle;
  final List<String> routes;
  final String status;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: title,
      subtitle: subtitle,
      child: PwfSisDataTable(
        columns: const ['المسار', 'الحالة'],
        rows: [
          for (final route in routes)
            [
              Text(route),
              PwfSisStatusBadge(label: status, icon: Icons.fact_check_outlined),
            ],
        ],
        cardBuilder: (row) =>
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: row),
      ),
    );
  }
}
