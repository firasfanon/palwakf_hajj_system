import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../system_routes.dart';
import '../../widgets/pwf_sis_nosok_components.dart';

class NosokInternalRequestsPage extends StatefulWidget {
  const NosokInternalRequestsPage({super.key});
  @override
  State<NosokInternalRequestsPage> createState() =>
      _NosokInternalRequestsPageState();
}

class _NosokInternalRequestsPageState extends State<NosokInternalRequestsPage> {
  String _status = 'الكل';
  @override
  Widget build(BuildContext context) {
    final rows = [
      [
        'NSK-1447-00018',
        'أحمد خليل',
        'حج',
        '1447',
        'needs_completion',
        'جواز سفر',
        'مراجع 1',
        'اليوم'
      ],
      [
        'NSK-1447-00021',
        'سمر ناصر',
        'عمرة',
        '1447',
        'under_review',
        'لا يوجد',
        'مراجع 2',
        'أمس'
      ],
      [
        'NSK-1447-00025',
        'محمد عودة',
        'حج',
        '1447',
        'submitted',
        'صورة شخصية',
        'غير مسند',
        'قبل يومين'
      ],
    ];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PwfSisSystemHero(
              title: 'طلبات نسك',
              description:
                  'طابور الطلبات التشغيلي مع فلاتر خفيفة وتحويل تلقائي إلى بطاقات على الشاشات الصغيرة.',
              badges: const ['requests', 'role-scoped']),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'Filter Bar',
            child: Wrap(spacing: 10, runSpacing: 10, children: [
              _filterChip('الكل'),
              _filterChip('submitted'),
              _filterChip('under_review'),
              _filterChip('needs_completion'),
              _filterChip('approved'),
              const SizedBox(
                  width: 220,
                  child: TextField(
                      decoration: InputDecoration(
                          labelText: 'بحث برقم الطلب أو الاسم',
                          border: OutlineInputBorder()))),
              const SizedBox(
                  width: 180,
                  child: TextField(
                      decoration: InputDecoration(
                          labelText: 'الموسم', border: OutlineInputBorder()))),
            ]),
          ),
          const SizedBox(height: 12),
          PwfSisPanel(
            title: 'جدول الطلبات',
            subtitle:
                'Desktop table / Mobile cards. الإجراءات الفعلية تتبع الصلاحية وحالة الطلب.',
            child: PwfSisDataTable(
              columns: const [
                'رقم الطلب',
                'مقدم الطلب',
                'الخدمة',
                'الموسم',
                'الحالة',
                'النواقص',
                'المسؤول',
                'آخر تحديث',
                'الإجراء'
              ],
              rows: [
                for (final row
                    in rows.where((r) => _status == 'الكل' || r[4] == _status))
                  [
                    Text(row[0]),
                    Text(row[1]),
                    Text(row[2]),
                    Text(row[3]),
                    PwfSisStatusBadge(label: row[4]),
                    Text(row[5]),
                    Text(row[6]),
                    Text(row[7]),
                    Wrap(spacing: 6, children: [
                      TextButton(
                          onPressed: () => context.go(
                              NosokSystemRoutes.adminApplicationDetails(
                                  'application-001')),
                          child: const Text('فتح')),
                      TextButton(
                          onPressed: () =>
                              context.go(NosokSystemRoutes.adminReview),
                          child: const Text('مراجعة')),
                    ]),
                  ],
              ],
              cardBuilder: (row) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    row[0],
                    const SizedBox(height: 4),
                    row[1],
                    row[4],
                    const SizedBox(height: 8),
                    row[8]
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String value) => FilterChip(
      label: Text(value),
      selected: _status == value,
      onSelected: (_) => setState(() => _status = value));
}
