import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_v30_merge_pack_contract.dart';

final nosokV30MergePackContractProvider =
    Provider<NosokV30MergePackContract>((ref) {
  return const NosokV30MergePackContract(
    version: 'v30-full-palwakf-merge-pack-application-pre-db',
    status:
        'merge-pack-application-ready / v29-compile-blocker-closed / platform-registry-entry-prepared / access-profile-override-closure-plan-ready / palwakf-browser-role-responsive-uat-pending / nosok-schema-creation-prepared-not-applied',
    productionDecision: 'production-not-approved',
    databaseState: 'schema-not-created-by-design-until-palwakf-merge',
    mergeApplicationSteps: [
      NosokV30MergeStep(
        key: 'fix_v29_compile_blocker',
        titleAr: 'إغلاق blocker صفحة v29',
        actionAr:
            'تصحيح النصوص متعددة الأسطر داخل nosok_admin_v29_merge_readiness_page.dart باستخدام \n بدل literal line break داخل single-quoted string.',
        targetPath:
            'lib/features/nosok_system/presentation/pages/admin/nosok_admin_v29_merge_readiness_page.dart',
        status: 'applied-in-v30',
      ),
      NosokV30MergeStep(
        key: 'copy_feature_folder',
        titleAr: 'نقل feature folder إلى PalWakf',
        actionAr:
            'نقل lib/features/nosok_system كاملًا إلى ريبو المنصة مع الحفاظ على flutter_riverpod.dart وعدم استخدام legacy.dart في الملفات الجديدة.',
        targetPath: 'PalWakf/lib/features/nosok_system',
        status: 'merge-instruction-ready',
      ),
      NosokV30MergeStep(
        key: 'wire_routes',
        titleAr: 'ربط المسارات داخل GoRouter المنصة',
        actionAr:
            'استدعاء NosokRoutes.buildRoutes() ضمن route group المناسب، مع الحفاظ على public /services/nosok وadmin /admin/systems/nosok.',
        targetPath: 'PalWakf/lib/app/routing/route_groups',
        status: 'merge-instruction-ready',
      ),
      NosokV30MergeStep(
        key: 'access_override',
        titleAr: 'إغلاق AccessProfile Override',
        actionAr:
            'استبدال preview access profile بـ provider override من منصة PalWakf وربطه بـ platform-wide RBAC.',
        targetPath:
            'platform_real_merge_pack/lib/core/access/nosok_access_profile_override.dart',
        status: 'closure-plan-ready-not-runtime-applied',
      ),
      NosokV30MergeStep(
        key: 'schema_creation_preparation',
        titleAr: 'تحضير إنشاء schema نسك',
        actionAr:
            'تجهيز ترتيب إنشاء nosok schema بعد الدمج فقط، دون تنفيذ CREATE/ALTER/DML في هذه المرحلة.',
        targetPath:
            'sql/32_nosok_v30_schema_creation_preparation_readiness.sql',
        status: 'prepared-not-applied',
      ),
    ],
    registryEntries: [
      NosokV30RegistryEntry(
        key: 'system_key',
        platformObject: 'platform.system_registry',
        valueContract:
            'system_key=nosok, route_base=/admin/systems/nosok, public_route_base=/services/nosok, system_type=semi_independent_service_system, owner_schema=nosok بعد الدمج.',
        status: 'entry-draft-ready',
      ),
      NosokV30RegistryEntry(
        key: 'system_sections',
        platformObject: 'platform.system_sections',
        valueContract:
            'dashboard, requests, review, lottery, lottery/eligibility, lottery/draw, lottery/waiting-list, lottery/committee, companies, campaigns, documents, messages, reports, settings.',
        status: 'sections-draft-ready',
      ),
      NosokV30RegistryEntry(
        key: 'health_boundary',
        platformObject: 'platform.system_health_contracts',
        valueContract:
            'health route + maintenance flag + error boundary حتى لا يعطل نسك المنصة عند فشل Runtime.',
        status: 'contract-ready',
      ),
      NosokV30RegistryEntry(
        key: 'public_service_center',
        platformObject: 'Public Service Center / homepage links',
        valueContract:
            'إظهار خدمات نسك للجمهور كمركز خدمة لا Dashboard، مع CTA للتقديم والمتابعة والنتائج والشركات.',
        status: 'surface-ready',
      ),
    ],
    rbacClosures: [
      NosokV30RbacClosure(
        roleKey: 'visitor',
        roleAr: 'زائر',
        permissions: 'public read only',
        guardSurface: '/services/nosok/* only',
        status: 'public-safe',
      ),
      NosokV30RbacClosure(
        roleKey: 'citizen',
        roleAr: 'مواطن/مستخدم عام',
        permissions: 'submit/track-own/request-completion/objection-own',
        guardSurface: 'RPC wrappers later; no direct table exposure',
        status: 'contract-ready-pending-auth-context',
      ),
      NosokV30RbacClosure(
        roleKey: 'nosok_employee',
        roleAr: 'موظف نسك',
        permissions: 'view assigned requests, review documents, send messages',
        guardSurface: 'admin routes scoped by AccessProfile',
        status: 'override-required-inside-palwakf',
      ),
      NosokV30RbacClosure(
        roleKey: 'nosok_supervisor',
        roleAr: 'مشرف نسك',
        permissions:
            'manage queues, eligibility review, waiting-list operations by scope',
        guardSurface: 'unit/role scoped admin routes',
        status: 'override-required-inside-palwakf',
      ),
      NosokV30RbacClosure(
        roleKey: 'hajj_committee',
        roleAr: 'لجنة الحج',
        permissions:
            'committee decisions for underfilled quota, objections, policy exceptions',
        guardSurface: '/admin/systems/nosok/lottery/committee',
        status: 'governance-sensitive-pending-platform-role',
      ),
      NosokV30RbacClosure(
        roleKey: 'superuser',
        roleAr: 'Superuser',
        permissions: 'full read/audit/production gate decision after evidence',
        guardSurface: 'platform superuser only',
        status: 'must-remain-audited',
      ),
    ],
    palwakfUatSurfaces: [
      NosokV30UatSurface(
        route: '/services/nosok',
        actorAr: 'زائر/مواطن',
        requiredEvidenceAr:
            'فتح الصفحة، CTA، عدم ظهور أدوات الموظف، RTL، mobile no overflow.',
        status: 'uat-required-inside-palwakf',
      ),
      NosokV30UatSurface(
        route: '/services/nosok/apply',
        actorAr: 'مواطن',
        requiredEvidenceAr:
            'Wizard يعمل كواجهة فقط قبل DB، validation عربي، لا raw backend errors.',
        status: 'uat-required-inside-palwakf',
      ),
      NosokV30UatSurface(
        route: '/services/nosok/lottery-results',
        actorAr: 'مواطن',
        requiredEvidenceAr:
            'يعرض نتيجة الشخص فقط كـ contract، دون بيانات الآخرين.',
        status: 'privacy-uat-required',
      ),
      NosokV30UatSurface(
        route: '/admin/systems/nosok',
        actorAr: 'موظف/مشرف/Superuser/restricted',
        requiredEvidenceAr:
            'زر دخول الموظفين يعمل، route guard يطبق المنع، restricted يذهب forbidden/read-only حسب العقد.',
        status: 'role-uat-required',
      ),
      NosokV30UatSurface(
        route: '/admin/systems/nosok/lottery/draw',
        actorAr: 'مدير نظام/لجنة مصرح لها',
        requiredEvidenceAr:
            'لا تشغيل قرعة حقيقي قبل DB؛ تظهر حالة prepared-not-applied وaudit required.',
        status: 'governance-uat-required',
      ),
      NosokV30UatSurface(
        route: '/admin/systems/nosok/v30-palwakf-merge-application',
        actorAr: 'Superuser/Platform admin',
        requiredEvidenceAr:
            'تعرض خطة الدمج، Registry/RBAC/Schema prep، وتثبت production-not-approved.',
        status: 'new-in-v30',
      ),
    ],
    schemaPreparationItems: [
      NosokV30SchemaPreparationItem(
        family: 'core schema shell',
        preparationAr:
            'nosok.seasons, service_types, settings, audit envelope.',
        applyTiming: 'after PalWakf merge + sandbox approval',
        status: 'draft-only',
      ),
      NosokV30SchemaPreparationItem(
        family: 'application lifecycle',
        preparationAr:
            'applications, applicants, companions, documents, reviews, messages.',
        applyTiming: 'after schema shell',
        status: 'draft-only',
      ),
      NosokV30SchemaPreparationItem(
        family: 'companies/campaigns/groups',
        preparationAr:
            'companies, campaigns, groups, company users/contracts later.',
        applyTiming: 'after partner policy review',
        status: 'draft-only',
      ),
      NosokV30SchemaPreparationItem(
        family: 'LGU quota lottery',
        preparationAr:
            'lottery_policies, lgu_quota_snapshots, eligibility_snapshots, draw_runs/results, waiting_list.',
        applyTiming: 'after LGU source + ministry policy approval',
        status: 'draft-only',
      ),
      NosokV30SchemaPreparationItem(
        family: 'committee/objections/audit',
        preparationAr:
            'committee_decisions, objections, immutable audit_events, public-safe result RPCs.',
        applyTiming: 'after governance approval',
        status: 'draft-only',
      ),
    ],
    blockers: [
      'لم يتم دمج نسك فعليًا داخل ريبو PalWakf في هذه الحزمة؛ هذه حزمة تطبيق/تعليمات و readiness داخل preview.',
      'لم يتم إنشاء nosok schema عمدًا قبل الدمج الرسمي مع PalWakf.',
      'AccessProfile الحقيقي ما زال يحتاج ربطًا داخل المنصة وليس preview provider.',
      'Browser/Role/Responsive UAT يجب أن يُنفذ داخل PalWakf بعد الدمج لا داخل preview فقط.',
      'أي SQL/RPC/RLS يبقى Draft/Readiness حتى تصريح الإنشاء بعد الدمج.',
      'لا توجد موافقة إنتاج ولا تعديل على waqf_assets.',
    ],
  );
});
