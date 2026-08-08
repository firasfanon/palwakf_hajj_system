class NosokV26ResultItem {
  const NosokV26ResultItem({
    required this.key,
    required this.titleAr,
    required this.status,
    required this.noteAr,
    this.priority = 'P1',
    this.ownerAr = 'فريق نسك/المنصة',
    this.evidenceRefAr = 'غير مرفق',
  });

  final String key;
  final String titleAr;
  final String status;
  final String noteAr;
  final String priority;
  final String ownerAr;
  final String evidenceRefAr;

  bool get passed => status == 'passed' || status == 'accepted';
  bool get blocked => status == 'blocked';
  bool get pending => status.startsWith('pending');
  bool get warning => status == 'warning' || status == 'partial';
}

class NosokV26ResultSection {
  const NosokV26ResultSection({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.items,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final List<NosokV26ResultItem> items;

  int get total => items.length;
  int get passedCount => items.where((item) => item.passed).length;
  int get blockedCount => items.where((item) => item.blocked).length;
  int get pendingCount => items.where((item) => item.pending).length;
  int get warningCount => items.where((item) => item.warning).length;
}

class NosokV26ProductionCandidateRedecision {
  const NosokV26ProductionCandidateRedecision({
    required this.status,
    required this.reasonAr,
    required this.nextActionAr,
    required this.allowedScopeAr,
    required this.blockerSummaryAr,
  });

  final String status;
  final String reasonAr;
  final String nextActionAr;
  final String allowedScopeAr;
  final String blockerSummaryAr;

  bool get isCandidate => status == 'production-candidate';
}

class NosokV26ResultPack {
  const NosokV26ResultPack({
    required this.localRuntimeResult,
    required this.browserResult,
    required this.roleResult,
    required this.responsiveResult,
    required this.fullMergeApplyResult,
    required this.supabaseRuntimeResult,
    required this.productionDecision,
  });

  final NosokV26ResultSection localRuntimeResult;
  final NosokV26ResultSection browserResult;
  final NosokV26ResultSection roleResult;
  final NosokV26ResultSection responsiveResult;
  final NosokV26ResultSection fullMergeApplyResult;
  final NosokV26ResultSection supabaseRuntimeResult;
  final NosokV26ProductionCandidateRedecision productionDecision;

  List<NosokV26ResultSection> get allSections => <NosokV26ResultSection>[
        localRuntimeResult,
        browserResult,
        roleResult,
        responsiveResult,
        fullMergeApplyResult,
        supabaseRuntimeResult,
      ];

  int get totalChecks =>
      allSections.fold<int>(0, (total, section) => total + section.total);
  int get passedChecks =>
      allSections.fold<int>(0, (total, section) => total + section.passedCount);
  int get pendingChecks => allSections.fold<int>(
      0, (total, section) => total + section.pendingCount);
  int get blockedChecks => allSections.fold<int>(
      0, (total, section) => total + section.blockedCount);
  int get warningChecks => allSections.fold<int>(
      0, (total, section) => total + section.warningCount);

  static NosokV26ResultPack baseline() {
    const local = NosokV26ResultSection(
      key: 'local_runtime_result',
      titleAr: 'نتيجة التشغيل المحلي بعد v25',
      descriptionAr:
          'استيعاب سجل التشغيل المرسل بعد v25: التنسيق نجح، وChrome startup نجح، وبقيت ملاحظة analyzer واحدة تم إغلاقها في v26.',
      items: <NosokV26ResultItem>[
        NosokV26ResultItem(
            key: 'flutter_clean',
            titleAr: 'flutter clean',
            status: 'passed',
            noteAr: 'نجح في السجل المرفق.',
            priority: 'P0',
            evidenceRefAr: 'local log / v26'),
        NosokV26ResultItem(
            key: 'pub_get',
            titleAr: 'flutter pub get',
            status: 'passed',
            noteAr: 'نجح مع ملاحظات إصدارات أحدث غير مانعة.',
            priority: 'P0',
            evidenceRefAr: 'local log / v26'),
        NosokV26ResultItem(
            key: 'dart_format',
            titleAr: 'dart format',
            status: 'passed',
            noteAr: 'تم تنسيق 165 ملفًا وتغيير 129 ملفًا حسب سجل المستخدم.',
            priority: 'P0',
            evidenceRefAr: 'local log / v26'),
        NosokV26ResultItem(
            key: 'flutter_analyze_v25',
            titleAr: 'flutter analyze قبل v26',
            status: 'partial',
            noteAr: 'وجد warning واحد: _V25EvidenceSectionPanel غير مستخدم.',
            priority: 'P0',
            evidenceRefAr: 'local log / v26'),
        NosokV26ResultItem(
            key: 'flutter_analyze_v26_fix',
            titleAr: 'إغلاق ملاحظة analyzer',
            status: 'passed',
            noteAr: 'تم حذف العنصر غير المستخدم ومسار import التابع له في v26.',
            priority: 'P0',
            evidenceRefAr: 'v26 patch'),
        NosokV26ResultItem(
            key: 'chrome_startup',
            titleAr: 'flutter run -d chrome',
            status: 'passed',
            noteAr:
                'وصل إلى Debug Service دون compile blocker في السجل المرسل.',
            priority: 'P0',
            evidenceRefAr: 'local log / v26'),
      ],
    );

    const browser = NosokV26ResultSection(
      key: 'browser_result',
      titleAr: 'نتائج Browser UAT',
      descriptionAr:
          'المستخدم أفاد سابقًا أن كل الصفحات تعمل، وتم تثبيت المسارات الجديدة كصفحات استيعاب ومراجعة قرار. Console review المفصل لا يزال مطلوبًا كأدلة صور/سجل.',
      items: <NosokV26ResultItem>[
        NosokV26ResultItem(
            key: 'public_portal',
            titleAr: '/services/nosok',
            status: 'accepted',
            noteAr: 'مقبول كصفحة عامة بعد Mega UI وفصل الجمهور عن الموظف.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'public_apply',
            titleAr: '/services/nosok/apply',
            status: 'accepted',
            noteAr:
                'Form Wizard موجود؛ إثبات Supabase submit الحقيقي مؤجل إلى Runtime UAT.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'public_track',
            titleAr: '/services/nosok/track',
            status: 'accepted',
            noteAr:
                'التتبع العام يعمل في preview، وخصوصية البيانات تحتاج UAT على Supabase.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'internal_console',
            titleAr: '/admin/systems/nosok',
            status: 'accepted',
            noteAr: 'Internal Operations Console موجودة وتفتح في preview.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'console_review',
            titleAr: 'Browser Console Review',
            status: 'pending-evidence',
            noteAr:
                'يلزم سجل console خالٍ من exceptions بعد تنقل فعلي بين المسارات الحرجة.',
            priority: 'P0'),
      ],
    );

    const roles = NosokV26ResultSection(
      key: 'role_result',
      titleAr: 'نتائج Role UAT',
      descriptionAr:
          'الـ preview يثبت فصل واجهة الجمهور عن الإدارة بصريًا، لكن اعتماد الأدوار النهائي لا يغلق قبل ربط AccessProfile الحقيقي في PalWakf.',
      items: <NosokV26ResultItem>[
        NosokV26ResultItem(
            key: 'visitor',
            titleAr: 'زائر',
            status: 'accepted',
            noteAr:
                'يرى بوابة الخدمة العامة، ولا يدخل Console إلا عبر مسارات إدارية محمية.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'citizen',
            titleAr: 'مواطن',
            status: 'pending-real-rbac',
            noteAr:
                'يلزم حساب/سياق مستخدم عام مع طلب واحد فقط عند التشغيل الحقيقي.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'employee',
            titleAr: 'موظف نسك',
            status: 'pending-real-rbac',
            noteAr: 'يلزم إثبات الطلبات المسندة له فقط بعد RBAC override.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'supervisor',
            titleAr: 'مشرف نسك',
            status: 'pending-real-rbac',
            noteAr: 'يلزم إثبات نطاق المديرية/الوحدة والحملات.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'system_admin',
            titleAr: 'مدير النظام',
            status: 'pending-real-rbac',
            noteAr: 'يلزم إثبات الإعدادات والتقارير دون تجاوز صلاحيات المنصة.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'superuser',
            titleAr: 'Superuser',
            status: 'pending-real-rbac',
            noteAr: 'يلزم إثبات visibility + route guard + audit/health.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'restricted',
            titleAr: 'مستخدم مقيد',
            status: 'pending-real-rbac',
            noteAr: 'يلزم إثبات read-only أو forbidden حسب العقد.',
            priority: 'P0'),
      ],
    );

    const responsive = NosokV26ResultSection(
      key: 'responsive_result',
      titleAr: 'نتائج Responsive / Anti-Overload',
      descriptionAr:
          'مكونات PWF-SIS تستخدم Wrap وDataTable adaptive cards، لكن أدلة desktop/laptop/tablet/mobile التفصيلية لم ترفق بعد.',
      items: <NosokV26ResultItem>[
        NosokV26ResultItem(
            key: 'desktop',
            titleAr: 'Desktop',
            status: 'accepted',
            noteAr: 'Chrome desktop startup وفتح الصفحات مقبولان.',
            priority: 'P1'),
        NosokV26ResultItem(
            key: 'laptop',
            titleAr: 'Laptop',
            status: 'pending-evidence',
            noteAr: 'يلزم لقطة 1366px بلا overflow.',
            priority: 'P1'),
        NosokV26ResultItem(
            key: 'tablet',
            titleAr: 'Tablet',
            status: 'pending-evidence',
            noteAr: 'يلزم إثبات tabs/stacked panels.',
            priority: 'P1'),
        NosokV26ResultItem(
            key: 'mobile',
            titleAr: 'Mobile',
            status: 'pending-evidence',
            noteAr: 'يلزم إثبات form wizard وcards بلا horizontal overflow.',
            priority: 'P1'),
      ],
    );

    const fullMerge = NosokV26ResultSection(
      key: 'full_merge_apply_result',
      titleAr: 'نتيجة تطبيق الدمج داخل PalWakf الكامل',
      descriptionAr:
          'لم ترفق نتيجة تطبيق platform_real_merge_pack داخل الريبو الكامل؛ لذلك لا يمكن رفع الحكم إلى production-candidate.',
      items: <NosokV26ResultItem>[
        NosokV26ResultItem(
            key: 'feature_copy',
            titleAr: 'نسخ feature إلى PalWakf',
            status: 'pending-full-repo',
            noteAr: 'يلزم سجل git/apply من الريبو الكامل.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'go_router',
            titleAr: 'GoRouter الحقيقي',
            status: 'pending-full-repo',
            noteAr:
                'يلزم إثبات عدم تعارض /services/nosok مع unitSlug أو shells.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'access_override',
            titleAr: 'RBAC Provider Override',
            status: 'blocked',
            noteAr:
                'مانع إنتاج حتى يربط nosokAccessProfileProvider بمصدر AccessProfile الحقيقي.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'dynamic_registry',
            titleAr: 'Dynamic Registry + Sections',
            status: 'pending-full-repo',
            noteAr: 'يلزم تسجيل النظام والأقسام والصلاحيات داخل منصة PalWakf.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'visual_identity_admin',
            titleAr: 'Visual Identity Admin compatibility',
            status: 'ready',
            noteAr:
                'جاهز مبدئيًا لاعتماده على ThemeData/colorScheme، لكنه يحتاج اختبار overrides المنشورة.',
            priority: 'P1'),
      ],
    );

    const supabase = NosokV26ResultSection(
      key: 'supabase_runtime_result',
      titleAr: 'نتائج Supabase Runtime / SQL UAT',
      descriptionAr:
          'لم ترفق نتائج SQL UAT من Supabase. v26 يضيف حزمة UAT read-only وإدخال نتيجة القرار فقط.',
      items: <NosokV26ResultItem>[
        NosokV26ResultItem(
            key: 'sql_uat_pack',
            titleAr: 'SQL UAT read-only pack',
            status: 'ready',
            noteAr: 'ملف v26 لا ينفذ DDL/DML ولا يلمس waqf_assets.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'schema_presence',
            titleAr: 'nosok schema presence',
            status: 'pending-supabase',
            noteAr: 'يلزم تشغيل في Supabase SQL Editor.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'rpc_presence',
            titleAr: 'RPC wrappers presence',
            status: 'pending-supabase',
            noteAr: 'يلزم إثبات wrappers العامة والإدارية.',
            priority: 'P0'),
        NosokV26ResultItem(
            key: 'storage_rls',
            titleAr: 'Storage/RLS',
            status: 'pending-supabase',
            noteAr: 'يلزم إثبات عدم كشف المرفقات والسياسات الصحيحة.',
            priority: 'P0'),
      ],
    );

    return const NosokV26ResultPack(
      localRuntimeResult: local,
      browserResult: browser,
      roleResult: roles,
      responsiveResult: responsive,
      fullMergeApplyResult: fullMerge,
      supabaseRuntimeResult: supabase,
      productionDecision: NosokV26ProductionCandidateRedecision(
        status: 'production-not-approved',
        reasonAr:
            'تم استيعاب أدلة التشغيل المحلي وChrome startup، وتم إغلاق warning v25 داخل v26. لكن Full PalWakf Merge وRBAC Provider Override وSQL/Role/Responsive UAT لم تغلق بعد بأدلة تشغيل حقيقية.',
        nextActionAr:
            'تطبيق platform_real_merge_pack داخل ريبو PalWakf الكامل، ثم إرسال نتائج SQL UAT وBrowser/Role/Responsive evidence. بعد ذلك يمكن إصدار production-candidate مشروط أو controlled-pilot.',
        allowedScopeAr:
            'staging-stable / preview-ready فقط. لا اعتماد إنتاج ولا pilot رسمي قبل إغلاق P0.',
        blockerSummaryAr:
            'الموانع الحالية: full repo apply pending، RBAC override blocked، SQL UAT pending، Role UAT pending، Responsive evidence pending.',
      ),
    );
  }
}
