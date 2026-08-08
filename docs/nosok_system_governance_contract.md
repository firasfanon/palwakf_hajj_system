# العقد الحاكم التنفيذي — نظام نسك داخل PalWakf

## 1) تعريف النظام
`nosok_system` هو نظام خدمات حج وعمرة وشركات مؤهلة وشكاوى ومواسم، يعمل تحت مظلة منصة PalWakf كنظام شبه مستقل وظيفيًا. في v09 أصبح للنظام shell داخلي، sidebar، صفحات وحدات، صفحات تشغيل، وقوالب RBAC، مع بقاء PalWakf مصدر الهوية والصلاحيات والـ Chrome العام.

## 2) المبادئ الحاكمة
- النظام **System** داخل المنصة، لا صفحة عادية.
- الـ Chrome العام من المنصة.
- الـ Body والسياق الخدمي خاصان بنسك.
- لا تكرار للهوية أو الصلاحيات خارج المنصة.
- الجداول السيادية داخل `nosok` schema.
- بيانات الجغرافيا والوحدات تُقرأ من `core`.
- `admin_users` هو مصدر الهوية الوحيد.
- RBAC عبر platform permissions مع RLS.
- النظام جديد، لذلك يعتمد `flutter_riverpod` الحديثة.
- لا خلط بين CRUD المحتوى وCRUD التشغيل.

## 3) المسؤوليات الوظيفية
### أ) عامة / جمهور
- عرض مواسم الحج والعمرة.
- عرض الشركات المؤهلة.
- عرض التعليمات والشروط والخطوات.
- تقديم طلبات أولية.
- تقديم الشكاوى.
- تتبع حالة الطلب/الشكوى لاحقًا.

### ب) داخلية / إدارية
- إدارة المواسم.
- إدارة البرامج الموسمية.
- إدارة الشركات المؤهلة وربطها بالمواسم.
- مراجعة الطلبات.
- إدارة المدفوعات.
- إدارة القرعة/الفرز.
- إدارة الشكاوى.
- إدارة المحتوى العام الخاص بالنظام.
- التقارير.

## 4) المعمارية العامة
### Shell
- Public routes ضمن Shell المنصة العامة، مع shell داخلي خفيف لنسك.
- Admin routes ضمن `/admin/systems/nosok`، مع shell داخلي وسايدبار خاص داخل PlatformAdminShell.
- `/admin/nosok` legacy redirects فقط.

### Feature Structure
- `features/systems/nosok_system/seasons`
- `features/systems/nosok_system/companies`
- `features/systems/nosok_system/applications`
- `features/systems/nosok_system/complaints`
- `features/systems/nosok_system/content`
- `features/systems/nosok_system/dashboard`

### البيانات
- schema = `nosok`
- القراءة المرجعية من `core`
- لا استعمال لـ `public` كمخزن جداول للنظام

## 5) الجداول التشغيلية الأساسية
- `nosok.seasons`
- `nosok.service_programs`
- `nosok.qualified_companies`
- `nosok.company_season_qualifications`
- `nosok.applications`
- `nosok.application_companions`
- `nosok.application_documents`
- `nosok.application_payments`
- `nosok.application_reviews`
- `nosok.draw_batches`
- `nosok.draw_results`
- `nosok.complaints`
- `nosok.complaint_actions`
- `nosok.system_announcements`
- `nosok.faq_items`
- `nosok.static_content_blocks`

## 6) الصفحات العامة
- `/systems/nosok`
- `/systems/nosok/hajj`
- `/systems/nosok/umrah`
- `/systems/nosok/companies`
- `/systems/nosok/complaints`
- `/systems/nosok/faq`
- `/systems/nosok/announcements`
- `/systems/nosok/apply`
- `/systems/nosok/application-status`

## 7) الصفحات الإدارية
- `/admin/systems/nosok`
- `/admin/systems/nosok/seasons`
- `/admin/systems/nosok/programs`
- `/admin/systems/nosok/companies`
- `/admin/systems/nosok/applications`
- `/admin/systems/nosok/applications/:applicationId`
- `/admin/systems/nosok/complaints`
- `/admin/systems/nosok/content`
- `/admin/systems/nosok/reports`
- `/admin/systems/nosok/units`
- `/admin/systems/nosok/units/:unitId`
- `/admin/systems/nosok/users-roles`
- `/admin/systems/nosok/sidebar`
- `/admin/systems/nosok/settings`
- `/admin/systems/nosok/health`

## 8) الصلاحيات
الصلاحيات القياسية المقترحة:
- `nosok.manageSystem`
- `nosok.manageSeasons`
- `nosok.managePrograms`
- `nosok.manageCompanies`
- `nosok.reviewApplications`
- `nosok.manageDraws`
- `nosok.managePayments`
- `nosok.manageComplaints`
- `nosok.manageContent`
- `nosok.viewReports`
- `nosok.publishResults`

الأدوار الوظيفية المقترحة:
- `superuser`
- `platformAdmin`
- `nosokAdmin`
- `nosokSeasonManager`
- `nosokApplicationsReviewer`
- `nosokComplaintsOfficer`
- `nosokContentManager`
- `nosokCompaniesManager`
- `nosokViewer`

## 9) تكامل المنصة
### مع core
- org_units
- governorates
- communities
- lgus

### مع assistant_core
- FAQ grounding
- explanation of registration steps
- internal guidance for staff
- future workflow assistance

### مع واجهة المنصة العامة
- إضافة بطاقة/مدخل للنظام
- Main Nav خاص بالنظام
- Hero خاص بالنظام
- Header/Footer من المنصة

## 10) المرحلة التنفيذية الحالية — v09
الدفعة الحالية تغلق:
- shell داخلي إداري وعام
- sidebar داخلي لنسك
- صفحات وحدات عامة وإدارية
- صفحة المستخدمين والأدوار والصلاحيات كقوالب RBAC
- صفحة إعدادات النظام
- صفحة الصحة والتشغيل
- SQL runtime contracts للسايدبار والوحدات والإعدادات والصحة

## 11) المرحلة التالية بعد الدمج
- ربط فعلي بالـ router و sidebar
- تنفيذ SQL في Supabase
- تفعيل سياسات RLS النهائية حسب بنية الصلاحيات في المنصة
- استكمال CRUD التفصيلي لكل قسم
- استيراد المواد الموجودة في موقع nosok الحالي


---

## Appendix v10 — Operational Semi-Independent Runtime

تم في v10 تثبيت أن التشغيل شبه المستقل لا يعني استقلالًا سياديًا عن PalWakf، بل يعني امتلاك نسك لحزمة تطوير ومعاينة قابلة للتشغيل، مع بقاء الإنتاج داخل host المنصة.

### ملفات التشغيل
- `pubspec.yaml`
- `lib/main.dart`

هذه الملفات لتشغيل preview/development harness فقط. عند الدمج الإنتاجي، تعمل نسك داخل PalWakf app/router/provider scope.

### AccessProfile
- `nosokAccessProfileProvider` نقطة ربط إلزامية.
- لا يجوز اعتماد مستخدمين أو أدوار داخل نسك كمصدر حاكم.
- Superuser/platformAdmin من PalWakf يجب أن يتجاوز قيود نسك الداخلية.

### Sidebar Filtering
سايدبار نسك الداخلي يفلتر العناصر runtime حسب permission keys من AccessProfile.

### Unit Scope
- `core.org_units` هو المرجع.
- `nosok.unit_service_scopes` يعرّف فقط سطح الخدمة العام/الإداري لنسك لكل وحدة.
