class NosokLotteryPolicy {
  const NosokLotteryPolicy({
    required this.seasonCode,
    required this.minAge,
    required this.quotaDivisor,
    required this.maxCompanions,
    required this.mahramRequired,
    required this.paymentRequiredBeforeDraw,
    required this.registrationOpenForEligiblePublic,
    required this.crossLguTransferRequiresCommitteeDecision,
    required this.notesAr,
    this.totalNationalHajjQuota,
    this.policyVersion = 'v27D-staging',
    this.populationSourceAr = 'Population snapshot / LGU registry',
    this.quotaSourceAr = 'وزارة الأوقاف — سياسة الموسم',
    this.lguAddressSourceAr = 'العنوان المعتمد في البطاقة الشخصية',
    this.underfilledQuotaPolicy =
        NosokUnderfilledQuotaPolicy.committeeDecisionRequired,
  });

  final String seasonCode;
  final int minAge;
  final int quotaDivisor;
  final int maxCompanions;
  final bool mahramRequired;
  final bool paymentRequiredBeforeDraw;
  final bool registrationOpenForEligiblePublic;
  final bool crossLguTransferRequiresCommitteeDecision;
  final String notesAr;
  final int? totalNationalHajjQuota;
  final String policyVersion;
  final String populationSourceAr;
  final String quotaSourceAr;
  final String lguAddressSourceAr;
  final NosokUnderfilledQuotaPolicy underfilledQuotaPolicy;

  int calculatedQuota(int population) {
    if (quotaDivisor <= 0) return 0;
    final quota = population ~/ quotaDivisor;
    return quota < 1 && population > 0 ? 1 : quota;
  }
}

enum NosokUnderfilledQuotaPolicy {
  committeeDecisionRequired,
  keepVacant,
  sameLguWaitingListOnly,
  ministryRedistributionByCommittee,
}

extension NosokUnderfilledQuotaPolicyLabel on NosokUnderfilledQuotaPolicy {
  String get labelAr {
    switch (this) {
      case NosokUnderfilledQuotaPolicy.committeeDecisionRequired:
        return 'قرار لجنة الحج إلزامي';
      case NosokUnderfilledQuotaPolicy.keepVacant:
        return 'إبقاء المقعد شاغرًا';
      case NosokUnderfilledQuotaPolicy.sameLguWaitingListOnly:
        return 'قائمة انتظار نفس التجمع فقط';
      case NosokUnderfilledQuotaPolicy.ministryRedistributionByCommittee:
        return 'إعادة توزيع بقرار لجنة/وزارة';
    }
  }
}

class NosokLguQuotaSnapshot {
  const NosokLguQuotaSnapshot({
    required this.lguCode,
    required this.lguNameAr,
    required this.governorateAr,
    required this.populationSnapshot,
    required this.calculatedQuota,
    required this.manualQuotaOverride,
    required this.finalCapacity,
    required this.eligibleApplications,
    required this.eligiblePeople,
    required this.selectedApplications,
    required this.selectedPeople,
    required this.remainingCapacity,
    required this.status,
    this.snapshotSourceAr = 'LGU population snapshot',
    this.freezeStatusAr = 'مثبت للموسم قبل القرعة',
  });

  final String lguCode;
  final String lguNameAr;
  final String governorateAr;
  final int populationSnapshot;
  final int calculatedQuota;
  final int? manualQuotaOverride;
  final int finalCapacity;
  final int eligibleApplications;
  final int eligiblePeople;
  final int selectedApplications;
  final int selectedPeople;
  final int remainingCapacity;
  final NosokLguQuotaStatus status;
  final String snapshotSourceAr;
  final String freezeStatusAr;

  bool get hasGap => remainingCapacity > 0;
  bool get requiresCommittee =>
      status == NosokLguQuotaStatus.committeeDecisionRequired;
}

enum NosokLguQuotaStatus {
  quotaPending,
  quotaLocked,
  includedInLguDraw,
  selectedUnderLguQuota,
  waitingListUnderLguQuota,
  quotaExhausted,
  committeeDecisionRequired,
}

extension NosokLguQuotaStatusLabel on NosokLguQuotaStatus {
  String get labelAr {
    switch (this) {
      case NosokLguQuotaStatus.quotaPending:
        return 'الحصة قيد التحضير';
      case NosokLguQuotaStatus.quotaLocked:
        return 'الحصة مثبتة للموسم';
      case NosokLguQuotaStatus.includedInLguDraw:
        return 'مدرج في قرعة التجمع';
      case NosokLguQuotaStatus.selectedUnderLguQuota:
        return 'مختار ضمن حصة التجمع';
      case NosokLguQuotaStatus.waitingListUnderLguQuota:
        return 'قائمة انتظار التجمع';
      case NosokLguQuotaStatus.quotaExhausted:
        return 'الحصة مكتملة';
      case NosokLguQuotaStatus.committeeDecisionRequired:
        return 'يتطلب قرار لجنة الحج';
    }
  }
}

class NosokLotteryApplicationCandidate {
  const NosokLotteryApplicationCandidate({
    required this.applicationNo,
    required this.applicantNameAr,
    required this.lguCode,
    required this.lguNameAr,
    required this.totalPeopleCount,
    required this.eligible,
    required this.reasonsAr,
    this.identityAddressAr = 'العنوان المعتمد في البطاقة الشخصية',
    this.hasPreviousHajj = false,
    this.documentsComplete = true,
    this.paymentRecorded = true,
    this.rankSeed = 0,
  });

  final String applicationNo;
  final String applicantNameAr;
  final String lguCode;
  final String lguNameAr;
  final int totalPeopleCount;
  final bool eligible;
  final List<String> reasonsAr;
  final String identityAddressAr;
  final bool hasPreviousHajj;
  final bool documentsComplete;
  final bool paymentRecorded;
  final int rankSeed;

  bool fitsCapacity(int remainingCapacity) =>
      eligible && totalPeopleCount <= remainingCapacity;
}

enum NosokLotteryCandidateDecision {
  selected,
  waitingList,
  excluded,
  capacityOverflow,
  committeeReview,
}

extension NosokLotteryCandidateDecisionLabel on NosokLotteryCandidateDecision {
  String get labelAr {
    switch (this) {
      case NosokLotteryCandidateDecision.selected:
        return 'مختار ضمن الحصة';
      case NosokLotteryCandidateDecision.waitingList:
        return 'قائمة انتظار';
      case NosokLotteryCandidateDecision.excluded:
        return 'مستبعد من القرعة';
      case NosokLotteryCandidateDecision.capacityOverflow:
        return 'لا يلائم السعة المتبقية';
      case NosokLotteryCandidateDecision.committeeReview:
        return 'مراجعة لجنة الحج';
    }
  }
}

class NosokLotterySelectionResult {
  const NosokLotterySelectionResult({
    required this.applicationNo,
    required this.applicantNameAr,
    required this.lguCode,
    required this.lguNameAr,
    required this.totalPeopleCount,
    required this.decision,
    required this.rank,
    required this.remainingCapacityAfterDecision,
    required this.reasonAr,
  });

  final String applicationNo;
  final String applicantNameAr;
  final String lguCode;
  final String lguNameAr;
  final int totalPeopleCount;
  final NosokLotteryCandidateDecision decision;
  final int rank;
  final int remainingCapacityAfterDecision;
  final String reasonAr;
}

enum NosokCommitteeDecisionType {
  keepVacant,
  waitForSameLguCompletion,
  promoteSameLguWaitingCandidate,
  redistributeByFormalPolicy,
  exceptionalReview,
}

extension NosokCommitteeDecisionTypeLabel on NosokCommitteeDecisionType {
  String get labelAr {
    switch (this) {
      case NosokCommitteeDecisionType.keepVacant:
        return 'إبقاء المقعد شاغرًا';
      case NosokCommitteeDecisionType.waitForSameLguCompletion:
        return 'انتظار استكمال طلب من نفس التجمع';
      case NosokCommitteeDecisionType.promoteSameLguWaitingCandidate:
        return 'ترقية طلب من قائمة انتظار نفس التجمع';
      case NosokCommitteeDecisionType.redistributeByFormalPolicy:
        return 'إعادة توزيع وفق سياسة رسمية';
      case NosokCommitteeDecisionType.exceptionalReview:
        return 'مراجعة استثنائية موثقة';
    }
  }
}

class NosokLotteryCommitteeDecisionDraft {
  const NosokLotteryCommitteeDecisionDraft({
    required this.lguCode,
    required this.lguNameAr,
    required this.remainingCapacity,
    required this.reasonAr,
    required this.allowedDecisionTypes,
    required this.auditRequirementAr,
  });

  final String lguCode;
  final String lguNameAr;
  final int remainingCapacity;
  final String reasonAr;
  final List<NosokCommitteeDecisionType> allowedDecisionTypes;
  final String auditRequirementAr;
}

class NosokLotteryCitizenResult {
  const NosokLotteryCitizenResult({
    required this.trackingCode,
    required this.lguNameAr,
    required this.peopleCount,
    required this.resultLabelAr,
    required this.publicMessageAr,
    required this.nextStepAr,
  });

  final String trackingCode;
  final String lguNameAr;
  final int peopleCount;
  final String resultLabelAr;
  final String publicMessageAr;
  final String nextStepAr;
}

class NosokLotteryObjectionReason {
  const NosokLotteryObjectionReason({
    required this.key,
    required this.titleAr,
    required this.descriptionAr,
    required this.requiresAttachment,
  });

  final String key;
  final String titleAr;
  final String descriptionAr;
  final bool requiresAttachment;
}

class NosokLotteryDrawRunEvidence {
  const NosokLotteryDrawRunEvidence({
    required this.runId,
    required this.seasonCode,
    required this.status,
    required this.policySnapshotHash,
    required this.operatorScope,
    required this.startedAtLabel,
    required this.totalLgus,
    required this.totalEligibleApplications,
    required this.totalSelectedPeople,
    required this.committeeRequiredLgus,
    this.algorithmVersion = 'capacity-aware-lgu-v27d',
    this.auditModeAr = 'immutable append-only required before production',
  });

  final String runId;
  final String seasonCode;
  final String status;
  final String policySnapshotHash;
  final String operatorScope;
  final String startedAtLabel;
  final int totalLgus;
  final int totalEligibleApplications;
  final int totalSelectedPeople;
  final int committeeRequiredLgus;
  final String algorithmVersion;
  final String auditModeAr;
}
