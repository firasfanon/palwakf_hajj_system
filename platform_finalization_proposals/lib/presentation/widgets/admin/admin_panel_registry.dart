import 'package:flutter/material.dart';

import '../../../app/routing/app_routes.dart';
import '../../../core/enums/system_key.dart';

class AdminPanelTabItem {
  const AdminPanelTabItem({
    required this.key,
    required this.label,
    required this.icon,
  });

  final String key;
  final String label;
  final IconData icon;
}

class AdminPanelGroup {
  const AdminPanelGroup({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String id;
  final String title;
  final String subtitle;
  final List<AdminPanelEntry> items;
}

class AdminPanelEntry {
  const AdminPanelEntry({
    required this.label,
    required this.description,
    required this.route,
    required this.icon,
    this.badge,
  });

  final String label;
  final String description;
  final String route;
  final IconData icon;
  final int? badge;
}

enum AdminGovernanceTier {
  administrativeCore,
  connectedSystem,
}

extension AdminGovernanceTierX on AdminGovernanceTier {
  String get labelAr {
    switch (this) {
      case AdminGovernanceTier.administrativeCore:
        return 'العقل الإداري / النظام المرجعي';
      case AdminGovernanceTier.connectedSystem:
        return 'نظام شبه مستقل مرتبط بالمنصة';
    }
  }
}

class AdminGovernedSystem {
  const AdminGovernedSystem({
    required this.systemKey,
    required this.label,
    required this.description,
    required this.icon,
    required this.tier,
    required this.familyAr,
    required this.notesAr,
    this.adminRoute,
    this.visibleInAdminSystemsTab = false,
  });

  final SystemKey systemKey;
  final String label;
  final String description;
  final IconData icon;
  final AdminGovernanceTier tier;
  final String familyAr;
  final String notesAr;
  final String? adminRoute;
  final bool visibleInAdminSystemsTab;
}

class AdminPanelRegistry {
  const AdminPanelRegistry._();

  static const tabs = <AdminPanelTabItem>[
    AdminPanelTabItem(
        key: 'main', label: 'الرئيسية', icon: Icons.dashboard_outlined),
    AdminPanelTabItem(
        key: 'public', label: 'الواجهة العامة', icon: Icons.web_outlined),
    AdminPanelTabItem(
        key: 'platform', label: 'المنصة', icon: Icons.settings_outlined),
    AdminPanelTabItem(
        key: 'systems', label: 'الأنظمة', icon: Icons.widgets_outlined),
    AdminPanelTabItem(
        key: 'developer', label: 'المطور', icon: Icons.developer_mode_outlined),
  ];

  static const mainGroup = AdminPanelGroup(
    id: 'main',
    title: 'الرئيسية',
    subtitle:
        'مداخل سريعة إلى اللوحة والمساعد ومعاينة الشات العام وبوابة إدارة المنصة.',
    items: [
      AdminPanelEntry(
        label: 'لوحة التحكم',
        description: 'المدخل الرئيسي إلى المؤشرات والوصول السريع.',
        route: AppRoutes.adminDashboard,
        icon: Icons.dashboard_rounded,
      ),
      AdminPanelEntry(
        label: 'المساعد الداخلي',
        description: 'الوصول إلى المساعد الإداري الخاص بالموظفين.',
        route: AppRoutes.adminAssistant,
        icon: Icons.assistant_rounded,
      ),
      AdminPanelEntry(
        label: 'معاينة شات الجمهور',
        description: 'اختبار تجربة الشات العام كما تظهر للزوار.',
        route: AppRoutes.adminChatbot,
        icon: Icons.smart_toy_rounded,
      ),
      AdminPanelEntry(
        label: 'بوابة إدارة المنصة',
        description: 'تجميع الحوكمة والإدارة العامة والأنظمة من مكان واحد.',
        route: AppRoutes.adminSettings,
        icon: Icons.settings_suggest_rounded,
      ),
    ],
  );

  static const publicGroup = AdminPanelGroup(
    id: 'public',
    title: 'الواجهة العامة',
    subtitle:
        'إدارة الصفحة الرئيسية والهوية العامة والمحتوى التشغيلي المتصل بها.',
    items: [
      AdminPanelEntry(
        label: 'إدارة الصفحة الرئيسية',
        description:
            'ترتيب أقسام الصفحة الرئيسية العامة والهوية العامة ومكونات الـ body الخاصة بـ home فقط.',
        route: AppRoutes.adminHomeManagement,
        icon: Icons.home_filled,
      ),
      AdminPanelEntry(
        label: 'إدارة واجهات الوحدات',
        description:
            'إدارة الصفحات الديناميكية الخاصة بالوحدات واختيار allowedSections ومعاينتها من مصدر الوحدات الحقيقي.',
        route: AppRoutes.adminUnitSurfacesManagement,
        icon: Icons.account_tree_rounded,
      ),
      AdminPanelEntry(
        label: 'إدارة واجهات الأنظمة',
        description:
            'إدارة Body الأنظمة المرتبطة بالمنصة تحت نفس العقد الحاكم مع بقاء الـ Chrome عامًا ومركزيًا.',
        route: AppRoutes.adminSystemSurfacesManagement,
        icon: Icons.widgets_rounded,
      ),
      AdminPanelEntry(
        label: 'إدارة المحتوى المشترك',
        description:
            'الأخبار والإعلانات والأنشطة والفعاليات ومعرض الصور والفيديوهات بنطاقي home وslug داخل نفس القالب الديناميكي.',
        route: AppRoutes.adminSharedContent,
        icon: Icons.dynamic_feed_outlined,
      ),
      AdminPanelEntry(
        label: 'السلايدر / الهيرو',
        description: 'إدارة الشرائح والرسائل البصرية الرئيسية.',
        route: AppRoutes.adminHeroSlider,
        icon: Icons.slideshow_rounded,
      ),
      AdminPanelEntry(
        label: 'الأخبار العاجلة',
        description: 'إدارة الرسائل الإخبارية العاجلة الظاهرة في الواجهة.',
        route: AppRoutes.adminBreakingNews,
        icon: Icons.campaign_rounded,
      ),
      AdminPanelEntry(
        label: 'خُطب الجمعة',
        description: 'إدارة الخطب والمحتوى الصوتي أو النصي المرتبط بها.',
        route: AppRoutes.adminFridaySermons,
        icon: Icons.mic_rounded,
      ),
    ],
  );

  static const publicPagesGroup = AdminPanelGroup(
    id: 'public_pages',
    title: 'الصفحات العامة',
    subtitle:
        'مساحات إدارية حقيقية للصفحات العامة المكتملة وربطها بمصادرها الفعلية داخل المنصة.',
    items: [
      AdminPanelEntry(
        label: 'بوابة الصفحات العامة',
        description:
            'فهرس إداري لجميع الصفحات العامة المرتبطة حقيقيًا بالقوائم والموقع.',
        route: AppRoutes.adminPublicPagesHub,
        icon: Icons.web_asset_rounded,
      ),
      AdminPanelEntry(
        label: 'عن الوزارة',
        description: 'إدارة الصفحة التعريفية الرسمية للوزارة.',
        route: AppRoutes.adminAboutPage,
        icon: Icons.info_outline_rounded,
      ),
      AdminPanelEntry(
        label: 'كلمة الوزير',
        description: 'إدارة الرسالة الرسمية لصفحة كلمة الوزير.',
        route: AppRoutes.adminMinisterPage,
        icon: Icons.record_voice_over_outlined,
      ),
      AdminPanelEntry(
        label: 'الرؤية والرسالة',
        description: 'إدارة النصوص المرجعية للرؤية والرسالة والقيم.',
        route: AppRoutes.adminVisionMissionPage,
        icon: Icons.track_changes_outlined,
      ),
      AdminPanelEntry(
        label: 'الهيكل التنظيمي',
        description: 'إدارة عرض صفحة الهيكل التنظيمي المرتبطة بمرجع الوحدات.',
        route: AppRoutes.adminStructurePage,
        icon: Icons.account_tree_outlined,
      ),
      AdminPanelEntry(
        label: 'الوزراء السابقون',
        description: 'إدارة الصفحة التاريخية للوزراء السابقين.',
        route: AppRoutes.adminFormerMinistersPage,
        icon: Icons.history_edu_outlined,
      ),
      AdminPanelEntry(
        label: 'الخدمات',
        description: 'إدارة صفحة الخدمات العامة وبطاقاتها.',
        route: AppRoutes.adminServicesPage,
        icon: Icons.design_services_outlined,
      ),
      AdminPanelEntry(
        label: 'الخدمات الإلكترونية',
        description: 'إدارة صفحة الخدمات الإلكترونية وروابطها.',
        route: AppRoutes.adminEServicesPage,
        icon: Icons.computer_outlined,
      ),
      AdminPanelEntry(
        label: 'الخدمات الاجتماعية',
        description: 'إدارة الصفحة العامة للخدمات الاجتماعية.',
        route: AppRoutes.adminSocialServicesPage,
        icon: Icons.people_outline_rounded,
      ),
      AdminPanelEntry(
        label: 'المشاريع',
        description: 'إدارة صفحة المشاريع والمبادرات العامة.',
        route: AppRoutes.adminProjectsPage,
        icon: Icons.work_outline_rounded,
      ),
      AdminPanelEntry(
        label: 'اتصل بنا',
        description: 'إدارة صفحة الاتصال وبيانات الوصول الرسمية.',
        route: AppRoutes.adminContactPage,
        icon: Icons.contact_phone_outlined,
      ),
      AdminPanelEntry(
        label: 'سياسة الخصوصية',
        description: 'إدارة النص الرسمي لسياسة الخصوصية.',
        route: AppRoutes.adminPrivacyPage,
        icon: Icons.privacy_tip_outlined,
      ),
      AdminPanelEntry(
        label: 'شروط الاستخدام',
        description: 'إدارة النص الرسمي لشروط الاستخدام.',
        route: AppRoutes.adminTermsPage,
        icon: Icons.rule_folder_outlined,
      ),
      AdminPanelEntry(
        label: 'خريطة الموقع',
        description: 'إدارة صفحة خريطة الموقع وروابطها العامة.',
        route: AppRoutes.adminSitemapPage,
        icon: Icons.map_outlined,
      ),
    ],
  );

  static const platformServicesGroup = AdminPanelGroup(
    id: 'platform_services',
    title: 'خدمات المنصة',
    subtitle:
        'مساحات إدارية حقيقية لخدمات المنصة العامة، منفصلة عن إدارة الصفحة الرئيسية نفسها.',
    items: [
      AdminPanelEntry(
        label: 'خدمة الزكاة',
        description: 'صفحة إدارية فعلية لإدارة الزكاة تحت إطار المنصة.',
        route: AppRoutes.adminZakat,
        icon: Icons.volunteer_activism_rounded,
      ),
      AdminPanelEntry(
        label: 'مواقيت الصلاة',
        description: 'صفحة إدارية فعلية لإدارة مواقيت الصلاة ضمن خدمات المنصة.',
        route: AppRoutes.adminPrayerTimes,
        icon: Icons.access_time_filled_rounded,
      ),
      AdminPanelEntry(
        label: 'القرآن الكريم',
        description: 'صفحة إدارية فعلية لإدارة القرآن الكريم ضمن خدمات المنصة.',
        route: AppRoutes.adminQuran,
        icon: Icons.menu_book_rounded,
      ),
    ],
  );

  static const platformGroup = AdminPanelGroup(
    id: 'platform',
    title: 'المنصة',
    subtitle:
        'إدارة المستخدمين والوحدات والملف الشخصي مع بوابة الحوكمة العامة.',
    items: [
      AdminPanelEntry(
        label: 'بوابة إدارة المنصة',
        description: 'بوابة الحوكمة والتنظيم والإحالة بين أقسام الإدارة.',
        route: AppRoutes.adminSettings,
        icon: Icons.settings_outlined,
      ),
      AdminPanelEntry(
        label: 'المستخدمون',
        description: 'إدارة المستخدمين، التفعيل، والصلاحيات الإدارية.',
        route: AppRoutes.adminUsers,
        icon: Icons.people_outline,
      ),
      AdminPanelEntry(
        label: 'المؤسسات والوحدات',
        description: 'إدارة المؤسسات والوحدات التنظيمية والربط المؤسسي.',
        route: AppRoutes.adminOrgUnits,
        icon: Icons.apartment_outlined,
      ),
      AdminPanelEntry(
        label: 'الشكاوى',
        description:
            'الخدمة السيادية للشكاوى على مستوى المنصة مع مسار إداري مركزي.',
        route: AppRoutes.adminComplaints,
        icon: Icons.report_gmailerrorred_rounded,
      ),
      AdminPanelEntry(
        label: 'الملف الشخصي',
        description: 'الوصول إلى إعدادات الحساب والملف الشخصي.',
        route: AppRoutes.adminProfile,
        icon: Icons.person_outline,
      ),
    ],
  );

  static const systemsGroup = AdminPanelGroup(
    id: 'systems',
    title: 'الأنظمة',
    subtitle:
        'الوصول المباشر إلى الأنظمة شبه المستقلة والتشغيلية المرتبطة بالمنصة.',
    items: [
      AdminPanelEntry(
        label: 'نظام الأراضي الوقفية',
        description: 'الدخول إلى نظام الأصول والأراضي الوقفية.',
        route: AppRoutes.adminWaqfLands,
        icon: Icons.landscape_rounded,
      ),
      AdminPanelEntry(
        label: 'نظام المساجد',
        description: 'إدارة نظام المساجد وخدماته المرتبطة.',
        route: AppRoutes.adminMosques,
        icon: Icons.mosque_rounded,
      ),
      AdminPanelEntry(
        label: 'نظام القضايا',
        description: 'الوصول إلى القضايا الوقفية ومتابعتها.',
        route: AppRoutes.adminCases,
        icon: Icons.gavel_rounded,
        badge: 45,
      ),
      AdminPanelEntry(
        label: 'نظام المهام',
        description:
            'إدارة المهام والمتابعات وربطها بالأصول والقضايا والفوترة.',
        route: AppRoutes.adminTasks,
        icon: Icons.task_alt_rounded,
      ),
      AdminPanelEntry(
        label: 'نظام نسك',
        description:
            'إدارة خدمات الحج والعمرة والمواسم والشركات المؤهلة والشكاوى ضمن نظام شبه مستقل تحت المنصة.',
        route: AppRoutes.adminNosok,
        icon: Icons.travel_explore_rounded,
      ),
      AdminPanelEntry(
        label: 'برامج نسك',
        description:
            'إدارة برامج المواسم ومسارات الحج والعمرة وربطها بالمواسم.',
        route: AppRoutes.adminNosokPrograms,
        icon: Icons.route_rounded,
      ),
      AdminPanelEntry(
        label: 'تقارير نسك',
        description: 'مؤشرات الموسم والطلبات والشكاوى والشركات المؤهلة.',
        route: AppRoutes.adminNosokReports,
        icon: Icons.analytics_outlined,
      ),
      AdminPanelEntry(
        label: 'نظام الوثائق',
        description: 'إدارة الوثائق والأرشفة والمرفقات.',
        route: AppRoutes.adminDocuments,
        icon: Icons.folder_rounded,
      ),
    ],
  );

  static const developerGroup = AdminPanelGroup(
    id: 'developer',
    title: 'المطور',
    subtitle:
        'أدوات صيانة وتشخيص للمطور، تشمل إظهار أسماء الصفحات ومساراتها عبر النظام لتسهيل تتبع الأخطاء.',
    items: [
      AdminPanelEntry(
        label: 'أدوات المطور',
        description:
            'تشغيل وضع الصيانة وإظهار أسماء الصفحات والمسارات ونسخ سجل التنقل الإداري.',
        route: AppRoutes.adminDeveloper,
        icon: Icons.developer_mode_rounded,
      ),
    ],
  );

  static const governedSystems = <AdminGovernedSystem>[
    AdminGovernedSystem(
      systemKey: SystemKey.adminData,
      label: 'awqaf_system',
      description:
          'العقل الإداري للمنصة ومصدر الحقيقة الإداري المرجعي المرتبط بالمؤسسة والوحدات والمرجعيات والسيادة الإدارية.',
      icon: Icons.hub_outlined,
      tier: AdminGovernanceTier.administrativeCore,
      familyAr: 'النظام الإداري المرجعي الرئيسي',
      notesAr:
          'يمثل awqaf_system المسار المرجعي/الإداري الرئيسي للمنصة. route العرض الحالي في التطبيق العام هو /admin-data، لكنه لا يعامَل كنظام فرعي عادي.',
      adminRoute: AppRoutes.adminData,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.platformAdmin,
      label: 'لوحة الإدارة',
      description:
          'النظام الحاكم لإدارة المنصة، المستخدمين، الحوكمة، والبوابات الإدارية.',
      icon: Icons.admin_panel_settings_outlined,
      tier: AdminGovernanceTier.administrativeCore,
      familyAr: 'الحوكمة والإدارة العامة',
      notesAr:
          'تلتقي مع awqaf_system في الحوكمة العامة، لكنها ليست بديلًا عنه كمصدر إداري سيادي للبيانات المرجعية.',
      adminRoute: AppRoutes.adminUsers,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.site,
      label: 'الموقع العام',
      description:
          'الواجهة العامة للوزارة والوحدات وما يتصل بها من محتوى وتشغيل.',
      icon: Icons.public_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'واجهة عامة ديناميكية',
      notesAr:
          'صفحة ديناميكية موحدة تتغذى من home أو slug، وتلتزم بالعقد الحاكم للمنصة.',
      adminRoute: AppRoutes.adminHomeManagement,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.mustakshif,
      label: 'مستكشف الوقف',
      description:
          'النظام المكاني/التاريخي لتحليل الأصول الوقفية والطبقات والروابط التاريخية.',
      icon: Icons.map_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'نظام تحليلي مكاني/تاريخي',
      notesAr:
          'نظام شبه مستقل متصل حوكميًا بالمنصة ويشارك العقد العام وقاعدة البيانات، وليس مجرد صفحة محتوى.',
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.lands,
      label: 'نظام الأراضي الوقفية',
      description:
          'شاشة الإدارة الحالية للأصول/الأراضي الوقفية داخل لوحة التحكم.',
      icon: Icons.landscape_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'تشغيلي/أصول',
      notesAr: 'واجهة تشغيلية مرتبطة بالأصول الوقفية ضمن العقد العام للمنصة.',
      adminRoute: AppRoutes.adminWaqfLands,
      visibleInAdminSystemsTab: true,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.properties,
      label: 'نظام العقارات/الأصول',
      description:
          'نظام تشغيلي مرتبط بالأصول الوقفية والعقود والاستعمالات عند تفعيله.',
      icon: Icons.location_city_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'تشغيلي/أصول',
      notesAr: 'نظام متخصص سيضاف أو يتوسع لاحقًا ضمن بنية المنصة المتصلة.',
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.cases,
      label: 'نظام القضايا',
      description: 'إدارة القضايا الوقفية والروابط القانونية للأصول الوقفية.',
      icon: Icons.gavel_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'نظام قانوني/تشغيلي',
      notesAr:
          'نظام شبه مستقل مرتبط بالمنصة ويخضع للحوكمة العامة وRBAC المشترك.',
      adminRoute: AppRoutes.adminCases,
      visibleInAdminSystemsTab: true,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.tasks,
      label: 'نظام المهام',
      description:
          'متابعة المهام الميدانية والإدارية وربطها بالأصول والقضايا والفوترة.',
      icon: Icons.task_alt_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'نظام تشغيلي/متابعة',
      notesAr:
          'يدير التنفيذ والمتابعة دون أن يعيد تعريف البيانات المرجعية السيادية.',
      adminRoute: AppRoutes.adminTasks,
      visibleInAdminSystemsTab: true,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.mosques,
      label: 'نظام المساجد',
      description: 'إدارة المساجد وخدماتها وربطها بالمنصة الحالية.',
      icon: Icons.mosque_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'خدمة تخصصية مرتبطة',
      notesAr:
          'نظام متخصص مرتبط بالمنصة ويستفيد من الهوية والصلاحيات المشتركة.',
      adminRoute: AppRoutes.adminMosques,
      visibleInAdminSystemsTab: true,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.nosok,
      label: 'نسك',
      description:
          'نظام خدمات الحج والعمرة والمواسم والشركات المؤهلة والشكاوى، يعمل تحت الحوكمة العامة للمنصة.',
      icon: Icons.travel_explore_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'خدمة تخصصية/تشغيلية',
      notesAr:
          'نظام mixed public/admin. الواجهة العامة تحت public shell والإدارة تحت admin shell، مع بقاء Shared Platform Chrome مركزيًا.',
      adminRoute: AppRoutes.adminNosok,
      visibleInAdminSystemsTab: true,
    ),
    AdminGovernedSystem(
      systemKey: SystemKey.billing,
      label: 'نظام الفوترة',
      description:
          'الفواتير والعقود والدفعات والمتأخرات المرتبطة بالأصول الوقفية.',
      icon: Icons.receipt_long_outlined,
      tier: AdminGovernanceTier.connectedSystem,
      familyAr: 'نظام مالي/تشغيلي',
      notesAr:
          'يرتبط بالعقد الحاكم للمنصة لكنه يحتفظ بمنطقه المالي والتشغيلي الخاص.',
    ),
  ];

  static List<AdminGovernedSystem> governedSystemsByTier(
      AdminGovernanceTier tier) {
    return governedSystems
        .where((system) => system.tier == tier)
        .toList(growable: false);
  }

  static List<AdminGovernedSystem> get administrativeCoreSystems =>
      governedSystemsByTier(AdminGovernanceTier.administrativeCore);

  static List<AdminGovernedSystem> get connectedSystems =>
      governedSystemsByTier(AdminGovernanceTier.connectedSystem);

  static const orderedGroups = <AdminPanelGroup>[
    mainGroup,
    publicGroup,
    publicPagesGroup,
    platformServicesGroup,
    platformGroup,
    systemsGroup,
    developerGroup,
  ];

  static AdminPanelTabItem tabForRoute(String? route) {
    final value = route ?? '';
    if (_publicRoutes.any((prefix) => value.startsWith(prefix))) return tabs[1];
    if (_platformRoutes.any((prefix) => value.startsWith(prefix)))
      return tabs[2];
    if (_systemRoutes.any((prefix) => value.startsWith(prefix))) return tabs[3];
    if (_developerRoutes.any((prefix) => value.startsWith(prefix)))
      return tabs[4];
    return tabs[0];
  }

  static List<AdminPanelGroup> groupsForTab(String tabKey) {
    switch (tabKey) {
      case 'public':
        return const [publicGroup, publicPagesGroup, platformServicesGroup];
      case 'platform':
        return const [platformGroup];
      case 'systems':
        return const [systemsGroup];
      case 'developer':
        return const [developerGroup];
      case 'main':
      default:
        return const [mainGroup];
    }
  }

  static String defaultRouteForTab(String tabKey) {
    final groups = groupsForTab(tabKey);
    for (final group in groups) {
      if (group.items.isNotEmpty) return group.items.first.route;
    }
    return AppRoutes.adminDashboard;
  }

  static List<AdminPanelEntry> quickAccessForPlatformPages() {
    return const [
      AdminPanelEntry(
        label: 'بوابة إدارة المنصة',
        description: 'العودة إلى تنظيم الحوكمة والإعدادات العامة.',
        route: AppRoutes.adminSettings,
        icon: Icons.settings_suggest_outlined,
      ),
      AdminPanelEntry(
        label: 'المستخدمون',
        description: 'التنقل السريع إلى إدارة المستخدمين والصلاحيات.',
        route: AppRoutes.adminUsers,
        icon: Icons.people,
      ),
      AdminPanelEntry(
        label: 'المؤسسات والوحدات',
        description: 'التنقل السريع إلى إدارة الوحدات والتنظيم المؤسسي.',
        route: AppRoutes.adminOrgUnits,
        icon: Icons.apartment,
      ),
      AdminPanelEntry(
        label: 'الشكاوى',
        description: 'الوصول السريع إلى الخدمة السيادية للشكاوى داخل المنصة.',
        route: AppRoutes.adminComplaints,
        icon: Icons.report_gmailerrorred_rounded,
      ),
      AdminPanelEntry(
        label: 'لوحة التحكم',
        description: 'العودة إلى لوحة التحكم الرئيسية.',
        route: AppRoutes.adminDashboard,
        icon: Icons.dashboard_customize_outlined,
      ),
      AdminPanelEntry(
        label: 'أدوات المطور',
        description: 'إظهار أسماء الصفحات ومساراتها وتشخيص التنقل الإداري.',
        route: AppRoutes.adminDeveloper,
        icon: Icons.developer_mode_rounded,
      ),
    ];
  }

  static List<AdminPanelEntry> get allEntries => [
        for (final group in orderedGroups) ...group.items,
      ];

  static List<AdminPanelEntry> quickAccessForSystemPages(
      {String? excludeRoute}) {
    return systemsGroup.items
        .where((item) => excludeRoute == null || item.route != excludeRoute)
        .toList(growable: false);
  }

  static AdminPanelEntry? entryForRoute(String? route) {
    final normalized = _normalizeRoute(route);
    for (final group in orderedGroups) {
      for (final item in group.items) {
        if (_normalizeRoute(item.route) == normalized) return item;
      }
    }
    return null;
  }

  static String _normalizeRoute(String? route) {
    final value = (route ?? '').trim();
    if (value.isEmpty) return '';
    final noQuery = value.split('?').first;
    if (noQuery.length > 1 && noQuery.endsWith('/')) {
      return noQuery.substring(0, noQuery.length - 1);
    }
    return noQuery;
  }

  static AdminGovernedSystem? governedSystemByName(String value) {
    final key = value.trim();
    for (final system in governedSystems) {
      if (system.systemKey.name == key) return system;
    }
    return null;
  }

  static const _publicRoutes = <String>[
    '/admin/home-management',
    '/admin/unit-surfaces-management',
    '/admin/system-surfaces-management',
    '/admin/hero-slider',
    '/admin/breaking-news',
    '/admin/activities-management',
    '/admin/friday-sermons',
    '/admin/zakat',
    '/admin/prayer-times',
    '/admin/quran',
  ];

  static const _platformRoutes = <String>[
    '/admin/users',
    '/admin/org-units',
    '/admin/profile',
    '/admin/settings',
    '/admin/complaints',
  ];

  static const _systemRoutes = <String>[
    '/admin/waqf-lands',
    '/admin/mosques',
    '/admin/cases',
    '/admin/tasks',
    '/admin/systems/nosok',
    '/admin/systems/nosok/seasons',
    '/admin/systems/nosok/programs',
    '/admin/systems/nosok/companies',
    '/admin/systems/nosok/applications',
    '/admin/systems/nosok/complaints',
    '/admin/systems/nosok/content',
    '/admin/systems/nosok/reports',
    '/admin/documents',
  ];

  static const _developerRoutes = <String>[
    '/admin/developer',
  ];
}
