import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  // Admin
  static const adminUsers = '/admin/users';
  static const adminFridaySermons = '/admin/friday-sermons';
  static const adminMosques = '/admin/mosques';
  static const adminOrgUnits = '/admin/org-units';

  // Public
  /// Root of the public website. We redirect it to the ministry unit (/home).
  static const root = '/';
  static const home = '/home';
  static const news = '/news';
  static const newsDetail = '/news/detail';
  static const announcements = '/announcements';
  static const activities = '/activities';
  static const services = '/services';
  static const eservices = '/eservices';
  static const socialServices = '/social-services';

  // Public (Features)
  static const complaints = '/complaints';
  static const nosok = '/systems/nosok';
  static const nosokHajj = '/systems/nosok/hajj';
  static const nosokUmrah = '/systems/nosok/umrah';
  static const nosokCompanies = '/systems/nosok/companies';
  static const nosokComplaints = '/systems/nosok/complaints';
  static const nosokFaq = '/systems/nosok/faq';
  static const nosokApplicationStatus = '/systems/nosok/application-status';
  static const nosokFollowUp = '/systems/nosok/follow-up';
  static const nosokApply = '/systems/nosok/apply';
  static const zakat = '/zakat';
  static const prayerTimes = '/prayer-times';
  static const quran = '/quran';
  static const chat = '/chat';

  // Legacy public aliases kept for backward compatibility after reclassifying
  // these pages as platform services rather than semi-independent systems.
  static const zakatSystem = '/zakat-system';
  static const prayerTimesSystem = '/prayer-times-system';
  static const quranSystem = '/quran-system';

  static const mosques = '/mosques';
  static const projects = '/projects';
  static const about = '/about';
  static const minister = '/minister';
  static const visionMission = '/vision-mission';
  static const structure = '/structure';
  static const formerMinisters = '/former-ministers';
  static const fridaySermon = '/friday-sermon';
  static const contact = '/contact';
  static const privacy = '/privacy';
  static const terms = '/terms';
  static const sitemap = '/sitemap';
  static const search = '/search';
  static const underConstruction = '/under-construction';
  static const notFound = '/not-found';

  /// Transition route when moving from the public website to a service system.
  /// Example: /switch/mustakshif
  static const switchSystemBase = '/switch';

  // Auth
  static const login = '/login';

  // Platform Admin
  static const adminLogin = '/admin/login';
  static const adminDashboard = '/admin/dashboard';
  static const adminWaqfLands = '/admin/waqf-lands';
  static const adminCases = '/admin/cases';
  static const adminDocuments = '/admin/documents';
  static const adminZakat = '/admin/zakat';
  static const adminPrayerTimes = '/admin/prayer-times';
  static const adminQuran = '/admin/quran';
  static const adminPublicPagesHub = '/admin/public-pages';
  static const adminAboutPage = '/admin/public-pages/about';
  static const adminMinisterPage = '/admin/public-pages/minister';
  static const adminVisionMissionPage = '/admin/public-pages/vision-mission';
  static const adminStructurePage = '/admin/public-pages/structure';
  static const adminFormerMinistersPage =
      '/admin/public-pages/former-ministers';
  static const adminServicesPage = '/admin/public-pages/services';
  static const adminEServicesPage = '/admin/public-pages/eservices';
  static const adminSocialServicesPage = '/admin/public-pages/social-services';
  static const adminProjectsPage = '/admin/public-pages/projects';
  static const adminContactPage = '/admin/public-pages/contact';
  static const adminPrivacyPage = '/admin/public-pages/privacy';
  static const adminTermsPage = '/admin/public-pages/terms';
  static const adminSitemapPage = '/admin/public-pages/sitemap';
  static const adminComplaints = '/admin/complaints';
  static const adminNosok = '/admin/systems/nosok';
  static const adminNosokSeasons = '/admin/systems/nosok/seasons';
  static const adminNosokCompanies = '/admin/systems/nosok/companies';
  static const adminNosokApplications = '/admin/systems/nosok/applications';
  static const adminNosokApplicationDetails =
      '/admin/systems/nosok/applications/:applicationId';
  static const adminNosokComplaints = '/admin/systems/nosok/complaints';
  static const adminNosokContent = '/admin/systems/nosok/content';
  static const adminNosokPrograms = '/admin/systems/nosok/programs';
  static const adminNosokReports = '/admin/systems/nosok/reports';
  static const adminNosokUnits = '/admin/systems/nosok/units';
  static const adminNosokUsersRoles = '/admin/systems/nosok/users-roles';
  static const adminNosokSidebar = '/admin/systems/nosok/sidebar';
  static const adminNosokSettings = '/admin/systems/nosok/settings';
  static const adminNosokHealth = '/admin/systems/nosok/health';

  static const adminNosokOperations = '/admin/systems/nosok/operations';
  static const adminNosokPaymentBridge = '/admin/systems/nosok/payment-bridge';
  static const adminNosokUnitQueues = '/admin/systems/nosok/unit-queues';
  static const adminNosokRoleUat = '/admin/systems/nosok/role-uat';
  static const adminNosokNotifications = '/admin/systems/nosok/notifications';
  static const adminNosokBillingAdapters =
      '/admin/systems/nosok/billing-adapters';
  static const adminNosokTrackingPrivacy =
      '/admin/systems/nosok/tracking-privacy';
  static const adminNosokReadinessEvidence =
      '/admin/systems/nosok/readiness-evidence';
  static const adminNosokApplicationLifecycle =
      '/admin/systems/nosok/application-lifecycle';
  static const adminNosokNotificationDispatch =
      '/admin/systems/nosok/notification-dispatch';

  static const adminProfile = '/admin/profile';
  static const adminMyActivity = '/admin/my-activity';
  static const adminActivities = '/admin/activities';
  static const adminSharedContent = '/admin/shared-content';
  static const adminSettings = '/admin/settings';
  static const adminDeveloper = '/admin/developer';
  static const adminReports = '/admin/reports';
  static const adminUsageGuide = '/admin/usage-guide';
  static const adminTasks = '/admin/tasks';
  static const adminTaskForm = '/admin/tasks/new';
  static String adminTaskDetails(String taskId) => '/admin/tasks/$taskId';
  static String adminTaskEdit(String taskId) => '/admin/tasks/$taskId/edit';
  static const adminHomeManagement = '/admin/home-management';
  static const adminUnitSurfacesManagement = '/admin/unit-surfaces-management';
  static const adminSystemSurfacesManagement =
      '/admin/system-surfaces-management';
  static const adminHeroSlider = '/admin/hero-slider';
  static const adminBreakingNews = '/admin/breaking-news';
  static const adminActivitiesManagement = '/admin/activities-management';

  // Assistant / Chat
  static const adminAssistant = '/admin/assistant';
  static const adminChatbot = '/admin/chatbot';

  // Systems
  static const mustakshif = '/mustakshif';
  static const adminData = '/admin-data';
  static const lands = '/lands';
  static const properties = '/properties';
  static const cases = '/cases';
  static const tasks = '/tasks';
  static const tasksNew = '/tasks/new';
  static String taskDetails(String taskId) => '/tasks/$taskId';
  static String taskEdit(String taskId) => '/tasks/$taskId/edit';
  static const mosquesSystem = '/mosques-system';
  static const billing = '/billing';

  // Guards
  static const forbidden = '/forbidden';

  /// GoRouter equivalent of "push and clear stack" (Navigator legacy).
  /// On GoRouter, `go()` replaces the stack.
  static void pushAndClearStack(BuildContext context, String location) {
    GoRouter.of(context).go(location);
  }

  /// GoRouter equivalent of "push replacement".
  static void pushReplacement(BuildContext context, String location) {
    // `replace` keeps the same shell but replaces the current location.
    GoRouter.of(context).replace(location);
  }
}
