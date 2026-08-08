import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/pwf_waqf_assets_access.dart';
import '../../application/pwf_waqf_assets_providers.dart';
import '../../domain/models/pwf_waqf_asset_operational_read_console.dart';
import '../../domain/models/pwf_waqf_asset_summary.dart';
import '../../routing/pwf_waqf_assets_route_paths.dart';
import '../../utils/pwf_waqf_assets_runtime_messages.dart';
import '../widgets/pwf_waqf_assets_access_gate.dart';

/// Read-only user-facing workspace for Waqf Assets.
///
/// This page is intentionally built on top of the same governed read surfaces
/// used by the Operational Read Console. It does not expose create/review/apply
/// actions and does not call any write RPC.
class PwfWaqfAssetsUserScreensPage extends ConsumerStatefulWidget {
  const PwfWaqfAssetsUserScreensPage({
    super.key,
    this.unitSlug,
  });

  static const routePath = PwfWaqfAssetsRoutePaths.userScreens;

  final String? unitSlug;

  @override
  ConsumerState<PwfWaqfAssetsUserScreensPage> createState() =>
      _PwfWaqfAssetsUserScreensPageState();
}

class _PwfWaqfAssetsUserScreensPageState
    extends ConsumerState<PwfWaqfAssetsUserScreensPage> {
  late final TextEditingController _assetIdController;
  late final TextEditingController _queryController;
  int _limit = 25;
  PwfWaqfAssetsOperationalReadConsoleFilter _filter =
      const PwfWaqfAssetsOperationalReadConsoleFilter(limit: 25);

  @override
  void initState() {
    super.initState();
    _assetIdController = TextEditingController();
    _queryController = TextEditingController();
  }

  @override
  void dispose() {
    _assetIdController.dispose();
    _queryController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filter = PwfWaqfAssetsOperationalReadConsoleFilter(
        waqfAssetId: _assetIdController.text.trim(),
        query: _queryController.text.trim(),
        limit: _limit,
      );
    });
  }

  void _clearFilters() {
    _assetIdController.clear();
    _queryController.clear();
    setState(() {
      _limit = 25;
      _filter = const PwfWaqfAssetsOperationalReadConsoleFilter(limit: 25);
    });
  }

  String _scopedPath(String centralPath) {
    final slug = widget.unitSlug?.trim();
    if (slug == null || slug.isEmpty) return centralPath;
    if (!centralPath.startsWith('/systems/awqaf-system')) return centralPath;
    return '/$slug${centralPath}';
  }

  String _detailPath(String waqfAssetId) {
    return _scopedPath(PwfWaqfAssetsRoutePaths.detailFor(waqfAssetId));
  }

  @override
  Widget build(BuildContext context) {
    final access = ref.watch(pwfWaqfAssetsAccessProvider);
    if (access.isLoading) {
      return const PwfWaqfAssetsAccessLoadingScaffold(
        title: 'شاشات مستخدمي الأصول الوقفية',
      );
    }
    if (!access.canRead) {
      return PwfWaqfAssetsAccessDeniedScaffold(
        title: 'شاشات مستخدمي الأصول الوقفية',
        access: access,
      );
    }

    final request = PwfWaqfAssetsOperationalReadConsoleRequest(
      unitSlug: widget.unitSlug,
      filter: _filter,
    );
    final consoleAsync =
        ref.watch(pwfWaqfAssetsOperationalReadConsoleProvider(request));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('شاشات مستخدمي الأصول الوقفية'),
          actions: [
            IconButton(
              tooltip: 'تحديث شاشة المستخدم',
              onPressed: () => ref.invalidate(
                pwfWaqfAssetsOperationalReadConsoleProvider(request),
              ),
              icon: const Icon(Icons.refresh_rounded),
            ),
            PopupMenuButton<String>(
              tooltip: 'انتقال سريع',
              onSelected: (value) => context.go(_scopedPath(value)),
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: PwfWaqfAssetsRoutePaths.operationalReadConsole,
                  child: Text('كونسول القراءة التشغيلية'),
                ),
                PopupMenuItem(
                  value: PwfWaqfAssetsRoutePaths.sourceRecords,
                  child: Text('سجلات المصادر'),
                ),
                PopupMenuItem(
                  value: PwfWaqfAssetsRoutePaths.root,
                  child: Text('سجل الأصول'),
                ),
              ],
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PwfWaqfAssetsAccessNotice(access: access),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: _UserScreensHeader(unitSlug: widget.unitSlug),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: _UserSearchCard(
                    assetIdController: _assetIdController,
                    queryController: _queryController,
                    limit: _limit,
                    onLimitChanged: (value) => setState(() => _limit = value),
                    onApply: _applyFilters,
                    onClear: _clearFilters,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(
                  child: consoleAsync.when(
                    data: (console) => _UserScreensBody(
                      console: console,
                      unitSlug: widget.unitSlug,
                      onOpenAsset: (id) => context.go(_detailPath(id)),
                      onOpenConsole: () => context.go(
                        _scopedPath(
                          PwfWaqfAssetsRoutePaths.operationalReadConsole,
                        ),
                      ),
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => _UserErrorCard(
                      messageAr: pwfWaqfAssetsSafeErrorMessage(
                        error,
                        actionAr: 'تحميل شاشات مستخدمي الأصول الوقفية',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserScreensHeader extends StatelessWidget {
  const _UserScreensHeader({this.unitSlug});

  final String? unitSlug;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  child: Icon(
                    Icons.person_search_rounded,
                    color: scheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  'واجهة المستخدمين للأصول الوقفية',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                _UserChip(
                  label: unitSlug == null ? 'نطاق مركزي' : 'وحدة: $unitSlug',
                ),
                const _UserChip(label: 'read-only'),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'شاشة مستخدم تشغيلية مبسطة للبحث عن أصل وقفي، قراءة ملخصه، مشاهدة سجلات المصدر المرتبطة، وفهم حالة الصلاحية دون فتح أي مسار كتابة أو مراجعة أو اعتماد.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserSearchCard extends StatelessWidget {
  const _UserSearchCard({
    required this.assetIdController,
    required this.queryController,
    required this.limit,
    required this.onLimitChanged,
    required this.onApply,
    required this.onClear,
  });

  final TextEditingController assetIdController;
  final TextEditingController queryController;
  final int limit;
  final ValueChanged<int> onLimitChanged;
  final VoidCallback onApply;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 320,
              child: TextField(
                controller: assetIdController,
                decoration: const InputDecoration(
                  labelText: 'رقم الأصل أو waqf_asset_id',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => onApply(),
              ),
            ),
            SizedBox(
              width: 320,
              child: TextField(
                controller: queryController,
                decoration: const InputDecoration(
                  labelText: 'بحث باسم الأصل أو الكود أو المصدر',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => onApply(),
              ),
            ),
            SizedBox(
              width: 140,
              child: DropdownButtonFormField<int>(
                initialValue: limit,
                decoration: const InputDecoration(
                  labelText: 'الحد',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                items: const [10, 25, 50]
                    .map(
                      (value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text('$value'),
                      ),
                    )
                    .toList(),
                onChanged: (value) => onLimitChanged(value ?? 25),
              ),
            ),
            FilledButton.icon(
              onPressed: onApply,
              icon: const Icon(Icons.search_rounded),
              label: const Text('بحث'),
            ),
            OutlinedButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.clear_all_rounded),
              label: const Text('مسح'),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserScreensBody extends StatelessWidget {
  const _UserScreensBody({
    required this.console,
    required this.unitSlug,
    required this.onOpenAsset,
    required this.onOpenConsole,
  });

  final PwfWaqfAssetsOperationalReadConsole console;
  final String? unitSlug;
  final ValueChanged<String> onOpenAsset;
  final VoidCallback onOpenConsole;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UserMetricRow(console: console),
        const SizedBox(height: 12),
        _ActorReadOnlyCard(runtimeAuth: console.runtimeAuth),
        const SizedBox(height: 12),
        if (console.assetsErrorAr != null)
          _UserErrorCard(messageAr: console.assetsErrorAr!),
        if (console.sourceRecordsErrorAr != null)
          _UserErrorCard(messageAr: console.sourceRecordsErrorAr!),
        _UserAssetsSection(
          assets: console.assetSummaries,
          onOpenAsset: onOpenAsset,
        ),
        const SizedBox(height: 12),
        _UserSourceRecordsSection(records: console.sourceRecords),
        const SizedBox(height: 12),
        _UserJourneySection(
          unitSlug: unitSlug,
          onOpenConsole: onOpenConsole,
        ),
        const SizedBox(height: 12),
        const _UserWriteBoundaryCard(),
      ],
    );
  }
}

class _UserMetricRow extends StatelessWidget {
  const _UserMetricRow({required this.console});

  final PwfWaqfAssetsOperationalReadConsole console;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth >= 860 ? 200.0 : double.infinity;
        final cards = <Widget>[
          _UserMetricCard(
            title: 'الأصول المتاحة',
            value: '${console.assetSummaries.length}',
            icon: Icons.account_balance_outlined,
          ),
          _UserMetricCard(
            title: 'سجلات مصادر',
            value: '${console.sourceRecords.length}',
            icon: Icons.fact_check_outlined,
          ),
          _UserMetricCard(
            title: 'دورة الحياة',
            value: '${console.lifecycleItems.length}',
            icon: Icons.route_outlined,
          ),
          _UserMetricCard(
            title: 'حالة الكتابة',
            value: console.writeStillDisabled ? 'مغلقة' : 'راجع فورًا',
            icon: Icons.lock_outline_rounded,
          ),
        ];
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final card in cards) SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}

class _ActorReadOnlyCard extends StatelessWidget {
  const _ActorReadOnlyCard({required this.runtimeAuth});

  final PwfWaqfAssetsRuntimeAuthSnapshot runtimeAuth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _UserSectionTitle(
              icon: Icons.badge_outlined,
              title: 'هوية المستخدم وحالة الوصول',
              chip: runtimeAuth.accessStatus,
            ),
            const SizedBox(height: 10),
            Text(runtimeAuth.safeMessageAr),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _UserStatusPill(
                  label:
                      runtimeAuth.authenticated ? 'authenticated' : 'anonymous',
                  passed: runtimeAuth.authenticated,
                ),
                _UserStatusPill(
                  label: 'assets read',
                  passed: runtimeAuth.canReadAwqafAssets,
                ),
                _UserStatusPill(
                  label: 'source records',
                  passed: runtimeAuth.canReadSourceRecords,
                ),
                _UserStatusPill(
                  label: 'wrong unit',
                  passed: !runtimeAuth.wrongUnit,
                ),
                const _UserStatusPill(label: 'write disabled', passed: true),
              ],
            ),
            const SizedBox(height: 12),
            DefaultTextStyle.merge(
              style: TextStyle(color: scheme.onSurfaceVariant),
              child: Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  Text('الحساب: ${runtimeAuth.email ?? 'غير معروض'}'),
                  Text(
                      'وحدة المستخدم: ${runtimeAuth.actorUnitSlug ?? 'غير محددة'}'),
                  Text(
                      'الوحدة المطلوبة: ${runtimeAuth.requestedUnitSlug ?? 'مركزي'}'),
                  Text(
                      'السبب: ${runtimeAuth.accessReason ?? runtimeAuth.accessStatus}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserAssetsSection extends StatelessWidget {
  const _UserAssetsSection({
    required this.assets,
    required this.onOpenAsset,
  });

  final List<PwfWaqfAssetSummary> assets;
  final ValueChanged<String> onOpenAsset;

  @override
  Widget build(BuildContext context) {
    return _UserSurfaceCard(
      icon: Icons.account_balance_outlined,
      title: 'نتائج بحث المستخدم',
      subtitle:
          'ملخصات أصول وقفية من public.rpc_waqf_assets_search_v1. الضغط يفتح بطاقة الأصل read-only.',
      emptyMessage: 'لا توجد أصول مطابقة للفلاتر الحالية.',
      isEmpty: assets.isEmpty,
      child: Column(
        children: [
          for (final asset in assets.take(25))
            _UserAssetTile(
              asset: asset,
              onTap:
                  asset.id.trim().isEmpty ? null : () => onOpenAsset(asset.id),
            ),
        ],
      ),
    );
  }
}

class _UserAssetTile extends StatelessWidget {
  const _UserAssetTile({required this.asset, this.onTap});

  final PwfWaqfAssetSummary asset;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: scheme.secondaryContainer,
          child: Icon(
            Icons.account_balance_rounded,
            color: scheme.onSecondaryContainer,
          ),
        ),
        title: Text(
            asset.displayNameAr.isEmpty ? 'أصل وقفي' : asset.displayNameAr),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _UserChip(label: 'id: ${asset.id}'),
              if (asset.nationalAssetCode.isNotEmpty)
                _UserChip(label: 'code: ${asset.nationalAssetCode}'),
              if (asset.assetType != null)
                _UserChip(label: 'type: ${asset.assetType}'),
              if (asset.governorateName != null)
                _UserChip(label: 'محافظة: ${asset.governorateName}'),
              if (asset.lguName != null)
                _UserChip(label: 'هيئة: ${asset.lguName}'),
              if (asset.approvalStatus != null)
                _UserChip(label: 'approval: ${asset.approvalStatus}'),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_left_rounded),
      ),
    );
  }
}

class _UserSourceRecordsSection extends StatelessWidget {
  const _UserSourceRecordsSection({required this.records});

  final List<PwfWaqfAssetsOperationalSourceRecord> records;

  @override
  Widget build(BuildContext context) {
    return _UserSurfaceCard(
      icon: Icons.fact_check_outlined,
      title: 'سجلات المصدر للمستخدم',
      subtitle:
          'معاينة read-only لسجلات المصادر لتفسير مصدر بيانات الأصل قبل أي مراجعة إدارية.',
      emptyMessage: 'لا توجد سجلات مصدر مطابقة.',
      isEmpty: records.isEmpty,
      child: Column(
        children: [
          for (final record in records.take(15))
            _UserPlainTile(
              title: record.normalizedName,
              subtitle:
                  'source=${record.sourceSystem} • review=${record.reviewStatus} • import=${record.importStatus}',
              metadata: [
                'source_record_id: ${record.sourceRecordId}',
                'waqf_asset_id: ${record.waqfAssetId.isEmpty ? 'غير مربوط' : record.waqfAssetId}',
                if (record.sourceBatchId != null)
                  'batch: ${record.sourceBatchId}',
              ],
            ),
        ],
      ),
    );
  }
}

class _UserJourneySection extends StatelessWidget {
  const _UserJourneySection(
      {required this.unitSlug, required this.onOpenConsole});

  final String? unitSlug;
  final VoidCallback onOpenConsole;

  @override
  Widget build(BuildContext context) {
    return _UserSurfaceCard(
      icon: Icons.timeline_rounded,
      title: 'مسارات المستخدم المتاحة',
      subtitle:
          'هذه المسارات تنقل المستخدم إلى القراءة أو التشخيص فقط، ولا تفتح create/review/apply.',
      emptyMessage: '',
      isEmpty: false,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: [
          _UserActionCard(
            icon: Icons.manage_search_rounded,
            title: 'الكونسول التشغيلي',
            subtitle: 'تفاصيل read-only أوسع للأسطح التشغيلية.',
            onTap: onOpenConsole,
          ),
          _UserActionCard(
            icon: Icons.shield_outlined,
            title: 'اعتماد الدخول الموحد',
            subtitle: unitSlug == null
                ? 'المسار المركزي يمر عبر Platform Access Gateway.'
                : 'مسار الوحدة $unitSlug يمر عبر Platform Access Gateway.',
            onTap: null,
          ),
          const _UserActionCard(
            icon: Icons.lock_outline_rounded,
            title: 'الكتابة مغلقة',
            subtitle: 'لا create draft ولا review decision ولا apply.',
            onTap: null,
          ),
        ],
      ),
    );
  }
}

class _UserWriteBoundaryCard extends StatelessWidget {
  const _UserWriteBoundaryCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _UserSectionTitle(
              icon: Icons.lock_outline_rounded,
              title: 'حدود الشاشة',
              chip: 'read-only user screens',
            ),
            SizedBox(height: 10),
            Text(
              'هذه الشاشة لا تنفذ insert/update/delete ولا create-draft ولا review-decision ولا add-note ولا controlled-apply. أي إجراء تشغيلي لاحق يحتاج تفويضًا مستقلًا وحزمة SQL/Browser UAT منفصلة.',
            ),
          ],
        ),
      ),
    );
  }
}

class _UserSurfaceCard extends StatelessWidget {
  const _UserSurfaceCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.emptyMessage,
    required this.isEmpty,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String emptyMessage;
  final bool isEmpty;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _UserSectionTitle(icon: icon, title: title, chip: 'read surface'),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            if (isEmpty)
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(emptyMessage),
              )
            else
              child,
          ],
        ),
      ),
    );
  }
}

class _UserPlainTile extends StatelessWidget {
  const _UserPlainTile({
    required this.title,
    required this.subtitle,
    required this.metadata,
  });

  final String title;
  final String subtitle;
  final List<String> metadata;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title.isEmpty ? 'سجل مصدر' : title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(subtitle),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [for (final item in metadata) _UserChip(label: item)],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserActionCard extends StatelessWidget {
  const _UserActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 260,
      child: Card.outlined(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(icon, color: scheme.primary),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserMetricCard extends StatelessWidget {
  const _UserMetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: scheme.primaryContainer,
              child: Icon(icon, color: scheme.onPrimaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelMedium),
                  Text(
                    value,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserSectionTitle extends StatelessWidget {
  const _UserSectionTitle({
    required this.icon,
    required this.title,
    this.chip,
  });

  final IconData icon;
  final String title;
  final String? chip;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(icon),
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w900),
        ),
        if (chip != null) _UserChip(label: chip!),
      ],
    );
  }
}

class _UserStatusPill extends StatelessWidget {
  const _UserStatusPill({required this.label, required this.passed});

  final String label;
  final bool passed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Chip(
      avatar: Icon(
        passed ? Icons.check_circle_outline : Icons.warning_amber_rounded,
        size: 18,
      ),
      label: Text(label),
      backgroundColor:
          passed ? scheme.secondaryContainer : scheme.errorContainer,
      labelStyle: TextStyle(
        color: passed ? scheme.onSecondaryContainer : scheme.onErrorContainer,
      ),
    );
  }
}

class _UserChip extends StatelessWidget {
  const _UserChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      visualDensity: VisualDensity.compact,
      label: Text(label),
    );
  }
}

class _UserErrorCard extends StatelessWidget {
  const _UserErrorCard({required this.messageAr});

  final String messageAr;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      color: scheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          messageAr,
          style: TextStyle(color: scheme.onErrorContainer),
        ),
      ),
    );
  }
}
