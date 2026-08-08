import 'package:flutter/material.dart';

Future<void> confirmCrudDelete(
  BuildContext context,
  Future<void> Function() onDelete,
) async {
  final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الحذف'),
          content: const Text('سيتم حذف السجل المحدد. هل تريد المتابعة؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('حذف'),
            ),
          ],
        ),
      ) ??
      false;
  if (!confirmed) return;
  await onDelete();
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف السجل.')),
    );
  }
}

String? requiredText(String? value) =>
    (value ?? '').trim().isEmpty ? 'هذا الحقل مطلوب' : null;

String formatDateYmd(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

Future<bool> showConfirmDialog(BuildContext context, String message) async {
  return (await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد الإجراء'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('متابعة'),
            ),
          ],
        ),
      )) ??
      false;
}
