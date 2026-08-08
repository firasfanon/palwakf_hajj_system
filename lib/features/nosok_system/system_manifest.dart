class NosokSystemManifest {
  const NosokSystemManifest._();

  static const systemKeyProposal = 'nosok';
  static const systemNameAr = 'نسك';
  static const systemNameEn = 'Nosok';
  static const hasPublicEntry = true;
  static const hasAdminEntry = true;
  static const dynamicUnitScope = true;

  // Platform reference v73 confirms that final registration is still pending.
  static const platformRegistrationPending = true;
  static const platformMergePackApplicationState =
      'v38b-prejoin-development-closure-applied';
  static const databaseSchemaCreated = false;
  static const databaseSchemaCreationState = 'deferred-until-palwakf-merge';

  static const descriptionAr =
      'نظام شبه مستقل لخدمات الحج والعمرة والشركات المؤهلة والشكاوى وقرعة الحج الحصصية حسب LGU، يعمل تحت منصة PalWakf مع صفحات عامة وإدارية وخطة دمج Registry/RBAC. لم تُنشأ schema قاعدة بيانات نسك بعد عمدًا حتى الدمج الرسمي مع المنصة. v38B يغلق مرحلة التطوير التحضيري قبل الانضمام: public runtime UAT closure، تجهيز Company/Partner workspace، تقوية Evidence Center، مراجعة نهائية لتصميم schema/RPC/RLS، حزمة انضمام PalWakf جاهزة للتسليم، ومصفوفة Role/Responsive كاملة، دون SQL apply ودون تنفيذ الانضمام ودون اعتماد إنتاج.';
}
