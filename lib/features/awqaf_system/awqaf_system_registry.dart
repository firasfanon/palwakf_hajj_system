import 'package:flutter/material.dart';

import 'awqaf_system_routes.dart';
import 'domain/enums/awqaf_system_section.dart';

class AwqafSystemNavItem {
  const AwqafSystemNavItem({
    required this.section,
    required this.groupAr,
    required this.titleAr,
    required this.subtitleAr,
    required this.path,
    required this.icon,
  });

  final AwqafSystemSection section;
  final String groupAr;
  final String titleAr;
  final String subtitleAr;
  final String path;
  final IconData icon;
}

abstract final class AwqafSystemRegistry {
  static const List<AwqafSystemNavItem> items = <AwqafSystemNavItem>[
    AwqafSystemNavItem(
      section: AwqafSystemSection.home,
      groupAr: 'الرئيسية',
      titleAr: 'الرئيسية التشغيلية',
      subtitleAr: 'مدخل أوقاف سيستم المستقل داخل System-of-Systems',
      path: AwqafSystemRoutes.home,
      icon: Icons.home_work_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.dashboard,
      groupAr: 'الرئيسية',
      titleAr: 'لوحة النظام',
      subtitleAr: 'مؤشرات مرجع البيانات السيادية',
      path: AwqafSystemRoutes.dashboard,
      icon: Icons.dashboard_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.contentCenter,
      groupAr: 'الرئيسية',
      titleAr: 'مركز محتوى أوقاف سيستم',
      subtitleAr:
          'CRUD تشغيلي موحد للصفحات والأقسام من الطبولوجيا إلى أوقاف أسيست',
      path: AwqafSystemRoutes.contentCenter,
      icon: Icons.dynamic_feed_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.homeSectionsAdmin,
      groupAr: 'جاهزية الانضمام',
      titleAr: 'إدارة أقسام الصفحة الرئيسية',
      subtitleAr: 'قوالب وأقسام Home الخاصة بأوقاف سيستم مع RBAC وpreview',
      path: AwqafSystemRoutes.homeSectionsAdmin,
      icon: Icons.dashboard_customize_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.safePageBuilder,
      groupAr: 'جاهزية الانضمام',
      titleAr: 'منشئ الصفحات الآمن',
      subtitleAr:
          'Page/Section Builder محكوم بقوالب آمنة ودون raw HTML أو service_role',
      path: AwqafSystemRoutes.safePageBuilder,
      icon: Icons.view_quilt_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.evidenceCenter,
      groupAr: 'جاهزية الانضمام',
      titleAr: 'مركز الأدلة',
      subtitleAr: 'Browser/RBAC/RLS/SQL/UAT evidence قبل الانضمام إلى المنصة',
      path: AwqafSystemRoutes.evidenceCenter,
      icon: Icons.fact_check_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.standaloneDevelopment,
      groupAr: 'جاهزية الانضمام',
      titleAr: 'تطوير Supabase مستقل',
      subtitleAr:
          'preview / standaloneSupabaseDevelopment / platformHosted adapters',
      path: AwqafSystemRoutes.standaloneDevelopment,
      icon: Icons.storage_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.schemaRpcDesign,
      groupAr: 'جاهزية الانضمام',
      titleAr: 'Schema / RPC / RLS',
      subtitleAr:
          'تصميم schema خاصة وRPC wrappers وسياسات RLS بعد census read-only',
      path: AwqafSystemRoutes.schemaRpcDesign,
      icon: Icons.schema_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.rbacRlsSupabaseReadiness,
      groupAr: 'جاهزية الانضمام',
      titleAr: 'جاهزية RBAC/RLS/Supabase',
      subtitleAr: 'كتالوج أدوار وصلاحيات وسياسات RLS وschema تطويرية محكومة',
      path: AwqafSystemRoutes.rbacRlsSupabaseReadiness,
      icon: Icons.admin_panel_settings_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.joinPackage,
      groupAr: 'جاهزية الانضمام',
      titleAr: 'Join Package',
      subtitleAr: 'حزمة تسليم أوقاف سيستم إلى PalWakf دون إعادة تصميم جوهرية',
      path: AwqafSystemRoutes.joinPackage,
      icon: Icons.inventory_2_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historicalAdminTopology,
      groupAr: 'الرئيسية',
      titleAr: 'الطبولوجيا الإدارية التاريخية',
      subtitleAr:
          'CRUD تشغيلي للعقد والعلاقات الزمنية بين التاريخ والمرجع الإداري الحديث',
      path: AwqafSystemRoutes.historicalAdminTopology,
      icon: Icons.account_tree_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.institution,
      groupAr: 'المؤسسة والهيكل',
      titleAr: 'بيانات المؤسسة',
      subtitleAr: 'الهوية والبيانات الرسمية',
      path: AwqafSystemRoutes.institution,
      icon: Icons.account_balance_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.orgUnits,
      groupAr: 'المؤسسة والهيكل',
      titleAr: 'الوحدات التنظيمية',
      subtitleAr: 'إدارات ومديريات ووحدات فرعية',
      path: AwqafSystemRoutes.orgUnits,
      icon: Icons.account_tree_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.orgStructure,
      groupAr: 'المؤسسة والهيكل',
      titleAr: 'شجرة الهيكل',
      subtitleAr: 'العلاقات الهرمية بين الوحدات',
      path: AwqafSystemRoutes.orgStructure,
      icon: Icons.schema_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.governorates,
      groupAr: 'المرجع الجغرافي',
      titleAr: 'المحافظات',
      subtitleAr: 'المستوى الإداري الأعلى',
      path: AwqafSystemRoutes.governorates,
      icon: Icons.map_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.communities,
      groupAr: 'المرجع الجغرافي',
      titleAr: 'التجمعات',
      subtitleAr: 'مدن وبلدات وقرى',
      path: AwqafSystemRoutes.communities,
      icon: Icons.location_city_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.lgus,
      groupAr: 'المرجع الجغرافي',
      titleAr: 'الهيئات المحلية',
      subtitleAr: 'بلديات ومجالس محلية',
      path: AwqafSystemRoutes.lgus,
      icon: Icons.apartment_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.communityWaqfPortions,
      groupAr: 'المرجع الجغرافي',
      titleAr: 'حصص الوقف للتجمعات',
      subtitleAr: 'الحصص الوقفية السيادية على مستوى التجمع الأم',
      path: AwqafSystemRoutes.communityWaqfPortions,
      icon: Icons.pie_chart_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.communityWaqfEvidence,
      groupAr: 'المرجع الجغرافي',
      titleAr: 'إثباتات الوقف',
      subtitleAr: 'الحجج والكتب والقوائم المرتبطة بالحصة الوقفية',
      path: AwqafSystemRoutes.communityWaqfEvidence,
      icon: Icons.fact_check_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.communityWaqfEvidenceDocuments,
      groupAr: 'المرجع الجغرافي',
      titleAr: 'مستندات إثباتات الوقف',
      subtitleAr: 'الملفات والروابط المرتبطة بسجلات إثباتات الوقف للتجمعات',
      path: AwqafSystemRoutes.communityWaqfEvidenceDocuments,
      icon: Icons.folder_open_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.communityWaqfPortionDocuments,
      groupAr: 'المرجع الجغرافي',
      titleAr: 'مستندات حصص الوقف',
      subtitleAr: 'الملفات والروابط المرتبطة بحصص الوقف للتجمعات',
      path: AwqafSystemRoutes.communityWaqfPortionDocuments,
      icon: Icons.perm_media_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.endowmentTypes,
      groupAr: 'مرجع الوقف',
      titleAr: 'أنواع الوقف',
      subtitleAr: 'قاموس الأنواع الأساسية للوقف',
      path: AwqafSystemRoutes.endowmentTypes,
      icon: Icons.category_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfDictionaries,
      groupAr: 'مرجع الوقف',
      titleAr: 'قواميس الوقف',
      subtitleAr: 'الحالات والتصنيفات والقواميس المساندة',
      path: AwqafSystemRoutes.waqfDictionaries,
      icon: Icons.bookmarks_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.endowers,
      groupAr: 'مرجع الوقف',
      titleAr: 'الواقفون',
      subtitleAr: 'سجل الواقفين والجهات المؤسسة',
      path: AwqafSystemRoutes.endowers,
      icon: Icons.groups_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.endowments,
      groupAr: 'مرجع الوقف',
      titleAr: 'الأوقاف',
      subtitleAr: 'السجل المرجعي للأوقاف الأم',
      path: AwqafSystemRoutes.endowments,
      icon: Icons.foundation_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.referenceWaqfLinking,
      groupAr: 'مرجع الوقف',
      titleAr: 'عقود ربط الوقف المرجعي',
      subtitleAr:
          'ربط الوقف الأم بالوثائق والطبولوجيا ومرشحات الأصول دون اعتماد تلقائي',
      path: AwqafSystemRoutes.referenceWaqfLinking,
      icon: Icons.link_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.communityDocumentEvidenceLinking,
      groupAr: 'مرجع الوقف',
      titleAr: 'ربط أدلة التجمعات والوثائق',
      subtitleAr:
          'عقود مراجعة تربط إثباتات التجمعات والوثائق بالوقف المرجعي دون اعتماد تلقائي',
      path: AwqafSystemRoutes.communityDocumentEvidenceLinking,
      icon: Icons.folder_copy_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.awqafAssistWorkspace,
      groupAr: 'أوقاف أسيست',
      titleAr: 'أوقاف أسيست',
      subtitleAr: 'مهارة نطاقية فوق مساعد المنصة؛ أدلة ورفض آمن دون كتابة',
      path: AwqafSystemRoutes.awqafAssistWorkspace,
      icon: Icons.psychology_alt_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.awqafAssistAnswerContracts,
      groupAr: 'أوقاف أسيست',
      titleAr: 'عقود إجابات أوقاف أسيست',
      subtitleAr:
          'إعداد إجابات مستندة إلى أدلة واستشهادات مع بوابات منع النشر عند نقص المراجعة',
      path: AwqafSystemRoutes.awqafAssistAnswerContracts,
      icon: Icons.fact_check_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.sqlContractRuntimeClosure,
      groupAr: 'أوقاف أسيست',
      titleAr: 'إغلاق عقود SQL وUAT',
      subtitleAr: 'فحص حضور عقود SQL ومسارات Browser UAT قبل أي توسع إنتاجي',
      path: AwqafSystemRoutes.sqlContractRuntimeClosure,
      icon: Icons.verified_user_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.systemCertification,
      groupAr: 'الإغلاق التشغيلي',
      titleAr: 'اعتماد أوقاف سيستم',
      subtitleAr:
          'شهادة System-of-Systems: التسجيل الديناميكي، الصحة، الصيانة، الحماية، وUAT',
      path: AwqafSystemRoutes.systemCertification,
      icon: Icons.verified_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.operationalReadiness,
      groupAr: 'الإغلاق التشغيلي',
      titleAr: 'مركز إغلاق الفجوات',
      subtitleAr:
          'مصفوفة تشغيلية للصفحات والعقود وBrowser UAT قبل العودة إلى waqf_assets',
      path: AwqafSystemRoutes.operationalReadiness,
      icon: Icons.rule_folder_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssets,
      groupAr: 'مرجع الوقف',
      titleAr: 'سجل الأصول الوقفية',
      subtitleAr:
          'السجل السيادي للعقارات والأصول الوقفية وربطها بالمراجعة والتسوية والوثائق',
      path: AwqafSystemRoutes.waqfAssets,
      icon: Icons.real_estate_agent_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssets,
      groupAr: 'مرجع الوقف',
      titleAr: 'تطوير نظام الأوقاف 6',
      subtitleAr:
          'مركز قيادة تشغيلي جديد بعد إغلاق أوقاف أسيست مع إبقاء الكتابة مغلقة',
      path: AwqafSystemRoutes.waqfAssetsOperationalDevelopment,
      icon: Icons.account_tree_outlined,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssets,
      groupAr: 'مرجع الوقف',
      titleAr: 'كونسول قراءة الأصول',
      subtitleAr:
          'واجهة تشغيلية read-only لسجلات المصادر والطابور ودورة الحياة وبوابة الصلاحيات',
      path: AwqafSystemRoutes.waqfAssetsOperationalReadConsole,
      icon: Icons.manage_search_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssets,
      groupAr: 'مرجع الوقف',
      titleAr: 'شاشات مستخدمي الأصول',
      subtitleAr:
          'واجهة مستخدم read-only للبحث وفتح ملخص الأصل وسجلات المصدر دون كتابة أو مراجعة',
      path: AwqafSystemRoutes.waqfAssetsUserScreens,
      icon: Icons.person_search_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssetsCandidateDryRun,
      groupAr: 'مرجع الوقف',
      titleAr: 'Dry Run مرشح أصل وقفي',
      subtitleAr:
          'تجربة محكومة لطابور تطوير waqf_assets قبل تطبيق أو نشر waqf_asset_id',
      path: AwqafSystemRoutes.waqfAssetsCandidateDryRun,
      icon: Icons.route_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssetsOperationalApplyGate,
      groupAr: 'مرجع الوقف',
      titleAr: 'بوابة تطبيق الأصل الوقفي',
      subtitleAr:
          'بوابة apply صريحة من طابور أوقاف سيستم إلى waqf.waqf_assets مع Role/Unit/RLS',
      path: AwqafSystemRoutes.waqfAssetsOperationalApplyGate,
      icon: Icons.verified_user_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssetLifecycle,
      groupAr: 'مرجع الوقف',
      titleAr: 'دورة حياة الأصل الوقفي',
      subtitleAr:
          'تشغيل مراحل الإدخال والمراجعة والاعتماد والربط والأرشفة عبر RPC فقط',
      path: AwqafSystemRoutes.waqfAssetLifecycle,
      icon: Icons.route_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.endowmentDeedDocuments,
      groupAr: 'مرجع الوقف',
      titleAr: 'مستندات حجج الوقف الأم',
      subtitleAr: 'إدارة بيانات ومستندات الحجج المرتبطة بالوقف المرجعي',
      path: AwqafSystemRoutes.endowmentDeedDocuments,
      icon: Icons.description_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.endowmentLinks,
      groupAr: 'مرجع الوقف',
      titleAr: 'علاقات الوقف',
      subtitleAr: 'ربط الوقف بالواقف والوحدة والجغرافيا',
      path: AwqafSystemRoutes.endowmentLinks,
      icon: Icons.link_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.endowmentSupervisors,
      groupAr: 'مرجع الوقف',
      titleAr: 'إسنادات إشراف الوقف الأم',
      subtitleAr: 'إدارة إسنادات الإشراف والولاية على الوقف المرجعي',
      path: AwqafSystemRoutes.endowmentSupervisors,
      icon: Icons.manage_accounts_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.endowmentBeneficiaries,
      groupAr: 'مرجع الوقف',
      titleAr: 'منتفعو الوقف الأم',
      subtitleAr: 'إدارة المنتفعين على مستوى الوقف المرجعي',
      path: AwqafSystemRoutes.endowmentBeneficiaries,
      icon: Icons.volunteer_activism_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssetEndowers,
      groupAr: 'مرجع الوقف',
      titleAr: 'واقفو الأصل الوقفي',
      subtitleAr: 'ربط الواقفين على مستوى الأصل الوقفي العيني',
      path: AwqafSystemRoutes.waqfAssetEndowers,
      icon: Icons.badge_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssetBeneficiaries,
      groupAr: 'مرجع الوقف',
      titleAr: 'منتفعو الأصل الوقفي',
      subtitleAr: 'إدارة المنتفعين على مستوى الأصل الوقفي العيني',
      path: AwqafSystemRoutes.waqfAssetBeneficiaries,
      icon: Icons.favorite_border_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssetSupervisionAssignments,
      groupAr: 'مرجع الوقف',
      titleAr: 'إسنادات إشراف الأصل الوقفي',
      subtitleAr: 'إدارة الإشراف والولاية على مستوى الأصل الوقفي العيني',
      path: AwqafSystemRoutes.waqfAssetSupervisionAssignments,
      icon: Icons.rule_folder_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.waqfAssetDeedDocuments,
      groupAr: 'مرجع الوقف',
      titleAr: 'مستندات حجج الأصل الوقفي',
      subtitleAr: 'إدارة بيانات ومستندات الحجج على مستوى الأصل الوقفي العيني',
      path: AwqafSystemRoutes.waqfAssetDeedDocuments,
      icon: Icons.folder_copy_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.importExport,
      groupAr: 'الحوكمة والتكامل',
      titleAr: 'مركز الاستيراد الإداري',
      subtitleAr: 'دفعات الاستيراد، المراجعة، الاعتماد، وسجل التنفيذ',
      path: AwqafSystemRoutes.importExport,
      icon: Icons.upload_file_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.unitPages,
      groupAr: 'الربط والنشر',
      titleAr: 'صفحات الوحدات',
      subtitleAr: 'ربط الوحدة بمسار الموقع العام',
      path: AwqafSystemRoutes.unitPages,
      icon: Icons.web_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyOntology,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'أنطولوجيا فلسطين',
      subtitleAr: 'تعريف الفترات المرجعية العليا',
      path: AwqafSystemRoutes.historyOntology,
      icon: Icons.history_edu_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyOtherEmpire,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'الإمبراطوريات الأخرى',
      subtitleAr: 'مصادر الفترات 1–11',
      path: AwqafSystemRoutes.historyOtherEmpire,
      icon: Icons.auto_stories_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyOttomanEmpire,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'الدولة العثمانية',
      subtitleAr: 'المصدر التفصيلي للفترتين 12 و13',
      path: AwqafSystemRoutes.historyOttomanEmpire,
      icon: Icons.castle_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyBritishMandate,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'الانتداب البريطاني على فلسطين',
      subtitleAr: 'مصدر مرحلتي الانتداب 14 و15',
      path: AwqafSystemRoutes.historyBritishMandate,
      icon: Icons.flag_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyStateOfIsrael,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'قيام دولة إسرائيل',
      subtitleAr: 'مصدر الفترة 16 بشكل مستقل',
      path: AwqafSystemRoutes.historyStateOfIsrael,
      icon: Icons.flag_circle_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyJordanianAdministration,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'الإدارة الأردنية',
      subtitleAr: 'مصدر الفترة 17',
      path: AwqafSystemRoutes.historyJordanianAdministration,
      icon: Icons.account_balance_wallet_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyEgyptGazaStrip,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'مصر / قطاع غزة',
      subtitleAr: 'مصدر الفترة 18 بشكل مستقل',
      path: AwqafSystemRoutes.historyEgyptGazaStrip,
      icon: Icons.travel_explore_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyIsraeliOccupation,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'الاحتلال الإسرائيلي',
      subtitleAr: 'مصدر مرحلتي 19 و20',
      path: AwqafSystemRoutes.historyIsraeliOccupation,
      icon: Icons.gpp_bad_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.historyPalestinianAutonomy,
      groupAr: 'التاريخ — مصادر المرحلة',
      titleAr: 'الحكم الذاتي الفلسطيني',
      subtitleAr: 'مصدر الفترة 21',
      path: AwqafSystemRoutes.historyPalestinianAutonomy,
      icon: Icons.how_to_reg_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalDivisionsStarter,
      groupAr: 'التاريخ — التقسيم السياسي',
      titleAr: 'لوحة البدء',
      subtitleAr: 'انطلاق المرحلة التالية فوق القالب المستقر',
      path: AwqafSystemRoutes.politicalDivisionsStarter,
      icon: Icons.account_tree_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalExplorer,
      groupAr: 'التاريخ — المستكشف السياسي',
      titleAr: 'المستكشف السياسي',
      subtitleAr: 'بوابة موحدة تربط التاريخ المرجعي والهرمي والفروع الحديثة',
      path: AwqafSystemRoutes.politicalExplorer,
      icon: Icons.alt_route_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalHistoricalWelaya,
      groupAr: 'التاريخ — التقسيم السياسي',
      titleAr: 'الولايات التاريخية',
      subtitleAr: 'المستوى السياسي الأعلى في الفرع العثماني',
      path: AwqafSystemRoutes.politicalHistoricalWelaya,
      icon: Icons.account_balance_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalHistoricalSonjoq,
      groupAr: 'التاريخ — التقسيم السياسي',
      titleAr: 'السناجق التاريخية',
      subtitleAr: 'الوحدات التابعة للولايات التاريخية',
      path: AwqafSystemRoutes.politicalHistoricalSonjoq,
      icon: Icons.fort_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalHistoricalLewa,
      groupAr: 'التاريخ — التقسيم السياسي',
      titleAr: 'الألوية التاريخية',
      subtitleAr: 'نقطة الالتقاء بين الفرع العثماني والانتداب البريطاني',
      path: AwqafSystemRoutes.politicalHistoricalLewa,
      icon: Icons.flag_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalHistoricalKada,
      groupAr: 'التاريخ — التقسيم السياسي',
      titleAr: 'الأقضية التاريخية',
      subtitleAr: 'المستوى الأدنى في التسلسل السياسي التاريخي',
      path: AwqafSystemRoutes.politicalHistoricalKada,
      icon: Icons.map_outlined,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalWestbankGazaAnchor,
      groupAr: 'التاريخ — الفروع السياسية الحديثة',
      titleAr: 'الضفة الغربية وقطاع غزة',
      subtitleAr: 'مرساة تشغيلية للفروع السياسية من 16 إلى 21',
      path: AwqafSystemRoutes.politicalWestbankGazaAnchor,
      icon: Icons.public_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalJordanianAdministrationBranch,
      groupAr: 'التاريخ — الفروع السياسية الحديثة',
      titleAr: 'الإدارة الأردنية',
      subtitleAr: 'الفرع السياسي للفترة 17',
      path: AwqafSystemRoutes.politicalJordanianAdministrationBranch,
      icon: Icons.account_balance_wallet_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalEgyptGazaStripBranch,
      groupAr: 'التاريخ — الفروع السياسية الحديثة',
      titleAr: 'مصر / قطاع غزة',
      subtitleAr: 'الفرع السياسي للفترة 18',
      path: AwqafSystemRoutes.politicalEgyptGazaStripBranch,
      icon: Icons.travel_explore_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalStateOfIsraelBranch,
      groupAr: 'التاريخ — الفروع السياسية الحديثة',
      titleAr: 'قيام دولة إسرائيل',
      subtitleAr: 'الفرع السياسي للفترة 16',
      path: AwqafSystemRoutes.politicalStateOfIsraelBranch,
      icon: Icons.flag_circle_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalIsraeliOccupationBranch,
      groupAr: 'التاريخ — الفروع السياسية الحديثة',
      titleAr: 'الاحتلال الإسرائيلي',
      subtitleAr: 'الفرع السياسي للفترتين 19 و20',
      path: AwqafSystemRoutes.politicalIsraeliOccupationBranch,
      icon: Icons.gpp_bad_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalPalestinianAutonomyBranch,
      groupAr: 'التاريخ — الفروع السياسية الحديثة',
      titleAr: 'الحكم الذاتي الفلسطيني',
      subtitleAr: 'الفرع السياسي للفترة 21',
      path: AwqafSystemRoutes.politicalPalestinianAutonomyBranch,
      icon: Icons.how_to_reg_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalModernGovernorates,
      groupAr: 'التاريخ — التقسيم الحديث',
      titleAr: 'المحافظات الحديثة',
      subtitleAr: 'المدخل التشغيلي للمرحلة الحديثة فوق source of truth الحالي',
      path: AwqafSystemRoutes.politicalModernGovernorates,
      icon: Icons.apartment_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalHistoricalGovernorates,
      groupAr: 'التاريخ — التقسيم الحديث',
      titleAr: 'المحافظات التاريخية',
      subtitleAr:
          'تبويب مستقل للمحافظات التاريخية تمهيدًا لربط LGUs التاريخي لاحقًا',
      path: AwqafSystemRoutes.politicalHistoricalGovernorates,
      icon: Icons.history_edu_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalModernCommunities,
      groupAr: 'التاريخ — التقسيم الحديث',
      titleAr: 'التجمعات الحديثة',
      subtitleAr: 'التجمعات الواقعة تحت المحافظات الحديثة فقط',
      path: AwqafSystemRoutes.politicalModernCommunities,
      icon: Icons.location_city_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.politicalHistoricalCommunities,
      groupAr: 'التاريخ — التقسيم الحديث',
      titleAr: 'التجمعات التاريخية',
      subtitleAr: 'تبويب مستقل للتجمعات التاريخية خارج المسار الحديث',
      path: AwqafSystemRoutes.politicalHistoricalCommunities,
      icon: Icons.domain_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.dataQuality,
      groupAr: 'الرقابة والتقارير',
      titleAr: 'الجودة والحوكمة',
      subtitleAr: 'كشف النواقص والازدواج والربط المفقود',
      path: AwqafSystemRoutes.dataQuality,
      icon: Icons.verified_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.reports,
      groupAr: 'الرقابة والتقارير',
      titleAr: 'التقارير',
      subtitleAr: 'ملخصات وإحصاءات مرجعية',
      path: AwqafSystemRoutes.reports,
      icon: Icons.assessment_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.auditLog,
      groupAr: 'الرقابة والتقارير',
      titleAr: 'سجل التدقيق',
      subtitleAr:
          'قراءة أحداث التدقيق والمراجعة من عقود SQL أو مصادر audit المتاحة',
      path: AwqafSystemRoutes.auditLog,
      icon: Icons.manage_search_rounded,
    ),
    AwqafSystemNavItem(
      section: AwqafSystemSection.settings,
      groupAr: 'الرقابة والتقارير',
      titleAr: 'إعدادات أوقاف سيستم',
      subtitleAr: 'إعدادات تشغيلية تضبط fallback وUAT وحماية waqf_assets',
      path: AwqafSystemRoutes.settings,
      icon: Icons.tune_rounded,
    ),
  ];

  static Map<String, List<AwqafSystemNavItem>> groupedItems() {
    final Map<String, List<AwqafSystemNavItem>> grouped =
        <String, List<AwqafSystemNavItem>>{};
    for (final AwqafSystemNavItem item in items) {
      grouped.putIfAbsent(item.groupAr, () => <AwqafSystemNavItem>[]).add(item);
    }
    return grouped;
  }

  static AwqafSystemNavItem itemForSection(AwqafSystemSection section) {
    return items
        .firstWhere((AwqafSystemNavItem item) => item.section == section);
  }

  static AwqafSystemSection sectionFromLocation(String location) {
    final String normalized = location.split('?').first;
    for (final AwqafSystemNavItem item in items) {
      if (normalized == item.path || normalized.startsWith('${item.path}/')) {
        return item.section;
      }
    }
    return AwqafSystemSection.dashboard;
  }
}
