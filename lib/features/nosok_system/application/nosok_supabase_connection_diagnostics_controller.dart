import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/models/nosok_supabase_connection_diagnostics.dart';
import '../infrastructure/nosok_runtime_environment.dart';

final nosokSupabaseConnectionDiagnosticsProvider =
    FutureProvider<NosokSupabaseConnectionDiagnostics>((ref) async {
  final checks = <NosokSupabaseDiagnosticCheck>[];
  final mode = NosokRuntimeEnvironment.effectiveDataMode;
  final hasUrl = NosokRuntimeEnvironment.hasSupabaseUrl;
  final hasAnonKey = NosokRuntimeEnvironment.hasSupabaseAnonKey;
  SupabaseClient? client;
  var initialized = false;

  final configuredMode = NosokRuntimeEnvironment.configuredDataMode;
  final modeAutoPromoted =
      NosokRuntimeEnvironment.dataModeAutoPromotedFromCredentials;

  checks.add(
    NosokSupabaseDiagnosticCheck(
      key: 'runtime_mode',
      titleAr: 'وضع التشغيل',
      status: mode == 'standaloneSupabaseDevelopment'
          ? NosokSupabaseDiagnosticStatus.passed
          : NosokSupabaseDiagnosticStatus.warning,
      detailAr: mode == 'standaloneSupabaseDevelopment'
          ? modeAutoPromoted
              ? 'تم تفعيل standaloneSupabaseDevelopment تلقائيًا لأن SUPABASE_URL وSUPABASE_ANON_KEY موجودان. الوضع المعرّف صراحة: ${configuredMode.isEmpty ? 'غير محدد' : configuredMode}.'
              : 'NOSOK_DATA_MODE مضبوط على standaloneSupabaseDevelopment.'
          : 'الوضع الحالي هو $mode. للاتصال الحقيقي المؤقت أضف SUPABASE_URL وSUPABASE_ANON_KEY أو اضبط NOSOK_DATA_MODE=standaloneSupabaseDevelopment.',
    ),
  );

  checks.add(
    NosokSupabaseDiagnosticCheck(
      key: 'supabase_url',
      titleAr: 'SUPABASE_URL',
      status: hasUrl
          ? NosokSupabaseDiagnosticStatus.passed
          : NosokSupabaseDiagnosticStatus.failed,
      detailAr: hasUrl
          ? 'تم العثور على الرابط: ${NosokRuntimeEnvironment.maskSupabaseUrl(NosokRuntimeEnvironment.supabaseUrl)}'
          : 'لم يتم العثور على SUPABASE_URL في .env أو dart-define.',
    ),
  );

  checks.add(
    NosokSupabaseDiagnosticCheck(
      key: 'supabase_anon_key',
      titleAr: 'SUPABASE_ANON_KEY',
      status: hasAnonKey
          ? NosokSupabaseDiagnosticStatus.passed
          : NosokSupabaseDiagnosticStatus.failed,
      detailAr: hasAnonKey
          ? 'تم العثور على المفتاح العام anon key: ${NosokRuntimeEnvironment.maskSecret(NosokRuntimeEnvironment.supabaseAnonKey)}'
          : 'لم يتم العثور على SUPABASE_ANON_KEY. لا تستخدم service_role داخل Flutter Web.',
    ),
  );

  if (!NosokRuntimeEnvironment.shouldInitializeSupabase) {
    checks.add(
      NosokSupabaseDiagnosticCheck(
        key: 'client_initialized',
        titleAr: 'Supabase Client',
        status: NosokSupabaseDiagnosticStatus.pending,
        detailAr: hasUrl && hasAnonKey
            ? 'تم العثور على بيانات الاتصال، لكن وضع التشغيل لا يطلب التهيئة. راجع NOSOK_DATA_MODE أو استخدم التفعيل التلقائي عبر القيم الحالية.'
            : 'لم تتم محاولة تهيئة Supabase لأن بيانات الاتصال غير مكتملة أو الوضع preview.',
      ),
    );
  } else {
    try {
      client = Supabase.instance.client;
      initialized = true;
      checks.add(
        const NosokSupabaseDiagnosticCheck(
          key: 'client_initialized',
          titleAr: 'Supabase Client',
          status: NosokSupabaseDiagnosticStatus.passed,
          detailAr: 'Supabase.instance.client متاح داخل التطبيق.',
        ),
      );
    } catch (error) {
      checks.add(
        NosokSupabaseDiagnosticCheck(
          key: 'client_initialized',
          titleAr: 'Supabase Client',
          status: NosokSupabaseDiagnosticStatus.failed,
          detailAr:
              'كان يجب تهيئة Supabase لأن وضع التشغيل يتطلب ذلك، لكن التهيئة لم تكتمل: ${_shortError(error)}',
        ),
      );
    }
  }

  if (client == null) {
    checks.add(
      const NosokSupabaseDiagnosticCheck(
        key: 'database_probe',
        titleAr: 'فحص قاعدة البيانات',
        status: NosokSupabaseDiagnosticStatus.pending,
        detailAr: 'لا يمكن تنفيذ فحص read-only لأن Supabase client غير مهيأ.',
      ),
    );
  } else {
    checks.add(await _probeNosokSchema(client));
    checks.add(await _probeHomepagePublicRpc(client));
    checks.add(await _probeCoreReferenceReadinessRpc(client));
  }

  return NosokSupabaseConnectionDiagnostics(
    version: 'v38I-2',
    dataMode: mode,
    supabaseUrlPresent: hasUrl,
    supabaseUrlMasked: NosokRuntimeEnvironment.maskSupabaseUrl(
        NosokRuntimeEnvironment.supabaseUrl),
    supabaseAnonKeyPresent: hasAnonKey,
    supabaseAnonKeyMasked: NosokRuntimeEnvironment.maskSecret(
        NosokRuntimeEnvironment.supabaseAnonKey),
    supabaseInitialized: initialized,
    repositoryDecision: _repositoryDecision(mode, initialized),
    productionDecision:
        'هذه صفحة تشخيص لبيئة Standalone Real-DB Development فقط. لا إنتاج، لا schema apply، ولا service_role داخل Flutter. في v38I-2 يتم تفعيل وضع قاعدة التطوير تلقائيًا عند وجود SUPABASE_URL وSUPABASE_ANON_KEY.',
    checks: checks,
  );
});

Future<NosokSupabaseDiagnosticCheck> _probeNosokSchema(
    SupabaseClient client) async {
  try {
    await client
        .schema('nosok')
        .from('homepage_sections')
        .select('id')
        .limit(1);
    return const NosokSupabaseDiagnosticCheck(
      key: 'nosok_schema_homepage_sections',
      titleAr: 'nosok.homepage_sections',
      status: NosokSupabaseDiagnosticStatus.passed,
      detailAr:
          'جدول nosok.homepage_sections قابل للقراءة عبر anon/RLS. هذا يعني أن schema التطوير مطبقة أو موجودة.',
    );
  } catch (error) {
    return NosokSupabaseDiagnosticCheck(
      key: 'nosok_schema_homepage_sections',
      titleAr: 'nosok.homepage_sections',
      status: NosokSupabaseDiagnosticStatus.warning,
      detailAr:
          'لم ينجح فحص nosok.homepage_sections. هذا متوقع إذا لم يتم تطبيق schema creation pack بعد. التفاصيل المختصرة: ${_shortError(error)}',
    );
  }
}

Future<NosokSupabaseDiagnosticCheck> _probeHomepagePublicRpc(
    SupabaseClient client) async {
  try {
    await client.rpc('rpc_nosok_homepage_sections_public_v1');
    return const NosokSupabaseDiagnosticCheck(
      key: 'homepage_public_rpc',
      titleAr: 'public.rpc_nosok_homepage_sections_public_v1',
      status: NosokSupabaseDiagnosticStatus.passed,
      detailAr: 'RPC العامة لأقسام الصفحة الرئيسية موجودة وتستجيب.',
    );
  } catch (error) {
    return NosokSupabaseDiagnosticCheck(
      key: 'homepage_public_rpc',
      titleAr: 'public.rpc_nosok_homepage_sections_public_v1',
      status: NosokSupabaseDiagnosticStatus.warning,
      detailAr:
          'RPC العامة غير متاحة بعد أو رُفضت بسبب RLS/صلاحيات. هذا طبيعي قبل schema apply. التفاصيل المختصرة: ${_shortError(error)}',
    );
  }
}

Future<NosokSupabaseDiagnosticCheck> _probeCoreReferenceReadinessRpc(
    SupabaseClient client) async {
  try {
    await client.rpc('rpc_nosok_core_reference_shape_readiness_v1');
    return const NosokSupabaseDiagnosticCheck(
      key: 'core_reference_readiness_rpc',
      titleAr: 'public.rpc_nosok_core_reference_shape_readiness_v1',
      status: NosokSupabaseDiagnosticStatus.passed,
      detailAr: 'RPC فحص core reference جاهزة وتستجيب.',
    );
  } catch (error) {
    return NosokSupabaseDiagnosticCheck(
      key: 'core_reference_readiness_rpc',
      titleAr: 'public.rpc_nosok_core_reference_shape_readiness_v1',
      status: NosokSupabaseDiagnosticStatus.pending,
      detailAr:
          'RPC فحص core المرجعي غير مطبقة بعد. يجب تشغيل shape discovery read-only قبل أي DDL. التفاصيل المختصرة: ${_shortError(error)}',
    );
  }
}

String _repositoryDecision(String mode, bool initialized) {
  if (mode == 'preview') {
    return 'NosokInMemoryRepository — وضع معاينة، لا اتصال قاعدة بيانات.';
  }
  if (mode == 'standaloneSupabaseDevelopment' && initialized) {
    return 'NosokSupabaseRepository — متاح للاختبار read-only/controlled RPC حسب وجود schema/RPC.';
  }
  if (mode == 'standaloneSupabaseDevelopment' && !initialized) {
    return 'Fallback إلى InMemory حتى تكتمل .env وتهيئة Supabase.';
  }
  if (mode == 'platformHosted') {
    return 'PalWakfHostedRepository لاحقًا داخل المنصة؛ غير منفذ في مسار نسك standalone.';
  }
  return 'وضع غير معروف؛ fallback آمن إلى preview.';
}

String _shortError(Object error) {
  final text = error.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  if (text.length <= 220) return text;
  return '${text.substring(0, 220)}…';
}
