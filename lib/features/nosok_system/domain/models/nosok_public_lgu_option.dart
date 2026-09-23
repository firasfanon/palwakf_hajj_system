class NosokPublicLguOption {
  const NosokPublicLguOption({
    required this.lguId,
    required this.lguNo,
    required this.lguCode,
    required this.lguNameAr,
  });

  final String lguId;
  final int lguNo;
  final String lguCode;
  final String lguNameAr;

  factory NosokPublicLguOption.fromMap(Map<String, dynamic> map) {
    return NosokPublicLguOption(
      lguId: (map['lgu_id'] ?? '').toString(),
      lguNo: (map['lgu_no'] as num?)?.toInt() ?? 0,
      lguCode: (map['lgu_code'] ?? '').toString(),
      lguNameAr: (map['lgu_name_ar'] ?? '').toString(),
    );
  }
}
