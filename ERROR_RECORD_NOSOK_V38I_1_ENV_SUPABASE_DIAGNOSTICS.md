# ERROR RECORD — Nosok v38I-1

## المشكلة
تشغيل الموقع لا يتصل بقاعدة البيانات لأن النسخة السابقة كانت تعتمد غالبًا على `String.fromEnvironment` أو وضع preview، بينما المستخدم سينسخ `.env` في جذر المشروع.

## السبب
`flutter run -d chrome` بدون `--dart-define` ومع عدم تحميل `.env` لا يهيئ `Supabase.initialize`، لذلك يبقى نسك على in-memory/preview.

## الحل
- إضافة `flutter_dotenv`.
- تحميل `.env` في `main.dart`.
- إنشاء `NosokRuntimeEnvironment`.
- إضافة صفحة تشخيص اتصال.
- منع أي schema apply قبل فحص البيئة.

## آخر baseline مستقر
`Nosok v38I` قبل هذه الدفعة.
