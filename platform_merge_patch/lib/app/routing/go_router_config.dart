import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/access/access_provider.dart';
import '../../core/access/access_profile.dart';
import '../../core/enums/enums.dart';
import '../../features/shells/presentation/forbidden_screen.dart';
import '../../features/shells/presentation/platform_admin_shell.dart';
import '../../features/shells/presentation/public_shell.dart';
import '../../features/shells/presentation/system_dashboard_placeholder.dart';
import '../../features/shells/presentation/system_shell.dart';
import '../../presentation/screens/admin/auth/login/login_screen.dart';
import '../../presentation/screens/admin/auth/profile/profile_screen.dart';
import '../../presentation/screens/admin/main/dashboard/dashboard_screen.dart';
import '../../presentation/screens/admin/main/dashboard/my_activity_screen.dart';
import '../../presentation/screens/admin/main/management/activities_management/activities_management_screen.dart';
import '../../presentation/screens/admin/main/management/breaking_news_management/breaking_news_management_screen.dart';
import '../../presentation/screens/admin/main/management/hero_slider_management/hero_slider_management_screen.dart';
import '../../presentation/screens/admin/main/management/home_management/homepage_management_screen.dart';
import '../../presentation/screens/admin/main/management/friday_sermons_management/friday_sermons_management_screen.dart';
import '../../presentation/screens/admin/systems/cases/cases_screen.dart';
import '../../presentation/screens/admin/systems/documents/documents_screen.dart';
import '../../presentation/screens/admin/systems/waqf_lands/waqf_lands_screen.dart';
import '../../presentation/screens/public/about/about_screen.dart';
import '../../presentation/screens/public/activities/activities_screen.dart';
import '../../presentation/screens/public/announcements_screen.dart';
import '../../presentation/screens/public/contact/contact_screen.dart';
import '../../presentation/screens/public/eservices_screen.dart';
import '../../presentation/screens/public/friday_sermon_screen.dart';
import '../../presentation/screens/public/home/home_screen.dart';
import '../../presentation/screens/public/mosques/mosques_screen.dart';
import '../../presentation/screens/public/news/news_screen.dart';
import '../../presentation/screens/public/news_details/news_detail_screen.dart';
import '../../presentation/screens/public/not_found/not_found_screen.dart';
import '../../presentation/screens/public/projects_screen.dart';
import '../../presentation/screens/public/search/search_screen.dart';
import '../../presentation/screens/public/services/services_screen.dart';
import '../../presentation/screens/public/social_services/social_services_screen.dart';
import '../../presentation/screens/public/structure_screen.dart';
import '../../presentation/screens/public/minister_screen.dart';
import '../../presentation/screens/public/former_ministers_screen.dart';
import '../../presentation/screens/public/vision_mission_screen.dart';
import '../../presentation/screens/public/switch_system/switch_system_screen.dart';
import '../../presentation/screens/public/under_construction_screen.dart';

// New HTML-identity Web pages (home_new)
import '../../features/platform/home/presentation/screens/pwf_under_construction_web_screen.dart';
import '../../features/platform/home/presentation/screens/pages/pwf_news_pages.dart';
import '../../features/platform/home/presentation/screens/pages/pwf_announcements_pages.dart';
import '../../features/platform/home/presentation/screens/pages/pwf_activities_pages.dart';
import '../../features/platform/home/presentation/screens/pages/pwf_misc_pages.dart';
import '../../features/platform/home/presentation/screens/pages/pwf_static_pages.dart';
import '../../features/platform/home/presentation/screens/pages/pwf_content_pages.dart';

import 'app_routes.dart';
import 'router_refresh_notifier.dart';
import 'unit_routes.dart';
import '../../data/models/news_article.dart';
import '../../presentation/screens/public/news_details/news_detail_route_screen.dart';
import '../../presentation/screens/public/unit/unit_home_screen.dart';
import '../../presentation/screens/admin/main/management/users_management/users_management_screen.dart';
import '../../presentation/screens/admin/main/management/mosques_management/mosques_management_screen.dart';
import '../../presentation/screens/admin/main/management/org_units_management/org_units_management_screen.dart';
import '../../presentation/screens/admin/main/management/settings/settings_screen.dart';
import '../../presentation/screens/admin/main/management/developer/developer_tools_screen.dart';
import '../../presentation/screens/admin/main/management/shared_content/shared_content_management_screen.dart';
import '../../presentation/providers/auth_provider.dart';
import '../../features/platform/assistant/assistant_core/data/services/chat_route_context_service.dart';
import '../../features/platform/home/presentation/screens/pwf_web_page_scaffold.dart';
import '../../features/platform/assistant/internal_assistant/data/models/assistant_context.dart';
import '../../features/platform/assistant/internal_assistant/presentation/pages/internal_assistant_page.dart';
import '../../features/platform/assistant/public_chatbot/presentation/pages/public_chatbot_page.dart';

// Zakat / Prayer Times / Quran (Public + Systems)
import '../../features/platform/governance/complaints/presentation/screens/pwf_complaints_screen.dart';
import '../../features/platform/governance/complaints/presentation/screens/admin/pwf_admin_complaints_screen.dart';
import '../../features/platform/services/zakat/presentation/screens/pwf_zakat_public_screen.dart';
import '../../features/platform/services/prayer_times/presentation/screens/pwf_prayer_times_public_screen.dart';
import '../../features/platform/services/quran/presentation/screens/pwf_quran_public_screen.dart';
import '../../features/platform/services/zakat/presentation/screens/admin/pwf_zakat_admin_dashboard_screen.dart';
import '../../features/platform/services/prayer_times/presentation/screens/admin/pwf_prayer_times_admin_dashboard_screen.dart';
import '../../features/platform/services/quran/presentation/screens/admin/pwf_quran_admin_dashboard_screen.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_application_status_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_notification_dispatch_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_application_lifecycle_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_citizen_followup_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_apply_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_companies_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_complaints_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_faq_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_hajj_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_public_home_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_umrah_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_applications_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_billing_adapters_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_application_details_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_companies_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_programs_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_complaints_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_content_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_dashboard_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_seasons_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_reports_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_units_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_unit_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_users_roles_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_sidebar_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_settings_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_health_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_operations_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_payment_bridge_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_readiness_evidence_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_unit_queues_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_tracking_privacy_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_role_uat_page.dart';
import '../../features/nosok_system/presentation/pages/admin/nosok_admin_notifications_page.dart';
import '../../features/nosok_system/presentation/pages/public/nosok_public_unit_page.dart';
import '../../features/nosok_system/presentation/widgets/nosok_admin_system_shell.dart';
import '../../features/nosok_system/presentation/widgets/nosok_public_system_shell.dart';
import '../../features/platform/home/presentation/screens/admin/pwf_public_pages_admin_screens.dart';
import '../../presentation/screens/admin/main/usage_guide/usage_guide_screen.dart';
import '../../features/tasks_system/presentation/pages/tasks_dashboard_page.dart';
import '../../features/tasks_system/presentation/pages/task_form_page.dart';
import '../../features/tasks_system/presentation/pages/task_detail_page.dart';

part 'route_groups/common_routes_group.dart';
part 'route_groups/public_routes_group.dart';
part 'route_groups/auth_routes_group.dart';
part 'route_groups/admin_routes_group.dart';
part 'route_groups/system_routes_group.dart';

class GoRouterConfig {
  static GoRouter build(Ref ref) {
    final refresh = GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    );

    return GoRouter(
      // Official sites should land directly on the ministry home.
      initialLocation: AppRoutes.home,
      refreshListenable: refresh,
      debugLogDiagnostics: true,
      redirect: (context, state) async {
        final location = state.uri.path;

        final isLogin =
            location == AppRoutes.login || location == AppRoutes.adminLogin;
        final isAdminRoute = location.startsWith('/admin');
        final systemKey = _systemKeyFromLocation(location);
        final isSystemRoute = systemKey != null;

        final user = Supabase.instance.client.auth.currentUser;

        // If already authenticated, keep them out of login.
        // Route them to a sensible destination based on their access profile.
        if (isLogin && user != null) {
          final repo = ref.read(accessRepositoryProvider);
          var profile = repo.getCached(user.id);
          profile ??= await repo.load(user.id);

          if (profile != null && !profile.isActive) {
            return AppRoutes.forbidden;
          }

          final from = state.uri.queryParameters['from'];
          if (from != null && from.isNotEmpty) {
            return Uri.decodeComponent(from);
          }

          // Any active admin_users account may enter the admin shell.
          if (profile != null) {
            return AppRoutes.adminDashboard;
          }

          return AppRoutes.home;
        }

        // Protected areas: admin routes (except /admin/login) and system routes.
        final isProtected =
            (isAdminRoute && location != AppRoutes.adminLogin) || isSystemRoute;

        if (isProtected && user == null) {
          final from = Uri.encodeComponent(state.uri.toString());
          return '${AppRoutes.login}?from=$from';
        }

        if (user == null) return null;

        // Load cached profile; if missing, load once (Fail-Closed by forbidding on null)
        final repo = ref.read(accessRepositoryProvider);
        var profile = repo.getCached(user.id);
        profile ??= await repo.load(user.id);

        if (profile != null && !profile.isActive) {
          return AppRoutes.forbidden;
        }

        final isTasksAdminRoute = location == AppRoutes.adminTasks ||
            location == AppRoutes.adminTaskForm ||
            RegExp(r'^/admin/tasks/[^/]+$').hasMatch(location) ||
            RegExp(r'^/admin/tasks/[^/]+/edit$').hasMatch(location);
        final isTasksWriteRoute = location == AppRoutes.tasksNew ||
            RegExp(r'^/tasks/[^/]+/edit$').hasMatch(location);

        if (isAdminRoute && location != AppRoutes.adminLogin) {
          if (profile == null) return AppRoutes.forbidden;
          if (isTasksAdminRoute) {
            if (!profile.canManageSystem(SystemKey.tasks)) {
              return AppRoutes.forbidden;
            }
          }
        }

        if (isSystemRoute) {
          if (profile == null) return AppRoutes.forbidden;
          if (!profile.canAccessSystem(systemKey!)) {
            return AppRoutes.forbidden;
          }
        }

        if (isTasksWriteRoute) {
          if (profile == null) return AppRoutes.forbidden;
          if (!profile.canWriteSystem(SystemKey.tasks)) {
            return AppRoutes.forbidden;
          }
        }

        return null;
      },
      routes: [
        ..._buildCommonRoutes(),
        _buildPublicShellRoute(),
        ..._buildAuthRoutes(),
        _buildAdminShellRoute(ref),
        ..._buildSystemShellRoutes(),
      ],
    );
  }

  static AssistantContextSeed _buildAssistantSeed(
      Ref ref, GoRouterState state) {
    final currentUser = ref.read(currentUserProvider);
    final access = ref.read(accessCachedProvider);
    final from = state.uri.queryParameters['from'] ?? AppRoutes.adminDashboard;
    final routeContext = ChatRouteContextService.resolve(
      from,
      fallbackUnitSlug: state.uri.queryParameters['unit'] ?? 'home',
    );

    final permissions =
        _permissionsForAssistantSystem(access, routeContext.systemKey);
    final unitSlug = state.uri.queryParameters['unit'] ?? routeContext.unitSlug;
    final waqfAssetId = state.uri.queryParameters['waqf_asset_id'] ??
        state.uri.queryParameters['waqfAssetId'] ??
        state.uri.queryParameters['asset_id'] ??
        state.uri.queryParameters['assetId'] ??
        routeContext.waqfAssetId;
    final nationalAssetCode =
        state.uri.queryParameters['national_asset_code'] ??
            state.uri.queryParameters['nationalAssetCode'] ??
            state.uri.queryParameters['asset_code'] ??
            state.uri.queryParameters['assetCode'] ??
            routeContext.nationalAssetCode;

    return AssistantContextSeed(
      displayName: currentUser?.name ?? currentUser?.email ?? 'PalWakf User',
      adminUserId:
          currentUser?.id ?? Supabase.instance.client.auth.currentUser?.id,
      systemKey: routeContext.systemKey,
      systemLabel: routeContext.pageLabelAr == 'لوحة الإدارة' &&
              routeContext.systemKey == 'awqaf_system'
          ? 'نظام الأوقاف'
          : _systemLabelForAssistant(routeContext.systemKey),
      roleLabel: _roleLabelForAssistant(
          access, currentUser?.role, routeContext.systemKey),
      permissions: permissions,
      currentRoute: from,
      unitId: unitSlug,
      unitSlug: unitSlug,
      waqfAssetId: waqfAssetId,
      nationalAssetCode: nationalAssetCode,
      currentPageLabel:
          state.uri.queryParameters['pageAr'] ?? routeContext.pageLabelAr,
      lastActionLabel:
          state.uri.queryParameters['pageAr'] ?? routeContext.pageLabelAr,
      lastRoute: from,
      knowledgeScopeLabel: 'داخلي',
    );
  }

  static String _systemLabelForAssistant(String systemKey) {
    switch (systemKey) {
      case 'mustakshif':
      case 'mustakshif_alwaqf':
        return 'مستكشف الوقف';
      case 'waqf_cases_system':
        return 'نظام القضايا الوقفية';
      case 'billing_system':
        return 'نظام الفوترة';
      case 'tasks_system':
        return 'نظام المهام';
      case 'public_site':
        return 'الموقع العام';
      case 'awqaf_system':
      default:
        return 'نظام الأوقاف';
    }
  }

  static String _roleLabelForAssistant(
      AccessProfile? access, String? fallbackRole, String systemKey) {
    if (access?.isSuperuser == true) return 'superuser';
    final role = _roleForAssistantSystem(access, systemKey);
    if (role != null) return role.name;
    return (fallbackRole == null || fallbackRole.trim().isEmpty)
        ? 'viewer'
        : fallbackRole.trim();
  }

  static List<String> _permissionsForAssistantSystem(
      AccessProfile? access, String systemKey) {
    final perms = access == null
        ? const <Permission>{}
        : (access.permissions[_assistantSystemKey(systemKey)] ??
            const <Permission>{});
    return perms.map((e) => e.name).toList()..sort();
  }

  static UserRole? _roleForAssistantSystem(
      AccessProfile? access, String systemKey) {
    if (access == null) return null;
    return access.roles[_assistantSystemKey(systemKey)];
  }

  static SystemKey _assistantSystemKey(String systemKey) {
    switch (systemKey) {
      case 'mustakshif':
      case 'mustakshif_alwaqf':
        return SystemKey.mustakshif;
      case 'waqf_cases_system':
        return SystemKey.cases;
      case 'billing_system':
        return SystemKey.billing;
      case 'tasks_system':
        return SystemKey.tasks;
      case 'public_site':
        return SystemKey.site;
      case 'awqaf_system':
      default:
        return SystemKey.platformAdmin;
    }
  }

  static SystemKey? _systemKeyFromLocation(String location) {
    if (location.startsWith('/mustakshif')) return SystemKey.mustakshif;
    if (location.startsWith('/admin-data')) return SystemKey.adminData;
    if (location.startsWith('/lands')) return SystemKey.lands;
    if (location.startsWith('/properties')) return SystemKey.properties;
    if (location.startsWith('/cases')) return SystemKey.cases;
    if (location.startsWith('/tasks')) return SystemKey.tasks;
    if (location.startsWith('/mosques-system')) return SystemKey.mosques;
    if (location.startsWith('/billing')) return SystemKey.billing;
    return null;
  }
}
