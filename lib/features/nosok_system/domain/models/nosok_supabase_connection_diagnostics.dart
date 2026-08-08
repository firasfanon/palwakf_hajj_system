class NosokSupabaseConnectionDiagnostics {
  const NosokSupabaseConnectionDiagnostics({
    required this.version,
    required this.dataMode,
    required this.supabaseUrlPresent,
    required this.supabaseUrlMasked,
    required this.supabaseAnonKeyPresent,
    required this.supabaseAnonKeyMasked,
    required this.supabaseInitialized,
    required this.repositoryDecision,
    required this.productionDecision,
    required this.checks,
  });

  final String version;
  final String dataMode;
  final bool supabaseUrlPresent;
  final String supabaseUrlMasked;
  final bool supabaseAnonKeyPresent;
  final String supabaseAnonKeyMasked;
  final bool supabaseInitialized;
  final String repositoryDecision;
  final String productionDecision;
  final List<NosokSupabaseDiagnosticCheck> checks;

  bool get canAttemptDatabaseChecks => supabaseInitialized;
}

class NosokSupabaseDiagnosticCheck {
  const NosokSupabaseDiagnosticCheck({
    required this.key,
    required this.titleAr,
    required this.status,
    required this.detailAr,
  });

  final String key;
  final String titleAr;
  final NosokSupabaseDiagnosticStatus status;
  final String detailAr;
}

enum NosokSupabaseDiagnosticStatus {
  passed,
  warning,
  failed,
  pending,
}

extension NosokSupabaseDiagnosticStatusX on NosokSupabaseDiagnosticStatus {
  String get labelAr {
    return switch (this) {
      NosokSupabaseDiagnosticStatus.passed => 'ناجح',
      NosokSupabaseDiagnosticStatus.warning => 'تحذير',
      NosokSupabaseDiagnosticStatus.failed => 'فشل',
      NosokSupabaseDiagnosticStatus.pending => 'مؤجل',
    };
  }
}
