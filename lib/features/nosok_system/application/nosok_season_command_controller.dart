import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/nosok_supabase_repository.dart';
import '../domain/models/nosok_season_command_gate.dart';

final nosokSeasonCommandGatesProvider =
    FutureProvider<List<NosokSeasonCommandGate>>((ref) {
  return ref.read(nosokRepositoryProvider).listSeasonCommandGates();
});

final nosokSeasonOpenGateDecisionProvider =
    FutureProvider<NosokSeasonOpenGateDecision>((ref) {
  return ref.read(nosokRepositoryProvider).evaluateSeasonOpenGate();
});
