import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_complaints_controller.dart';

class NosokAdminComplaintsPage extends ConsumerWidget {
  const NosokAdminComplaintsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintsAsync = ref.watch(nosokComplaintsControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: complaintsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
            child:
                const Text('تعذر تحميل الشكاوى حاليًا. أعد المحاولة لاحقًا.')),
        data: (complaints) {
          if (complaints.isEmpty) {
            return const Center(child: Text('لا توجد شكاوى بعد.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final complaint = complaints[index];
              return Card(
                child: ListTile(
                  title: Text(complaint.subject),
                  subtitle: Text(complaint.complaintNo),
                  trailing: Text(complaint.status),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
