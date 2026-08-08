# PalWakf Governing Guide Appendix — Nosok V19

## New governing additions

### 1. Lifecycle enforcement
يجب أن تنتقل حالات طلبات نسك عبر State Machine فقط. صفحة تفاصيل الطلب تعرض الانتقالات المسموحة حسب الحالة الحالية، وتسجل كل انتقال في سجل lifecycle.

### 2. Follow-up inbox
إجراءات المواطن العامة لا تُعالج داخل صفحة التتبع مباشرة؛ بل تتحول إلى صندوق متابعة إداري محكوم بالصلاحيات والوحدات.

### 3. Notification provider UAT
نسك لا يملك محرك SMS/Email. كل إشعار يُنشئ queue/dispatch contract، ويتم اختبار Adapter عبر UAT ثم يمر لاحقًا لخدمة إشعارات PalWakf.

### 4. Production gate
نجاح v19 لا يعني production approval. يجب إغلاق browser/SQL/role/evidence قبل أي قرار اعتماد.

### 5. Sovereign boundaries
لا تعديل على:
- `waqf_assets`
- `waqf`
- `awqaf_system`
