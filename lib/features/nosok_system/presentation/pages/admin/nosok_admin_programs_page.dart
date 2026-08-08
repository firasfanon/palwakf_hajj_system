import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../application/nosok_programs_controller.dart';
import '../../../application/nosok_seasons_controller.dart';
import '../../../domain/models/nosok_season.dart';
import '../../../domain/models/nosok_service_program.dart';
import '../../widgets/nosok_page_scaffold.dart';
import '../../widgets/nosok_section_card.dart';
import 'nosok_admin_crud_helpers.dart';

class NosokAdminProgramsPage extends ConsumerWidget {
  const NosokAdminProgramsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(nosokProgramsControllerProvider);
    final seasonsAsync = ref.watch(nosokSeasonsControllerProvider);

    return NosokPageScaffold(
      title: 'إدارة البرامج',
      subtitle: 'CRUD فعلي لبرامج الحج والعمرة وربطها بالمواسم ونوافذ التسجيل.',
      actions: [
        FilledButton.icon(
          onPressed: seasonsAsync.hasValue && seasonsAsync.value!.isNotEmpty
              ? () => _openProgramDialog(context, ref, seasonsAsync.value!)
              : null,
          icon: const Icon(Icons.add),
          label: const Text('إضافة برنامج'),
        ),
      ],
      children: [
        NosokSectionCard(
          title: 'البرامج الحالية',
          child: seasonsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) =>
                const Text('تعذر تحميل المواسم المرجعية حاليًا.'),
            data: (seasons) {
              final seasonMap = {
                for (final season in seasons) season.id: season.titleAr
              };
              return programsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) =>
                    const Text('تعذر تحميل البرامج حاليًا.'),
                data: (programs) {
                  if (programs.isEmpty) {
                    return const Text('لا توجد برامج حتى الآن.');
                  }
                  return Column(
                    children: programs
                        .map(
                          (program) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(program.titleAr),
                              subtitle: Text(
                                '${seasonMap[program.seasonId] ?? '—'} • ${program.code} • ${program.status} • حد المرافقين: ${program.maxCompanions ?? 0}',
                              ),
                              trailing: Wrap(
                                spacing: 4,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined),
                                    onPressed: () => _openProgramDialog(
                                        context, ref, seasons,
                                        program: program),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline),
                                    onPressed: () => confirmCrudDelete(
                                        context,
                                        () => ref
                                            .read(
                                                nosokProgramsControllerProvider
                                                    .notifier)
                                            .deleteProgram(program.id)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

Future<void> _openProgramDialog(
  BuildContext context,
  WidgetRef ref,
  List<NosokSeason> seasons, {
  NosokServiceProgram? program,
}) async {
  final result = await showDialog<NosokServiceProgram>(
    context: context,
    builder: (context) => _ProgramDialog(seasons: seasons, program: program),
  );
  if (result == null) return;
  try {
    await ref
        .read(nosokProgramsControllerProvider.notifier)
        .saveProgram(result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                program == null ? 'تم إنشاء البرنامج.' : 'تم تحديث البرنامج.')),
      );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text(
                'تعذر حفظ البرنامج حاليًا. راجع البيانات والصلاحية ثم حاول مجددًا.')),
      );
    }
  }
}

class _ProgramDialog extends StatefulWidget {
  const _ProgramDialog({required this.seasons, this.program});

  final List<NosokSeason> seasons;
  final NosokServiceProgram? program;

  @override
  State<_ProgramDialog> createState() => _ProgramDialogState();
}

class _ProgramDialogState extends State<_ProgramDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _titleArController;
  late final TextEditingController _titleEnController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _maxCompanionsController;
  late final TextEditingController _notesController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late String _seasonId;
  late String _serviceType;
  late String _status;
  late bool _isVisible;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    final initial = widget.program ??
        NosokServiceProgram.empty().copyWith(seasonId: widget.seasons.first.id);
    _codeController = TextEditingController(text: initial.code);
    _titleArController = TextEditingController(text: initial.titleAr);
    _titleEnController = TextEditingController(text: initial.titleEn ?? '');
    _descriptionController =
        TextEditingController(text: initial.description ?? '');
    _maxCompanionsController =
        TextEditingController(text: initial.maxCompanions?.toString() ?? '0');
    _notesController = TextEditingController(text: initial.notes ?? '');
    _startDateController = TextEditingController(
        text: initial.registrationStartAt == null
            ? ''
            : formatDateYmd(initial.registrationStartAt!));
    _endDateController = TextEditingController(
        text: initial.registrationEndAt == null
            ? ''
            : formatDateYmd(initial.registrationEndAt!));
    _seasonId = initial.seasonId;
    _serviceType = initial.serviceType;
    _status = initial.status;
    _isVisible = initial.isPubliclyVisible;
    _startDate = initial.registrationStartAt;
    _endDate = initial.registrationEndAt;
  }

  @override
  void dispose() {
    _codeController.dispose();
    _titleArController.dispose();
    _titleEnController.dispose();
    _descriptionController.dispose();
    _maxCompanionsController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.program == null ? 'إضافة برنامج' : 'تعديل برنامج'),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _seasonId,
                    decoration: const InputDecoration(
                        labelText: 'الموسم', border: OutlineInputBorder()),
                    items: widget.seasons
                        .map((season) => DropdownMenuItem(
                            value: season.id, child: Text(season.titleAr)))
                        .toList(),
                    onChanged: (value) => setState(
                        () => _seasonId = value ?? widget.seasons.first.id),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _serviceType,
                    decoration: const InputDecoration(
                        labelText: 'نوع الخدمة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'hajj', child: Text('حج')),
                      DropdownMenuItem(value: 'umrah', child: Text('عمرة')),
                    ],
                    onChanged: (value) =>
                        setState(() => _serviceType = value ?? 'hajj'),
                  ),
                ),
                _programField(_codeController, 'رمز البرنامج',
                    validator: requiredText),
                _programField(_titleArController, 'العنوان بالعربية',
                    validator: requiredText),
                _programField(_titleEnController, 'العنوان بالإنجليزية'),
                SizedBox(
                  width: 300,
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                        labelText: 'الحالة', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'draft', child: Text('مسودة')),
                      DropdownMenuItem(value: 'active', child: Text('نشط')),
                      DropdownMenuItem(
                          value: 'inactive', child: Text('غير نشط')),
                      DropdownMenuItem(value: 'archived', child: Text('مؤرشف')),
                    ],
                    onChanged: (value) =>
                        setState(() => _status = value ?? 'draft'),
                  ),
                ),
                _programField(_maxCompanionsController, 'الحد الأعلى للمرافقين',
                    keyboardType: TextInputType.number),
                _programDateField('بداية نافذة التسجيل', _startDateController,
                    () => _pickDate(isStart: true)),
                _programDateField('نهاية نافذة التسجيل', _endDateController,
                    () => _pickDate(isStart: false)),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'الوصف', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(
                  width: 612,
                  child: TextFormField(
                    controller: _notesController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                        labelText: 'ملاحظات', border: OutlineInputBorder()),
                  ),
                ),
                SwitchListTile(
                  value: _isVisible,
                  onChanged: (value) => setState(() => _isVisible = value),
                  title: const Text('مرئي للجمهور'),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء')),
        FilledButton(
          onPressed: () {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            Navigator.of(context).pop(
              NosokServiceProgram(
                id: widget.program?.id ?? '',
                seasonId: _seasonId,
                code: _codeController.text.trim(),
                titleAr: _titleArController.text.trim(),
                titleEn: _titleEnController.text.trim().isEmpty
                    ? null
                    : _titleEnController.text.trim(),
                serviceType: _serviceType,
                description: _descriptionController.text.trim().isEmpty
                    ? null
                    : _descriptionController.text.trim(),
                registrationStartAt: _startDate,
                registrationEndAt: _endDate,
                maxCompanions:
                    int.tryParse(_maxCompanionsController.text.trim()) ?? 0,
                notes: _notesController.text.trim().isEmpty
                    ? null
                    : _notesController.text.trim(),
                status: _status,
                isPubliclyVisible: _isVisible,
              ),
            );
          },
          child: const Text('حفظ'),
        ),
      ],
    );
  }

  Future<void> _pickDate({required bool isStart}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2100),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
        _startDateController.text = formatDateYmd(picked);
      } else {
        _endDate = picked;
        _endDateController.text = formatDateYmd(picked);
      }
    });
  }
}

Widget _programField(TextEditingController controller, String label,
    {String? Function(String?)? validator, TextInputType? keyboardType}) {
  return SizedBox(
    width: 300,
    child: TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      decoration:
          InputDecoration(labelText: label, border: const OutlineInputBorder()),
    ),
  );
}

Widget _programDateField(
    String label, TextEditingController controller, VoidCallback onTap) {
  return SizedBox(
    width: 300,
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
    ),
  );
}
