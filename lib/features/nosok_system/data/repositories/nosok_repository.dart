import '../../domain/models/nosok_announcement.dart';
import '../../domain/models/nosok_billing_provider_adapter.dart';
import '../../domain/models/nosok_public_tracking_privacy_check.dart';
import '../../domain/models/nosok_production_readiness_evidence.dart';
import '../../domain/models/nosok_application.dart';
import '../../domain/models/nosok_application_companion.dart';
import '../../domain/models/nosok_application_document.dart';
import '../../domain/models/nosok_application_draft.dart';
import '../../domain/models/nosok_application_payment.dart';
import '../../domain/models/nosok_application_review.dart';
import '../../domain/models/nosok_application_lifecycle_transition.dart';
import '../../domain/models/nosok_citizen_followup_action.dart';
import '../../domain/models/nosok_followup_inbox_item.dart';
import '../../domain/models/nosok_notification_dispatch.dart';
import '../../domain/models/nosok_notification_provider_adapter_uat.dart';
import '../../domain/models/nosok_company.dart';
import '../../domain/models/nosok_company_season_qualification.dart';
import '../../domain/models/nosok_complaint.dart';
import '../../domain/models/nosok_dashboard_summary.dart';
import '../../domain/models/nosok_faq_item.dart';

import '../../domain/models/nosok_notification_template.dart';
import '../../domain/models/nosok_operational_item.dart';
import '../../domain/models/nosok_payment_bridge_request.dart';
import '../../domain/models/nosok_role_uat_case.dart';
import '../../domain/models/nosok_role_uat_evidence.dart';
import '../../domain/models/nosok_season.dart';
import '../../domain/models/nosok_service_program.dart';
import '../../domain/models/nosok_unit_scope.dart';
import '../../domain/models/nosok_unit_application_queue_item.dart';
import '../../domain/models/nosok_workflow_bucket.dart';
import '../../domain/models/nosok_service_desk_search_result.dart';
import '../../domain/models/nosok_season_command_gate.dart';

abstract class NosokRepository {
  Future<List<NosokSeason>> listSeasons({bool publicOnly = false});
  Future<NosokSeason> saveSeason(NosokSeason season);
  Future<void> deleteSeason(String id);

  Future<List<NosokServiceProgram>> listPrograms({
    String? seasonId,
    bool publicOnly = false,
    String? serviceType,
  });
  Future<NosokServiceProgram> saveProgram(NosokServiceProgram program);
  Future<void> deleteProgram(String id);

  Future<List<NosokCompany>> listCompanies({
    String? query,
    bool publicOnly = false,
    String? seasonId,
  });
  Future<NosokCompany> saveCompany(NosokCompany company);
  Future<void> deleteCompany(String id);

  Future<List<NosokCompanySeasonQualification>> listCompanyQualifications({
    String? companyId,
    String? seasonId,
  });
  Future<NosokCompanySeasonQualification> saveCompanyQualification(
    NosokCompanySeasonQualification qualification,
  );
  Future<void> deleteCompanyQualification(String id);

  Future<List<NosokComplaint>> listComplaints({String? query});
  Future<List<NosokApplication>> listApplications({String? query});
  Future<NosokApplication?> getApplicationById(String id);
  Future<NosokApplication> updateApplicationStatus({
    required String applicationId,
    required String applicationStatus,
    String? eligibilityStatus,
    String? reviewReason,
  });
  Future<NosokApplication> submitApplication(NosokApplicationDraft draft);
  Future<NosokApplication?> lookupApplicationByTrackingToken(
      String trackingToken);
  Future<List<NosokApplicationCompanion>> listApplicationCompanions(
      String applicationId);
  Future<List<NosokApplicationReview>> listApplicationReviews(
      String applicationId);

  Future<List<NosokApplicationLifecycleRule>> listLifecycleRules(
      {String? fromStatus});
  Future<List<NosokApplicationLifecycleTransition>>
      listApplicationLifecycleTransitions({String? applicationId});
  Future<NosokApplicationLifecycleTransition> transitionApplicationLifecycle({
    required String applicationId,
    required String transitionKey,
    String? reasonAr,
    String? noteAr,
  });
  Future<List<NosokCitizenFollowupAction>> listCitizenFollowupActions(
      String trackingToken);
  Future<NosokCitizenFollowupRequest> submitCitizenFollowupAction({
    required String trackingToken,
    required String actionKey,
    String? noteAr,
  });

  Future<List<NosokApplicationDocument>> listApplicationDocuments(
      String applicationId);
  Future<NosokApplicationDocument> saveApplicationDocument(
      NosokApplicationDocument document);
  Future<void> deleteApplicationDocument(String id);

  Future<List<NosokApplicationPayment>> listApplicationPayments(
      String applicationId);
  Future<NosokApplicationPayment> saveApplicationPayment(
      NosokApplicationPayment payment);
  Future<NosokApplicationPayment> verifyApplicationPayment({
    required String paymentId,
    required String applicationId,
    required String verificationStatus,
    String? verificationNotes,
    String? paymentStatus,
  });
  Future<void> deleteApplicationPayment(String id);

  Future<List<NosokFaqItem>> listFaqItems();
  Future<List<NosokAnnouncement>> listAnnouncements();

  Future<List<NosokUnitScope>> listUnitScopes();
  Future<NosokUnitScope?> getPublicUnitScope(String unitSlug);

  Future<NosokDashboardSummary> loadDashboardSummary();

  Future<List<NosokOperationalItem>> listOperationalReadiness();
  Future<List<NosokPaymentBridgeRequest>> listPaymentBridgeRequests();
  Future<NosokPaymentBridgeRequest> executePaymentBridgeRequest({
    required String bridgeRequestId,
    String? providerKey,
    String? paymentChannel,
    String? notes,
  });
  Future<NosokPaymentBridgeRequest> syncPaymentBridgeRequest({
    required String bridgeRequestId,
    String? providerReference,
    String? notes,
  });
  Future<NosokPaymentBridgeRequest> createPaymentBridgeRequest({
    required String applicationId,
    String? paymentId,
    double? amount,
    String currencyCode = 'ILS',
    String? paymentMethod,
    String? notes,
  });
  Future<List<NosokRoleUatCase>> listRoleUatCases();
  Future<List<NosokRoleUatEvidence>> listRoleUatEvidence(
      {String? matrixCaseId});
  Future<NosokRoleUatEvidence> saveRoleUatEvidence(
      NosokRoleUatEvidence evidence);
  Future<List<NosokUnitApplicationQueueItem>> listUnitApplicationQueue({
    String? unitId,
    String? unitSlug,
    String? status,
  });

  Future<List<NosokBillingProviderAdapter>> listBillingProviderAdapters();
  Future<NosokBillingProviderAdapter> runBillingProviderAdapterHealthCheck(
      {required String adapterId});
  Future<List<NosokPublicTrackingPrivacyCheck>>
      listPublicTrackingPrivacyChecks();
  Future<NosokPublicTrackingPrivacyCheck> savePublicTrackingPrivacyReview({
    required String checkKey,
    required String status,
    String? evidenceNote,
  });
  Future<List<NosokProductionReadinessEvidence>>
      listProductionReadinessEvidence({String? status});
  Future<NosokProductionReadinessEvidence> saveProductionReadinessEvidence(
      NosokProductionReadinessEvidence evidence);
  Future<List<NosokNotificationTemplate>> listNotificationTemplates();

  Future<List<NosokFollowupInboxItem>> listFollowupInbox(
      {String? status, String? unitId});
  Future<NosokFollowupInboxItem> updateFollowupInboxItem({
    required String followupId,
    required String status,
    String? assignedUnitId,
    String? resolutionNoteAr,
  });
  Future<List<NosokNotificationProviderAdapter>>
      listNotificationProviderAdapters();
  Future<List<NosokNotificationProviderUatResult>>
      listNotificationProviderUatResults({String? providerKey});
  Future<NosokNotificationProviderUatResult> runNotificationProviderAdapterUat({
    required String providerKey,
    required String testKey,
    String? evidenceUrl,
  });
  Future<List<NosokNotificationDispatch>> listNotificationDispatches(
      {String? status});
  Future<NosokNotificationDispatch> createNotificationDispatch({
    required String eventKey,
    required String templateKey,
    required String relatedEntityType,
    required String relatedEntityId,
    String channel = 'in_app',
    String recipientScope = 'citizen',
    String? payloadPreviewAr,
  });
  Future<NosokNotificationDispatch> markNotificationDispatch({
    required String dispatchId,
    required String status,
    String? providerReference,
    String? errorMessage,
  });

  Future<List<NosokWorkflowBucket>> listWorkflowBuckets();
  Future<List<NosokServiceDeskSearchResult>> searchServiceDesk(String query);
  Future<List<NosokServiceDeskScript>> listServiceDeskScripts(
      {String? category});
  Future<List<NosokSeasonCommandGate>> listSeasonCommandGates(
      {String? seasonId});
  Future<NosokSeasonOpenGateDecision> evaluateSeasonOpenGate(
      {String? seasonId});
}
