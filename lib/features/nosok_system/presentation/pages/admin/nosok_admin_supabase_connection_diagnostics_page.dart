import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_supabase_connection_diagnostics_controller.dart';
import '../../../domain/models/nosok_supabase_connection_diagnostics.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokAdminSupabaseConnectionDiagnosticsPage extends ConsumerWidget {
  const NosokAdminSupabaseConnectionDiagnosticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final diagnostics = ref.watch(nosokSupabaseConnectionDiagnosticsProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: diagnostics.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            PwfSisNotice(
              title: 'تعذر تشغيل تشخيص الاتصال',
              message: error.toString(),
              tone: PwfSisNoticeTone.error,
            ),
          ],
        ),
        data: (snapshot) => _DiagnosticsBody(snapshot: snapshot),
      ),
    );
  }
}

class _DiagnosticsBody extends StatelessWidget {
  const _DiagnosticsBody({required this.snapshot});

  final NosokSupabaseConnectionDiagnostics snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const PwfSisSystemHero(
          title: 'Nosok v38I-1 — Env-Based Supabase Binding Diagnostics',
          description:
              'صفحة تشخيص لتأكيد قراءة ملف .env، وضع Repository، تهيئة Supabase client، وحالة RPC/schema قبل أي تطبيق SQL. الهدف هو فحص بيئة التطوير الحقيقية دون إنشاء جداول ودون اعتماد إنتاج.',
          badges: [
            'v38I-1',
            'env diagnostics',
            'no schema apply',
            'no production approval',
          ],
          actions: [
            PwfSisStatusBadge(
              label: 'diagnostics only',
              icon: Icons.monitor_heart_outlined,
              tone: PwfSisNoticeTone.info,
            ),
            PwfSisStatusBadge(
              label: 'no service_role in Flutter',
              icon: Icons.key_off_outlined,
              tone: PwfSisNoticeTone.warning,
            ),
          ],
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'قرار التشغيل الحالي',
          subtitle: snapshot.repositoryDecision,
          child: Text(snapshot.productionDecision),
        ),
        const SizedBox(height: 12),
        PwfSisAdaptiveWorkspace(
          minTileWidth: 210,
          children: [
            PwfSisMetricCard(
              label: 'Data mode',
              value: snapshot.dataMode,
              subtitle: 'NOSOK_DATA_MODE',
              icon: Icons.toggle_on_outlined,
            ),
            PwfSisMetricCard(
              label: 'Supabase URL',
              value: snapshot.supabaseUrlPresent ? 'PRESENT' : 'MISSING',
              subtitle: snapshot.supabaseUrlMasked,
              icon: Icons.link_outlined,
            ),
            PwfSisMetricCard(
              label: 'Anon key',
              value: snapshot.supabaseAnonKeyPresent ? 'PRESENT' : 'MISSING',
              subtitle: snapshot.supabaseAnonKeyMasked,
              icon: Icons.vpn_key_outlined,
            ),
            PwfSisMetricCard(
              label: 'Client',
              value: snapshot.supabaseInitialized ? 'READY' : 'NOT READY',
              subtitle: 'Supabase.instance.client',
              icon: Icons.storage_outlined,
            ),
          ],
        ),
        const SizedBox(height: 12),
        PwfSisPanel(
          title: 'فحوصات الاتصال والبيئة',
          subtitle:
              'هذه الفحوصات read-only/diagnostic ولا تنشئ schema ولا تعدل البيانات.',
          child: PwfSisDataTable(
            columns: const ['الفحص', 'الحالة', 'التفصيل'],
            rows: [
              for (final check in snapshot.checks)
                [
                  Text(check.titleAr),
                  PwfSisStatusBadge(
                    label: check.status.labelAr,
                    icon: _iconForStatus(check.status),
                    tone: _toneForStatus(check.status),
                  ),
                  Text(check.detailAr),
                ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        const PwfSisNotice(
          title: 'ترتيب التشغيل الصحيح',
          message:
              'انسخ .env في جذر المشروع، شغّل التطبيق، افحص هذه الصفحة، ثم شغّل shape discovery read-only. لا تشغّل schema creation pack قبل مراجعة نتائج الفحص.',
          tone: PwfSisNoticeTone.warning,
        ),
      ],
    );
  }

  static IconData _iconForStatus(NosokSupabaseDiagnosticStatus status) {
    return switch (status) {
      NosokSupabaseDiagnosticStatus.passed => Icons.check_circle_outline,
      NosokSupabaseDiagnosticStatus.warning => Icons.warning_amber_outlined,
      NosokSupabaseDiagnosticStatus.failed => Icons.error_outline,
      NosokSupabaseDiagnosticStatus.pending => Icons.schedule_outlined,
    };
  }

  static PwfSisNoticeTone _toneForStatus(NosokSupabaseDiagnosticStatus status) {
    return switch (status) {
      NosokSupabaseDiagnosticStatus.passed => PwfSisNoticeTone.success,
      NosokSupabaseDiagnosticStatus.warning => PwfSisNoticeTone.warning,
      NosokSupabaseDiagnosticStatus.failed => PwfSisNoticeTone.error,
      NosokSupabaseDiagnosticStatus.pending => PwfSisNoticeTone.neutral,
    };
  }
}
