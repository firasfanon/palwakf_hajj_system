import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokInternalReviewPage extends StatelessWidget {
  const NosokInternalReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PwfSisSystemHero(
              title: 'مراجعة الطلبات',
              description:
                  'طابور مراجعة منفصل عن الصفحة الرئيسية، مع مؤشرات أولوية ونواقص وDecision Panel.',
              badges: ['review', 'decision-panel']),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'Review Queue',
            child: PwfSisReviewQueue(items: [
              ('NSK-1447-00018', 'أولوية عالية — وثيقة ناقصة', 'priority'),
              ('NSK-1447-00021', 'جاهز للقبول الأولي', 'ready'),
              ('NSK-1447-00025', 'مطلوب تحويل للمديرية', 'transfer'),
            ]),
          ),
          SizedBox(height: 12),
          PwfSisDecisionPanel(actions: [
            FilledButton(onPressed: null, child: Text('قبول أولي')),
            OutlinedButton(onPressed: null, child: Text('طلب استكمال')),
            OutlinedButton(onPressed: null, child: Text('رفض مع سبب')),
            OutlinedButton(onPressed: null, child: Text('تحويل لموظف')),
            TextButton(onPressed: null, child: Text('تعليق داخلي')),
          ]),
          SizedBox(height: 12),
          PwfSisNotice(
              title: 'Role-Based UI',
              message:
                  'الأزرار المعطلة هنا placeholders آمنة في preview. في PalWakf تظهر/تعمل فقط حسب RBAC وحالة الطلب.'),
        ],
      ),
    );
  }
}
