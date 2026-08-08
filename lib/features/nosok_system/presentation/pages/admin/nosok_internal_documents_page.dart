import 'package:flutter/material.dart';

import '../../widgets/pwf_sis_nosok_components.dart';

class NosokInternalDocumentsPage extends StatelessWidget {
  const NosokInternalDocumentsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          PwfSisSystemHero(
              title: 'مرفقات نسك',
              description:
                  'متابعة الوثائق والتحقق ومعاينة الجودة مع رابط بصري إلى Document Intelligence عند توفره.',
              badges: ['documents', 'quality', 'planned DI']),
          SizedBox(height: 12),
          PwfSisPanel(
            title: 'قائمة المرفقات',
            child: Column(children: [
              PwfSisDocumentPreview(
                  title: 'جواز سفر — NSK-1447-00018', status: 'needs_review'),
              PwfSisDocumentPreview(
                  title: 'صورة شخصية — NSK-1447-00021', status: 'verified'),
              PwfSisDocumentPreview(
                  title: 'إثبات إضافي — NSK-1447-00025', status: 'low_quality'),
            ]),
          ),
          SizedBox(height: 12),
          PwfSisNotice(
              title: 'تكامل Document Intelligence',
              message:
                  'يعرض كـ planned/disabled ما لم تكن خدمة التحليل مفعلة داخل PalWakf، ولا يعمل وهميًا.'),
        ],
      ),
    );
  }
}
