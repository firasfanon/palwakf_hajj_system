enum NosokServiceType { hajj, umrah, mixed }

enum NosokSeasonStatus { draft, open, closed, archived }

enum NosokCompanyStatus { draft, qualified, suspended, inactive }

enum NosokApplicationStatus {
  draft,
  submitted,
  underReview,
  accepted,
  rejected,
  waitlist,
  closed,
}

enum NosokComplaintStatus {
  submitted,
  underReview,
  inProgress,
  resolved,
  closed,
  rejected,
}

enum NosokPriority { low, normal, high, urgent }

extension NosokEnumX on Enum {
  String get dbValue {
    final raw = name;
    return raw.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}
