class NosokV25EvidenceItem {
  const NosokV25EvidenceItem({
    required this.key,
    required this.titleAr,
    required this.status,
    required this.noteAr,
    this.priority = 'P1',
    this.ownerAr = 'فريق نسك/المنصة',
  });

  final String key;
  final String titleAr;
  final String status;
  final String noteAr;
  final String priority;
  final String ownerAr;

  bool get passed => status == 'passed';
  bool get blocked => status == 'blocked';
  bool get pending => status.startsWith('pending');
}

class NosokV25EvidenceSection {
  const NosokV25EvidenceSection({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.items,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final List<NosokV25EvidenceItem> items;

  int get total => items.length;
  int get passedCount => items.where((item) => item.passed).length;
  int get blockedCount => items.where((item) => item.blocked).length;
  int get pendingCount => items.where((item) => item.pending).length;
}

class NosokV25ProductionCandidateDecision {
  const NosokV25ProductionCandidateDecision({
    required this.status,
    required this.reasonAr,
    required this.nextActionAr,
    required this.allowedScopeAr,
  });

  final String status;
  final String reasonAr;
  final String nextActionAr;
  final String allowedScopeAr;

  bool get isCandidate => status == 'production-candidate';
}

class NosokV25EvidencePack {
  const NosokV25EvidencePack({
    required this.runtimeEvidence,
    required this.browserEvidence,
    required this.roleEvidence,
    required this.responsiveEvidence,
    required this.mergeApplication,
    required this.supabaseEvidence,
    required this.decision,
  });

  final NosokV25EvidenceSection runtimeEvidence;
  final NosokV25EvidenceSection browserEvidence;
  final NosokV25EvidenceSection roleEvidence;
  final NosokV25EvidenceSection responsiveEvidence;
  final NosokV25EvidenceSection mergeApplication;
  final NosokV25EvidenceSection supabaseEvidence;
  final NosokV25ProductionCandidateDecision decision;

  List<NosokV25EvidenceSection> get allSections => <NosokV25EvidenceSection>[
        runtimeEvidence,
        browserEvidence,
        roleEvidence,
        responsiveEvidence,
        mergeApplication,
        supabaseEvidence,
      ];

  int get totalChecks =>
      allSections.fold<int>(0, (total, section) => total + section.total);
  int get passedChecks =>
      allSections.fold<int>(0, (total, section) => total + section.passedCount);
  int get blockers => allSections.fold<int>(
      0, (total, section) => total + section.blockedCount);
  int get pendingChecks => allSections.fold<int>(
      0, (total, section) => total + section.pendingCount);

  static NosokV25EvidencePack baseline() {
    const runtime = NosokV25EvidenceSection(
      key: 'runtime_evidence',
      titleAr: 'استيعاب أدلة التشغيل المحلي',
      descriptionAr:
          'نتيجة v24.2: التحليل نظيف وChrome startup نجح، مع بقاء Browser UAT التفصيلي مطلوبًا كأدلة لقطات/Console.',
      items: <NosokV25EvidenceItem>[
        NosokV25EvidenceItem(
            key: 'flutter_clean',
            titleAr: 'flutter clean',
            status: 'passed',
            noteAr: 'نجح في سجل التشغيل الأخير.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'pub_get',
            titleAr: 'flutter pub get',
            status: 'passed',
            noteAr: 'نجح مع ملاحظات outdated فقط، دون كسر constraints.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'dart_format',
            titleAr: 'dart format',
            status: 'passed',
            noteAr: 'تم تنسيق 160 ملفًا في آخر سجل.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'flutter_analyze',
            titleAr: 'flutter analyze',
            status: 'passed',
            noteAr: 'No issues found في آخر سجل v24.2.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'chrome_startup',
            titleAr: 'flutter run -d chrome',
            status: 'passed',
            noteAr: 'وصل إلى Debug Service بدون compile blockers.',
            priority: 'P0'),
      ],
    );

    const browser = NosokV25EvidenceSection(
      key: 'browser_evidence',
      titleAr: 'Browser UAT Evidence Intake',
      descriptionAr:
          'استيعاب حالة فتح مسارات الجمهور والموظف. هذه الصفحة لا تعتمد الإنتاج دون أدلة Console/Responsive/Role.',
      items: <NosokV25EvidenceItem>[
        NosokV25EvidenceItem(
            key: 'public_services',
            titleAr: '/services/nosok',
            status: 'passed',
            noteAr: 'أبلغ المستخدم أن كل الصفحات تعمل بعد v23.2/v24.2.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'public_apply',
            titleAr: '/services/nosok/apply',
            status: 'passed',
            noteAr:
                'Form wizard ضمن بوابة الجمهور، مع استمرار اختبار Supabase runtime لاحقًا.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'public_track',
            titleAr: '/services/nosok/track',
            status: 'passed',
            noteAr:
                'التتبع العام يعمل في preview؛ يجب توثيق عدم كشف بيانات حساسة عند تشغيل Supabase.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'public_requirements',
            titleAr: '/services/nosok/requirements',
            status: 'passed',
            noteAr: 'تم إصلاح compile blocker السابق، وذكر مناسكنا محفوظ.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'internal_console',
            titleAr: '/admin/systems/nosok',
            status: 'passed',
            noteAr: 'لوحة النظام تفتح ضمن preview host.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'console_review',
            titleAr: 'Browser console review',
            status: 'pending-evidence',
            noteAr: 'يلزم إرفاق لقطة أو سجل Console نظيف لكل المسارات الحرجة.',
            priority: 'P0'),
      ],
    );

    const roles = NosokV25EvidenceSection(
      key: 'role_evidence',
      titleAr: 'Role UAT Evidence Intake',
      descriptionAr:
          'التحقق من فصل واجهة المواطن عن الموظف وفق AccessProfile الحقيقي داخل PalWakf، لا وفق preview فقط.',
      items: <NosokV25EvidenceItem>[
        NosokV25EvidenceItem(
            key: 'visitor',
            titleAr: 'زائر',
            status: 'passed',
            noteAr: 'بوابة الجمهور منفصلة عن Internal Console في الواجهة.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'citizen',
            titleAr: 'مواطن',
            status: 'pending-evidence',
            noteAr:
                'يحتاج إثبات تتبع/استكمال طلب واحد فقط بعد تشغيل Supabase runtime.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'employee',
            titleAr: 'موظف نسك',
            status: 'pending-evidence',
            noteAr:
                'لا يغلق قبل ربط nosokAccessProfileProvider بمصدر AccessProfile الحقيقي.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'supervisor',
            titleAr: 'مشرف نسك',
            status: 'pending-evidence',
            noteAr: 'يلزم إثبات نطاق الوحدات والحملات.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'system_admin',
            titleAr: 'مدير النظام',
            status: 'pending-evidence',
            noteAr: 'يلزم إثبات الوصول للإعدادات والتقارير دون تجاوز RBAC.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'superuser',
            titleAr: 'Superuser',
            status: 'pending-evidence',
            noteAr: 'يلزم إثبات override كامل وظهور audit/health.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'restricted',
            titleAr: 'مستخدم مقيد',
            status: 'pending-evidence',
            noteAr: 'يلزم إثبات read-only أو forbidden حسب العقد.',
            priority: 'P0'),
      ],
    );

    const responsive = NosokV25EvidenceSection(
      key: 'responsive_evidence',
      titleAr: 'Responsive / Anti-Overload Evidence',
      descriptionAr:
          'تقييم mobile/tablet/desktop بعد Mega UI. لا يكفي فتح Chrome desktop فقط.',
      items: <NosokV25EvidenceItem>[
        NosokV25EvidenceItem(
            key: 'desktop',
            titleAr: 'Desktop',
            status: 'passed',
            noteAr: 'Chrome startup وفتح الصفحات تم عبر Desktop preview.',
            priority: 'P1'),
        NosokV25EvidenceItem(
            key: 'laptop',
            titleAr: 'Laptop 1366px',
            status: 'pending-evidence',
            noteAr: 'مطلوب لقطة تؤكد عدم وجود overflow.',
            priority: 'P1'),
        NosokV25EvidenceItem(
            key: 'tablet',
            titleAr: 'Tablet',
            status: 'pending-evidence',
            noteAr: 'مطلوب اختبار تكديس panels وتحول الجداول.',
            priority: 'P1'),
        NosokV25EvidenceItem(
            key: 'mobile',
            titleAr: 'Mobile',
            status: 'pending-evidence',
            noteAr:
                'مطلوب اختبار Wizard، tracking، requests cards بلا horizontal overflow.',
            priority: 'P1'),
      ],
    );

    const merge = NosokV25EvidenceSection(
      key: 'full_pwf_merge',
      titleAr: 'Full PalWakf Merge Application Result Intake',
      descriptionAr:
          'تسجيل نتيجة تطبيق platform_real_merge_pack داخل ريبو المنصة الكامل. لا يمكن إغلاقها داخل preview host.',
      items: <NosokV25EvidenceItem>[
        NosokV25EvidenceItem(
            key: 'feature_copy',
            titleAr: 'نسخ feature إلى PalWakf',
            status: 'pending-real-merge',
            noteAr: 'يلزم تطبيق داخل ريبو PalWakf الكامل.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'route_group_apply',
            titleAr: 'دمج route group الحقيقي',
            status: 'pending-real-merge',
            noteAr: 'يلزم ربط GoRouter الحقيقي دون كسر unitSlug أو shell.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'rbac_override_apply',
            titleAr: 'RBAC Provider Override',
            status: 'blocked',
            noteAr:
                'لا production-candidate قبل ربط provider بمصدر PalWakf الحقيقي.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'registry_sections_apply',
            titleAr: 'Dynamic Registry + Sections',
            status: 'pending-real-merge',
            noteAr: 'يلزم تشغيل SQL التسجيل أو إدراجه حسب عقد المنصة.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'visual_identity_admin',
            titleAr: 'Visual Identity Admin compatibility',
            status: 'ready',
            noteAr:
                'جاهز مبدئيًا لأن الواجهة تعتمد ThemeData/colorScheme ولا تملك هوية مستقلة.',
            priority: 'P1'),
      ],
    );

    const supabase = NosokV25EvidenceSection(
      key: 'supabase_runtime',
      titleAr: 'Supabase Runtime / SQL UAT Intake',
      descriptionAr:
          'استيعاب نتائج SQL UAT. لم يتم تنفيذ أي SQL إنتاجي داخل هذه الدفعة.',
      items: <NosokV25EvidenceItem>[
        NosokV25EvidenceItem(
            key: 'read_only_uat',
            titleAr: 'Read-only UAT pack',
            status: 'ready',
            noteAr: 'ملف v25 يجهز فحصًا read-only فقط.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'schema_presence',
            titleAr: 'nosok schema presence',
            status: 'pending-supabase',
            noteAr: 'يلزم نتيجة Supabase SQL Editor.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'rpc_presence',
            titleAr: 'RPC wrappers presence',
            status: 'pending-supabase',
            noteAr: 'يلزم إثبات وجود wrappers التشغيلية.',
            priority: 'P0'),
        NosokV25EvidenceItem(
            key: 'storage_rls',
            titleAr: 'Storage/RLS review',
            status: 'pending-supabase',
            noteAr: 'يلزم إثبات policies وعدم كشف وثائق الجمهور.',
            priority: 'P0'),
      ],
    );

    return const NosokV25EvidencePack(
      runtimeEvidence: runtime,
      browserEvidence: browser,
      roleEvidence: roles,
      responsiveEvidence: responsive,
      mergeApplication: merge,
      supabaseEvidence: supabase,
      decision: NosokV25ProductionCandidateDecision(
        status: 'production-not-approved',
        reasonAr:
            'الـ preview مستقر ومحلل Flutter نظيف، لكن Full PalWakf Merge وRBAC override وSQL/Role/Responsive UAT لم تغلق بعد بأدلة تشغيل حقيقية.',
        nextActionAr:
            'تطبيق platform_real_merge_pack داخل ريبو PalWakf الكامل، ثم إرسال نتائج SQL UAT وBrowser/Role/Responsive evidence لاستيعابها في v26.',
        allowedScopeAr:
            'يسمح بالاستمرار كـ staging-stable / preview-ready فقط، ولا يسمح بإنتاج أو pilot رسمي قبل إغلاق P0.',
      ),
    );
  }
}
