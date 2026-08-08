import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_payment_bridge_request.dart';

final nosokPaymentBridgeRequestsProvider =
    FutureProvider<List<NosokPaymentBridgeRequest>>((ref) {
  return ref.read(nosokRepositoryProvider).listPaymentBridgeRequests();
});

class NosokPaymentBridgeController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> createRequest({
    required String applicationId,
    String? paymentId,
    double? amount,
    String currencyCode = 'ILS',
    String? paymentMethod,
    String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(nosokRepositoryProvider).createPaymentBridgeRequest(
            applicationId: applicationId,
            paymentId: paymentId,
            amount: amount,
            currencyCode: currencyCode,
            paymentMethod: paymentMethod,
            notes: notes,
          );
      ref.invalidate(nosokPaymentBridgeRequestsProvider);
    });
  }

  Future<void> executeRequest({
    required String bridgeRequestId,
    String? providerKey,
    String? paymentChannel,
    String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(nosokRepositoryProvider).executePaymentBridgeRequest(
            bridgeRequestId: bridgeRequestId,
            providerKey: providerKey,
            paymentChannel: paymentChannel,
            notes: notes,
          );
      ref.invalidate(nosokPaymentBridgeRequestsProvider);
    });
  }

  Future<void> syncRequest({
    required String bridgeRequestId,
    String? providerReference,
    String? notes,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(nosokRepositoryProvider).syncPaymentBridgeRequest(
            bridgeRequestId: bridgeRequestId,
            providerReference: providerReference,
            notes: notes,
          );
      ref.invalidate(nosokPaymentBridgeRequestsProvider);
    });
  }
}

final nosokPaymentBridgeControllerProvider =
    AsyncNotifierProvider<NosokPaymentBridgeController, void>(
  NosokPaymentBridgeController.new,
);
