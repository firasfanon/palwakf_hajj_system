import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/nosok_system/application/access/nosok_access_profile.dart';
import 'features/nosok_system/data/repositories/nosok_in_memory_repository.dart';
import 'features/nosok_system/data/repositories/nosok_supabase_repository.dart';
import 'features/nosok_system/presentation/routes/nosok_routes.dart';
import 'features/nosok_system/system_routes.dart';
import 'features/nosok_system/system_permissions.dart';
import 'features/nosok_system/infrastructure/nosok_runtime_environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // The empty .env placeholder may be replaced locally. If loading fails,
    // the app falls back to dart-define values or preview mode.
  }

  final shouldInitializeSupabase =
      NosokRuntimeEnvironment.shouldInitializeSupabase;

  // v38I-2: Supabase is initialized only for standalone real-db development
  // or platform-hosted mode. If SUPABASE_URL + SUPABASE_ANON_KEY are present,
  // the runtime environment promotes preview placeholders to standaloneSupabaseDevelopment.
  if (shouldInitializeSupabase) {
    await Supabase.initialize(
      url: NosokRuntimeEnvironment.supabaseUrl,
      anonKey: NosokRuntimeEnvironment.supabaseAnonKey,
    );
  }

  runApp(
    ProviderScope(
      overrides: [
        nosokAccessProfileProvider
            .overrideWithValue(_resolveUatAccessProfile()),
        if (!shouldInitializeSupabase)
          nosokRepositoryProvider.overrideWithValue(NosokInMemoryRepository()),
      ],
      child: const NosokStandalonePreviewApp(),
    ),
  );
}

NosokAccessProfile _resolveUatAccessProfile() {
  const key = String.fromEnvironment('NOSOK_UAT_ACCESS_PROFILE',
      defaultValue: 'superuser');
  return switch (key) {
    'anonymous' => NosokAccessProfile.unbound.copyWith(source: 'uat-anonymous'),
    'no_role' => const NosokAccessProfile(
        isAuthenticated: true,
        isSuperuser: false,
        roleKeys: <String>{},
        permissionKeys: <String>{},
        source: 'uat-no-role'),
    'wrong_permission' => const NosokAccessProfile(
        isAuthenticated: true,
        isSuperuser: false,
        roleKeys: <String>{'nosokViewer'},
        permissionKeys: <String>{NosokPermissionKeys.viewNosokDashboard},
        source: 'uat-wrong-permission'),
    'wrong_scope' => const NosokAccessProfile(
        isAuthenticated: true,
        isSuperuser: false,
        roleKeys: <String>{'nosokUnitOfficer'},
        permissionKeys: <String>{NosokPermissionKeys.manageNosokUnits},
        unitIds: <String>{'1b39cc65-dc74-401f-a431-1fbf78cfbd0e'},
        unitSlugs: <String>{'bth'},
        governorateIds: <String>{'17b45c86-a439-47a0-9ca7-085a1f5e75d4'},
        lguIds: <String>{},
        source: 'uat-wrong-scope'),
    'allowed_v39' => const NosokAccessProfile(
        isAuthenticated: true,
        isSuperuser: false,
        roleKeys: <String>{'nosokSupervisor'},
        permissionKeys: <String>{
          NosokPermissionKeys.redecideNosokProductionGate
        },
        source: 'uat-allowed-v39'),
    _ => NosokAccessProfile.standaloneSuperuser,
  };
}

class NosokStandalonePreviewApp extends StatelessWidget {
  const NosokStandalonePreviewApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: NosokSystemRoutes.publicHome,
    routes: <RouteBase>[
      ...NosokRoutes.publicRoutes,
      ...NosokRoutes.adminRoutes,
      GoRoute(
        path: '/',
        redirect: (context, state) => NosokSystemRoutes.publicHome,
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'نسك — معاينة تشغيلية',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0B3D91),
          brightness: Brightness.light,
        ),
        fontFamily: 'Arial',
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      routerConfig: _router,
    );
  }
}
