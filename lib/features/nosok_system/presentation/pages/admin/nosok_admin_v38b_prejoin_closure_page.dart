import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminV38BPrejoinClosurePage extends StatelessWidget {
  const NosokAdminV38BPrejoinClosurePage({super.key});

  static const _publicRuntimeRoutes = [
    [
      '/services/nosok',
      'الصفحة الرئيسية العامة',
      'جاهزة للفحص البصري والكونسول'
    ],
    [
      '/services/nosok/apply',
      'تقديم طلب',
      'يجب تأكيد عدم وجود RenderFlex/overflow بعد v37H'
    ],
    [
      '/services/nosok/track',
      'متابعة طلب',
      'تجربة مواطن بدون كشف بيانات حساسة'
    ],
    [
      '/services/nosok/lottery-results',
      'نتائج القرعة',
      'lookup آمن حسب الرقم المرجعي/الهوية'
    ],
    ['/services/nosok/waiting-list', 'قائمة الانتظار', 'عرض نتيجة المواطن فقط'],
    [
      '/services/nosok/objections',
      'الاعتراضات',
      'نموذج اعتراض عام بدون backend فعلي'
    ],
    [
      '/services/nosok/companies',
      'الشركات المؤهلة',
      'دليل عام للشركات المعتمدة'
    ],
    ['/services/nosok/contact', 'التواصل', 'دعم عام وصياغة مواطن'],
    ['/services/nosok/complaints', 'الشكاوى', 'قناة ملاحظة/شكوى عامة'],
  ];

  static const _companyWorkspaceContracts = [
    [
      'company_rep_scope',
      'ممثل الشركة يرى نطاق شركته فقط',
      'binding deferred until PalWakf RBAC'
    ],
    [
      'campaign_capacity',
      'سعة الحملات ومؤشرات الاكتمال',
      'contract-ready / no DB'
    ],
    [
      'linked_applicants',
      'قوائم الحجاج المرتبطين بالشركة',
      'contract-ready / no DB'
    ],
    ['missing_documents', 'النواقص والمرفقات للشركة', 'contract-ready / no DB'],
    ['partner_messages', 'رسائل الوزارة والشركة', 'contract-ready / no DB'],
    ['company_reports', 'تقارير الشركة الموسمية', 'contract-ready / no DB'],
  ];

  static const _schemaReviewRows = [
    ['nosok.seasons', 'season governance', 'final design / not applied'],
    [
      'nosok.applications',
      'application workflow',
      'final design / not applied'
    ],
    [
      'nosok.applicants',
      'citizen applicant profile',
      'final design / not applied'
    ],
    [
      'nosok.companions',
      'companions and mahram rules',
      'final design / not applied'
    ],
    [
      'nosok.documents',
      'document metadata and storage links',
      'final design / not applied'
    ],
    ['nosok.companies', 'qualified companies', 'final design / not applied'],
    ['nosok.campaigns', 'campaigns and capacity', 'final design / not applied'],
    [
      'nosok.lottery_policies',
      'seasonal configurable policy',
      'final design / not applied'
    ],
    [
      'nosok.lgu_quota_snapshots',
      'LGU quota snapshots',
      'final design / not applied'
    ],
    [
      'nosok.lottery_draw_runs',
      'draw execution evidence',
      'final design / not applied'
    ],
    [
      'nosok.lottery_draw_results',
      'winners and waiting lists',
      'final design / not applied'
    ],
    [
      'nosok.lottery_committee_decisions',
      'committee exception decisions',
      'final design / not applied'
    ],
    [
      'nosok.lottery_objections',
      'objection workflow',
      'final design / not applied'
    ],
    [
      'nosok.lottery_audit_events',
      'audit evidence',
      'final design / not applied'
    ],
  ];

  static const _roleResponsiveRows = [
    ['visitor', 'public pages only', '390/768/1366/wide'],
    ['citizen', 'own request / result / objection only', '390/768/1366/wide'],
    ['company_representative', 'company workspace only', '390/768/1366/wide'],
    ['nosok_employee', 'assigned operational queues', '768/1366/wide'],
    [
      'nosok_supervisor',
      'scope supervision and lottery queues',
      '768/1366/wide'
    ],
    ['system_admin', 'settings and reports', '1366/wide'],
    ['superuser', 'evidence center and all audit surfaces', '1366/wide'],
    ['restricted_user', 'forbidden/read-only behavior', '390/768/1366/wide'],
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
            title: 'Nosok v38B — إغلاق التطوير التحضيري قبل الانضمام',
            description:
                'دفعة تحضيرية نهائية داخل مشروع نسك فقط. تغلق مصفوفة واجهات الجمهور، تجهيز مساحة الشركات، مركز الأدلة، تصميم schema/RPC/RLS، وحزمة الانضمام إلى PalWakf دون تنفيذ الانضمام أو إنشاء الجداول أو تطبيق SQL.',
            badges: const [
              'v38B',
              'pre-join-development-closure',
              'development/preparation-only',
              'schema-not-created-by-design',
              'production-not-approved',
            ],
            actions: const [
              PwfSisStatusBadge(
                label: 'No PalWakf join execution',
                icon: Icons.hub_outlined,
                tone: PwfSisNoticeTone.warning,
              ),
              PwfSisStatusBadge(
                label: 'No SQL / No DML',
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
                label: 'Public Runtime',
                value: '9',
                subtitle: 'مسارات جمهور جاهزة للفحص النهائي',
                icon: Icons.public_outlined,
              ),
              PwfSisMetricCard(
                label: 'Company Workspace',
                value: '6',
                subtitle: 'عقود نطاق شركة قبل backend',
                icon: Icons.business_center_outlined,
              ),
              PwfSisMetricCard(
                label: 'Schema Design',
                value: '14',
                subtitle: 'جداول مصممة وغير مطبقة',
                icon: Icons.schema_outlined,
              ),
              PwfSisMetricCard(
                label: 'Roles',
                value: '8',
                subtitle: 'مصفوفة أدوار جاهزة للمنصة',
                icon: Icons.groups_2_outlined,
              ),
              PwfSisMetricCard(
                label: 'Join Package',
                value: 'READY',
                subtitle: 'حزمة تسليم للمنصة لا تنفيذ داخل نسك',
                icon: Icons.inventory_2_outlined,
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
            title: 'قرار v38B الحاكم',
            message:
                'هذه الدفعة لا تنفذ انضمام نسك إلى PalWakf. هي تغلق جاهزية نسك كحزمة استقبال: واجهات، عقود، مصفوفات، وحزمة تسليم. تنفيذ الانضمام الحقيقي يبقى من مسار منصة PalWakf بعد استيفاء شروط الاستضافة.',
            tone: PwfSisNoticeTone.warning,
          ),
          const SizedBox(height: 12),
          _MatrixPanel(
            title: 'Public Runtime UAT Closure Matrix',
            subtitle:
                'مسارات الجمهور المطلوب فحصها قبل تسليم حزمة الانضمام. لا تعرض هذه الصفحات أي لغة schema/RPC/RLS/backend للمواطن.',
            columns: const ['المسار', 'الواجهة', 'شرط الإغلاق'],
            rows: _publicRuntimeRoutes,
            badgeLabel: 'UAT target',
          ),
          const SizedBox(height: 12),
          _MatrixPanel(
            title: 'Company / Partner Workspace Preparation',
            subtitle:
                'تجهيز بوابة الشركة كمساحة شريك لا كلوحة إدارة وزارة. كل البنود contract-ready فقط حتى backend الحقيقي.',
            columns: const ['العقد', 'ما يمثله', 'حالة v38B'],
            rows: _companyWorkspaceContracts,
            badgeLabel: 'contract-ready',
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Evidence Center Hardening',
            subtitle:
                'تثبيت مركز الأدلة كمدخل موحد للجاهزية، بدل تشتيت صفحات التطوير التاريخية في لوحة الموظف.',
            child: PwfSisTimeline(
              items: const [
                'يبقى /admin/systems/nosok/evidence-center نقطة دخول وحيدة للأدلة قبل الانضمام.',
                'صفحات v24–v38 القديمة تبقى routable للتدقيق، لكنها ليست جزءًا من التشغيل اليومي.',
                'يحتوي المركز على public runtime evidence، role/responsive matrix، schema drafts، PalWakf join checklist، وproduction blockers.',
                'صلاحية الوصول: superuser أو readiness/platform-integration فقط عند الدمج الفعلي.',
              ],
            ),
          ),
          const SizedBox(height: 12),
          _MatrixPanel(
            title: 'Schema / RPC / RLS Final Design Review',
            subtitle:
                'تصميم نهائي غير مطبق. إنشاء schema نسك مؤجل حتى تصبح منصة PalWakf هي المضيف الفعلي.',
            columns: const ['العلاقة', 'الوظيفة', 'حالة v38B'],
            rows: _schemaReviewRows,
            badgeLabel: 'not applied',
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'PalWakf Join Package Finalization',
            subtitle:
                'محتويات حزمة التسليم التي يأخذها مسار منصة PalWakf عند قرار الاستقبال الفعلي.',
            child: PwfSisTimeline(
              items: const [
                'feature folder map: lib/features/nosok_system/**',
                'public/admin route map تحت /services/nosok و/admin/systems/nosok.',
                'permission catalog وrole catalog وAccessProfile override requirements.',
                'Dynamic System Registry entry draft وSystem Sections draft.',
                'Sidebar/Dashboard binding instructions وPWF-SIS/theme requirements.',
                'Health/Maintenance/Error Boundary requirements قبل production candidate.',
              ],
            ),
          ),
          const SizedBox(height: 12),
          _MatrixPanel(
            title: 'Role / Responsive Matrix Completion',
            subtitle:
                'المصفوفة التي يجب أن تنفذ داخل PalWakf لاحقًا. v38B يجهزها فقط ولا يعتمدها كدليل إنتاج.',
            columns: const ['الدور', 'نطاق الاختبار', 'أحجام الشاشة'],
            rows: _roleResponsiveRows,
            badgeLabel: 'matrix-ready',
          ),
          const SizedBox(height: 12),
          const PwfSisNotice(
            title: 'بوابة الإنتاج ما زالت مغلقة',
            message:
                'حتى بعد v38B لا يوجد اعتماد إنتاج: لا backend، لا schema، لا SQL، لا RBAC حقيقي داخل PalWakf، ولا UAT أدوار داخل المنصة. هذه الدفعة تغلق التحضير فقط.',
            tone: PwfSisNoticeTone.error,
          ),
        ],
      ),
    );
  }
}

class _MatrixPanel extends StatelessWidget {
  const _MatrixPanel({
    required this.title,
    required this.subtitle,
    required this.columns,
    required this.rows,
    required this.badgeLabel,
  });

  final String title;
  final String subtitle;
  final List<String> columns;
  final List<List<String>> rows;
  final String badgeLabel;

  @override
  Widget build(BuildContext context) {
    return PwfSisPanel(
      title: title,
      subtitle: subtitle,
      child: PwfSisDataTable(
        columns: columns,
        rows: [
          for (final row in rows)
            [
              Text(row[0]),
              Text(row[1]),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(row[2]),
                  PwfSisStatusBadge(
                      label: badgeLabel, icon: Icons.fact_check_outlined),
                ],
              ),
            ],
        ],
        cardBuilder: (row) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: row,
        ),
      ),
    );
  }
}
