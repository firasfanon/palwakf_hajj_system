import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NosokAsyncView<T> extends StatelessWidget {
  const NosokAsyncView({
    super.key,
    required this.value,
    required this.dataBuilder,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) dataBuilder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: dataBuilder,
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: const Text(
              'تعذر تحميل البيانات حاليًا. أعد المحاولة أو تواصل مع الدعم الفني إذا استمرت المشكلة.'),
        ),
      ),
    );
  }
}
