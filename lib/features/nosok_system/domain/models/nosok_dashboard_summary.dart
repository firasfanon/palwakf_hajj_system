class NosokDashboardSummary {
  const NosokDashboardSummary({
    required this.activeSeasonsCount,
    required this.activeProgramsCount,
    required this.publishedCompaniesCount,
    required this.openComplaintsCount,
    required this.pendingApplicationsCount,
  });

  final int activeSeasonsCount;
  final int activeProgramsCount;
  final int publishedCompaniesCount;
  final int openComplaintsCount;
  final int pendingApplicationsCount;

  factory NosokDashboardSummary.fromMap(Map<String, dynamic> map) {
    return NosokDashboardSummary(
      activeSeasonsCount: (map['active_seasons_count'] ?? 0) as int,
      activeProgramsCount: (map['active_programs_count'] ?? 0) as int,
      publishedCompaniesCount: (map['published_companies_count'] ?? 0) as int,
      openComplaintsCount: (map['open_complaints_count'] ?? 0) as int,
      pendingApplicationsCount: (map['pending_applications_count'] ?? 0) as int,
    );
  }
}
