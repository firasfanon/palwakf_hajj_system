import 'package:supabase_flutter/supabase_flutter.dart';

class NosokPublicCampaignDto {
  const NosokPublicCampaignDto({
    required this.id,
    required this.campaignCode,
    required this.titleAr,
    required this.serviceType,
    required this.status,
    this.descriptionAr,
    this.seasonYear,
    this.applicationOpenAt,
    this.applicationCloseAt,
  });

  final String id;
  final String campaignCode;
  final String titleAr;
  final String serviceType;
  final String status;
  final String? descriptionAr;
  final int? seasonYear;
  final DateTime? applicationOpenAt;
  final DateTime? applicationCloseAt;

  factory NosokPublicCampaignDto.fromMap(Map<String, dynamic> map) {
    final id = (map['id'] ?? map['campaign_id'] ?? '').toString();
    return NosokPublicCampaignDto(
      id: id,
      campaignCode:
          (map['campaign_code'] ?? map['code'] ?? id).toString().trim(),
      titleAr: (map['title_ar'] ?? map['name_ar'] ?? map['title'] ?? 'موسم نسك')
          .toString(),
      serviceType: (map['service_type'] ?? 'hajj').toString(),
      status: (map['status'] ?? 'published').toString(),
      descriptionAr:
          map['description_ar']?.toString() ?? map['summary_ar']?.toString(),
      seasonYear: (map['season_year'] as num?)?.toInt(),
      applicationOpenAt: _parseDateTime(
        map['application_open_at'] ??
            map['registration_start_at'] ??
            map['open_at'],
      ),
      applicationCloseAt: _parseDateTime(
        map['application_close_at'] ??
            map['registration_end_at'] ??
            map['close_at'],
      ),
    );
  }
}

class NosokPublicRequirementDto {
  const NosokPublicRequirementDto({
    required this.id,
    required this.titleAr,
    required this.requirementType,
    this.descriptionAr,
    this.campaignCode,
    this.isMandatory = true,
  });

  final String id;
  final String titleAr;
  final String requirementType;
  final String? descriptionAr;
  final String? campaignCode;
  final bool isMandatory;

  factory NosokPublicRequirementDto.fromMap(Map<String, dynamic> map) {
    return NosokPublicRequirementDto(
      id: (map['id'] ?? map['requirement_id'] ?? map['rule_key'] ?? '')
          .toString(),
      titleAr:
          (map['title_ar'] ?? map['label_ar'] ?? map['title'] ?? 'متطلب نسك')
              .toString(),
      requirementType: (map['requirement_type'] ??
              map['type'] ??
              map['rule_key'] ??
              'general')
          .toString(),
      descriptionAr: map['description_ar']?.toString() ??
          map['help_text_ar']?.toString() ??
          _safeRuleBodyDescription(map['rule_body']),
      campaignCode: map['campaign_code']?.toString(),
      isMandatory: map['is_mandatory'] != false,
    );
  }
}

class NosokPublicSubmitResult {
  const NosokPublicSubmitResult({
    required this.accepted,
    this.applicationId,
    this.applicationNo,
    this.trackingCode,
    this.safeMessageAr,
  });

  final bool accepted;
  final String? applicationId;
  final String? applicationNo;
  final String? trackingCode;
  final String? safeMessageAr;

  factory NosokPublicSubmitResult.fromMap(Map<String, dynamic> map) {
    return NosokPublicSubmitResult(
      accepted: map['accepted'] == true ||
          map['ok'] == true ||
          (map['application_id']?.toString().isNotEmpty ?? false),
      applicationId: map['application_id']?.toString(),
      applicationNo:
          map['application_no']?.toString() ?? map['tracking_code']?.toString(),
      trackingCode:
          map['tracking_code']?.toString() ?? map['tracking_token']?.toString(),
      safeMessageAr:
          map['message_ar']?.toString() ?? map['safe_message_ar']?.toString(),
    );
  }
}

class NosokPublicTrackingResult {
  const NosokPublicTrackingResult({
    required this.found,
    this.applicationNo,
    this.serviceType,
    this.statusAr,
    this.eligibilityStatusAr,
    this.safeMessageAr,
    this.lastPublicEventAr,
    this.submittedAt,
  });

  final bool found;
  final String? applicationNo;
  final String? serviceType;
  final String? statusAr;
  final String? eligibilityStatusAr;
  final String? safeMessageAr;
  final String? lastPublicEventAr;
  final DateTime? submittedAt;

  factory NosokPublicTrackingResult.fromMap(Map<String, dynamic> map) {
    return NosokPublicTrackingResult(
      found: map['found'] == true ||
          map['exists'] == true ||
          (map['tracking_code']?.toString().isNotEmpty ?? false),
      applicationNo:
          map['application_no']?.toString() ?? map['tracking_code']?.toString(),
      serviceType: map['service_type']?.toString(),
      statusAr: map['status_ar']?.toString() ??
          map['application_status_ar']?.toString() ??
          map['application_status']?.toString() ??
          map['status']?.toString(),
      eligibilityStatusAr: map['eligibility_status_ar']?.toString() ??
          map['eligibility_status']?.toString(),
      safeMessageAr:
          map['message_ar']?.toString() ?? map['safe_message_ar']?.toString(),
      lastPublicEventAr: map['last_public_event_ar']?.toString(),
      submittedAt: _parseDateTime(map['submitted_at']),
    );
  }
}

class NosokPublicWrapperRpcAdapter {
  const NosokPublicWrapperRpcAdapter(this._client);

  final SupabaseClient _client;

  Future<List<NosokPublicCampaignDto>> listPublicCampaigns(
      {String? serviceType}) async {
    final serviceTypeValue = _nullIfBlank(serviceType);
    final rows = serviceTypeValue == null
        ? await _rpcList('rpc_nosok_campaigns_public_list_v1')
        : await _rpcListWithFallbacks(
            'rpc_nosok_campaigns_public_list_v1',
            parameterAttempts: [
              <String, dynamic>{'p_service_type': serviceTypeValue},
            ],
          );
    return rows.map(NosokPublicCampaignDto.fromMap).toList(growable: false);
  }

  Future<List<NosokPublicRequirementDto>> listPublicRequirements(
      {String? campaignCode}) async {
    final campaignCodeValue = _nullIfBlank(campaignCode);
    final rows = campaignCodeValue == null
        ? await _rpcList('rpc_nosok_requirements_public_list_v1')
        : await _rpcListWithFallbacks(
            'rpc_nosok_requirements_public_list_v1',
            parameterAttempts: [
              <String, dynamic>{'p_campaign_code': campaignCodeValue},
              <String, dynamic>{'p_campaign_id': campaignCodeValue},
            ],
          );
    return rows.map(NosokPublicRequirementDto.fromMap).toList(growable: false);
  }

  Future<NosokPublicSubmitResult> submitPublicApplication(
      Map<String, dynamic> payload) async {
    try {
      final response = await _client.rpc(
        'rpc_nosok_application_submit_v1',
        params: payload,
      );
      return NosokPublicSubmitResult.fromMap(_firstMap(response));
    } catch (_) {
      throw StateError('تعذر تنفيذ public submit RPC الآمن لنظام نسك.');
    }
  }

  Future<NosokPublicTrackingResult> trackPublicApplication(
      {required String trackingCode}) async {
    final normalized = trackingCode.trim().toUpperCase();
    try {
      final response = await _client.rpc(
        'rpc_nosok_application_track_v1',
        params: <String, dynamic>{'p_tracking_code': normalized},
      );
      return NosokPublicTrackingResult.fromMap(_firstMap(response));
    } catch (_) {
      throw StateError('تعذر تنفيذ public tracking RPC الآمن لنظام نسك.');
    }
  }

  Future<List<Map<String, dynamic>>> _rpcList(
    String fn, {
    Map<String, dynamic>? params,
  }) async {
    final response = params == null
        ? await _client.rpc(fn)
        : await _client.rpc(fn, params: params);
    if (response is List) {
      return response
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList(growable: false);
    }
    if (response is Map) {
      final rows = response['data'] ?? response['rows'] ?? response['items'];
      if (rows is List) {
        return rows
            .whereType<Map>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList(growable: false);
      }
      return <Map<String, dynamic>>[Map<String, dynamic>.from(response)];
    }
    return const <Map<String, dynamic>>[];
  }

  Future<List<Map<String, dynamic>>> _rpcListWithFallbacks(
    String fn, {
    required List<Map<String, dynamic>> parameterAttempts,
  }) async {
    Object? lastError;
    for (final params in parameterAttempts) {
      try {
        return await _rpcList(fn, params: params);
      } catch (error) {
        lastError = error;
      }
    }
    try {
      return await _rpcList(fn);
    } catch (_) {
      if (lastError != null) throw lastError;
      rethrow;
    }
  }

  Map<String, dynamic> _firstMap(Object? response) {
    if (response is Map) return Map<String, dynamic>.from(response);
    if (response is List && response.isNotEmpty && response.first is Map) {
      return Map<String, dynamic>.from(response.first as Map);
    }
    return <String, dynamic>{
      'accepted': false,
      'found': false,
      'safe_message_ar': 'تعذر قراءة نتيجة آمنة من RPC.',
    };
  }

  String? _nullIfBlank(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}

DateTime? _parseDateTime(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}

String? _safeRuleBodyDescription(Object? value) {
  if (value == null) return null;
  if (value is Map) {
    final description = value['description_ar'] ??
        value['summary_ar'] ??
        value['body_ar'] ??
        value['text_ar'];
    return description?.toString();
  }
  final text = value.toString().trim();
  if (text.isEmpty || text == '{}') return null;
  return text;
}
