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
import 'nosok_repository.dart';

class NosokInMemoryRepository implements NosokRepository {
  NosokInMemoryRepository();

  final List<NosokSeason> _seasons = <NosokSeason>[
    NosokSeason(
      id: 'season-1447',
      seasonCode: 'HAJJ-1447',
      titleAr: 'موسم الحج 1447هـ / 2026م',
      serviceType: 'hajj',
      hijriYear: 1447,
      gregorianYear: 2026,
      status: 'open',
      isPubliclyVisible: true,
      notes: 'بيانات تشغيلية تجريبية للمعاينة فقط.',
    ),
  ];

  final List<NosokServiceProgram> _programs = <NosokServiceProgram>[
    const NosokServiceProgram(
      id: 'program-hajj-main',
      seasonId: 'season-1447',
      code: 'HAJJ-MAIN',
      titleAr: 'برنامج الحج الرئيسي',
      serviceType: 'hajj',
      description: 'برنامج تجريبي يعرض رحلة التقديم داخل نسك.',
      maxCompanions: 2,
      notes: 'Preview only',
      status: 'active',
      isPubliclyVisible: true,
    ),
  ];

  final List<NosokCompany> _companies = <NosokCompany>[
    const NosokCompany(
      id: 'company-001',
      companyNameAr: 'شركة نسك النموذجية للحج والعمرة',
      status: 'active',
      isPubliclyVisible: true,
      phone: '02-0000000',
      mobile: '0590000000',
      addressText: 'فلسطين',
      licenseNo: 'NSK-DEMO-001',
      currentSeasonQualificationStatus: 'qualified',
    ),
  ];

  final List<NosokCompanySeasonQualification> _qualifications =
      <NosokCompanySeasonQualification>[
    const NosokCompanySeasonQualification(
      id: 'qualification-001',
      companyId: 'company-001',
      seasonId: 'season-1447',
      qualificationStatus: 'qualified',
      isPubliclyVisible: true,
      seasonTitleAr: 'موسم الحج 1447هـ / 2026م',
      qualificationNotes: 'تأهيل تجريبي للمعاينة.',
    ),
  ];

  final List<NosokApplication> _applications = <NosokApplication>[
    NosokApplication(
      id: 'application-001',
      applicationNo: 'NSK-DEMO-000001',
      applicantFullName: 'مراجع تجريبي',
      nationalId: '000000000',
      serviceType: 'hajj',
      applicationStatus: 'submitted',
      eligibilityStatus: 'pending',
      seasonId: 'season-1447',
      programId: 'program-hajj-main',
      mobile: '0590000000',
      submittedAt: DateTime.now().subtract(const Duration(days: 1)),
      trackingToken: 'NSK-DEMO-TRACK',
      trackingTokenIssuedAt: DateTime.now().subtract(const Duration(days: 1)),
      documentsCount: 1,
      paymentsCount: 1,
      totalPaidAmount: 1500,
      lastPaymentStatus: 'under_review',
    ),
  ];

  final Map<String, List<NosokApplicationCompanion>> _companions =
      <String, List<NosokApplicationCompanion>>{};
  final Map<String, List<NosokApplicationDocument>> _documents =
      <String, List<NosokApplicationDocument>>{
    'application-001': <NosokApplicationDocument>[
      const NosokApplicationDocument(
        id: 'doc-001',
        applicationId: 'application-001',
        documentType: 'identity',
        documentTitle: 'هوية شخصية',
        reviewStatus: 'pending',
        originalFileName: 'identity-preview.pdf',
      ),
    ],
  };
  final Map<String, List<NosokApplicationPayment>> _payments =
      <String, List<NosokApplicationPayment>>{
    'application-001': <NosokApplicationPayment>[
      const NosokApplicationPayment(
        id: 'payment-001',
        applicationId: 'application-001',
        paymentType: 'registration_fee',
        amount: 1500,
        currencyCode: 'ILS',
        paymentStatus: 'pending',
        verificationStatus: 'under_review',
        paymentReference: 'DEMO-PAY-001',
      ),
    ],
  };

  final List<NosokUnitScope> _unitScopes = <NosokUnitScope>[
    const NosokUnitScope(
      unitId: 'home',
      unitSlug: 'home',
      unitNameAr: 'المركز الرئيسي',
      isEnabled: true,
      publicTitleAr: 'نسك — المركز الرئيسي',
      publicIntroAr: 'سطح تجريبي لخدمات الحج والعمرة في المركز الرئيسي.',
    ),
    const NosokUnitScope(
      unitId: 'bethlehem',
      unitSlug: 'bethlehem',
      unitNameAr: 'مديرية بيت لحم',
      isEnabled: true,
      publicTitleAr: 'نسك — مديرية بيت لحم',
      publicIntroAr: 'خدمات نسك ضمن نطاق مديرية بيت لحم.',
    ),
  ];

  final List<NosokPaymentBridgeRequest> _bridgeRequests =
      <NosokPaymentBridgeRequest>[
    const NosokPaymentBridgeRequest(
      id: 'bridge-demo-001',
      applicationId: 'application-001',
      applicationNo: 'NSK-DEMO-000001',
      paymentId: 'payment-001',
      amount: 1500,
      currencyCode: 'ILS',
      bridgeStatus: 'draft',
      paymentMethod: 'manual_receipt',
      notes: 'طلب جسر تجريبي؛ لا يرسل إلى بوابة دفع حقيقية في Preview.',
    ),
  ];

  final List<NosokRoleUatEvidence> _roleUatEvidence = <NosokRoleUatEvidence>[];

  final List<NosokBillingProviderAdapter> _billingAdapters =
      <NosokBillingProviderAdapter>[
    const NosokBillingProviderAdapter(
      id: 'adapter-billing-system-contract',
      providerKey: 'billing_system',
      titleAr: 'محرك الفوترة المركزي في PalWakf',
      adapterStatus: 'enabled',
      adapterMode: 'platform_rpc_bridge',
      supportsWebhook: true,
      requiresSignature: true,
      idempotencyPolicy: 'required',
      callbackUrlPath: '/api/billing/callbacks/nosok',
      healthStatus: 'contract_ready',
      notesAr:
          'Adapter تجريبي للمعاينة؛ التنفيذ الإنتاجي يحتاج ربط RPC الحقيقي من billing_system.',
    ),
    const NosokBillingProviderAdapter(
      id: 'adapter-manual-receipt',
      providerKey: 'manual_receipt_review',
      titleAr: 'مراجعة سندات الدفع اليدوية',
      adapterStatus: 'enabled',
      adapterMode: 'manual_verification',
      supportsWebhook: false,
      requiresSignature: false,
      idempotencyPolicy: 'required',
      healthStatus: 'passed',
      notesAr: 'مسار مؤقت لسندات الدفع إلى حين تفعيل بوابة الدفع المركزية.',
    ),
  ];

  final List<NosokPublicTrackingPrivacyCheck> _privacyChecks =
      <NosokPublicTrackingPrivacyCheck>[
    const NosokPublicTrackingPrivacyCheck(
      checkKey: 'public_tracking_allowed_fields',
      titleAr: 'حد الحقول المسموح عرضها في التتبع العام',
      status: 'needs_evidence',
      severity: 'blocker',
      publicDataFields: <String>[
        'application_no',
        'application_status',
        'eligibility_status',
        'service_type',
        'submitted_at'
      ],
      blockedFields: <String>[
        'national_id',
        'phone',
        'mobile',
        'email',
        'address_text',
        'document_urls',
        'payment_receipts'
      ],
      evidenceNoteAr:
          'يلزم Screenshot وSQL evidence لصفحة /systems/nosok/application-status.',
    ),
    const NosokPublicTrackingPrivacyCheck(
      checkKey: 'tracking_token_non_enumerable',
      titleAr: 'رمز التتبع غير قابل للتخمين ولا يعتمد على رقم الهوية',
      status: 'needs_evidence',
      severity: 'blocker',
      blockedFields: <String>['national_id_lookup', 'phone_lookup'],
      evidenceNoteAr: 'يجب إثبات أن التتبع لا يعمل عبر رقم الهوية أو الهاتف.',
    ),
  ];

  final List<NosokProductionReadinessEvidence> _readinessEvidence =
      <NosokProductionReadinessEvidence>[];

  final List<NosokApplicationLifecycleTransition> _lifecycleTransitions =
      <NosokApplicationLifecycleTransition>[
    NosokApplicationLifecycleTransition(
      id: 'transition-demo-001',
      applicationId: 'application-001',
      applicationNo: 'NSK-DEMO-000001',
      transitionKey: 'submit_to_review',
      fromStatus: 'submitted',
      toStatus: 'under_review',
      eligibilityStatus: 'needs_review',
      actorRole: 'nosokApplicationsReviewer',
      reasonAr: 'تحويل تجريبي للمراجعة.',
      createdAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),
  ];

  final List<NosokCitizenFollowupRequest> _followupRequests =
      <NosokCitizenFollowupRequest>[];

  final List<NosokNotificationProviderAdapter> _notificationProviderAdapters =
      <NosokNotificationProviderAdapter>[
    NosokNotificationProviderAdapter(
      id: 'notification-provider-in-app',
      providerKey: 'platform_in_app',
      titleAr: 'إشعارات المنصة الداخلية',
      channel: 'in_app',
      adapterMode: 'platform_notification_bridge',
      healthStatus: 'contract_ready',
      requiresSignature: false,
      callbackPath: '/internal/notifications/nosok',
      lastCheckedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      notesAr: 'Adapter معاينة يثبت أن نسك لا يبني محرك إشعارات مستقلًا.',
    ),
    const NosokNotificationProviderAdapter(
      id: 'notification-provider-sms',
      providerKey: 'platform_sms_gateway',
      titleAr: 'بوابة الرسائل القصيرة المركزية',
      channel: 'sms',
      adapterMode: 'platform_provider_contract',
      healthStatus: 'needs_provider_binding',
      requiresSignature: true,
      callbackPath: '/api/notifications/callbacks/nosok',
      notesAr: 'يتطلب اعتماد مزود الرسائل المركزي وسياسة عدم كشف نصوص حساسة.',
    ),
  ];

  final List<NosokNotificationProviderUatResult>
      _notificationProviderUatResults = <NosokNotificationProviderUatResult>[
    NosokNotificationProviderUatResult(
      id: 'notification-uat-demo-001',
      providerKey: 'platform_in_app',
      channel: 'in_app',
      testKey: 'queue_to_dispatch_contract',
      status: 'passed',
      expectedAr: 'إنشاء سجل dispatch بدون إرسال خارجي مستقل من نسك.',
      actualAr:
          'تم إنشاء سجل معاينة داخل طابور نسك بانتظار جسر إشعارات المنصة.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
    ),
  ];

  final List<NosokNotificationDispatch> _dispatches =
      <NosokNotificationDispatch>[
    NosokNotificationDispatch(
      id: 'dispatch-demo-001',
      eventKey: 'application_submitted',
      templateKey: 'application_submitted',
      channel: 'in_app',
      recipientScope: 'citizen',
      relatedEntityType: 'nosok_application',
      relatedEntityId: 'application-001',
      status: 'queued',
      payloadPreviewAr: 'تم استلام طلبك التجريبي. احتفظ برمز التتبع.',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  @override
  Future<List<NosokSeason>> listSeasons({bool publicOnly = false}) async {
    return _seasons
        .where((item) => !publicOnly || item.isPubliclyVisible)
        .toList();
  }

  @override
  Future<NosokSeason> saveSeason(NosokSeason season) async {
    final saved =
        season.id.trim().isEmpty ? season.copyWith(id: _id('season')) : season;
    _replace(_seasons, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<void> deleteSeason(String id) async =>
      _seasons.removeWhere((item) => item.id == id);

  @override
  Future<List<NosokServiceProgram>> listPrograms(
      {String? seasonId, bool publicOnly = false, String? serviceType}) async {
    return _programs.where((item) {
      if (publicOnly && !item.isPubliclyVisible) return false;
      if (_hasValue(seasonId) && item.seasonId != seasonId) return false;
      if (_hasValue(serviceType) && item.serviceType != serviceType)
        return false;
      return true;
    }).toList();
  }

  @override
  Future<NosokServiceProgram> saveProgram(NosokServiceProgram program) async {
    final saved = program.id.trim().isEmpty
        ? program.copyWith(id: _id('program'))
        : program;
    _replace(_programs, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<void> deleteProgram(String id) async =>
      _programs.removeWhere((item) => item.id == id);

  @override
  Future<List<NosokCompany>> listCompanies(
      {String? query, bool publicOnly = false, String? seasonId}) async {
    final qualifiedCompanyIds = _hasValue(seasonId)
        ? _qualifications
            .where(
                (item) => item.seasonId == seasonId && item.isPubliclyVisible)
            .map((item) => item.companyId)
            .toSet()
        : null;
    return _companies.where((item) {
      if (publicOnly && !item.isPubliclyVisible) return false;
      if (qualifiedCompanyIds != null && !qualifiedCompanyIds.contains(item.id))
        return false;
      if (_hasValue(query)) {
        final q = query!.trim();
        return item.companyNameAr.contains(q) ||
            (item.licenseNo ?? '').contains(q) ||
            (item.addressText ?? '').contains(q);
      }
      return true;
    }).toList();
  }

  @override
  Future<NosokCompany> saveCompany(NosokCompany company) async {
    final id = company.id.trim().isEmpty ? _id('company') : company.id;
    final saved = NosokCompany(
      id: id,
      companyNameAr: company.companyNameAr,
      companyNameEn: company.companyNameEn,
      status: company.status,
      isPubliclyVisible: company.isPubliclyVisible,
      phone: company.phone,
      mobile: company.mobile,
      email: company.email,
      addressText: company.addressText,
      licenseNo: company.licenseNo,
      governorateId: company.governorateId,
      unitId: company.unitId,
      notes: company.notes,
      currentSeasonQualificationStatus:
          company.currentSeasonQualificationStatus,
    );
    _replace(_companies, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<void> deleteCompany(String id) async =>
      _companies.removeWhere((item) => item.id == id);

  @override
  Future<List<NosokCompanySeasonQualification>> listCompanyQualifications(
      {String? companyId, String? seasonId}) async {
    return _qualifications.where((item) {
      if (_hasValue(companyId) && item.companyId != companyId) return false;
      if (_hasValue(seasonId) && item.seasonId != seasonId) return false;
      return true;
    }).toList();
  }

  @override
  Future<NosokCompanySeasonQualification> saveCompanyQualification(
      NosokCompanySeasonQualification qualification) async {
    final saved = qualification.id.trim().isEmpty
        ? NosokCompanySeasonQualification(
            id: _id('qualification'),
            companyId: qualification.companyId,
            seasonId: qualification.seasonId,
            qualificationStatus: qualification.qualificationStatus,
            isPubliclyVisible: qualification.isPubliclyVisible,
            seasonTitleAr: qualification.seasonTitleAr,
            qualificationNotes: qualification.qualificationNotes,
            startsAt: qualification.startsAt,
            endsAt: qualification.endsAt,
          )
        : qualification;
    _replace(_qualifications, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<void> deleteCompanyQualification(String id) async =>
      _qualifications.removeWhere((item) => item.id == id);

  @override
  Future<List<NosokComplaint>> listComplaints({String? query}) async {
    return const <NosokComplaint>[
      NosokComplaint(
          id: 'complaint-001',
          complaintNo: 'NSK-CMP-DEMO-001',
          subject: 'استفسار عن التسجيل',
          complainantName: 'مراجع تجريبي',
          status: 'received',
          priority: 'normal'),
    ];
  }

  @override
  Future<List<NosokApplication>> listApplications({String? query}) async {
    final normalizedQuery = query?.trim();
    if (normalizedQuery == null || normalizedQuery.isEmpty) {
      return _applications.toList();
    }
    return _applications
        .where(
          (item) =>
              item.applicantFullName.contains(normalizedQuery) ||
              item.applicationNo.contains(normalizedQuery),
        )
        .toList();
  }

  @override
  Future<NosokApplication?> getApplicationById(String id) async {
    final matches = _applications.where((item) => item.id == id);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<NosokApplication> updateApplicationStatus(
      {required String applicationId,
      required String applicationStatus,
      String? eligibilityStatus,
      String? reviewReason}) async {
    final current = await getApplicationById(applicationId);
    if (current == null)
      throw StateError('الطلب غير موجود في مستودع المعاينة.');
    final updated = NosokApplication(
      id: current.id,
      applicationNo: current.applicationNo,
      applicantFullName: current.applicantFullName,
      nationalId: current.nationalId,
      serviceType: current.serviceType,
      applicationStatus: applicationStatus,
      seasonId: current.seasonId,
      programId: current.programId,
      mobile: current.mobile,
      phone: current.phone,
      email: current.email,
      submittedAt: current.submittedAt,
      trackingToken: current.trackingToken,
      eligibilityStatus: eligibilityStatus ?? current.eligibilityStatus,
      seasonTitleAr: current.seasonTitleAr,
      programTitleAr: current.programTitleAr,
      reviewedAt: DateTime.now(),
      trackingTokenIssuedAt: current.trackingTokenIssuedAt,
      documentsCount: current.documentsCount,
      paymentsCount: current.paymentsCount,
      totalPaidAmount: current.totalPaidAmount,
      lastPaymentStatus: current.lastPaymentStatus,
    );
    _replace(_applications, updated, (item) => item.id == updated.id);
    return updated;
  }

  @override
  Future<NosokApplication> submitApplication(
      NosokApplicationDraft draft) async {
    final count = _applications.length + 1;
    final id = _id('application');
    final application = NosokApplication(
      id: id,
      applicationNo: 'NSK-DEMO-${count.toString().padLeft(6, '0')}',
      applicantFullName: draft.applicantFullName,
      nationalId: draft.nationalId,
      serviceType: draft.serviceType,
      applicationStatus: 'submitted',
      seasonId: draft.seasonId,
      programId: draft.programId,
      mobile: draft.mobile,
      phone: draft.phone,
      email: draft.email,
      submittedAt: DateTime.now(),
      trackingToken: 'NSK-DEMO-${DateTime.now().millisecondsSinceEpoch}',
      trackingTokenIssuedAt: DateTime.now(),
      eligibilityStatus: 'pending',
      documentsCount: draft.documents.length,
      paymentsCount: draft.payments.length,
      totalPaidAmount:
          draft.payments.fold<double>(0, (sum, item) => sum + item.amount),
      lastPaymentStatus:
          draft.payments.isEmpty ? null : draft.payments.last.paymentStatus,
    );
    _applications.add(application);
    _companions[id] = draft.companions;
    _documents[id] = draft.documents
        .map((doc) => doc.copyWith(id: _id('doc'), applicationId: id))
        .toList();
    _payments[id] = draft.payments
        .map((payment) => payment.copyWith(id: _id('pay'), applicationId: id))
        .toList();
    return application;
  }

  @override
  Future<NosokApplication?> lookupApplicationByTrackingToken(
      String trackingToken) async {
    final matches = _applications
        .where((item) => item.trackingToken == trackingToken.trim());
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<List<NosokApplicationCompanion>> listApplicationCompanions(
          String applicationId) async =>
      _companions[applicationId] ?? const <NosokApplicationCompanion>[];

  @override
  Future<List<NosokApplicationReview>> listApplicationReviews(
      String applicationId) async {
    return <NosokApplicationReview>[
      NosokApplicationReview(
          id: 'review-$applicationId',
          applicationId: applicationId,
          reviewAction: 'created',
          reviewReason: 'سجل تجريبي للمعاينة.',
          createdAt: DateTime.now().subtract(const Duration(hours: 12))),
    ];
  }

  @override
  Future<List<NosokApplicationDocument>> listApplicationDocuments(
          String applicationId) async =>
      _documents[applicationId] ?? const <NosokApplicationDocument>[];

  @override
  Future<NosokApplicationDocument> saveApplicationDocument(
      NosokApplicationDocument document) async {
    final list = _documents.putIfAbsent(
        document.applicationId, () => <NosokApplicationDocument>[]);
    final saved = document.id.trim().isEmpty
        ? document.copyWith(id: _id('doc'))
        : document;
    _replace(list, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<void> deleteApplicationDocument(String id) async {
    for (final list in _documents.values) {
      list.removeWhere((item) => item.id == id);
    }
  }

  @override
  Future<List<NosokApplicationPayment>> listApplicationPayments(
          String applicationId) async =>
      _payments[applicationId] ?? const <NosokApplicationPayment>[];

  @override
  Future<NosokApplicationPayment> saveApplicationPayment(
      NosokApplicationPayment payment) async {
    final list = _payments.putIfAbsent(
        payment.applicationId, () => <NosokApplicationPayment>[]);
    final saved =
        payment.id.trim().isEmpty ? payment.copyWith(id: _id('pay')) : payment;
    _replace(list, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<NosokApplicationPayment> verifyApplicationPayment(
      {required String paymentId,
      required String applicationId,
      required String verificationStatus,
      String? verificationNotes,
      String? paymentStatus}) async {
    final list = _payments[applicationId] ?? <NosokApplicationPayment>[];
    final current = list.where((item) => item.id == paymentId).firstOrNull;
    if (current == null)
      throw StateError('الدفعة غير موجودة في مستودع المعاينة.');
    final updated = current.copyWith(
      verificationStatus: verificationStatus,
      paymentStatus: paymentStatus ?? current.paymentStatus,
      verificationNotes: verificationNotes,
      verifiedAt: DateTime.now(),
    );
    _replace(list, updated, (item) => item.id == updated.id);
    return updated;
  }

  @override
  Future<void> deleteApplicationPayment(String id) async {
    for (final list in _payments.values) {
      list.removeWhere((item) => item.id == id);
    }
  }

  @override
  Future<List<NosokApplicationLifecycleRule>> listLifecycleRules(
      {String? fromStatus}) async {
    final rules = const <NosokApplicationLifecycleRule>[
      NosokApplicationLifecycleRule(
        transitionKey: 'submit_to_review',
        titleAr: 'تحويل للمراجعة',
        fromStatus: 'submitted',
        toStatus: 'under_review',
        descriptionAr: 'ينقل الطلب من مقدم إلى قيد المراجعة.',
        requiredPermission: 'reviewNosokApplications',
      ),
      NosokApplicationLifecycleRule(
        transitionKey: 'request_completion',
        titleAr: 'طلب استكمال من المواطن',
        fromStatus: 'under_review',
        toStatus: 'needs_completion',
        descriptionAr: 'يفتح إجراءات متابعة للمواطن دون كشف بيانات حساسة.',
        requiredPermission: 'reviewNosokApplications',
        requiresReason: true,
      ),
      NosokApplicationLifecycleRule(
        transitionKey: 'approve_application',
        titleAr: 'اعتماد الطلب',
        fromStatus: 'under_review',
        toStatus: 'accepted',
        descriptionAr: 'اعتماد أولي بعد اكتمال الوثائق والدفعات.',
        requiredPermission: 'approveNosokApplications',
        requiresReason: true,
      ),
      NosokApplicationLifecycleRule(
        transitionKey: 'reject_application',
        titleAr: 'رفض الطلب',
        fromStatus: 'under_review',
        toStatus: 'rejected',
        descriptionAr: 'رفض محكوم بسبب موثق.',
        requiredPermission: 'approveNosokApplications',
        requiresReason: true,
      ),
      NosokApplicationLifecycleRule(
        transitionKey: 'close_application',
        titleAr: 'إغلاق الطلب',
        fromStatus: 'accepted',
        toStatus: 'closed',
        descriptionAr: 'إغلاق إداري بعد اكتمال الإجراءات.',
        requiredPermission: 'manageNosokApplications',
      ),
    ];
    if (!_hasValue(fromStatus)) return rules;
    return rules
        .where((rule) => rule.fromStatus == fromStatus!.trim())
        .toList();
  }

  @override
  Future<List<NosokApplicationLifecycleTransition>>
      listApplicationLifecycleTransitions({String? applicationId}) async {
    return _lifecycleTransitions
        .where((item) {
          if (_hasValue(applicationId) && item.applicationId != applicationId)
            return false;
          return true;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<NosokApplicationLifecycleTransition> transitionApplicationLifecycle({
    required String applicationId,
    required String transitionKey,
    String? reasonAr,
    String? noteAr,
  }) async {
    final applicationIndex =
        _applications.indexWhere((item) => item.id == applicationId);
    if (applicationIndex == -1) {
      throw StateError('الطلب غير موجود.');
    }
    final application = _applications[applicationIndex];
    final rules =
        await listLifecycleRules(fromStatus: application.applicationStatus);
    final rule =
        rules.where((item) => item.transitionKey == transitionKey).firstOrNull;
    if (rule == null || !rule.isEnabled) {
      return NosokApplicationLifecycleTransition(
        id: _id('blocked-transition'),
        applicationId: applicationId,
        applicationNo: application.applicationNo,
        transitionKey: transitionKey,
        fromStatus: application.applicationStatus,
        toStatus: application.applicationStatus,
        isAllowed: false,
        blockerReasonAr: 'هذا الانتقال غير مسموح من الحالة الحالية.',
        createdAt: DateTime.now(),
      );
    }
    final updated = NosokApplication(
      id: application.id,
      applicationNo: application.applicationNo,
      applicantFullName: application.applicantFullName,
      nationalId: application.nationalId,
      serviceType: application.serviceType,
      applicationStatus: rule.toStatus,
      seasonId: application.seasonId,
      programId: application.programId,
      mobile: application.mobile,
      phone: application.phone,
      email: application.email,
      submittedAt: application.submittedAt,
      trackingToken: application.trackingToken,
      eligibilityStatus: rule.toStatus == 'accepted'
          ? 'eligible'
          : rule.toStatus == 'rejected'
              ? 'ineligible'
              : application.eligibilityStatus,
      seasonTitleAr: application.seasonTitleAr,
      programTitleAr: application.programTitleAr,
      reviewedAt: DateTime.now(),
      trackingTokenIssuedAt: application.trackingTokenIssuedAt,
      documentsCount: application.documentsCount,
      paymentsCount: application.paymentsCount,
      totalPaidAmount: application.totalPaidAmount,
      lastPaymentStatus: application.lastPaymentStatus,
    );
    _applications[applicationIndex] = updated;
    final transition = NosokApplicationLifecycleTransition(
      id: _id('transition'),
      applicationId: applicationId,
      applicationNo: application.applicationNo,
      transitionKey: transitionKey,
      fromStatus: application.applicationStatus,
      toStatus: rule.toStatus,
      eligibilityStatus: updated.eligibilityStatus,
      actorRole: 'preview-admin',
      reasonAr: reasonAr,
      noteAr: noteAr,
      createdAt: DateTime.now(),
    );
    _lifecycleTransitions.add(transition);
    await createNotificationDispatch(
      eventKey: transitionKey,
      templateKey: transitionKey == 'request_completion'
          ? 'application_requires_followup'
          : 'application_status_changed',
      relatedEntityType: 'nosok_application',
      relatedEntityId: applicationId,
      payloadPreviewAr:
          'تم تحديث حالة الطلب ${application.applicationNo} إلى ${rule.toStatus}.',
    );
    return transition;
  }

  @override
  Future<List<NosokCitizenFollowupAction>> listCitizenFollowupActions(
      String trackingToken) async {
    final application = _applications
        .where((item) => item.trackingToken == trackingToken.trim())
        .firstOrNull;
    if (application == null) return const <NosokCitizenFollowupAction>[];
    return <NosokCitizenFollowupAction>[
      NosokCitizenFollowupAction(
        actionKey: 'add_note',
        titleAr: 'إضافة ملاحظة للطلب',
        descriptionAr:
            'إرسال ملاحظة مختصرة لموظف نسك دون تعديل البيانات الحساسة.',
        actionType: 'request',
        requiresNote: true,
        enabled: true,
        displayOrder: 10,
      ),
      NosokCitizenFollowupAction(
        actionKey: 'request_contact_update',
        titleAr: 'طلب تحديث بيانات التواصل',
        descriptionAr: 'طلب إداري لتحديث وسيلة التواصل بعد تحقق الموظف.',
        actionType: 'request',
        requiresNote: true,
        enabled: application.applicationStatus != 'closed',
        status:
            application.applicationStatus == 'closed' ? 'closed' : 'available',
        displayOrder: 20,
      ),
      NosokCitizenFollowupAction(
        actionKey: 'submit_objection',
        titleAr: 'تقديم اعتراض/مراجعة',
        descriptionAr:
            'يظهر عند الرفض أو الحاجة للاستكمال، ويذهب لطابور متابعة إداري.',
        actionType: 'request',
        requiresNote: true,
        enabled: application.applicationStatus == 'rejected' ||
            application.applicationStatus == 'needs_completion',
        status: application.applicationStatus == 'rejected' ||
                application.applicationStatus == 'needs_completion'
            ? 'available'
            : 'not_available_for_status',
        displayOrder: 30,
      ),
    ];
  }

  @override
  Future<NosokCitizenFollowupRequest> submitCitizenFollowupAction({
    required String trackingToken,
    required String actionKey,
    String? noteAr,
  }) async {
    final application = _applications
        .where((item) => item.trackingToken == trackingToken.trim())
        .firstOrNull;
    if (application == null) {
      throw StateError('رمز التتبع غير صحيح.');
    }
    final actions = await listCitizenFollowupActions(trackingToken);
    final action = actions
        .where((item) => item.actionKey == actionKey && item.enabled)
        .firstOrNull;
    if (action == null) {
      throw StateError('الإجراء غير متاح لهذه الحالة.');
    }
    final request = NosokCitizenFollowupRequest(
      id: _id('followup'),
      applicationNo: application.applicationNo,
      actionKey: actionKey,
      status: 'submitted',
      noteAr: noteAr,
      createdAt: DateTime.now(),
    );
    _followupRequests.add(request);
    await createNotificationDispatch(
      eventKey: 'citizen_followup_submitted',
      templateKey: 'citizen_followup_submitted',
      relatedEntityType: 'nosok_application',
      relatedEntityId: application.id,
      recipientScope: 'admin',
      payloadPreviewAr:
          'وصل إجراء متابعة من المواطن على الطلب ${application.applicationNo}.',
    );
    return request;
  }

  @override
  Future<List<NosokFaqItem>> listFaqItems() async {
    return const <NosokFaqItem>[
      NosokFaqItem(
          id: 'faq-001',
          questionAr: 'هل هذه البيانات إنتاجية؟',
          answerAr: 'لا، هذه بيانات معاينة standalone فقط.',
          displayOrder: 1,
          isPublished: true),
      NosokFaqItem(
          id: 'faq-002',
          questionAr: 'من يملك الصلاحيات؟',
          answerAr:
              'في الدمج الحقيقي، PalWakf AccessProfile/RBAC هو المصدر الحاكم.',
          displayOrder: 2,
          isPublished: true),
    ];
  }

  @override
  Future<List<NosokAnnouncement>> listAnnouncements() async {
    return const <NosokAnnouncement>[
      NosokAnnouncement(
          id: 'ann-001',
          titleAr: 'نسك قيد التطوير تحت PalWakf',
          bodyAr: 'هذه واجهة تشغيل تجريبية للنظام شبه المستقل.',
          priority: 1,
          isPublished: true),
    ];
  }

  @override
  Future<List<NosokUnitScope>> listUnitScopes() async => _unitScopes;

  @override
  Future<NosokUnitScope?> getPublicUnitScope(String unitSlug) async {
    final matches = _unitScopes
        .where((item) => item.unitSlug == unitSlug && item.isEnabled);
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<List<NosokOperationalItem>> listOperationalReadiness() async {
    return <NosokOperationalItem>[
      const NosokOperationalItem(
        key: 'application_queue',
        titleAr: 'طابور الطلبات قابل للتشغيل',
        status: 'passed_preview',
        severity: 'info',
        detailsAr: 'المعاينة تعرض الطلبات والوثائق والدفعات وتفاصيل الطلب.',
        source: 'in_memory_preview',
      ),
      const NosokOperationalItem(
        key: 'billing_bridge',
        titleAr: 'جسر الدفع المركزي جاهز كعقد تكامل',
        status: 'contract_ready',
        severity: 'warning',
        detailsAr: 'التنفيذ الإنتاجي يحتاج ربط billing_system من منصة PalWakf.',
        source: 'v11_contract',
      ),
      const NosokOperationalItem(
        key: 'role_uat',
        titleAr: 'مصفوفة Role UAT جاهزة',
        status: 'pending_browser_evidence',
        severity: 'warning',
        detailsAr:
            'يلزم اختبار superuser ومستخدم محدود ومستخدم وحدة قبل الإنتاج.',
        source: 'v11_contract',
      ),
    ];
  }

  @override
  Future<List<NosokPaymentBridgeRequest>> listPaymentBridgeRequests() async {
    return List<NosokPaymentBridgeRequest>.unmodifiable(
        _bridgeRequests.reversed);
  }

  @override
  Future<NosokPaymentBridgeRequest> createPaymentBridgeRequest({
    required String applicationId,
    String? paymentId,
    double? amount,
    String currencyCode = 'ILS',
    String? paymentMethod,
    String? notes,
  }) async {
    final created = NosokPaymentBridgeRequest(
      id: _id('bridge'),
      applicationId: applicationId,
      applicationNo: _applications
          .where((item) => item.id == applicationId)
          .firstOrNull
          ?.applicationNo,
      paymentId: paymentId,
      amount: amount,
      currencyCode: currencyCode,
      bridgeStatus: 'draft',
      paymentMethod: paymentMethod,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _bridgeRequests.add(created);
    return created;
  }

  @override
  Future<NosokPaymentBridgeRequest> executePaymentBridgeRequest({
    required String bridgeRequestId,
    String? providerKey,
    String? paymentChannel,
    String? notes,
  }) async {
    final current =
        _bridgeRequests.where((item) => item.id == bridgeRequestId).firstOrNull;
    if (current == null)
      throw StateError('طلب جسر الدفع غير موجود في المعاينة.');
    final updated = NosokPaymentBridgeRequest(
      id: current.id,
      applicationId: current.applicationId,
      applicationNo: current.applicationNo,
      paymentId: current.paymentId,
      amount: current.amount,
      currencyCode: current.currencyCode,
      bridgeStatus: 'sent_to_billing',
      billingReference: 'BILL-DEMO-${DateTime.now().millisecondsSinceEpoch}',
      providerReference: current.providerReference,
      paymentMethod: paymentChannel ?? current.paymentMethod,
      notes: [
        current.notes,
        notes,
        'provider=${providerKey ?? 'billing_system'}'
      ].where((item) => (item ?? '').trim().isNotEmpty).join(' | '),
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );
    _replace(_bridgeRequests, updated, (item) => item.id == updated.id);
    return updated;
  }

  @override
  Future<NosokPaymentBridgeRequest> syncPaymentBridgeRequest({
    required String bridgeRequestId,
    String? providerReference,
    String? notes,
  }) async {
    final current =
        _bridgeRequests.where((item) => item.id == bridgeRequestId).firstOrNull;
    if (current == null)
      throw StateError('طلب جسر الدفع غير موجود في المعاينة.');
    final updated = NosokPaymentBridgeRequest(
      id: current.id,
      applicationId: current.applicationId,
      applicationNo: current.applicationNo,
      paymentId: current.paymentId,
      amount: current.amount,
      currencyCode: current.currencyCode,
      bridgeStatus: 'billing_synced',
      billingReference: current.billingReference ??
          'BILL-DEMO-${DateTime.now().millisecondsSinceEpoch}',
      providerReference: providerReference ??
          current.providerReference ??
          'PROVIDER-DEMO-SYNC',
      paymentMethod: current.paymentMethod,
      notes: [current.notes, notes, 'synced_preview']
          .where((item) => (item ?? '').trim().isNotEmpty)
          .join(' | '),
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );
    _replace(_bridgeRequests, updated, (item) => item.id == updated.id);
    return updated;
  }

  @override
  Future<List<NosokRoleUatCase>> listRoleUatCases() async {
    return const <NosokRoleUatCase>[
      NosokRoleUatCase(
          id: 'uat-superuser-dashboard',
          roleKey: 'superuser',
          surfaceKey: 'admin_dashboard',
          expectedAccess: 'allow',
          status: 'pending'),
      NosokRoleUatCase(
          id: 'uat-viewer-payments',
          roleKey: 'nosokViewer',
          surfaceKey: 'payment_bridge',
          expectedAccess: 'deny',
          status: 'pending'),
      NosokRoleUatCase(
          id: 'uat-payments-officer',
          roleKey: 'nosokPaymentsOfficer',
          surfaceKey: 'payment_bridge',
          expectedAccess: 'allow_limited',
          status: 'pending'),
      NosokRoleUatCase(
          id: 'uat-unit-officer',
          roleKey: 'nosokUnitOfficer',
          surfaceKey: 'unit_scoped_applications',
          expectedAccess: 'allow_scoped',
          status: 'pending'),
    ];
  }

  @override
  Future<List<NosokRoleUatEvidence>> listRoleUatEvidence(
      {String? matrixCaseId}) async {
    return _roleUatEvidence
        .where((item) {
          if (_hasValue(matrixCaseId) && item.matrixCaseId != matrixCaseId)
            return false;
          return true;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<NosokRoleUatEvidence> saveRoleUatEvidence(
      NosokRoleUatEvidence evidence) async {
    final saved = evidence.id.trim().isEmpty
        ? NosokRoleUatEvidence(
            id: _id('role-uat-evidence'),
            matrixCaseId: evidence.matrixCaseId,
            roleKey: evidence.roleKey,
            surfaceKey: evidence.surfaceKey,
            expectedAccess: evidence.expectedAccess,
            actualAccess: evidence.actualAccess,
            resultStatus: evidence.resultStatus,
            testedBy: evidence.testedBy,
            evidenceUrl: evidence.evidenceUrl,
            notesAr: evidence.notesAr,
            testedAt: DateTime.now(),
          )
        : evidence;
    _replace(_roleUatEvidence, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<List<NosokUnitApplicationQueueItem>> listUnitApplicationQueue(
      {String? unitId, String? unitSlug, String? status}) async {
    final allowedUnitIds = _hasValue(unitId) ? {unitId!.trim()} : <String>{};
    final allowedSlugs = _hasValue(unitSlug) ? {unitSlug!.trim()} : <String>{};
    return _applications.where((application) {
      if (_hasValue(status) && application.applicationStatus != status)
        return false;
      final appUnitId =
          application.seasonId == 'season-1447' ? 'home' : 'unknown';
      final appUnitSlug = appUnitId;
      if (allowedUnitIds.isNotEmpty && !allowedUnitIds.contains(appUnitId))
        return false;
      if (allowedSlugs.isNotEmpty && !allowedSlugs.contains(appUnitSlug))
        return false;
      return true;
    }).map((application) {
      final docs =
          _documents[application.id] ?? const <NosokApplicationDocument>[];
      final pays =
          _payments[application.id] ?? const <NosokApplicationPayment>[];
      return NosokUnitApplicationQueueItem(
        id: application.id,
        applicationNo: application.applicationNo,
        applicantFullName: application.applicantFullName,
        serviceType: application.serviceType,
        applicationStatus: application.applicationStatus,
        eligibilityStatus: application.eligibilityStatus,
        unitId: 'home',
        unitSlug: 'home',
        unitNameAr: 'المركز الرئيسي',
        seasonTitleAr: application.seasonTitleAr ?? 'موسم الحج 1447هـ / 2026م',
        programTitleAr: application.programTitleAr ?? 'برنامج الحج الرئيسي',
        mobile: application.mobile,
        submittedAt: application.submittedAt,
        documentsCount: docs.length,
        pendingDocumentsCount:
            docs.where((item) => item.reviewStatus == 'pending').length,
        rejectedDocumentsCount:
            docs.where((item) => item.reviewStatus == 'rejected').length,
        paymentsCount: pays.length,
        totalPaidAmount: pays.fold<double>(0, (sum, item) => sum + item.amount),
        pendingPaymentsCount: pays
            .where((item) =>
                item.verificationStatus == 'pending' ||
                item.verificationStatus == 'under_review')
            .length,
        verifiedPaymentsCount:
            pays.where((item) => item.verificationStatus == 'verified').length,
        needsAction: docs.any((item) => item.reviewStatus == 'rejected') ||
            pays.any((item) => item.verificationStatus == 'rejected'),
      );
    }).toList();
  }

  @override
  Future<List<NosokBillingProviderAdapter>>
      listBillingProviderAdapters() async {
    return List<NosokBillingProviderAdapter>.unmodifiable(_billingAdapters);
  }

  @override
  Future<NosokBillingProviderAdapter> runBillingProviderAdapterHealthCheck(
      {required String adapterId}) async {
    final current =
        _billingAdapters.where((item) => item.id == adapterId).firstOrNull;
    if (current == null)
      throw StateError('Adapter الدفع غير موجود في المعاينة.');
    final updated = NosokBillingProviderAdapter(
      id: current.id,
      providerKey: current.providerKey,
      titleAr: current.titleAr,
      adapterStatus: current.adapterStatus,
      adapterMode: current.adapterMode,
      supportsWebhook: current.supportsWebhook,
      requiresSignature: current.requiresSignature,
      idempotencyPolicy: current.idempotencyPolicy,
      callbackUrlPath: current.callbackUrlPath,
      healthStatus: current.isHardened ? 'passed' : 'needs_hardening',
      lastHealthAt: DateTime.now(),
      notesAr: current.notesAr,
      createdAt: current.createdAt,
      updatedAt: DateTime.now(),
    );
    _replace(_billingAdapters, updated, (item) => item.id == updated.id);
    return updated;
  }

  @override
  Future<List<NosokPublicTrackingPrivacyCheck>>
      listPublicTrackingPrivacyChecks() async {
    return List<NosokPublicTrackingPrivacyCheck>.unmodifiable(_privacyChecks);
  }

  @override
  Future<NosokPublicTrackingPrivacyCheck> savePublicTrackingPrivacyReview({
    required String checkKey,
    required String status,
    String? evidenceNote,
  }) async {
    final current =
        _privacyChecks.where((item) => item.checkKey == checkKey).firstOrNull;
    if (current == null)
      throw StateError('فحص الخصوصية غير موجود في المعاينة.');
    final updated = NosokPublicTrackingPrivacyCheck(
      checkKey: current.checkKey,
      titleAr: current.titleAr,
      status: status,
      severity: current.severity,
      publicDataFields: current.publicDataFields,
      blockedFields: current.blockedFields,
      evidenceNoteAr: evidenceNote ?? current.evidenceNoteAr,
      lastReviewedAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _replace(
        _privacyChecks, updated, (item) => item.checkKey == updated.checkKey);
    return updated;
  }

  @override
  Future<List<NosokProductionReadinessEvidence>>
      listProductionReadinessEvidence({String? status}) async {
    return _readinessEvidence
        .where((item) {
          if (_hasValue(status) && item.status != status) return false;
          return true;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<NosokProductionReadinessEvidence> saveProductionReadinessEvidence(
      NosokProductionReadinessEvidence evidence) async {
    final saved = evidence.id.trim().isEmpty
        ? NosokProductionReadinessEvidence(
            id: _id('readiness-evidence'),
            evidenceKey: evidence.evidenceKey,
            evidenceType: evidence.evidenceType,
            status: evidence.status,
            evidenceUrl: evidence.evidenceUrl,
            evidenceSummaryAr: evidence.evidenceSummaryAr,
            ownerRole: evidence.ownerRole,
            collectedAt: evidence.collectedAt ?? DateTime.now(),
            approvedAt: evidence.approvedAt,
            notesAr: evidence.notesAr,
          )
        : evidence;
    _replace(_readinessEvidence, saved, (item) => item.id == saved.id);
    return saved;
  }

  @override
  Future<List<NosokNotificationTemplate>> listNotificationTemplates() async {
    return const <NosokNotificationTemplate>[
      NosokNotificationTemplate(
          id: 'tpl-submit',
          templateKey: 'application_submitted',
          channel: 'in_app',
          titleAr: 'تم استلام طلبك',
          bodyAr: 'تم استلام طلب نسك الخاص بك. احتفظ برمز التتبع.',
          triggerEvent: 'submit'),
      NosokNotificationTemplate(
          id: 'tpl-payment',
          templateKey: 'payment_verified',
          channel: 'in_app',
          titleAr: 'تم اعتماد الدفعة',
          bodyAr: 'تم اعتماد دفعة مرتبطة بطلب نسك.',
          triggerEvent: 'payment_verified'),
      NosokNotificationTemplate(
          id: 'tpl-reject',
          templateKey: 'application_requires_followup',
          channel: 'in_app',
          titleAr: 'مطلوب استكمال',
          bodyAr: 'يرجى مراجعة حالة طلبك واستكمال المطلوب.',
          triggerEvent: 'needs_action'),
    ];
  }

  @override
  Future<List<NosokNotificationDispatch>> listNotificationDispatches(
      {String? status}) async {
    return _dispatches
        .where((item) {
          if (_hasValue(status) && item.status != status) return false;
          return true;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<NosokNotificationDispatch> createNotificationDispatch({
    required String eventKey,
    required String templateKey,
    required String relatedEntityType,
    required String relatedEntityId,
    String channel = 'in_app',
    String recipientScope = 'citizen',
    String? payloadPreviewAr,
  }) async {
    final dispatch = NosokNotificationDispatch(
      id: _id('dispatch'),
      eventKey: eventKey,
      templateKey: templateKey,
      channel: channel,
      recipientScope: recipientScope,
      relatedEntityType: relatedEntityType,
      relatedEntityId: relatedEntityId,
      status: 'queued',
      payloadPreviewAr: payloadPreviewAr,
      createdAt: DateTime.now(),
    );
    _dispatches.add(dispatch);
    return dispatch;
  }

  @override
  Future<NosokNotificationDispatch> markNotificationDispatch({
    required String dispatchId,
    required String status,
    String? providerReference,
    String? errorMessage,
  }) async {
    final current =
        _dispatches.where((item) => item.id == dispatchId).firstOrNull;
    if (current == null) throw StateError('الإشعار غير موجود.');
    final updated = NosokNotificationDispatch(
      id: current.id,
      eventKey: current.eventKey,
      templateKey: current.templateKey,
      channel: current.channel,
      recipientScope: current.recipientScope,
      relatedEntityType: current.relatedEntityType,
      relatedEntityId: current.relatedEntityId,
      status: status,
      payloadPreviewAr: current.payloadPreviewAr,
      providerReference: providerReference ?? current.providerReference,
      errorMessage: errorMessage,
      createdAt: current.createdAt,
      dispatchedAt: status == 'sent' ? DateTime.now() : current.dispatchedAt,
    );
    _replace(_dispatches, updated, (item) => item.id == dispatchId);
    return updated;
  }

  @override
  Future<List<NosokWorkflowBucket>> listWorkflowBuckets() async {
    final pendingApplications = _applications
        .where((item) =>
            item.applicationStatus == 'submitted' ||
            item.applicationStatus == 'under_review')
        .length;
    final pendingDocs = _documents.values
        .expand((items) => items)
        .where((item) => item.reviewStatus == 'pending')
        .length;
    final rejectedDocs = _documents.values
        .expand((items) => items)
        .where((item) => item.reviewStatus == 'rejected')
        .length;
    final pendingPayments = _payments.values
        .expand((items) => items)
        .where((item) =>
            item.verificationStatus == 'pending' ||
            item.verificationStatus == 'under_review')
        .length;
    return <NosokWorkflowBucket>[
      NosokWorkflowBucket(
          bucketKey: 'applications_review',
          titleAr: 'طلبات تحتاج مراجعة',
          descriptionAr: 'طلبات جديدة أو قيد المراجعة.',
          routePath: '/admin/systems/nosok/applications',
          severity: 'high',
          displayOrder: 10,
          itemCount: pendingApplications,
          warningCount: pendingApplications),
      NosokWorkflowBucket(
          bucketKey: 'documents_review',
          titleAr: 'وثائق بانتظار تحقق',
          descriptionAr: 'وثائق مرفوعة تحتاج اعتمادًا أو رفضًا.',
          routePath: '/admin/systems/nosok/applications',
          severity: rejectedDocs > 0 ? 'blocker' : 'high',
          displayOrder: 20,
          itemCount: pendingDocs + rejectedDocs,
          blockerCount: rejectedDocs),
      NosokWorkflowBucket(
          bucketKey: 'payments_verification',
          titleAr: 'دفعات غير مغلقة',
          descriptionAr: 'دفعات تحتاج تحققًا أو مزامنة جسر الفوترة.',
          routePath: '/admin/systems/nosok/payment-bridge',
          severity: 'high',
          displayOrder: 30,
          itemCount: pendingPayments,
          warningCount: pendingPayments),
      NosokWorkflowBucket(
          bucketKey: 'unit_queues',
          titleAr: 'طوابير الوحدات',
          descriptionAr: 'طلبات مقيدة بسياق الوحدة/المديرية.',
          routePath: '/admin/systems/nosok/unit-queues',
          severity: 'normal',
          displayOrder: 40,
          itemCount: _applications.length),
      const NosokWorkflowBucket(
          bucketKey: 'complaints_followup',
          titleAr: 'شكاوى مفتوحة',
          descriptionAr: 'قضايا تواصل تحتاج متابعة وإغلاق.',
          routePath: '/admin/systems/nosok/complaints',
          severity: 'normal',
          displayOrder: 50,
          itemCount: 1,
          warningCount: 1),
    ];
  }

  @override
  Future<List<NosokServiceDeskSearchResult>> searchServiceDesk(
      String query) async {
    final q = query.trim();
    if (q.isEmpty) return const <NosokServiceDeskSearchResult>[];
    final results = <NosokServiceDeskSearchResult>[];
    for (final application in _applications) {
      final matched = application.applicationNo.contains(q) ||
          application.applicantFullName.contains(q) ||
          application.nationalId.contains(q) ||
          (application.trackingToken ?? '').contains(q) ||
          (application.mobile ?? '').contains(q);
      if (matched) {
        results.add(NosokServiceDeskSearchResult(
          resultType: 'application',
          entityId: application.id,
          primaryLabel: application.applicationNo,
          secondaryLabel:
              '${application.applicantFullName} — ${application.serviceType}',
          status: application.applicationStatus,
          routePath: '/admin/systems/nosok/applications/${application.id}',
          matchedBy: 'preview_application_index',
          lastActivityAt: application.submittedAt,
        ));
      }
    }
    if ('NSK-CMP-DEMO-001'.contains(q) || 'استفسار'.contains(q)) {
      results.add(const NosokServiceDeskSearchResult(
        resultType: 'complaint',
        entityId: 'complaint-001',
        primaryLabel: 'NSK-CMP-DEMO-001',
        secondaryLabel: 'استفسار عن التسجيل',
        status: 'received',
        routePath: '/admin/systems/nosok/complaints',
        matchedBy: 'preview_complaint_index',
      ));
    }
    return results;
  }

  @override
  Future<List<NosokServiceDeskScript>> listServiceDeskScripts(
      {String? category}) async {
    const scripts = <NosokServiceDeskScript>[
      NosokServiceDeskScript(
          scriptKey: 'application_received',
          titleAr: 'تم استلام طلبك',
          bodyAr:
              'يرجى الاحتفاظ برمز التتبع ومراجعة صفحة متابعة الطلب لمعرفة الحالة.',
          category: 'application',
          displayOrder: 10),
      NosokServiceDeskScript(
          scriptKey: 'needs_completion',
          titleAr: 'الطلب يحتاج استكمال',
          bodyAr:
              'راجع ملاحظات المراجعة ثم أعد رفع الوثيقة أو السند المطلوب عند إتاحة التعديل.',
          category: 'application',
          displayOrder: 20),
      NosokServiceDeskScript(
          scriptKey: 'payment_under_review',
          titleAr: 'الدفعة قيد التحقق',
          bodyAr:
              'لا يعني رفع السند اعتماد الدفعة؛ الاعتماد يتم بعد التحقق الإداري أو مزامنة الفوترة.',
          category: 'payment',
          displayOrder: 30),
      NosokServiceDeskScript(
          scriptKey: 'privacy_tracking',
          titleAr: 'التتبع آمن',
          bodyAr:
              'لا تُعرض البيانات الشخصية في صفحة التتبع العامة؛ استخدم الرمز فقط.',
          category: 'privacy',
          displayOrder: 40),
    ];
    if (!_hasValue(category)) return scripts;
    return scripts.where((item) => item.category == category!.trim()).toList();
  }

  @override
  Future<List<NosokSeasonCommandGate>> listSeasonCommandGates(
      {String? seasonId}) async {
    final hasActiveSeason =
        _seasons.any((item) => item.status == 'open' && item.isPubliclyVisible);
    final hasProgram = _programs
        .any((item) => item.status == 'active' && item.isPubliclyVisible);
    final hasQualifiedCompany = _qualifications.any((item) =>
        item.qualificationStatus == 'qualified' && item.isPubliclyVisible);
    final privacyPassed = _privacyChecks
        .where((item) => item.severity == 'blocker')
        .every((item) => item.status == 'passed');
    final roleEvidencePassed =
        _roleUatEvidence.any((item) => item.resultStatus == 'passed');
    final billingReady = _billingAdapters.any((item) =>
        item.healthStatus == 'passed' || item.healthStatus == 'contract_ready');
    return <NosokSeasonCommandGate>[
      NosokSeasonCommandGate(
          checkKey: 'active_season',
          titleAr: 'موسم نشط ومراجَع',
          descriptionAr: 'وجود موسم فعال بمدد تسجيل صحيحة.',
          gateType: 'required',
          ownerSurface: 'seasons',
          routePath: '/admin/systems/nosok/seasons',
          passed: hasActiveSeason,
          status: hasActiveSeason ? 'passed' : 'blocked',
          blockerCount: hasActiveSeason ? 0 : 1,
          displayOrder: 10),
      NosokSeasonCommandGate(
          checkKey: 'published_program',
          titleAr: 'برنامج خدمة منشور',
          descriptionAr: 'برنامج حج/عمرة ظاهر للجمهور عند فتح الخدمة.',
          gateType: 'required',
          ownerSurface: 'programs',
          routePath: '/admin/systems/nosok/programs',
          passed: hasProgram,
          status: hasProgram ? 'passed' : 'blocked',
          blockerCount: hasProgram ? 0 : 1,
          displayOrder: 20),
      NosokSeasonCommandGate(
          checkKey: 'qualified_companies',
          titleAr: 'شركات مؤهلة للموسم',
          descriptionAr: 'تأهيل الشركات مرتبط بالموسم لا بالنص الثابت.',
          gateType: 'required',
          ownerSurface: 'companies',
          routePath: '/admin/systems/nosok/companies',
          passed: hasQualifiedCompany,
          status: hasQualifiedCompany ? 'passed' : 'blocked',
          blockerCount: hasQualifiedCompany ? 0 : 1,
          displayOrder: 30),
      NosokSeasonCommandGate(
          checkKey: 'tracking_privacy',
          titleAr: 'خصوصية التتبع مجتازة',
          descriptionAr: 'عدم عرض الاسم أو الهوية أو الهاتف في التتبع العام.',
          gateType: 'gate',
          ownerSurface: 'tracking_privacy',
          routePath: '/admin/systems/nosok/tracking-privacy',
          passed: privacyPassed,
          status: privacyPassed ? 'passed' : 'needs_evidence',
          blockerCount: privacyPassed ? 0 : 1,
          displayOrder: 40),
      NosokSeasonCommandGate(
          checkKey: 'role_uat',
          titleAr: 'Role UAT للأدوار الحرجة',
          descriptionAr: 'اختبار superuser والموظف المحدود وأدوار نسك.',
          gateType: 'gate',
          ownerSurface: 'role_uat',
          routePath: '/admin/systems/nosok/role-uat',
          passed: roleEvidencePassed,
          status: roleEvidencePassed ? 'passed' : 'needs_evidence',
          blockerCount: roleEvidencePassed ? 0 : 1,
          displayOrder: 50),
      NosokSeasonCommandGate(
          checkKey: 'billing_bridge',
          titleAr: 'جسر الدفع جاهز',
          descriptionAr:
              'عدم تخزين بيانات بطاقات داخل نسك وربط billing_system.',
          gateType: 'gate',
          ownerSurface: 'billing_adapters',
          routePath: '/admin/systems/nosok/billing-adapters',
          passed: billingReady,
          status: billingReady ? 'contract_ready' : 'blocked',
          blockerCount: billingReady ? 0 : 1,
          displayOrder: 60),
    ];
  }

  @override
  Future<NosokSeasonOpenGateDecision> evaluateSeasonOpenGate(
      {String? seasonId}) async {
    final gates = await listSeasonCommandGates(seasonId: seasonId);
    final blockers = gates.where((gate) => gate.isBlocking).length;
    return NosokSeasonOpenGateDecision(
      canOpen: blockers == 0,
      blockerCount: blockers,
      noteAr: blockers == 0
          ? 'يمكن فتح الموسم في المعاينة؛ لا توجد blockers ظاهرة.'
          : 'لا يمكن فتح الموسم: توجد $blockers عناصر Gate غير مغلقة.',
    );
  }

  @override
  Future<List<NosokFollowupInboxItem>> listFollowupInbox(
      {String? status, String? unitId}) async {
    final items = <NosokFollowupInboxItem>[];
    for (final request in _followupRequests) {
      final application = _applications
          .where((item) => item.applicationNo == request.applicationNo)
          .firstOrNull;
      items.add(NosokFollowupInboxItem(
        id: request.id,
        applicationId: application?.id ?? '',
        applicationNo: request.applicationNo,
        actionKey: request.actionKey,
        actionTitleAr: _followupTitle(request.actionKey),
        status: request.status,
        priority: request.actionKey == 'submit_objection' ? 'high' : 'normal',
        applicantMaskedName:
            _maskName(application?.applicantFullName ?? 'مراجع'),
        noteAr: request.noteAr,
        assignedUnitId: 'unit-demo',
        assignedUnitNameAr: 'وحدة تجريبية',
        createdAt: request.createdAt,
      ));
    }
    if (items.isEmpty) {
      items.add(NosokFollowupInboxItem(
        id: 'followup-preview-001',
        applicationId: 'application-001',
        applicationNo: 'NSK-DEMO-000001',
        actionKey: 'request_contact_update',
        actionTitleAr: 'طلب تحديث بيانات تواصل',
        status: 'submitted',
        priority: 'normal',
        applicantMaskedName: 'مراجع***',
        noteAr: 'طلب معاينة يظهر في صندوق متابعة المواطن.',
        assignedUnitId: 'unit-demo',
        assignedUnitNameAr: 'وحدة تجريبية',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ));
    }
    return items.where((item) {
      if (_hasValue(status) && item.status != status!.trim()) return false;
      if (_hasValue(unitId) && item.assignedUnitId != unitId!.trim())
        return false;
      return true;
    }).toList();
  }

  @override
  Future<NosokFollowupInboxItem> updateFollowupInboxItem({
    required String followupId,
    required String status,
    String? assignedUnitId,
    String? resolutionNoteAr,
  }) async {
    final current = (await listFollowupInbox())
        .where((item) => item.id == followupId)
        .firstOrNull;
    if (current == null) throw StateError('طلب المتابعة غير موجود.');
    return NosokFollowupInboxItem(
      id: current.id,
      applicationId: current.applicationId,
      applicationNo: current.applicationNo,
      actionKey: current.actionKey,
      actionTitleAr: current.actionTitleAr,
      status: status,
      priority: current.priority,
      applicantMaskedName: current.applicantMaskedName,
      noteAr: current.noteAr,
      assignedUnitId: assignedUnitId ?? current.assignedUnitId,
      assignedUnitNameAr: current.assignedUnitNameAr,
      resolutionNoteAr: resolutionNoteAr,
      createdAt: current.createdAt,
      resolvedAt: status == 'resolved' || status == 'closed'
          ? DateTime.now()
          : current.resolvedAt,
    );
  }

  @override
  Future<List<NosokNotificationProviderAdapter>>
      listNotificationProviderAdapters() async {
    return List<NosokNotificationProviderAdapter>.unmodifiable(
        _notificationProviderAdapters);
  }

  @override
  Future<List<NosokNotificationProviderUatResult>>
      listNotificationProviderUatResults({String? providerKey}) async {
    return _notificationProviderUatResults
        .where((item) {
          if (_hasValue(providerKey) && item.providerKey != providerKey!.trim())
            return false;
          return true;
        })
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<NosokNotificationProviderUatResult> runNotificationProviderAdapterUat({
    required String providerKey,
    required String testKey,
    String? evidenceUrl,
  }) async {
    final adapter = _notificationProviderAdapters
        .where((item) => item.providerKey == providerKey)
        .firstOrNull;
    final result = NosokNotificationProviderUatResult(
      id: _id('notification-uat'),
      providerKey: providerKey,
      channel: adapter?.channel ?? 'unknown',
      testKey: testKey,
      status: adapter == null
          ? 'failed'
          : adapter.healthStatus == 'needs_provider_binding'
              ? 'needs_evidence'
              : 'passed',
      expectedAr:
          'يتحقق الاختبار من وجود عقد Adapter وعدم إرسال نسك لإشعار مستقل خارج خدمات المنصة.',
      actualAr: adapter == null
          ? 'المزود غير مسجل.'
          : 'تم العثور على ${adapter.titleAr} بحالة ${adapter.healthStatus}.',
      evidenceUrl: evidenceUrl,
      errorMessage: adapter == null ? 'provider_not_registered' : null,
      createdAt: DateTime.now(),
    );
    _notificationProviderUatResults.add(result);
    return result;
  }

  String _followupTitle(String actionKey) {
    switch (actionKey) {
      case 'add_note':
        return 'إضافة ملاحظة من المواطن';
      case 'request_contact_update':
        return 'طلب تحديث بيانات تواصل';
      case 'submit_objection':
        return 'اعتراض/مراجعة قرار';
      default:
        return actionKey;
    }
  }

  String _maskName(String value) {
    final trimmed = value.trim();
    if (trimmed.length <= 4) return 'مراجع***';
    return '${trimmed.substring(0, 4)}***';
  }

  @override
  Future<NosokDashboardSummary> loadDashboardSummary() async {
    return NosokDashboardSummary(
      activeSeasonsCount:
          _seasons.where((item) => item.status == 'open').length,
      activeProgramsCount:
          _programs.where((item) => item.status == 'active').length,
      publishedCompaniesCount:
          _companies.where((item) => item.isPubliclyVisible).length,
      openComplaintsCount: 1,
      pendingApplicationsCount: _applications
          .where((item) => item.applicationStatus == 'submitted')
          .length,
    );
  }

  void _replace<T>(List<T> list, T item, bool Function(T element) test) {
    final index = list.indexWhere(test);
    if (index == -1) {
      list.add(item);
    } else {
      list[index] = item;
    }
  }

  String _id(String prefix) =>
      '$prefix-${DateTime.now().microsecondsSinceEpoch}';
  bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
