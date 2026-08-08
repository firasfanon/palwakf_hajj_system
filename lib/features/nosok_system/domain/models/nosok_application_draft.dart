import 'nosok_application_companion.dart';
import 'nosok_application_document.dart';
import 'nosok_application_payment.dart';

class NosokApplicationDraft {
  const NosokApplicationDraft({
    required this.seasonId,
    required this.programId,
    required this.serviceType,
    required this.applicantFullName,
    required this.nationalId,
    this.birthDate,
    this.gender,
    this.phone,
    this.mobile,
    this.email,
    this.governorateId,
    this.communityId,
    this.addressText,
    this.maritalStatus,
    this.notes,
    this.companions = const <NosokApplicationCompanion>[],
    this.documents = const <NosokApplicationDocument>[],
    this.payments = const <NosokApplicationPayment>[],
  });

  final String seasonId;
  final String programId;
  final String serviceType;
  final String applicantFullName;
  final String nationalId;
  final DateTime? birthDate;
  final String? gender;
  final String? phone;
  final String? mobile;
  final String? email;
  final String? governorateId;
  final String? communityId;
  final String? addressText;
  final String? maritalStatus;
  final String? notes;
  final List<NosokApplicationCompanion> companions;
  final List<NosokApplicationDocument> documents;
  final List<NosokApplicationPayment> payments;

  Map<String, dynamic> toRpcParams() {
    return <String, dynamic>{
      'p_season_id': seasonId,
      'p_program_id': programId,
      'p_service_type': serviceType,
      'p_applicant_full_name': applicantFullName,
      'p_national_id': nationalId,
      'p_birth_date': _formatDate(birthDate),
      'p_gender': gender,
      'p_phone': phone,
      'p_mobile': mobile,
      'p_email': email,
      'p_governorate_id': governorateId,
      'p_community_id': communityId,
      'p_address_text': addressText,
      'p_marital_status': maritalStatus,
      'p_notes': notes,
      'p_companions': companions.map((item) => item.toMap()).toList(),
      'p_documents': documents.map((item) => item.toUpsertMap()).toList(),
      'p_payments': payments.map((item) => item.toUpsertMap()).toList(),
    };
  }

  Map<String, dynamic> toFallbackInsertMap({required String applicationNo}) {
    return <String, dynamic>{
      'season_id': seasonId,
      'program_id': programId,
      'application_no': applicationNo,
      'service_type': serviceType,
      'applicant_full_name': applicantFullName,
      'national_id': nationalId,
      'birth_date': _formatDate(birthDate),
      'gender': gender,
      'phone': phone,
      'mobile': mobile,
      'email': email,
      'governorate_id': governorateId,
      'community_id': communityId,
      'address_text': addressText,
      'marital_status': maritalStatus,
      'application_status': 'submitted',
      'eligibility_status': 'pending',
      'submitted_at': DateTime.now().toIso8601String(),
      'notes': notes,
    };
  }
}

String? _formatDate(DateTime? value) {
  if (value == null) return null;
  return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
}
