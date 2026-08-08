import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/nosok_lottery_policy.dart';

class NosokLotteryDashboardState {
  const NosokLotteryDashboardState({
    required this.policy,
    required this.lguQuotas,
    required this.candidates,
    required this.selectionResults,
    required this.committeeDecisions,
    required this.citizenResults,
    required this.objectionReasons,
    required this.evidence,
  });

  final NosokLotteryPolicy policy;
  final List<NosokLguQuotaSnapshot> lguQuotas;
  final List<NosokLotteryApplicationCandidate> candidates;
  final List<NosokLotterySelectionResult> selectionResults;
  final List<NosokLotteryCommitteeDecisionDraft> committeeDecisions;
  final List<NosokLotteryCitizenResult> citizenResults;
  final List<NosokLotteryObjectionReason> objectionReasons;
  final NosokLotteryDrawRunEvidence evidence;

  int get totalCapacity =>
      lguQuotas.fold<int>(0, (sum, item) => sum + item.finalCapacity);
  int get selectedPeople =>
      lguQuotas.fold<int>(0, (sum, item) => sum + item.selectedPeople);
  int get remainingCapacity =>
      lguQuotas.fold<int>(0, (sum, item) => sum + item.remainingCapacity);
  int get committeeRequired => lguQuotas
      .where((item) =>
          item.status == NosokLguQuotaStatus.committeeDecisionRequired)
      .length;
  int get waitingListCount => selectionResults
      .where(
          (item) => item.decision == NosokLotteryCandidateDecision.waitingList)
      .length;
  int get selectedApplicationCount => selectionResults
      .where((item) => item.decision == NosokLotteryCandidateDecision.selected)
      .length;
}

final nosokLotteryDashboardProvider =
    Provider<NosokLotteryDashboardState>((ref) {
  const policy = NosokLotteryPolicy(
    seasonCode: '1447H-2026',
    minAge: 16,
    quotaDivisor: 1000,
    maxCompanions: 2,
    mahramRequired: true,
    paymentRequiredBeforeDraw: true,
    registrationOpenForEligiblePublic: true,
    crossLguTransferRequiresCommitteeDecision: true,
    totalNationalHajjQuota: 6600,
    populationSourceAr:
        'Snapshot معتمد من الوزارة/الجهة الإحصائية قبل إغلاق التسجيل',
    quotaSourceAr: 'حصة الحج الموسمية + سياسة توزيع الوزارة',
    lguAddressSourceAr: 'LGU مشتق من عنوان البطاقة الشخصية لا من اختيار يدوي',
    underfilledQuotaPolicy:
        NosokUnderfilledQuotaPolicy.committeeDecisionRequired,
    notesAr:
        'التسجيل مفتوح لكل من تنطبق عليه الشروط، لكن دخول القرعة مشروط باكتمال الأهلية وربط العنوان المعتمد في البطاقة الشخصية بالتجمع/LGU. الحصص والسكان والشروط قابلة للتعديل حسب سياسة الوزارة قبل تثبيت snapshot الموسم.',
  );

  const lguQuotas = <NosokLguQuotaSnapshot>[
    NosokLguQuotaSnapshot(
      lguCode: 'B-NHLN',
      lguNameAr: 'نحالين',
      governorateAr: 'بيت لحم',
      populationSnapshot: 10000,
      calculatedQuota: 10,
      manualQuotaOverride: null,
      finalCapacity: 10,
      eligibleApplications: 37,
      eligiblePeople: 89,
      selectedApplications: 4,
      selectedPeople: 10,
      remainingCapacity: 0,
      status: NosokLguQuotaStatus.quotaExhausted,
    ),
    NosokLguQuotaSnapshot(
      lguCode: 'H-DURA',
      lguNameAr: 'دورا',
      governorateAr: 'الخليل',
      populationSnapshot: 42000,
      calculatedQuota: 42,
      manualQuotaOverride: 40,
      finalCapacity: 40,
      eligibleApplications: 144,
      eligiblePeople: 381,
      selectedApplications: 17,
      selectedPeople: 40,
      remainingCapacity: 0,
      status: NosokLguQuotaStatus.quotaExhausted,
    ),
    NosokLguQuotaSnapshot(
      lguCode: 'J-QBTY',
      lguNameAr: 'قباطية',
      governorateAr: 'جنين',
      populationSnapshot: 28000,
      calculatedQuota: 28,
      manualQuotaOverride: null,
      finalCapacity: 28,
      eligibleApplications: 91,
      eligiblePeople: 214,
      selectedApplications: 12,
      selectedPeople: 27,
      remainingCapacity: 1,
      status: NosokLguQuotaStatus.committeeDecisionRequired,
    ),
  ];

  const candidates = <NosokLotteryApplicationCandidate>[
    NosokLotteryApplicationCandidate(
      applicationNo: 'NSK-1447-000391',
      applicantNameAr: 'طلب عائلة — نحالين',
      lguCode: 'B-NHLN',
      lguNameAr: 'نحالين',
      totalPeopleCount: 4,
      eligible: true,
      rankSeed: 1,
      reasonsAr: ['مكتمل الشروط', 'العنوان مطابق للبطاقة', 'الرسوم مسجلة'],
    ),
    NosokLotteryApplicationCandidate(
      applicationNo: 'NSK-1447-000412',
      applicantNameAr: 'طلب فردي — نحالين',
      lguCode: 'B-NHLN',
      lguNameAr: 'نحالين',
      totalPeopleCount: 1,
      eligible: true,
      rankSeed: 4,
      reasonsAr: ['مناسب لاستكمال السعة المتبقية'],
    ),
    NosokLotteryApplicationCandidate(
      applicationNo: 'NSK-1447-000428',
      applicantNameAr: 'طلب مرافقين — نحالين',
      lguCode: 'B-NHLN',
      lguNameAr: 'نحالين',
      totalPeopleCount: 3,
      eligible: true,
      rankSeed: 6,
      reasonsAr: ['يتجاوز السعة المتبقية بعد اختيار سابق'],
    ),
    NosokLotteryApplicationCandidate(
      applicationNo: 'NSK-1447-000517',
      applicantNameAr: 'طلب غير مكتمل — قباطية',
      lguCode: 'J-QBTY',
      lguNameAr: 'قباطية',
      totalPeopleCount: 2,
      eligible: false,
      documentsComplete: false,
      paymentRecorded: false,
      rankSeed: 2,
      reasonsAr: ['نقص وثيقة مطلوبة', 'لا يدخل القرعة حتى الاستكمال'],
    ),
    NosokLotteryApplicationCandidate(
      applicationNo: 'NSK-1447-000611',
      applicantNameAr: 'طلب عائلي — قباطية',
      lguCode: 'J-QBTY',
      lguNameAr: 'قباطية',
      totalPeopleCount: 2,
      eligible: true,
      rankSeed: 3,
      reasonsAr: ['مؤهل لكن لا يلائم السعة المتبقية 1'],
    ),
  ];

  const selectionResults = <NosokLotterySelectionResult>[
    NosokLotterySelectionResult(
      applicationNo: 'NSK-1447-000391',
      applicantNameAr: 'طلب عائلة — نحالين',
      lguCode: 'B-NHLN',
      lguNameAr: 'نحالين',
      totalPeopleCount: 4,
      decision: NosokLotteryCandidateDecision.selected,
      rank: 1,
      remainingCapacityAfterDecision: 6,
      reasonAr: 'تم اختياره ضمن قرعة نحالين دون تجاوز السعة.',
    ),
    NosokLotterySelectionResult(
      applicationNo: 'NSK-1447-000412',
      applicantNameAr: 'طلب فردي — نحالين',
      lguCode: 'B-NHLN',
      lguNameAr: 'نحالين',
      totalPeopleCount: 1,
      decision: NosokLotteryCandidateDecision.selected,
      rank: 4,
      remainingCapacityAfterDecision: 0,
      reasonAr: 'استُخدم لاستكمال المقعد المتبقي داخل نفس التجمع.',
    ),
    NosokLotterySelectionResult(
      applicationNo: 'NSK-1447-000428',
      applicantNameAr: 'طلب مرافقين — نحالين',
      lguCode: 'B-NHLN',
      lguNameAr: 'نحالين',
      totalPeopleCount: 3,
      decision: NosokLotteryCandidateDecision.waitingList,
      rank: 6,
      remainingCapacityAfterDecision: 0,
      reasonAr: 'بقي في قائمة الانتظار لأن الحصة اكتملت.',
    ),
    NosokLotterySelectionResult(
      applicationNo: 'NSK-1447-000517',
      applicantNameAr: 'طلب غير مكتمل — قباطية',
      lguCode: 'J-QBTY',
      lguNameAr: 'قباطية',
      totalPeopleCount: 2,
      decision: NosokLotteryCandidateDecision.excluded,
      rank: 2,
      remainingCapacityAfterDecision: 1,
      reasonAr: 'استبعاد مؤقت بسبب نقص الوثائق قبل snapshot الأهلية.',
    ),
    NosokLotterySelectionResult(
      applicationNo: 'NSK-1447-000611',
      applicantNameAr: 'طلب عائلي — قباطية',
      lguCode: 'J-QBTY',
      lguNameAr: 'قباطية',
      totalPeopleCount: 2,
      decision: NosokLotteryCandidateDecision.capacityOverflow,
      rank: 3,
      remainingCapacityAfterDecision: 1,
      reasonAr:
          'لا يلائم السعة المتبقية 1؛ يتطلب قرار لجنة إذا لم يوجد طلب فردي مؤهل.',
    ),
  ];

  const committeeDecisions = <NosokLotteryCommitteeDecisionDraft>[
    NosokLotteryCommitteeDecisionDraft(
      lguCode: 'J-QBTY',
      lguNameAr: 'قباطية',
      remainingCapacity: 1,
      reasonAr:
          'لا يوجد طلب مؤهل من نفس التجمع بعدد أفراد يساوي أو يقل عن السعة المتبقية.',
      allowedDecisionTypes: [
        NosokCommitteeDecisionType.keepVacant,
        NosokCommitteeDecisionType.waitForSameLguCompletion,
        NosokCommitteeDecisionType.redistributeByFormalPolicy,
        NosokCommitteeDecisionType.exceptionalReview,
      ],
      auditRequirementAr:
          'قرار لجنة الحج + سبب + محضر + أثر تدقيقي. لا تحويل تلقائي بين التجمعات.',
    ),
  ];

  const citizenResults = <NosokLotteryCitizenResult>[
    NosokLotteryCitizenResult(
      trackingCode: 'NSK-1447-000391',
      lguNameAr: 'نحالين',
      peopleCount: 4,
      resultLabelAr: 'مختار ضمن حصة التجمع',
      publicMessageAr:
          'تم اختيار طلبك ضمن قرعة التجمع المعتمد في البطاقة الشخصية.',
      nextStepAr: 'انتظر تعليمات الدفع/الحملة من خلال قناة نسك الرسمية.',
    ),
    NosokLotteryCitizenResult(
      trackingCode: 'NSK-1447-000428',
      lguNameAr: 'نحالين',
      peopleCount: 3,
      resultLabelAr: 'قائمة انتظار',
      publicMessageAr:
          'طلبك مؤهل لكنه بقي في قائمة انتظار نفس التجمع بعد اكتمال الحصة.',
      nextStepAr: 'تابع الصفحة خلال نافذة الانسحابات أو قرارات اللجنة.',
    ),
  ];

  const objectionReasons = <NosokLotteryObjectionReason>[
    NosokLotteryObjectionReason(
      key: 'identity_lgu_mismatch',
      titleAr: 'التجمع المعتمد غير صحيح',
      descriptionAr: 'اعتراض على LGU المشتق من عنوان البطاقة الشخصية.',
      requiresAttachment: true,
    ),
    NosokLotteryObjectionReason(
      key: 'people_count_mismatch',
      titleAr: 'عدد الأشخاص المحتسب غير صحيح',
      descriptionAr: 'اعتراض على عدد المرافقين أو المحرم أو أفراد الطلب.',
      requiresAttachment: false,
    ),
    NosokLotteryObjectionReason(
      key: 'eligibility_completed_before_freeze',
      titleAr: 'استكمال نواقص قبل إغلاق التسجيل',
      descriptionAr: 'إثبات أن الطلب كان مكتملًا قبل تثبيت pool القرعة.',
      requiresAttachment: true,
    ),
    NosokLotteryObjectionReason(
      key: 'committee_quota_decision_review',
      titleAr: 'مراجعة قرار الحصة غير المستكملة',
      descriptionAr:
          'طلب مراجعة قرار اللجنة المتعلق بالمقاعد الشاغرة أو إعادة التوزيع.',
      requiresAttachment: false,
    ),
  ];

  const evidence = NosokLotteryDrawRunEvidence(
    runId: 'DRAW-1447H-STAGING-002',
    seasonCode: '1447H-2026',
    status: 'staging/governance-only/not-executed-production',
    policySnapshotHash: 'policy-snapshot-v27d-lgu-capacity-9c21',
    operatorScope: 'nosok_lottery_manager + hajj_committee + audit_viewer',
    startedAtLabel: '2026-05-19 — staging evidence v27D',
    totalLgus: 3,
    totalEligibleApplications: 272,
    totalSelectedPeople: 77,
    committeeRequiredLgus: 1,
    algorithmVersion: 'capacity-aware-lgu-v27d',
    auditModeAr: 'append-only evidence required; no silent result mutation',
  );

  return const NosokLotteryDashboardState(
    policy: policy,
    lguQuotas: lguQuotas,
    candidates: candidates,
    selectionResults: selectionResults,
    committeeDecisions: committeeDecisions,
    citizenResults: citizenResults,
    objectionReasons: objectionReasons,
    evidence: evidence,
  );
});
