import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_application.dart';
import '../domain/models/nosok_application_companion.dart';
import '../domain/models/nosok_application_draft.dart';
import '../domain/models/nosok_application_review.dart';

final nosokApplicationsControllerProvider =
    AsyncNotifierProvider<NosokApplicationsController, List<NosokApplication>>(
  NosokApplicationsController.new,
);

final nosokApplicationSubmissionControllerProvider =
    AsyncNotifierProvider<NosokApplicationSubmissionController, void>(
  NosokApplicationSubmissionController.new,
);

final nosokApplicationTrackingLookupProvider =
    FutureProvider.family<NosokApplication?, String>((ref, trackingToken) {
  return ref
      .read(nosokRepositoryProvider)
      .lookupApplicationByTrackingToken(trackingToken);
});

final nosokApplicationDetailsProvider =
    FutureProvider.family<NosokApplication?, String>((ref, applicationId) {
  return ref.read(nosokRepositoryProvider).getApplicationById(applicationId);
});

final nosokApplicationCompanionsProvider =
    FutureProvider.family<List<NosokApplicationCompanion>, String>(
        (ref, applicationId) {
  return ref
      .read(nosokRepositoryProvider)
      .listApplicationCompanions(applicationId);
});

final nosokApplicationReviewsProvider =
    FutureProvider.family<List<NosokApplicationReview>, String>(
        (ref, applicationId) {
  return ref
      .read(nosokRepositoryProvider)
      .listApplicationReviews(applicationId);
});

class NosokApplicationsController
    extends AsyncNotifier<List<NosokApplication>> {
  String? _lastQuery;

  @override
  Future<List<NosokApplication>> build() async {
    return ref.read(nosokRepositoryProvider).listApplications();
  }

  Future<void> refreshList({String? query}) async {
    _lastQuery = query ?? _lastQuery;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () =>
          ref.read(nosokRepositoryProvider).listApplications(query: _lastQuery),
    );
  }
}

class NosokApplicationSubmissionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<NosokApplication> submit(NosokApplicationDraft draft) async {
    state = const AsyncLoading();
    try {
      final application =
          await ref.read(nosokRepositoryProvider).submitApplication(draft);
      state = const AsyncData(null);
      return application;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}
