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
            .overrideWithValue(NosokAccessProfile.standaloneSuperuser),
        if (!shouldInitializeSupabase)
          nosokRepositoryProvider.overrideWithValue(NosokInMemoryRepository()),
      ],
      child: const NosokStandalonePreviewApp(),
    ),
  );
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
