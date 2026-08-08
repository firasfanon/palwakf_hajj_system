import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_service_desk_controller.dart';
import '../../../domain/models/nosok_service_desk_search_result.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminServiceDeskPage extends ConsumerStatefulWidget {
  const NosokAdminServiceDeskPage({super.key});

  @override
  ConsumerState<NosokAdminServiceDeskPage> createState() =>
      _NosokAdminServiceDeskPageState();
}

class _NosokAdminServiceDeskPageState
    extends ConsumerState<NosokAdminServiceDeskPage> {
  late final TextEditingController _queryController;

  @override
  void initState() {
    super.initState();
    _queryController =
        TextEditingController(text: ref.read(nosokServiceDeskQueryProvider));
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _submitSearch() {
    ref.read(nosokServiceDeskQueryProvider.notifier).state =
        _queryController.text.trim();
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(nosokServiceDeskQueryProvider);
    final resultsValue = ref.watch(nosokServiceDeskSearchResultsProvider);
    final scriptsValue = ref.watch(nosokServiceDeskScriptsProvider);

    return NosokPageScaffold(
      title: 'مكتب الخدمة',
      subtitle:
          'واجهة موظف أمامي مربوطة بالبيانات للبحث عن الطلبات والشكاوى والردود الموحدة دون فتح كامل لوحة الإدارة.',
      actions: [
        FilledButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminApplications),
          icon: const Icon(Icons.assignment_outlined),
          label: const Text('كل الطلبات'),
        ),
        OutlinedButton.icon(
          onPressed: () => context.go(NosokSystemRoutes.adminComplaints),
          icon: const Icon(Icons.support_agent_outlined),
          label: const Text('الشكاوى'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'بحث مكتب الخدمة',
          subtitle:
              'ابحث برقم الطلب، رمز التتبع، رقم الهوية، الجوال، أو رقم الشكوى. هذا سطح إداري محمي وليس تتبعًا عامًا.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _queryController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  labelText: 'استعلام مكتب الخدمة',
                  hintText: 'مثال: NSK-DEMO-000001 أو NSK-DEMO-TRACK',
                  prefixIcon: const Icon(Icons.search_outlined),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _queryController.clear();
                            ref
                                .read(nosokServiceDeskQueryProvider.notifier)
                                .state = '';
                          },
                          icon: const Icon(Icons.close_outlined),
                        ),
                ),
                onSubmitted: (_) => _submitSearch(),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _submitSearch,
                  icon: const Icon(Icons.search_outlined),
                  label: const Text('بحث'),
                ),
              ),
              const SizedBox(height: 16),
              resultsValue.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stackTrace) => const Text(
                    'تعذر تنفيذ البحث حاليًا. أعد المحاولة أو عدّل المرشحات.'),
                data: (results) {
                  if (query.trim().length < 2) {
                    return const _SearchHint();
                  }
                  if (results.isEmpty) {
                    return const _EmptySearchResult();
                  }
                  return Column(
                    children: [
                      for (final result in results)
                        _SearchResultTile(result: result),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        scriptsValue.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
            title: 'تعذر تحميل نصوص الخدمة',
            subtitle: 'تعذر تحميل البيانات حاليًا.',
            child:
                const Text('تأكد من تطبيق SQL v17 أو استخدم مستودع المعاينة.'),
          ),
          data: (scripts) => NosokSectionCard(
            title: 'نصوص إجابة موحدة',
            subtitle:
                'تمنع اختلاف الردود بين الموظفين وتدعم المساعد الداخلي لاحقًا.',
            child: Column(
              children: [
                for (final script in scripts)
                  Card.outlined(
                    child: ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: Text(script.titleAr),
                      subtitle: Text(script.bodyAr),
                      trailing: Text(script.category),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return const Text(
        'أدخل حرفين على الأقل لبدء البحث. لا تستخدم هذا السطح لعرض بيانات حساسة خارج صلاحيات الموظف.');
  }
}

class _EmptySearchResult extends StatelessWidget {
  const _EmptySearchResult();

  @override
  Widget build(BuildContext context) {
    return const Card.outlined(
      child: ListTile(
        leading: Icon(Icons.search_off_outlined),
        title: Text('لا توجد نتائج'),
        subtitle: Text('تحقق من رقم الطلب أو رمز التتبع أو رقم الشكوى.'),
      ),
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  const _SearchResultTile({required this.result});

  final NosokServiceDeskSearchResult result;

  @override
  Widget build(BuildContext context) {
    final icon = result.resultType == 'complaint'
        ? Icons.support_agent_outlined
        : Icons.assignment_outlined;
    return Card.outlined(
      child: ListTile(
        leading: Icon(icon),
        title: Text(result.primaryLabel),
        subtitle: Text([
          result.secondaryLabel,
          result.status,
          result.matchedBy == null ? null : 'matched: ${result.matchedBy}',
        ]
            .whereType<String>()
            .where((item) => item.trim().isNotEmpty)
            .join(' — ')),
        trailing: (result.routePath ?? '').trim().isEmpty
            ? null
            : const Icon(Icons.open_in_new_outlined),
        onTap: (result.routePath ?? '').trim().isEmpty
            ? null
            : () => context.go(result.routePath!),
      ),
    );
  }
}
