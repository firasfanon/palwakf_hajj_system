enum NosokVisualContext {
  publicSystemBody,
  adminInternal,
}

class NosokVisualContextDef {
  const NosokVisualContextDef({
    required this.context,
    required this.labelAr,
    required this.usesSharedPlatformChrome,
    required this.notesAr,
  });

  final NosokVisualContext context;
  final String labelAr;
  final bool usesSharedPlatformChrome;
  final String notesAr;
}

const nosokPublicVisualContext = NosokVisualContextDef(
  context: NosokVisualContext.publicSystemBody,
  labelAr: 'نسك — الواجهة العامة',
  usesSharedPlatformChrome: true,
  notesAr:
      'الهيدر/التوب بار/الفوتر من المنصة، بينما Hero/Nav/Cards الخاصة بنسك تأتي من Body النظام.',
);

const nosokAdminVisualContext = NosokVisualContextDef(
  context: NosokVisualContext.adminInternal,
  labelAr: 'نسك — الإدارة الداخلية',
  usesSharedPlatformChrome: true,
  notesAr:
      'نسك داخل لوحة الإدارة كمسار تشغيلي شبه مستقل، دون إعادة بناء Shell الإداري.',
);
