import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Runtime environment resolver for Nosok standalone/pre-join builds.
///
/// Important: the packaged `.env` is a placeholder. In local development the
/// presence of SUPABASE_URL + SUPABASE_ANON_KEY is treated as an explicit
/// request to run `standaloneSupabaseDevelopment` unless another non-preview
/// mode is provided. This prevents the common failure where credentials are
/// present but the placeholder leaves NOSOK_DATA_MODE=preview.
class NosokRuntimeEnvironment {
  const NosokRuntimeEnvironment._();

  static const String compileTimeMode =
      String.fromEnvironment('NOSOK_DATA_MODE');
  static const String compileTimeSupabaseUrl =
      String.fromEnvironment('SUPABASE_URL');
  static const String compileTimeSupabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  static String get configuredDataMode => _firstNonBlank([
        dotenv.env['NOSOK_DATA_MODE'],
        compileTimeMode,
      ]);

  static String get effectiveDataMode {
    final configured = configuredDataMode;
    if (configured.isNotEmpty && configured != 'preview') return configured;
    if (hasSupabaseCredentials) return 'standaloneSupabaseDevelopment';
    return 'preview';
  }

  static bool get dataModeAutoPromotedFromCredentials =>
      (configuredDataMode.isEmpty || configuredDataMode == 'preview') &&
      hasSupabaseCredentials &&
      effectiveDataMode == 'standaloneSupabaseDevelopment';

  static String get supabaseUrl => _firstNonBlank([
        dotenv.env['SUPABASE_URL'],
        compileTimeSupabaseUrl,
      ]);

  static String get supabaseAnonKey => _firstNonBlank([
        dotenv.env['SUPABASE_ANON_KEY'],
        compileTimeSupabaseAnonKey,
      ]);

  static bool get hasSupabaseUrl => supabaseUrl.trim().isNotEmpty;
  static bool get hasSupabaseAnonKey => supabaseAnonKey.trim().isNotEmpty;
  static bool get hasSupabaseCredentials =>
      hasSupabaseUrl && hasSupabaseAnonKey;

  static bool get isStandaloneSupabaseDevelopment =>
      effectiveDataMode == 'standaloneSupabaseDevelopment';

  static bool get isPlatformHosted => effectiveDataMode == 'platformHosted';

  static bool get shouldInitializeSupabase =>
      hasSupabaseCredentials &&
      (isStandaloneSupabaseDevelopment || isPlatformHosted);

  static String maskSupabaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'غير محدد';
    final uri = Uri.tryParse(trimmed);
    if (uri == null || uri.host.isEmpty) return 'قيمة غير قابلة للتحليل';
    return '${uri.scheme}://${uri.host}';
  }

  static String maskSecret(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return 'غير محدد';
    if (trimmed.length <= 10) return '***';
    return '${trimmed.substring(0, 6)}…${trimmed.substring(trimmed.length - 4)}';
  }

  static String _firstNonBlank(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) return trimmed;
    }
    return '';
  }
}
