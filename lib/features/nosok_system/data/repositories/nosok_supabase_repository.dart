import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/nosok_announcement.dart';
import '../../domain/models/nosok_billing_provider_adapter.dart';
import '../../domain/models/nosok_public_tracking_privacy_check.dart';
import '../../domain/models/nosok_production_readiness_evidence.dart';
import '../../domain/models/nosok_application.dart';
import '../../domain/models/nosok_application_companion.dart';
import '../../domain/models/nosok_application_document.dart';
import '../../domain/models/nosok_application_draft.dart';
import '../../domain/models/nosok_application_payment.dart';
import '../../domain/models/nosok_application_review.dart';
import '../../domain/models/nosok_application_lifecycle_transition.dart';
import '../../domain/models/nosok_citizen_followup_action.dart';
import '../../domain/models/nosok_followup_inbox_item.dart';
import '../../domain/models/nosok_notification_dispatch.dart';
import '../../domain/models/nosok_notification_provider_adapter_uat.dart';
import '../../domain/models/nosok_company.dart';
import '../../domain/models/nosok_company_season_qualification.dart';
import '../../domain/models/nosok_complaint.dart';
import '../../domain/models/nosok_dashboard_summary.dart';
import '../../domain/models/nosok_faq_item.dart';

import '../../domain/models/nosok_notification_template.dart';
import '../../domain/models/nosok_operational_item.dart';
import '../../domain/models/nosok_payment_bridge_request.dart';
import '../../domain/models/nosok_role_uat_case.dart';
import '../../domain/models/nosok_role_uat_evidence.dart';
import '../../domain/models/nosok_season.dart';
import '../../domain/models/nosok_service_program.dart';
import '../../domain/models/nosok_unit_scope.dart';
import '../../domain/models/nosok_unit_application_queue_item.dart';
import '../../domain/models/nosok_workflow_bucket.dart';
import '../../domain/models/nosok_service_desk_search_result.dart';
import '../../infrastructure/nosok_runtime_environment.dart';
import '../../domain/models/nosok_season_command_gate.dart';
import 'nosok_in_memory_repository.dart';
import 'nosok_repository.dart';

enum NosokRuntimeDataMode {
  preview,
  standaloneSupabaseDevelopment,
  platformHosted,
}

final nosokRuntimeDataModeProvider = Provider<NosokRuntimeDataMode>((ref) {
  return switch (NosokRuntimeEnvironment.effectiveDataMode) {
    'preview' => NosokRuntimeDataMode.preview,
    'platformHosted' => NosokRuntimeDataMode.platformHosted,
    'standaloneSupabaseDevelopment' =>
      NosokRuntimeDataMode.standaloneSupabaseDevelopment,
    _ => NosokRuntimeDataMode.preview,
  };
});

final nosokRepositoryProvider = Provider<NosokRepository>((ref) {
  final mode = ref.watch(nosokRuntimeDataModeProvider);
  if (mode == NosokRuntimeDataMode.preview) {
    return NosokInMemoryRepository();
  }

  try {
    return NosokSupabaseRepository(Supabase.instance.client);
  } catch (_) {
    return NosokInMemoryRepository();
  }
});

class NosokSupabaseRepository implements NosokRepository {
  NosokSupabaseRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<List<NosokSeason>> listSeasons({bool publicOnly = false}) async {
    if (publicOnly) {
      try {
        final rows = await _client.rpc('rpc_nosok_public_seasons_list_v1');
        return _mapList(rows, NosokSeason.fromMap);
      } catch (_) {
        final rows = await _client
            .schema('nosok')
            .from('seasons')
            .select()
            .eq('is_publicly_visible', true)
            .eq('status', 'open')
            .order('gregorian_year', ascending: false)
            .order('registration_start_at', ascending: false);
        return rows
            .map<NosokSeason>((row) => NosokSeason.fromMap(row))
            .toList();
      }
    }

    final rows = await _client
        .schema('nosok')
        .from('seasons')
        .select()
        .order('gregorian_year', ascending: false)
        .order('registration_start_at', ascending: false);
    return rows.map<NosokSeason>((row) => NosokSeason.fromMap(row)).toList();
  }

  @override
  Future<NosokSeason> saveSeason(NosokSeason season) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_season_upsert_v1',
        params: <String, dynamic>{
          'p_id': season.id.trim().isEmpty ? null : season.id,
          'p_season_code': season.seasonCode,
          'p_title_ar': season.titleAr,
          'p_title_en': season.titleEn,
          'p_service_type': season.serviceType,
          'p_hijri_year': season.hijriYear,
          'p_gregorian_year': season.gregorianYear,
          'p_registration_start_at':
              season.registrationStartAt?.toIso8601String(),
          'p_registration_end_at': season.registrationEndAt?.toIso8601String(),
          'p_status': season.status,
          'p_notes': season.notes,
          'p_is_publicly_visible': season.isPubliclyVisible,
        },
      );
      return _singleFromRpc(rows, NosokSeason.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('seasons')
          .upsert(season.toUpsertMap(), onConflict: 'id')
          .select()
          .single();
      return NosokSeason.fromMap(row);
    }
  }

  @override
  Future<void> deleteSeason(String id) async {
    try {
      await _client.rpc('rpc_nosok_admin_season_delete_v1',
          params: <String, dynamic>{'p_id': id});
    } catch (_) {
      await _client.schema('nosok').from('seasons').delete().eq('id', id);
    }
  }

  @override
  Future<List<NosokServiceProgram>> listPrograms({
    String? seasonId,
    bool publicOnly = false,
    String? serviceType,
  }) async {
    if (publicOnly) {
      try {
        final rows = await _client.rpc(
          'rpc_nosok_public_programs_list_v1',
          params: <String, dynamic>{
            'p_season_id': _nullIfBlank(seasonId),
            'p_service_type': _nullIfBlank(serviceType),
          },
        );
        return _mapList(rows, NosokServiceProgram.fromMap);
      } catch (_) {
        var builder = _client
            .schema('nosok')
            .from('service_programs')
            .select()
            .eq('is_publicly_visible', true)
            .eq('status', 'active');
        if (_hasValue(seasonId)) {
          builder = builder.eq('season_id', seasonId!);
        }
        if (_hasValue(serviceType)) {
          builder = builder.eq('service_type', serviceType!);
        }
        final rows = await builder.order('title_ar');
        return rows
            .map<NosokServiceProgram>((row) => NosokServiceProgram.fromMap(row))
            .toList();
      }
    }

    var builder = _client.schema('nosok').from('service_programs').select();
    if (_hasValue(seasonId)) {
      builder = builder.eq('season_id', seasonId!);
    }
    if (_hasValue(serviceType)) {
      builder = builder.eq('service_type', serviceType!);
    }
    final rows = await builder.order('created_at', ascending: false);
    return rows
        .map<NosokServiceProgram>((row) => NosokServiceProgram.fromMap(row))
        .toList();
  }

  @override
  Future<NosokServiceProgram> saveProgram(NosokServiceProgram program) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_program_upsert_v1',
        params: <String, dynamic>{
          'p_id': program.id.trim().isEmpty ? null : program.id,
          'p_season_id': program.seasonId,
          'p_code': program.code,
          'p_title_ar': program.titleAr,
          'p_title_en': program.titleEn,
          'p_service_type': program.serviceType,
          'p_description': program.description,
          'p_registration_start_at':
              program.registrationStartAt?.toIso8601String(),
          'p_registration_end_at': program.registrationEndAt?.toIso8601String(),
          'p_max_companions': program.maxCompanions,
          'p_notes': program.notes,
          'p_status': program.status,
          'p_is_publicly_visible': program.isPubliclyVisible,
        },
      );
      return _singleFromRpc(rows, NosokServiceProgram.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('service_programs')
          .upsert(program.toUpsertMap(), onConflict: 'id')
          .select()
          .single();
      return NosokServiceProgram.fromMap(row);
    }
  }

  @override
  Future<void> deleteProgram(String id) async {
    try {
      await _client.rpc('rpc_nosok_admin_program_delete_v1',
          params: <String, dynamic>{'p_id': id});
    } catch (_) {
      await _client
          .schema('nosok')
          .from('service_programs')
          .delete()
          .eq('id', id);
    }
  }

  @override
  Future<List<NosokCompany>> listCompanies({
    String? query,
    bool publicOnly = false,
    String? seasonId,
  }) async {
    if (publicOnly) {
      try {
        final rows = await _client.rpc(
          'rpc_nosok_public_companies_list_v1',
          params: <String, dynamic>{
            'p_query': _nullIfBlank(query),
            'p_season_id': _nullIfBlank(seasonId),
          },
        );
        return _mapList(rows, NosokCompany.fromMap);
      } catch (_) {
        var builder = _client
            .schema('nosok')
            .from('qualified_companies')
            .select()
            .eq('is_publicly_visible', true);
        if (_hasValue(query)) {
          final safe = query!.trim();
          builder = builder.or(
              'company_name_ar.ilike.%$safe%,license_no.ilike.%$safe%,address_text.ilike.%$safe%');
        }
        final rows = await builder.order('company_name_ar');
        var companies =
            rows.map<NosokCompany>((row) => NosokCompany.fromMap(row)).toList();
        if (_hasValue(seasonId)) {
          final qualifications =
              await listCompanyQualifications(seasonId: seasonId);
          final qualifiedIds = qualifications
              .where((item) =>
                  item.qualificationStatus == 'qualified' &&
                  item.isPubliclyVisible)
              .map((item) => item.companyId)
              .toSet();
          companies = companies
              .where((item) => qualifiedIds.contains(item.id))
              .toList();
        }
        return companies;
      }
    }

    var builder = _client.schema('nosok').from('qualified_companies').select();
    if (_hasValue(query)) {
      final safe = query!.trim();
      builder = builder.or(
          'company_name_ar.ilike.%$safe%,license_no.ilike.%$safe%,address_text.ilike.%$safe%');
    }
    final rows = await builder.order('company_name_ar');
    return rows.map<NosokCompany>((row) => NosokCompany.fromMap(row)).toList();
  }

  @override
  Future<NosokCompany> saveCompany(NosokCompany company) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_company_upsert_v1',
        params: <String, dynamic>{
          'p_id': company.id.trim().isEmpty ? null : company.id,
          'p_company_name_ar': company.companyNameAr,
          'p_company_name_en': company.companyNameEn,
          'p_license_no': company.licenseNo,
          'p_phone': company.phone,
          'p_mobile': company.mobile,
          'p_email': company.email,
          'p_address_text': company.addressText,
          'p_governorate_id': company.governorateId,
          'p_unit_id': company.unitId,
          'p_status': company.status,
          'p_is_publicly_visible': company.isPubliclyVisible,
          'p_notes': company.notes,
        },
      );
      return _singleFromRpc(rows, NosokCompany.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('qualified_companies')
          .upsert(company.toUpsertMap(), onConflict: 'id')
          .select()
          .single();
      return NosokCompany.fromMap(row);
    }
  }

  @override
  Future<void> deleteCompany(String id) async {
    try {
      await _client.rpc('rpc_nosok_admin_company_delete_v1',
          params: <String, dynamic>{'p_id': id});
    } catch (_) {
      await _client
          .schema('nosok')
          .from('qualified_companies')
          .delete()
          .eq('id', id);
    }
  }

  @override
  Future<List<NosokCompanySeasonQualification>> listCompanyQualifications({
    String? companyId,
    String? seasonId,
  }) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_company_qualifications_list_v1',
        params: <String, dynamic>{
          'p_company_id': _nullIfBlank(companyId),
          'p_season_id': _nullIfBlank(seasonId),
        },
      );
      return _mapList(rows, NosokCompanySeasonQualification.fromMap);
    } catch (_) {
      var builder = _client
          .schema('nosok')
          .from('company_season_qualifications')
          .select();
      if (_hasValue(companyId)) {
        builder = builder.eq('company_id', companyId!);
      }
      if (_hasValue(seasonId)) {
        builder = builder.eq('season_id', seasonId!);
      }
      final rows = await builder.order('created_at', ascending: false);
      return rows
          .map<NosokCompanySeasonQualification>(
              (row) => NosokCompanySeasonQualification.fromMap(row))
          .toList();
    }
  }

  @override
  Future<NosokCompanySeasonQualification> saveCompanyQualification(
    NosokCompanySeasonQualification qualification,
  ) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_company_qualification_upsert_v1',
        params: <String, dynamic>{
          'p_id': qualification.id.trim().isEmpty ? null : qualification.id,
          'p_company_id': qualification.companyId,
          'p_season_id': qualification.seasonId,
          'p_qualification_status': qualification.qualificationStatus,
          'p_is_publicly_visible': qualification.isPubliclyVisible,
          'p_qualification_notes': qualification.qualificationNotes,
          'p_starts_at': qualification.startsAt?.toIso8601String(),
          'p_ends_at': qualification.endsAt?.toIso8601String(),
        },
      );
      return _singleFromRpc(rows, NosokCompanySeasonQualification.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('company_season_qualifications')
          .upsert(qualification.toUpsertMap(), onConflict: 'id')
          .select()
          .single();
      return NosokCompanySeasonQualification.fromMap(row);
    }
  }

  @override
  Future<void> deleteCompanyQualification(String id) async {
    try {
      await _client.rpc('rpc_nosok_admin_company_qualification_delete_v1',
          params: <String, dynamic>{'p_id': id});
    } catch (_) {
      await _client
          .schema('nosok')
          .from('company_season_qualifications')
          .delete()
          .eq('id', id);
    }
  }

  @override
  Future<List<NosokComplaint>> listComplaints({String? query}) async {
    var builder = _client.schema('nosok').from('complaints').select();
    if (_hasValue(query)) {
      final safe = query!.trim();
      builder = builder.or('subject.ilike.%$safe%,complaint_no.ilike.%$safe%');
    }
    final rows = await builder.order('submitted_at', ascending: false);
    return rows
        .map<NosokComplaint>((row) => NosokComplaint.fromMap(row))
        .toList();
  }

  @override
  Future<List<NosokApplication>> listApplications({String? query}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_applications_list_v1',
        params: <String, dynamic>{'p_query': _nullIfBlank(query)},
      );
      return _mapList(rows, NosokApplication.fromMap);
    } catch (_) {
      var builder = _client.schema('nosok').from('applications').select();
      if (_hasValue(query)) {
        final safe = query!.trim();
        builder = builder.or(
            'application_no.ilike.%$safe%,tracking_token.ilike.%$safe%,applicant_full_name.ilike.%$safe%,national_id.ilike.%$safe%');
      }
      final rows = await builder.order('submitted_at', ascending: false);
      return rows
          .map<NosokApplication>((row) => NosokApplication.fromMap(row))
          .toList();
    }
  }

  @override
  Future<NosokApplication?> getApplicationById(String id) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_detail_v1',
        params: <String, dynamic>{'p_application_id': id},
      );
      final mapped = _mapList(rows, NosokApplication.fromMap);
      if (mapped.isNotEmpty) return mapped.first;
    } catch (_) {
      // fallback below
    }

    final row = await _client
        .schema('nosok')
        .from('applications')
        .select(
            'id,season_id,program_id,application_no,tracking_token,tracking_token_issued_at,service_type,applicant_full_name,national_id,application_status,eligibility_status,phone,mobile,email,submitted_at,reviewed_at,address_text,notes')
        .eq('id', id)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    return NosokApplication.fromMap(row);
  }

  @override
  Future<NosokApplication> updateApplicationStatus({
    required String applicationId,
    required String applicationStatus,
    String? eligibilityStatus,
    String? reviewReason,
  }) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_update_status_v1',
        params: <String, dynamic>{
          'p_application_id': applicationId,
          'p_application_status': applicationStatus,
          'p_eligibility_status': _nullIfBlank(eligibilityStatus),
          'p_review_reason': _nullIfBlank(reviewReason),
        },
      );
      return _singleFromRpc(rows, NosokApplication.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('applications')
          .update(<String, dynamic>{
            'application_status': applicationStatus,
            'eligibility_status': _nullIfBlank(eligibilityStatus),
            'reviewed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', applicationId)
          .select()
          .single();
      try {
        await _client
            .schema('nosok')
            .from('application_reviews')
            .insert(<String, dynamic>{
          'application_id': applicationId,
          'review_action': 'status_update',
          'review_reason': reviewReason,
        });
      } catch (_) {}
      return NosokApplication.fromMap(row);
    }
  }

  @override
  Future<NosokApplication> submitApplication(
      NosokApplicationDraft draft) async {
    try {
      final rows = await _client.rpc('rpc_nosok_public_submit_application_v1',
          params: draft.toRpcParams());
      return _singleFromRpc(rows, NosokApplication.fromMap);
    } catch (_) {
      final applicationNo = 'NSK-${DateTime.now().millisecondsSinceEpoch}';
      final row = await _client
          .schema('nosok')
          .from('applications')
          .insert(draft.toFallbackInsertMap(applicationNo: applicationNo))
          .select()
          .single();
      final application = NosokApplication.fromMap(row);
      if (draft.companions.isNotEmpty) {
        final companionRows = draft.companions
            .map((item) => <String, dynamic>{
                  ...item.toMap(),
                  'application_id': application.id
                })
            .toList();
        await _client
            .schema('nosok')
            .from('application_companions')
            .insert(companionRows);
      }
      if (draft.documents.isNotEmpty) {
        final documentRows =
            await Future.wait(draft.documents.map((item) async {
          final payload = await _prepareDocumentPayload(item);
          payload['application_id'] = application.id;
          return payload;
        }));
        await _client
            .schema('nosok')
            .from('application_documents')
            .insert(documentRows);
      }
      if (draft.payments.isNotEmpty) {
        final paymentRows = draft.payments
            .map((item) => <String, dynamic>{
                  ...item.toUpsertMap(),
                  'application_id': application.id
                })
            .toList();
        await _client
            .schema('nosok')
            .from('application_payments')
            .insert(paymentRows);
      }
      await _client
          .schema('nosok')
          .from('application_reviews')
          .insert(<String, dynamic>{
        'application_id': application.id,
        'review_action': 'submit',
        'review_reason': 'Public submission fallback path',
      });
      return application;
    }
  }

  @override
  Future<NosokApplication?> lookupApplicationByTrackingToken(
      String trackingToken) async {
    final normalized = trackingToken.trim().toUpperCase();
    if (normalized.isEmpty) {
      return null;
    }

    try {
      final rows = await _client.rpc(
        'rpc_nosok_public_application_status_by_token_v1',
        params: <String, dynamic>{'p_tracking_token': normalized},
      );
      final mapped = _mapList(rows, NosokApplication.fromMap);
      if (mapped.isNotEmpty) {
        return mapped.first;
      }
    } catch (_) {}

    final row = await _client
        .schema('nosok')
        .from('applications')
        .select(
            'id,season_id,program_id,application_no,tracking_token,tracking_token_issued_at,service_type,applicant_full_name,national_id,application_status,eligibility_status,phone,mobile,email,submitted_at,reviewed_at')
        .eq('tracking_token', normalized)
        .maybeSingle();
    if (row == null) {
      return null;
    }
    return NosokApplication.fromMap(row);
  }

  @override
  Future<List<NosokApplicationCompanion>> listApplicationCompanions(
      String applicationId) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_companions_list_v1',
        params: <String, dynamic>{'p_application_id': applicationId},
      );
      return _mapList(rows, NosokApplicationCompanion.fromMap);
    } catch (_) {
      final rows = await _client
          .schema('nosok')
          .from('application_companions')
          .select()
          .eq('application_id', applicationId)
          .order('created_at');
      return rows
          .map<NosokApplicationCompanion>(
              (row) => NosokApplicationCompanion.fromMap(row))
          .toList();
    }
  }

  @override
  Future<List<NosokApplicationReview>> listApplicationReviews(
      String applicationId) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_reviews_list_v1',
        params: <String, dynamic>{'p_application_id': applicationId},
      );
      return _mapList(rows, NosokApplicationReview.fromMap);
    } catch (_) {
      final rows = await _client
          .schema('nosok')
          .from('application_reviews')
          .select()
          .eq('application_id', applicationId)
          .order('created_at', ascending: false);
      return rows
          .map<NosokApplicationReview>(
              (row) => NosokApplicationReview.fromMap(row))
          .toList();
    }
  }

  @override
  Future<List<NosokApplicationDocument>> listApplicationDocuments(
      String applicationId) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_documents_list_v1',
        params: <String, dynamic>{'p_application_id': applicationId},
      );
      return _mapList(rows, NosokApplicationDocument.fromMap);
    } catch (_) {
      final rows = await _client
          .schema('nosok')
          .from('application_documents')
          .select()
          .eq('application_id', applicationId)
          .order('uploaded_at', ascending: false);
      return rows
          .map<NosokApplicationDocument>(
              (row) => NosokApplicationDocument.fromMap(row))
          .toList();
    }
  }

  @override
  Future<NosokApplicationDocument> saveApplicationDocument(
      NosokApplicationDocument document) async {
    final payload = await _prepareDocumentPayload(document);
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_document_upsert_v1',
        params: <String, dynamic>{
          'p_id': document.id.trim().isEmpty ? null : document.id,
          'p_application_id': document.applicationId,
          'p_document_type': document.documentType,
          'p_document_title': document.documentTitle,
          'p_original_file_name': document.originalFileName,
          'p_file_url': payload['file_url'],
          'p_storage_bucket': payload['storage_bucket'],
          'p_storage_path': payload['storage_path'],
          'p_mime_type': document.mimeType,
          'p_file_size_bytes': document.fileSizeBytes,
          'p_review_status': document.reviewStatus,
          'p_review_notes': document.reviewNotes,
          'p_notes': document.notes,
        },
      );
      return _singleFromRpc(rows, NosokApplicationDocument.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('application_documents')
          .upsert(payload, onConflict: 'id')
          .select()
          .single();
      return NosokApplicationDocument.fromMap(row);
    }
  }

  @override
  Future<void> deleteApplicationDocument(String id) async {
    try {
      await _client.rpc('rpc_nosok_admin_application_document_delete_v1',
          params: <String, dynamic>{'p_id': id});
    } catch (_) {
      await _client
          .schema('nosok')
          .from('application_documents')
          .delete()
          .eq('id', id);
    }
  }

  @override
  Future<List<NosokApplicationPayment>> listApplicationPayments(
      String applicationId) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_payments_list_v1',
        params: <String, dynamic>{'p_application_id': applicationId},
      );
      return _mapList(rows, NosokApplicationPayment.fromMap);
    } catch (_) {
      final rows = await _client
          .schema('nosok')
          .from('application_payments')
          .select()
          .eq('application_id', applicationId)
          .order('created_at', ascending: false);
      return rows
          .map<NosokApplicationPayment>(
              (row) => NosokApplicationPayment.fromMap(row))
          .toList();
    }
  }

  @override
  Future<NosokApplicationPayment> saveApplicationPayment(
      NosokApplicationPayment payment) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_payment_upsert_v1',
        params: <String, dynamic>{
          'p_id': payment.id.trim().isEmpty ? null : payment.id,
          'p_application_id': payment.applicationId,
          'p_payment_type': payment.paymentType,
          'p_amount': payment.amount,
          'p_currency_code': payment.currencyCode,
          'p_payment_reference': payment.paymentReference,
          'p_payment_method': payment.paymentMethod,
          'p_provider_name': payment.providerName,
          'p_external_transaction_id': payment.externalTransactionId,
          'p_receipt_url': payment.receiptUrl,
          'p_receipt_storage_bucket': payment.receiptStorageBucket,
          'p_receipt_storage_path': payment.receiptStoragePath,
          'p_receipt_original_file_name': payment.receiptOriginalFileName,
          'p_receipt_mime_type': payment.receiptMimeType,
          'p_receipt_file_size_bytes': payment.receiptFileSizeBytes,
          'p_paid_at': payment.paidAt?.toIso8601String(),
          'p_payment_status': payment.paymentStatus,
          'p_verification_status': payment.verificationStatus,
          'p_verification_notes': payment.verificationNotes,
          'p_notes': payment.notes,
        },
      );
      return _singleFromRpc(rows, NosokApplicationPayment.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('application_payments')
          .upsert(payment.toUpsertMap(), onConflict: 'id')
          .select()
          .single();
      return NosokApplicationPayment.fromMap(row);
    }
  }

  @override
  Future<NosokApplicationPayment> verifyApplicationPayment({
    required String paymentId,
    required String applicationId,
    required String verificationStatus,
    String? verificationNotes,
    String? paymentStatus,
  }) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_application_payment_verify_v1',
        params: <String, dynamic>{
          'p_payment_id': paymentId,
          'p_application_id': applicationId,
          'p_verification_status': verificationStatus,
          'p_verification_notes': _nullIfBlank(verificationNotes),
          'p_payment_status': _nullIfBlank(paymentStatus),
        },
      );
      return _singleFromRpc(rows, NosokApplicationPayment.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('application_payments')
          .update(<String, dynamic>{
            'verification_status': verificationStatus,
            'verification_notes': _nullIfBlank(verificationNotes),
            'verified_at': DateTime.now().toIso8601String(),
            if (_hasValue(paymentStatus)) 'payment_status': paymentStatus,
          })
          .eq('id', paymentId)
          .select()
          .single();
      try {
        await _client
            .schema('nosok')
            .from('application_reviews')
            .insert(<String, dynamic>{
          'application_id': applicationId,
          'review_action': verificationStatus == 'verified'
              ? 'verify_payment'
              : 'reject_payment',
          'review_reason': verificationNotes,
        });
      } catch (_) {}
      return NosokApplicationPayment.fromMap(row);
    }
  }

  @override
  Future<void> deleteApplicationPayment(String id) async {
    try {
      await _client.rpc('rpc_nosok_admin_application_payment_delete_v1',
          params: <String, dynamic>{'p_id': id});
    } catch (_) {
      await _client
          .schema('nosok')
          .from('application_payments')
          .delete()
          .eq('id', id);
    }
  }

  @override
  Future<List<NosokFaqItem>> listFaqItems() async {
    try {
      final rows = await _client.rpc('rpc_nosok_public_faq_list_v1');
      return _mapList(rows, NosokFaqItem.fromMap);
    } catch (_) {
      final rows = await _client
          .schema('nosok')
          .from('faq_items')
          .select()
          .eq('is_published', true)
          .order('display_order');
      return rows
          .map<NosokFaqItem>((row) => NosokFaqItem.fromMap(row))
          .toList();
    }
  }

  @override
  Future<List<NosokAnnouncement>> listAnnouncements() async {
    try {
      final rows = await _client.rpc('rpc_nosok_public_announcements_list_v1');
      return _mapList(rows, NosokAnnouncement.fromMap);
    } catch (_) {
      final rows = await _client
          .schema('nosok')
          .from('system_announcements')
          .select('id,title_ar,body_ar,display_order,is_published')
          .eq('is_published', true)
          .order('display_order');
      return rows
          .map<NosokAnnouncement>((row) => NosokAnnouncement.fromMap(
              <String, dynamic>{...row, 'priority': row['display_order']}))
          .toList();
    }
  }

  @override
  Future<List<NosokUnitScope>> listUnitScopes() async {
    try {
      final rows = await _client.rpc('rpc_nosok_admin_unit_scopes_v1');
      return _mapList(rows, NosokUnitScope.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('unit_service_scopes')
            .select()
            .order('unit_slug');
        return rows
            .map<NosokUnitScope>((row) => NosokUnitScope.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokUnitScope>[];
      }
    }
  }

  @override
  Future<NosokUnitScope?> getPublicUnitScope(String unitSlug) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_public_unit_surface_v1',
        params: <String, dynamic>{'p_unit_slug': unitSlug},
      );
      final list = _mapList(rows, NosokUnitScope.fromMap);
      return list.isEmpty ? null : list.first;
    } catch (_) {
      try {
        final row = await _client
            .schema('nosok')
            .from('unit_service_scopes')
            .select()
            .eq('unit_slug', unitSlug)
            .eq('is_enabled', true)
            .maybeSingle();
        return row == null ? null : NosokUnitScope.fromMap(row);
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<List<NosokOperationalItem>> listOperationalReadiness() async {
    try {
      final rows =
          await _client.rpc('rpc_nosok_admin_operational_readiness_v1');
      return _mapList(rows, NosokOperationalItem.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('operational_checklist')
            .select()
            .order('severity')
            .order('check_key');
        return rows
            .map<NosokOperationalItem>(
                (row) => NosokOperationalItem.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokOperationalItem>[];
      }
    }
  }

  @override
  Future<List<NosokPaymentBridgeRequest>> listPaymentBridgeRequests() async {
    try {
      final rows =
          await _client.rpc('rpc_nosok_admin_payment_bridge_requests_v1');
      return _mapList(rows, NosokPaymentBridgeRequest.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('payment_bridge_requests')
            .select()
            .order('created_at', ascending: false);
        return rows
            .map<NosokPaymentBridgeRequest>(
                (row) => NosokPaymentBridgeRequest.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokPaymentBridgeRequest>[];
      }
    }
  }

  @override
  Future<NosokPaymentBridgeRequest> createPaymentBridgeRequest({
    required String applicationId,
    String? paymentId,
    double? amount,
    String currencyCode = 'ILS',
    String? paymentMethod,
    String? notes,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_admin_payment_bridge_request_create_v1',
      params: <String, dynamic>{
        'p_application_id': applicationId,
        'p_payment_id': _nullIfBlank(paymentId),
        'p_amount': amount,
        'p_currency_code': currencyCode,
        'p_payment_method': _nullIfBlank(paymentMethod),
        'p_notes': _nullIfBlank(notes),
      },
    );
    return _singleFromRpc(rows, NosokPaymentBridgeRequest.fromMap);
  }

  @override
  Future<NosokPaymentBridgeRequest> executePaymentBridgeRequest({
    required String bridgeRequestId,
    String? providerKey,
    String? paymentChannel,
    String? notes,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_admin_payment_bridge_execute_v1',
      params: <String, dynamic>{
        'p_bridge_request_id': bridgeRequestId,
        'p_provider_key': _nullIfBlank(providerKey),
        'p_payment_channel': _nullIfBlank(paymentChannel),
        'p_notes': _nullIfBlank(notes),
      },
    );
    return _singleFromRpc(rows, NosokPaymentBridgeRequest.fromMap);
  }

  @override
  Future<NosokPaymentBridgeRequest> syncPaymentBridgeRequest({
    required String bridgeRequestId,
    String? providerReference,
    String? notes,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_admin_payment_bridge_sync_v1',
      params: <String, dynamic>{
        'p_bridge_request_id': bridgeRequestId,
        'p_provider_reference': _nullIfBlank(providerReference),
        'p_notes': _nullIfBlank(notes),
      },
    );
    return _singleFromRpc(rows, NosokPaymentBridgeRequest.fromMap);
  }

  @override
  Future<List<NosokRoleUatCase>> listRoleUatCases() async {
    try {
      final rows = await _client.rpc('rpc_nosok_admin_role_uat_matrix_v1');
      return _mapList(rows, NosokRoleUatCase.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('role_uat_matrix')
            .select()
            .order('role_key')
            .order('surface_key');
        return rows
            .map<NosokRoleUatCase>((row) => NosokRoleUatCase.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokRoleUatCase>[];
      }
    }
  }

  @override
  Future<List<NosokRoleUatEvidence>> listRoleUatEvidence(
      {String? matrixCaseId}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_role_uat_evidence_v1',
        params: <String, dynamic>{
          'p_matrix_case_id': _nullIfBlank(matrixCaseId)
        },
      );
      return _mapList(rows, NosokRoleUatEvidence.fromMap);
    } catch (_) {
      try {
        final rows = _hasValue(matrixCaseId)
            ? await _client
                .schema('nosok')
                .from('role_uat_evidence')
                .select()
                .eq('matrix_case_id', matrixCaseId!.trim())
                .order('tested_at', ascending: false)
            : await _client
                .schema('nosok')
                .from('role_uat_evidence')
                .select()
                .order('tested_at', ascending: false);
        return rows
            .map<NosokRoleUatEvidence>(
                (row) => NosokRoleUatEvidence.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokRoleUatEvidence>[];
      }
    }
  }

  @override
  Future<NosokRoleUatEvidence> saveRoleUatEvidence(
      NosokRoleUatEvidence evidence) async {
    final rows = await _client.rpc(
      'rpc_nosok_admin_role_uat_evidence_upsert_v1',
      params: <String, dynamic>{'p_payload': evidence.toUpsertMap()},
    );
    return _singleFromRpc(rows, NosokRoleUatEvidence.fromMap);
  }

  @override
  Future<List<NosokUnitApplicationQueueItem>> listUnitApplicationQueue({
    String? unitId,
    String? unitSlug,
    String? status,
  }) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_unit_application_queue_v1',
        params: <String, dynamic>{
          'p_unit_id': _nullIfBlank(unitId),
          'p_unit_slug': _nullIfBlank(unitSlug),
          'p_status': _nullIfBlank(status),
        },
      );
      return _mapList(rows, NosokUnitApplicationQueueItem.fromMap);
    } catch (_) {
      return const <NosokUnitApplicationQueueItem>[];
    }
  }

  @override
  Future<List<NosokBillingProviderAdapter>>
      listBillingProviderAdapters() async {
    try {
      final rows =
          await _client.rpc('rpc_nosok_admin_billing_provider_adapters_v1');
      return _mapList(rows, NosokBillingProviderAdapter.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('billing_provider_adapters')
            .select()
            .order('provider_key');
        return rows
            .map<NosokBillingProviderAdapter>(
                (row) => NosokBillingProviderAdapter.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokBillingProviderAdapter>[];
      }
    }
  }

  @override
  Future<NosokBillingProviderAdapter> runBillingProviderAdapterHealthCheck(
      {required String adapterId}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_billing_provider_adapter_health_check_v1',
        params: <String, dynamic>{'p_adapter_id': adapterId},
      );
      return _singleFromRpc(rows, NosokBillingProviderAdapter.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('billing_provider_adapters')
          .update(<String, dynamic>{
            'health_status': 'contract_checked',
            'last_health_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', adapterId)
          .select()
          .single();
      return NosokBillingProviderAdapter.fromMap(row);
    }
  }

  @override
  Future<List<NosokPublicTrackingPrivacyCheck>>
      listPublicTrackingPrivacyChecks() async {
    try {
      final rows = await _client
          .rpc('rpc_nosok_admin_public_tracking_privacy_checks_v1');
      return _mapList(rows, NosokPublicTrackingPrivacyCheck.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('public_tracking_privacy_checks')
            .select()
            .order('severity')
            .order('check_key');
        return rows
            .map<NosokPublicTrackingPrivacyCheck>(
                (row) => NosokPublicTrackingPrivacyCheck.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokPublicTrackingPrivacyCheck>[];
      }
    }
  }

  @override
  Future<NosokPublicTrackingPrivacyCheck> savePublicTrackingPrivacyReview({
    required String checkKey,
    required String status,
    String? evidenceNote,
  }) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_public_tracking_privacy_review_upsert_v1',
        params: <String, dynamic>{
          'p_check_key': checkKey,
          'p_status': status,
          'p_evidence_note_ar': _nullIfBlank(evidenceNote),
        },
      );
      return _singleFromRpc(rows, NosokPublicTrackingPrivacyCheck.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('public_tracking_privacy_checks')
          .update(<String, dynamic>{
            'status': status,
            'evidence_note_ar': _nullIfBlank(evidenceNote),
            'last_reviewed_at': DateTime.now().toIso8601String(),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('check_key', checkKey)
          .select()
          .single();
      return NosokPublicTrackingPrivacyCheck.fromMap(row);
    }
  }

  @override
  Future<List<NosokProductionReadinessEvidence>>
      listProductionReadinessEvidence({String? status}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_production_readiness_evidence_v1',
        params: <String, dynamic>{'p_status': _nullIfBlank(status)},
      );
      return _mapList(rows, NosokProductionReadinessEvidence.fromMap);
    } catch (_) {
      try {
        final builder = _client
            .schema('nosok')
            .from('production_readiness_evidence')
            .select();
        final rows = _hasValue(status)
            ? await builder
                .eq('status', status!.trim())
                .order('collected_at', ascending: false)
            : await builder.order('collected_at', ascending: false);
        return rows
            .map<NosokProductionReadinessEvidence>(
                (row) => NosokProductionReadinessEvidence.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokProductionReadinessEvidence>[];
      }
    }
  }

  @override
  Future<NosokProductionReadinessEvidence> saveProductionReadinessEvidence(
      NosokProductionReadinessEvidence evidence) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_admin_production_readiness_evidence_upsert_v1',
        params: <String, dynamic>{'p_payload': evidence.toUpsertMap()},
      );
      return _singleFromRpc(rows, NosokProductionReadinessEvidence.fromMap);
    } catch (_) {
      final row = await _client
          .schema('nosok')
          .from('production_readiness_evidence')
          .upsert(evidence.toUpsertMap(), onConflict: 'id')
          .select()
          .single();
      return NosokProductionReadinessEvidence.fromMap(row);
    }
  }

  @override
  Future<List<NosokNotificationTemplate>> listNotificationTemplates() async {
    try {
      final rows =
          await _client.rpc('rpc_nosok_admin_notification_templates_v1');
      return _mapList(rows, NosokNotificationTemplate.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('notification_templates')
            .select()
            .order('template_key');
        return rows
            .map<NosokNotificationTemplate>(
                (row) => NosokNotificationTemplate.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokNotificationTemplate>[];
      }
    }
  }

  @override
  Future<NosokDashboardSummary> loadDashboardSummary() async {
    try {
      final rows =
          await _client.rpc('rpc_nosok_admin_dashboard_deep_summary_v1');
      if (rows is List && rows.isNotEmpty) {
        return NosokDashboardSummary.fromMap(
            (rows.first as Map).cast<String, dynamic>());
      }
    } catch (_) {}

    try {
      final rows = await _client.rpc('rpc_nosok_admin_dashboard_summary_v1');
      if (rows is List && rows.isNotEmpty) {
        return NosokDashboardSummary.fromMap(
            (rows.first as Map).cast<String, dynamic>());
      }
    } catch (_) {}

    final activeSeasons = await _client
        .schema('nosok')
        .from('seasons')
        .select('id')
        .eq('status', 'open');
    final activePrograms = await _client
        .schema('nosok')
        .from('service_programs')
        .select('id')
        .eq('status', 'active');
    final publishedCompanies = await _client
        .schema('nosok')
        .from('qualified_companies')
        .select('id')
        .eq('is_publicly_visible', true);
    final openComplaints = await _client
        .schema('nosok')
        .from('complaints')
        .select('id')
        .inFilter('status', ['submitted', 'under_review', 'in_progress']);
    final pendingApplications = await _client
        .schema('nosok')
        .from('applications')
        .select('id')
        .inFilter('application_status', ['submitted', 'under_review']);

    return NosokDashboardSummary(
      activeSeasonsCount: activeSeasons.length,
      activeProgramsCount: activePrograms.length,
      publishedCompaniesCount: publishedCompanies.length,
      openComplaintsCount: openComplaints.length,
      pendingApplicationsCount: pendingApplications.length,
    );
  }

  @override
  Future<List<NosokWorkflowBucket>> listWorkflowBuckets() async {
    try {
      final rows =
          await _client.rpc('rpc_nosok_v17_admin_workflow_buckets_bound_v1');
      return _mapList(rows, NosokWorkflowBucket.fromMap);
    } catch (_) {
      try {
        final rows =
            await _client.rpc('rpc_nosok_v16_admin_workflow_buckets_v1');
        return _mapList(rows, NosokWorkflowBucket.fromMap);
      } catch (_) {
        return const <NosokWorkflowBucket>[];
      }
    }
  }

  @override
  Future<List<NosokServiceDeskSearchResult>> searchServiceDesk(
      String query) async {
    if (!_hasValue(query)) {
      return const <NosokServiceDeskSearchResult>[];
    }
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v17_service_desk_search_v1',
        params: <String, dynamic>{'p_query': query.trim()},
      );
      return _mapList(rows, NosokServiceDeskSearchResult.fromMap);
    } catch (_) {
      final applications = await listApplications(query: query);
      return applications.map((application) {
        return NosokServiceDeskSearchResult(
          resultType: 'application',
          entityId: application.id,
          primaryLabel: application.applicationNo,
          secondaryLabel: application.applicantFullName,
          status: application.applicationStatus,
          routePath: '/admin/systems/nosok/applications/${application.id}',
          matchedBy: 'fallback_application_search',
          lastActivityAt: application.submittedAt,
        );
      }).toList();
    }
  }

  @override
  Future<List<NosokServiceDeskScript>> listServiceDeskScripts(
      {String? category}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v17_service_desk_scripts_v1',
        params: <String, dynamic>{'p_category': _nullIfBlank(category)},
      );
      return _mapList(rows, NosokServiceDeskScript.fromMap);
    } catch (_) {
      try {
        var builder = _client
            .schema('nosok')
            .from('service_desk_scripts')
            .select()
            .eq('is_active', true);
        if (_hasValue(category)) {
          builder = builder.eq('category', category!.trim());
        }
        final rows = await builder.order('display_order');
        return rows
            .map<NosokServiceDeskScript>(
                (row) => NosokServiceDeskScript.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokServiceDeskScript>[];
      }
    }
  }

  @override
  Future<List<NosokSeasonCommandGate>> listSeasonCommandGates(
      {String? seasonId}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v17_season_command_gates_v1',
        params: <String, dynamic>{'p_season_id': _nullIfBlank(seasonId)},
      );
      return _mapList(rows, NosokSeasonCommandGate.fromMap);
    } catch (_) {
      return const <NosokSeasonCommandGate>[];
    }
  }

  @override
  Future<NosokSeasonOpenGateDecision> evaluateSeasonOpenGate(
      {String? seasonId}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v17_season_open_gate_decision_v1',
        params: <String, dynamic>{'p_season_id': _nullIfBlank(seasonId)},
      );
      return _singleFromRpc(rows, NosokSeasonOpenGateDecision.fromMap);
    } catch (_) {
      final gates = await listSeasonCommandGates(seasonId: seasonId);
      final blockers = gates.where((gate) => gate.isBlocking).length;
      return NosokSeasonOpenGateDecision(
        canOpen: blockers == 0 && gates.isNotEmpty,
        blockerCount: blockers,
        noteAr: blockers == 0
            ? 'لا توجد blockers ظاهرة في فحص fallback.'
            : 'توجد $blockers blockers تمنع فتح الموسم.',
      );
    }
  }

  @override
  Future<List<NosokApplicationLifecycleRule>> listLifecycleRules(
      {String? fromStatus}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v18_application_lifecycle_rules_v1',
        params: <String, dynamic>{'p_from_status': _nullIfBlank(fromStatus)},
      );
      return _mapList(rows, NosokApplicationLifecycleRule.fromMap);
    } catch (_) {
      return const <NosokApplicationLifecycleRule>[
        NosokApplicationLifecycleRule(
            transitionKey: 'submit_to_review',
            titleAr: 'تحويل للمراجعة',
            fromStatus: 'submitted',
            toStatus: 'under_review'),
        NosokApplicationLifecycleRule(
            transitionKey: 'request_completion',
            titleAr: 'طلب استكمال',
            fromStatus: 'under_review',
            toStatus: 'needs_completion',
            requiresReason: true),
        NosokApplicationLifecycleRule(
            transitionKey: 'approve_application',
            titleAr: 'اعتماد الطلب',
            fromStatus: 'under_review',
            toStatus: 'accepted',
            requiresReason: true),
        NosokApplicationLifecycleRule(
            transitionKey: 'reject_application',
            titleAr: 'رفض الطلب',
            fromStatus: 'under_review',
            toStatus: 'rejected',
            requiresReason: true),
      ];
    }
  }

  @override
  Future<List<NosokApplicationLifecycleTransition>>
      listApplicationLifecycleTransitions({String? applicationId}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v18_application_lifecycle_transitions_v1',
        params: <String, dynamic>{
          'p_application_id': _nullIfBlank(applicationId)
        },
      );
      return _mapList(rows, NosokApplicationLifecycleTransition.fromMap);
    } catch (_) {
      try {
        var builder = _client
            .schema('nosok')
            .from('application_lifecycle_transitions')
            .select();
        if (_hasValue(applicationId)) {
          builder = builder.eq('application_id', applicationId!.trim());
        }
        final rows = await builder.order('created_at', ascending: false);
        return rows
            .map<NosokApplicationLifecycleTransition>(
                (row) => NosokApplicationLifecycleTransition.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokApplicationLifecycleTransition>[];
      }
    }
  }

  @override
  Future<NosokApplicationLifecycleTransition> transitionApplicationLifecycle({
    required String applicationId,
    required String transitionKey,
    String? reasonAr,
    String? noteAr,
  }) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v19_application_transition_enforced_v1',
        params: <String, dynamic>{
          'p_application_id': applicationId,
          'p_transition_key': transitionKey,
          'p_reason_ar': _nullIfBlank(reasonAr),
          'p_note_ar': _nullIfBlank(noteAr),
        },
      );
      return _singleFromRpc(rows, NosokApplicationLifecycleTransition.fromMap);
    } catch (_) {
      final rows = await _client.rpc(
        'rpc_nosok_v18_application_transition_v1',
        params: <String, dynamic>{
          'p_application_id': applicationId,
          'p_transition_key': transitionKey,
          'p_reason_ar': _nullIfBlank(reasonAr),
          'p_note_ar': _nullIfBlank(noteAr),
        },
      );
      return _singleFromRpc(rows, NosokApplicationLifecycleTransition.fromMap);
    }
  }

  @override
  Future<List<NosokCitizenFollowupAction>> listCitizenFollowupActions(
      String trackingToken) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v18_public_followup_actions_v1',
        params: <String, dynamic>{'p_tracking_token': trackingToken.trim()},
      );
      return _mapList(rows, NosokCitizenFollowupAction.fromMap);
    } catch (_) {
      return const <NosokCitizenFollowupAction>[];
    }
  }

  @override
  Future<NosokCitizenFollowupRequest> submitCitizenFollowupAction({
    required String trackingToken,
    required String actionKey,
    String? noteAr,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_v18_public_followup_request_submit_v1',
      params: <String, dynamic>{
        'p_tracking_token': trackingToken.trim(),
        'p_action_key': actionKey,
        'p_note_ar': _nullIfBlank(noteAr),
      },
    );
    return _singleFromRpc(rows, NosokCitizenFollowupRequest.fromMap);
  }

  @override
  Future<List<NosokNotificationDispatch>> listNotificationDispatches(
      {String? status}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v18_admin_notification_dispatch_queue_v1',
        params: <String, dynamic>{'p_status': _nullIfBlank(status)},
      );
      return _mapList(rows, NosokNotificationDispatch.fromMap);
    } catch (_) {
      try {
        var builder = _client
            .schema('nosok')
            .from('notification_dispatch_queue')
            .select();
        if (_hasValue(status)) {
          builder = builder.eq('status', status!.trim());
        }
        final rows = await builder.order('created_at', ascending: false);
        return rows
            .map<NosokNotificationDispatch>(
                (row) => NosokNotificationDispatch.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokNotificationDispatch>[];
      }
    }
  }

  @override
  Future<NosokNotificationDispatch> createNotificationDispatch({
    required String eventKey,
    required String templateKey,
    required String relatedEntityType,
    required String relatedEntityId,
    String channel = 'in_app',
    String recipientScope = 'citizen',
    String? payloadPreviewAr,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_v18_admin_notification_dispatch_create_v1',
      params: <String, dynamic>{
        'p_event_key': eventKey,
        'p_template_key': templateKey,
        'p_channel': channel,
        'p_recipient_scope': recipientScope,
        'p_related_entity_type': relatedEntityType,
        'p_related_entity_id': relatedEntityId,
        'p_payload_preview_ar': _nullIfBlank(payloadPreviewAr),
      },
    );
    return _singleFromRpc(rows, NosokNotificationDispatch.fromMap);
  }

  @override
  Future<NosokNotificationDispatch> markNotificationDispatch({
    required String dispatchId,
    required String status,
    String? providerReference,
    String? errorMessage,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_v18_admin_notification_dispatch_mark_v1',
      params: <String, dynamic>{
        'p_dispatch_id': dispatchId,
        'p_status': status,
        'p_provider_reference': _nullIfBlank(providerReference),
        'p_error_message': _nullIfBlank(errorMessage),
      },
    );
    return _singleFromRpc(rows, NosokNotificationDispatch.fromMap);
  }

  @override
  Future<List<NosokFollowupInboxItem>> listFollowupInbox(
      {String? status, String? unitId}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v19_admin_followup_inbox_v1',
        params: <String, dynamic>{
          'p_status': _nullIfBlank(status),
          'p_unit_id': _nullIfBlank(unitId),
        },
      );
      return _mapList(rows, NosokFollowupInboxItem.fromMap);
    } catch (_) {
      try {
        var builder =
            _client.schema('nosok').from('citizen_followup_requests').select();
        if (_hasValue(status)) {
          builder = builder.eq('status', status!.trim());
        }
        final rows = await builder.order('created_at', ascending: false);
        return rows
            .map<NosokFollowupInboxItem>(
                (row) => NosokFollowupInboxItem.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokFollowupInboxItem>[];
      }
    }
  }

  @override
  Future<NosokFollowupInboxItem> updateFollowupInboxItem({
    required String followupId,
    required String status,
    String? assignedUnitId,
    String? resolutionNoteAr,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_v19_admin_followup_inbox_update_v1',
      params: <String, dynamic>{
        'p_followup_id': followupId,
        'p_status': status,
        'p_assigned_unit_id': _nullIfBlank(assignedUnitId),
        'p_resolution_note_ar': _nullIfBlank(resolutionNoteAr),
      },
    );
    return _singleFromRpc(rows, NosokFollowupInboxItem.fromMap);
  }

  @override
  Future<List<NosokNotificationProviderAdapter>>
      listNotificationProviderAdapters() async {
    try {
      final rows =
          await _client.rpc('rpc_nosok_v19_notification_provider_adapters_v1');
      return _mapList(rows, NosokNotificationProviderAdapter.fromMap);
    } catch (_) {
      try {
        final rows = await _client
            .schema('nosok')
            .from('notification_provider_adapters')
            .select()
            .order('provider_key');
        return rows
            .map<NosokNotificationProviderAdapter>(
                (row) => NosokNotificationProviderAdapter.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokNotificationProviderAdapter>[];
      }
    }
  }

  @override
  Future<List<NosokNotificationProviderUatResult>>
      listNotificationProviderUatResults({String? providerKey}) async {
    try {
      final rows = await _client.rpc(
        'rpc_nosok_v19_notification_provider_uat_results_v1',
        params: <String, dynamic>{'p_provider_key': _nullIfBlank(providerKey)},
      );
      return _mapList(rows, NosokNotificationProviderUatResult.fromMap);
    } catch (_) {
      try {
        var builder = _client
            .schema('nosok')
            .from('notification_provider_uat_results')
            .select();
        if (_hasValue(providerKey)) {
          builder = builder.eq('provider_key', providerKey!.trim());
        }
        final rows = await builder.order('created_at', ascending: false);
        return rows
            .map<NosokNotificationProviderUatResult>(
                (row) => NosokNotificationProviderUatResult.fromMap(row))
            .toList();
      } catch (_) {
        return const <NosokNotificationProviderUatResult>[];
      }
    }
  }

  @override
  Future<NosokNotificationProviderUatResult> runNotificationProviderAdapterUat({
    required String providerKey,
    required String testKey,
    String? evidenceUrl,
  }) async {
    final rows = await _client.rpc(
      'rpc_nosok_v19_notification_provider_adapter_uat_run_v1',
      params: <String, dynamic>{
        'p_provider_key': providerKey,
        'p_test_key': testKey,
        'p_evidence_url': _nullIfBlank(evidenceUrl),
      },
    );
    return _singleFromRpc(rows, NosokNotificationProviderUatResult.fromMap);
  }

  Future<Map<String, dynamic>> _prepareDocumentPayload(
      NosokApplicationDocument document) async {
    String? fileUrl = document.fileUrl;
    if (!_hasValue(fileUrl) &&
        _hasValue(document.storageBucket) &&
        _hasValue(document.storagePath)) {
      try {
        fileUrl = _client.storage
            .from(document.storageBucket!.trim())
            .getPublicUrl(document.storagePath!.trim());
      } catch (_) {
        fileUrl = document.fileUrl;
      }
    }
    return <String, dynamic>{
      ...document.toUpsertMap(),
      'file_url': fileUrl,
    };
  }
}

bool _hasValue(String? value) => (value ?? '').trim().isNotEmpty;
String? _nullIfBlank(String? value) => _hasValue(value) ? value!.trim() : null;

List<T> _mapList<T>(dynamic rows, T Function(Map<String, dynamic>) factory) {
  if (rows is! List) {
    return <T>[];
  }
  return rows
      .cast<dynamic>()
      .map((row) => factory((row as Map).cast<String, dynamic>()))
      .toList();
}

T _singleFromRpc<T>(dynamic rows, T Function(Map<String, dynamic>) factory) {
  if (rows is List && rows.isNotEmpty) {
    return factory((rows.first as Map).cast<String, dynamic>());
  }
  if (rows is Map) {
    return factory(rows.cast<String, dynamic>());
  }
  throw StateError('RPC did not return a usable row');
}
