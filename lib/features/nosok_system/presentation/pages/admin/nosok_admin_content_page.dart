import 'package:flutter/material.dart';

class NosokAdminContentPage extends StatelessWidget {
  const NosokAdminContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _ContentCard(
            title: 'إدارة المحتوى',
            body:
                'هذه الصفحة مخصصة لإدارة الإعلانات، FAQ، والنصوص الثابتة الخاصة بنسك وربطها بعرض الواجهة العامة.',
          ),
          SizedBox(height: 16),
          _ContentCard(
            title: 'الدفعة التالية',
            body:
                'إضافة CRUD فعلي لـ system_announcements وfaq_items وstatic_content_blocks مع صلاحيات نشر واعتماد.',
          ),
        ],
      ),
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(body),
          ],
        ),
      ),
    );
  }
}
