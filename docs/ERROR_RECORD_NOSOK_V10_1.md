# Error Record — Nosok v10.1

## الخطأ 1 — Web platform missing

**السجل:**
`This application is not configured to build on the web. To add web support to a project, run flutter create .`

**السبب:**
حزمة v10 تضمنت `main.dart` و`pubspec.yaml` لكنها لم تتضمن ملفات Web platform اللازمة للمعاينة.

**الحل:**
إضافة `web/index.html`, `web/manifest.json`, و`.metadata` كحد أدنى لتشغيل Chrome preview.

## الخطأ 2 — NosokSectionCard actions

**السجل:**
`No named parameter with the name 'actions'` في صفحة تفاصيل الطلب الإدارية.

**السبب:**
صفحة التفاصيل تستخدم نمط header actions، بينما `NosokSectionCard` لم يكن يدعم هذا المعامل.

**الحل:**
توسيع `NosokSectionCard` بإضافة `actions` اختيارية وعرضها داخل header مرن.

## الخطأ 3 — NosokStatCard label

**السجل:**
`No named parameter with the name 'label'` في Dashboard وReports.

**السبب:**
عدم توافق اسم المعامل بين الودجت والاستخدامات.

**الحل:**
دعم `label` كـ alias لـ `title` دون كسر الاستخدامات القديمة.

## الخطأ 4 — _companyField غير معرّف

**السجل:**
`The method '_companyField' isn't defined for the type '_CompanyDialogState'`.

**السبب:**
استخدام helper في dialog دون نقله إلى state class.

**الحل:**
إضافة `_companyField` داخل `_CompanyDialogState`.

## آخر baseline مستقر

`nosok_platform_integration_patch_v10_1_compile_web_hotfix_under_platform.zip` بعد إعادة الاختبار المحلي.
