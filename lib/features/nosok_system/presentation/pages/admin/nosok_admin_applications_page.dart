import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../application/nosok_applications_controller.dart';
import '../../../domain/models/nosok_application.dart';
import '../../../system_routes.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokAdminApplicationsPage extends ConsumerStatefulWidget {
  const NosokAdminApplicationsPage({super.key});

  @override
  ConsumerState<NosokAdminApplicationsPage> createState() =>
      _NosokAdminApplicationsPageState();
}

class _NosokAdminApplicationsPageState
    extends ConsumerState<NosokAdminApplicationsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(nosokApplicationsControllerProvider);

    return NosokPageScaffold(
      title: 'إدارة الطلبات',
      subtitle:
          'قائمة تشغيلية للطلبات مع انتقال مباشر إلى صفحة تفاصيل إدارية كاملة لكل طلب، بما يشمل الوثائق والدفعات والتحقق والحالة وسجل المراجعة.',
      actions: [
        SizedBox(
          width: 320,
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'بحث برقم الطلب أو رمز التتبع أو الاسم أو الهوية',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  ref
                      .read(nosokApplicationsControllerProvider.notifier)
                      .refreshList(query: '');
                },
                icon: const Icon(Icons.clear),
              ),
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (value) => ref
                .read(nosokApplicationsControllerProvider.notifier)
                .refreshList(query: value),
          ),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'الطلبات الحالية',
          child: applicationsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Text('تعذر تحميل الطلبات حاليًا. أعد المحاولة لاحقًا.'),
            data: (applications) {
              if (applications.isEmpty) {
                return const Text('لا توجد طلبات بعد.');
              }
              return Column(
                children: applications
                    .map((application) =>
                        _ApplicationCard(application: application))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.application});

  final NosokApplication application;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(application.applicantFullName,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _chip('رقم الطلب: ${application.applicationNo}'),
                _chip('الحالة: ${application.applicationStatus}'),
                _chip('الأهلية: ${application.eligibilityStatus ?? '-'}'),
                _chip('التتبع: ${application.trackingToken ?? '-'}'),
                if (application.documentsCount != null)
                  _chip('الوثائق: ${application.documentsCount}'),
                if (application.paymentsCount != null)
                  _chip('الدفعات: ${application.paymentsCount}'),
                if (application.totalPaidAmount != null)
                  _chip(
                      'المدفوع: ${application.totalPaidAmount!.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => context.push(
                      NosokSystemRoutes.adminApplicationDetails(
                          application.id)),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('تفاصيل الطلب'),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push(
                      NosokSystemRoutes.adminApplicationDetails(
                          application.id)),
                  icon: const Icon(Icons.upload_file_outlined),
                  label: const Text('الوثائق والدفعات'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _chip(String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: Colors.black12),
    ),
    child: Text(text),
  );
}
