import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_citizen_followup_controller.dart';
import '../../../domain/models/nosok_citizen_followup_action.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';

class NosokCitizenFollowupPage extends ConsumerStatefulWidget {
  const NosokCitizenFollowupPage({super.key});

  @override
  ConsumerState<NosokCitizenFollowupPage> createState() =>
      _NosokCitizenFollowupPageState();
}

class _NosokCitizenFollowupPageState
    extends ConsumerState<NosokCitizenFollowupPage> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _tokenController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final actionsAsync = ref.watch(nosokCitizenFollowupActionsProvider);
    final submitting =
        ref.watch(nosokCitizenFollowupControllerProvider).isLoading;

    return NosokPageScaffold(
      title: 'استكمال النواقص والمتابعة',
      subtitle:
          'استخدم رقم الطلب أو رمز التتبع لإرسال ملاحظة أو استكمال مطلوب دون عرض أي بيانات حساسة في الصفحة العامة.',
      children: [
        NosokSectionCard(
          title: 'رقم الطلب أو رمز التتبع',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _tokenController,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(
                  labelText: 'رقم الطلب / رمز التتبع',
                  hintText: 'NSK-TRK-...',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _loadActions(),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadActions,
                icon: const Icon(Icons.search_outlined),
                label: const Text('عرض الإجراءات المتاحة'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        actionsAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (error, stackTrace) => NosokSectionCard(
            title: 'تعذر تحميل الإجراءات',
            subtitle: 'تعذر تحميل البيانات حاليًا.',
            child: const Text('تحقق من رمز التتبع ثم أعد المحاولة.'),
          ),
          data: (actions) => NosokSectionCard(
            title: 'الإجراءات المتاحة للمواطن',
            subtitle: actions.isEmpty
                ? 'أدخل رمز تتبع صحيحًا لعرض الإجراءات.'
                : 'اختر الإجراء المناسب ثم أرسل الملاحظة إن لزم.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظة للمراجعة الإدارية',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                for (final action in actions)
                  _ActionTile(
                      action: action,
                      submitting: submitting,
                      onSubmit: () => _submit(action)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _loadActions() {
    final token = _tokenController.text.trim().toUpperCase();
    ref.read(nosokCitizenFollowupTokenProvider.notifier).state = token;
  }

  Future<void> _submit(NosokCitizenFollowupAction action) async {
    final token = _tokenController.text.trim().toUpperCase();
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('أدخل رمز التتبع أولًا.')));
      return;
    }
    final request =
        await ref.read(nosokCitizenFollowupControllerProvider.notifier).submit(
              trackingToken: token,
              actionKey: action.actionKey,
              noteAr: _noteController.text.trim().isEmpty
                  ? null
                  : _noteController.text.trim(),
            );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم إرسال المتابعة: ${request.id}')));
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile(
      {required this.action, required this.submitting, required this.onSubmit});

  final NosokCitizenFollowupAction action;
  final bool submitting;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: ListTile(
        leading: Icon(action.enabled
            ? Icons.playlist_add_check_outlined
            : Icons.block_outlined),
        title: Text(action.titleAr),
        subtitle: Text('${action.descriptionAr}\nالحالة: ${action.status}'),
        trailing: FilledButton(
          onPressed: action.enabled && !submitting ? onSubmit : null,
          child: const Text('إرسال'),
        ),
      ),
    );
  }
}
