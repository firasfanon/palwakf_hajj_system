class NosokV24CheckItem {
  const NosokV24CheckItem({
    required this.key,
    required this.titleAr,
    required this.status,
    required this.noteAr,
    this.priority = 'P1',
  });

  final String key;
  final String titleAr;
  final String status;
  final String noteAr;
  final String priority;

  bool get passed => status == 'passed';
  bool get blocked => status == 'blocked';
}

class NosokV24EvidenceGroup {
  const NosokV24EvidenceGroup({
    required this.titleAr,
    required this.descriptionAr,
    required this.items,
  });

  final String titleAr;
  final String descriptionAr;
  final List<NosokV24CheckItem> items;

  int get passedCount => items.where((item) => item.passed).length;
  int get blockersCount => items.where((item) => item.blocked).length;
}

class NosokV24ProductionDecision {
  const NosokV24ProductionDecision({
    required this.status,
    required this.reasonAr,
    required this.nextGateAr,
  });

  final String status;
  final String reasonAr;
  final String nextGateAr;

  bool get approved => status == 'production-approved';
}

class NosokV24UatPack {
  const NosokV24UatPack({
    required this.browserGroups,
    required this.roleGroups,
    required this.responsiveGroups,
    required this.mergeGroups,
    required this.supabaseGroups,
    required this.decision,
  });

  final List<NosokV24EvidenceGroup> browserGroups;
  final List<NosokV24EvidenceGroup> roleGroups;
  final List<NosokV24EvidenceGroup> responsiveGroups;
  final List<NosokV24EvidenceGroup> mergeGroups;
  final List<NosokV24EvidenceGroup> supabaseGroups;
  final NosokV24ProductionDecision decision;

  List<NosokV24EvidenceGroup> get allGroups => <NosokV24EvidenceGroup>[
        ...browserGroups,
        ...roleGroups,
        ...responsiveGroups,
        ...mergeGroups,
        ...supabaseGroups,
      ];

  int get totalChecks =>
      allGroups.fold<int>(0, (total, group) => total + group.items.length);
  int get passedChecks =>
      allGroups.fold<int>(0, (total, group) => total + group.passedCount);
  int get blockers =>
      allGroups.fold<int>(0, (total, group) => total + group.blockersCount);

  static NosokV24UatPack baseline() {
    const browser = <NosokV24EvidenceGroup>[
      NosokV24EvidenceGroup(
        titleAr: 'Browser UAT — الواجهة العامة',
        descriptionAr:
            'فتح مسارات الجمهور بعد v23.2 دون أخطاء analyzer ودون raw backend traces.',
        items: <NosokV24CheckItem>[
          NosokV24CheckItem(
              key: 'public_home',
              titleAr: '/services/nosok',
              status: 'passed',
              noteAr:
                  'صفحة الخدمة العامة تعمل ضمن PWF-SIS وتذكر مناسكنا كقناة إرشادية.'),
          NosokV24CheckItem(
              key: 'public_apply',
              titleAr: '/services/nosok/apply',
              status: 'passed',
              noteAr:
                  'Form Wizard ظاهر، والاختبار التشغيلي النهائي للرفع الفعلي يبقى مع Supabase.'),
          NosokV24CheckItem(
              key: 'public_track',
              titleAr: '/services/nosok/track',
              status: 'passed',
              noteAr:
                  'التتبع العام منفصل عن الواجهة الداخلية ولا يكشف audit أو RBAC.'),
          NosokV24CheckItem(
              key: 'public_requirements',
              titleAr: '/services/nosok/requirements',
              status: 'passed',
              noteAr:
                  'تم إصلاح compile blocker في PwfSisNotice والحفاظ على ذكر مناسكنا.'),
          NosokV24CheckItem(
              key: 'public_faq',
              titleAr: '/services/nosok/faq',
              status: 'pending-evidence',
              noteAr:
                  'يفتح ضمن القائمة، ويتطلب لقطة Browser UAT موثقة قبل production-candidate.'),
        ],
      ),
      NosokV24EvidenceGroup(
        titleAr: 'Browser UAT — الواجهة الداخلية',
        descriptionAr: 'فتح Console الموظف مع فصلها عن بوابة الجمهور.',
        items: <NosokV24CheckItem>[
          NosokV24CheckItem(
              key: 'admin_home',
              titleAr: '/admin/systems/nosok',
              status: 'passed',
              noteAr: 'لوحة داخلية مستقلة داخل Platform Admin Shell.'),
          NosokV24CheckItem(
              key: 'admin_requests',
              titleAr: '/admin/systems/nosok/requests',
              status: 'passed',
              noteAr: 'صفحة الطلبات ضمن Internal Operations Console.'),
          NosokV24CheckItem(
              key: 'admin_review',
              titleAr: '/admin/systems/nosok/review',
              status: 'passed',
              noteAr: 'Review Queue مفصولة عن الصفحة الرئيسية.'),
          NosokV24CheckItem(
              key: 'admin_campaigns',
              titleAr: '/admin/systems/nosok/campaigns',
              status: 'passed',
              noteAr: 'الحملات تظهر كسطح تفصيلي لا كبطاقات مزدحمة.'),
          NosokV24CheckItem(
              key: 'admin_documents',
              titleAr: '/admin/systems/nosok/documents',
              status: 'passed',
              noteAr:
                  'سطح وثائق مستقل مع تكامل document_intelligence ك planned عند غياب backend.'),
          NosokV24CheckItem(
              key: 'admin_messages',
              titleAr: '/admin/systems/nosok/messages',
              status: 'passed',
              noteAr: 'صندوق مراسلات/متابعة منفصل.'),
        ],
      ),
    ];

    const roles = <NosokV24EvidenceGroup>[
      NosokV24EvidenceGroup(
        titleAr: 'Role Matrix — فصل الواجهات حسب الدور',
        descriptionAr:
            'لا يكفي إخفاء بصري؛ يجب أن تؤكد منصة PalWakf route guards وAccessProfile override عند الدمج الحقيقي.',
        items: <NosokV24CheckItem>[
          NosokV24CheckItem(
              key: 'visitor',
              titleAr: 'زائر',
              status: 'passed',
              noteAr: 'يرى بوابة الخدمات العامة ولا يرى Console الموظف.'),
          NosokV24CheckItem(
              key: 'citizen',
              titleAr: 'مواطن/مراجع',
              status: 'pending-evidence',
              noteAr:
                  'يحتاج اختبار تتبع طلب واحد فقط بعد تشغيل Supabase runtime.'),
          NosokV24CheckItem(
              key: 'employee',
              titleAr: 'موظف نسك',
              status: 'pending-evidence',
              noteAr:
                  'يتطلب ربط nosokAccessProfileProvider مع AccessProfile الحقيقي.'),
          NosokV24CheckItem(
              key: 'supervisor',
              titleAr: 'مشرف نسك',
              status: 'pending-evidence',
              noteAr: 'يتطلب Role UAT للطلبات والحملات والتقارير حسب النطاق.'),
          NosokV24CheckItem(
              key: 'system_admin',
              titleAr: 'مدير النظام',
              status: 'pending-evidence',
              noteAr:
                  'يتطلب إثبات رؤية الإعدادات والصلاحيات دون كسر RBAC المنصة.'),
          NosokV24CheckItem(
              key: 'superuser',
              titleAr: 'Superuser',
              status: 'pending-evidence',
              noteAr: 'يتطلب إثبات override كامل وظهور audit/health.'),
          NosokV24CheckItem(
              key: 'restricted',
              titleAr: 'مستخدم مقيد',
              status: 'pending-evidence',
              noteAr: 'يجب أن يظهر read-only أو forbidden حسب عقد المنصة.'),
        ],
      ),
    ];

    const responsive = <NosokV24EvidenceGroup>[
      NosokV24EvidenceGroup(
        titleAr: 'Responsive UAT — Anti-Overload UX',
        descriptionAr:
            'تأكيد التحول من الجداول إلى cards/wizard/bottom sheets حيث يلزم.',
        items: <NosokV24CheckItem>[
          NosokV24CheckItem(
              key: 'desktop',
              titleAr: 'Desktop',
              status: 'passed',
              noteAr: 'الواجهة تعمل على Chrome preview.'),
          NosokV24CheckItem(
              key: 'laptop',
              titleAr: 'Laptop',
              status: 'pending-evidence',
              noteAr: 'مطلوب لقطة 1366px.'),
          NosokV24CheckItem(
              key: 'tablet',
              titleAr: 'Tablet',
              status: 'pending-evidence',
              noteAr: 'مطلوب اختبار تكديس panels وتقليل الأعمدة.'),
          NosokV24CheckItem(
              key: 'mobile',
              titleAr: 'Mobile',
              status: 'pending-evidence',
              noteAr:
                  'مطلوب اختبار نموذج التقديم وصفحات الطلبات دون overflow.'),
        ],
      ),
    ];

    const merge = <NosokV24EvidenceGroup>[
      NosokV24EvidenceGroup(
        titleAr: 'PalWakf Merge Readiness',
        descriptionAr: 'تجهيز نقل نسك من preview host إلى ريبو المنصة الكامل.',
        items: <NosokV24CheckItem>[
          NosokV24CheckItem(
              key: 'feature_copy',
              titleAr: 'نسخ feature',
              status: 'ready',
              noteAr: 'lib/features/nosok_system جاهز للنقل.'),
          NosokV24CheckItem(
              key: 'route_group',
              titleAr: 'GoRouter route group',
              status: 'ready',
              noteAr: 'NosokRoutes موجودة مع public/internal separation.'),
          NosokV24CheckItem(
              key: 'access_override',
              titleAr: 'AccessProfile override',
              status: 'blocked',
              noteAr:
                  'لا يغلق قبل التطبيق داخل PalWakf الكامل وربطه بالمصدر السيادي.',
              priority: 'P0'),
          NosokV24CheckItem(
              key: 'system_registry',
              titleAr: 'Dynamic Registry',
              status: 'ready',
              noteAr:
                  'ملفات platform_real_merge_pack موجودة وتحتاج تنفيذ داخل المنصة.'),
          NosokV24CheckItem(
              key: 'visual_identity',
              titleAr: 'Visual Identity Admin compatibility',
              status: 'ready',
              noteAr:
                  'الواجهة تعتمد ThemeData/colorScheme ولا تملك هوية منفصلة.'),
        ],
      ),
    ];

    const supabase = <NosokV24EvidenceGroup>[
      NosokV24EvidenceGroup(
        titleAr: 'Supabase Runtime UAT',
        descriptionAr: 'حزمة فحص read-only قبل أي SQL إنتاجي أو seed staging.',
        items: <NosokV24CheckItem>[
          NosokV24CheckItem(
              key: 'schema_presence',
              titleAr: 'nosok schema',
              status: 'pending-supabase',
              noteAr: 'يفحص عبر sql/22_nosok_v24_read_only_uat_pack.sql.'),
          NosokV24CheckItem(
              key: 'rpc_presence',
              titleAr: 'RPC wrappers',
              status: 'pending-supabase',
              noteAr: 'يفحص وجود wrappers العامة والإدارية دون DML.'),
          NosokV24CheckItem(
              key: 'storage_policy',
              titleAr: 'Storage policy',
              status: 'pending-supabase',
              noteAr: 'يفحص وجود bucket/policies بعد تطبيق setup المصرح.'),
          NosokV24CheckItem(
              key: 'rls_review',
              titleAr: 'RLS review',
              status: 'pending-supabase',
              noteAr: 'لا اعتماد قبل إثبات RLS/permissions.'),
        ],
      ),
    ];

    return const NosokV24UatPack(
      browserGroups: browser,
      roleGroups: roles,
      responsiveGroups: responsive,
      mergeGroups: merge,
      supabaseGroups: supabase,
      decision: NosokV24ProductionDecision(
        status: 'production-not-approved',
        reasonAr:
            'الواجهة مستقرة وChrome preview يعمل، لكن الإنتاج مشروط بتطبيق الدمج داخل PalWakf الكامل وSQL/Role/Responsive UAT.',
        nextGateAr:
            'v25 يجب أن يستوعب نتائج SQL UAT وBrowser/Role/Responsive evidence بعد التنفيذ الحقيقي.',
      ),
    );
  }
}
