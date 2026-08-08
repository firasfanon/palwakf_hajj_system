import 'package:supabase_flutter/supabase_flutter.dart';

class NosokPublicCampaignDto {
  const NosokPublicCampaignDto({
    required this.id,
    required this.titleAr,
    required this.serviceType,
    required this.status,
    this.descriptionAr,
  });

  final String id;
  final String titleAr;
  final String serviceType;
  final String status;
  final String? descriptionAr;

  factory NosokPublicCampaignDto.fromMap(Map<String, dynamic> map) {
    return NosokPublicCampaignDto(
      id: (map['id'] ?? map['campaign_id'] ?? '').toString(),
      titleAr: (map['title_ar'] ?? map['name_ar'] ?? map['title'] ?? 'موسم نسك')
          .toString(),
      serviceType: (map['service_type'] ?? 'hajj').toString(),
      status: (map['status'] ?? 'published').toString(),
      descriptionAr:
          map['description_ar']?.toString() ?? map['summary_ar']?.toString(),
    );
  }
}

class NosokPublicRequirementDto {
  const NosokPublicRequirementDto({
    required this.id,
    required this.titleAr,
    required this.requirementType,
    this.descriptionAr,
  });

  final String id;
  final String titleAr;
  final String requirementType;
  final String? descriptionAr;

  factory NosokPublicRequirementDto.fromMap(Map<String, dynamic> map) {
    return NosokPublicRequirementDto(
      id: (map['id'] ?? map['requirement_id'] ?? '').toString(),
      titleAr:
          (map['title_ar'] ?? map['label_ar'] ?? map['title'] ?? 'متطلب نسك')
              .toString(),
      requirementType:
          (map['requirement_type'] ?? map['type'] ?? 'general').toString(),
      descriptionAr:
          map['description_ar']?.toString() ?? map['help_text_ar']?.toString(),
    );
  }
}

class NosokPublicSubmitResult {
  const NosokPublicSubmitResult({
    required this.accepted,
    this.applicationId,
    this.trackingCode,
    this.safeMessageAr,
  });

  final bool accepted;
  final String? applicationId;
  final String? trackingCode;
  final String? safeMessageAr;

  factory NosokPublicSubmitResult.fromMap(Map<String, dynamic> map) {
    return NosokPublicSubmitResult(
      accepted: map['accepted'] == true || map['ok'] == true,
      applicationId: map['application_id']?.toString(),
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
    this.statusAr,
    this.safeMessageAr,
    this.lastPublicEventAr,
  });

  final bool found;
  final String? statusAr;
  final String? safeMessageAr;
  final String? lastPublicEventAr;

  factory NosokPublicTrackingResult.fromMap(Map<String, dynamic> map) {
    return NosokPublicTrackingResult(
      found: map['found'] == true || map['exists'] == true,
      statusAr: map['status_ar']?.toString() ??
          map['application_status_ar']?.toString(),
      safeMessageAr:
          map['message_ar']?.toString() ?? map['safe_message_ar']?.toString(),
      lastPublicEventAr: map['last_public_event_ar']?.toString(),
    );
  }
}

class NosokPublicWrapperRpcAdapter {
  const NosokPublicWrapperRpcAdapter(this._client);

  final SupabaseClient _client;

  Future<List<NosokPublicCampaignDto>> listPublicCampaigns(
      {String? serviceType}) async {
    final rows = await _rpcList(
      'rpc_nosok_campaigns_public_list_v1',
      params: <String, dynamic>{'p_service_type': _nullIfBlank(serviceType)},
    );
    return rows.map(NosokPublicCampaignDto.fromMap).toList(growable: false);
  }

  Future<List<NosokPublicRequirementDto>> listPublicRequirements(
      {String? campaignId}) async {
    final rows = await _rpcList(
      'rpc_nosok_requirements_public_list_v1',
      params: <String, dynamic>{'p_campaign_id': _nullIfBlank(campaignId)},
    );
    return rows.map(NosokPublicRequirementDto.fromMap).toList(growable: false);
  }

  Future<NosokPublicSubmitResult> submitPublicApplication(
      Map<String, dynamic> payload) async {
    final response = await _client.rpc(
      'rpc_nosok_application_submit_v1',
      params: <String, dynamic>{'p_payload': payload},
    );
    return NosokPublicSubmitResult.fromMap(_firstMap(response));
  }

  Future<NosokPublicTrackingResult> trackPublicApplication(
      {required String trackingCode}) async {
    final response = await _client.rpc(
      'rpc_nosok_application_track_v1',
      params: <String, dynamic>{'p_tracking_code': trackingCode.trim()},
    );
    return NosokPublicTrackingResult.fromMap(_firstMap(response));
  }

  Future<List<Map<String, dynamic>>> _rpcList(String fn,
      {Map<String, dynamic>? params}) async {
    final response = await _client.rpc(fn, params: params);
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

  Map<String, dynamic> _firstMap(Object? response) {
    if (response is Map) return Map<String, dynamic>.from(response);
    if (response is List && response.isNotEmpty && response.first is Map) {
      return Map<String, dynamic>.from(response.first as Map);
    }
    return <String, dynamic>{
      'accepted': false,
      'found': false,
      'safe_message_ar': 'تعذر قراءة نتيجة آمنة من RPC.'
    };
  }

  String? _nullIfBlank(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
