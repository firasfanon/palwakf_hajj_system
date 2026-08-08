class NosokSeasonCommandGate {
  const NosokSeasonCommandGate({
    required this.checkKey,
    required this.titleAr,
    this.descriptionAr,
    this.gateType = 'required',
    this.ownerSurface,
    this.routePath,
    this.passed = false,
    this.status = 'pending',
    this.evidenceNote,
    this.blockerCount = 0,
    this.displayOrder = 100,
  });

  final String checkKey;
  final String titleAr;
  final String? descriptionAr;
  final String gateType;
  final String? ownerSurface;
  final String? routePath;
  final bool passed;
  final String status;
  final String? evidenceNote;
  final int blockerCount;
  final int displayOrder;

  bool get isBlocking => !passed && (gateType == 'gate' || blockerCount > 0);

  factory NosokSeasonCommandGate.fromMap(Map<String, dynamic> map) {
    return NosokSeasonCommandGate(
      checkKey: (map['check_key'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? '').toString(),
      descriptionAr: map['description_ar']?.toString(),
      gateType: (map['gate_type'] ?? 'required').toString(),
      ownerSurface: map['owner_surface']?.toString(),
      routePath: map['route_path']?.toString(),
      passed: map['passed'] == true || map['passed']?.toString() == 'true',
      status: (map['status'] ?? 'pending').toString(),
      evidenceNote: map['evidence_note']?.toString(),
      blockerCount: (map['blocker_count'] as num?)?.toInt() ?? 0,
      displayOrder: (map['display_order'] as num?)?.toInt() ?? 100,
    );
  }
}

class NosokSeasonOpenGateDecision {
  const NosokSeasonOpenGateDecision({
    required this.canOpen,
    required this.blockerCount,
    required this.noteAr,
  });

  final bool canOpen;
  final int blockerCount;
  final String noteAr;

  factory NosokSeasonOpenGateDecision.fromMap(Map<String, dynamic> map) {
    return NosokSeasonOpenGateDecision(
      canOpen: map['can_open'] == true || map['can_open']?.toString() == 'true',
      blockerCount: (map['blocker_count'] as num?)?.toInt() ?? 0,
      noteAr: (map['note_ar'] ?? '').toString(),
    );
  }
}
