import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/participant_model.dart';
import '../repositories/participant_repository.dart';

final participantRepositoryProvider = Provider<ParticipantRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return ParticipantRepository(firestore);
});

final participantsProvider =
    StreamProvider.family<List<ParticipantModel>, String>((ref, eventId) {
      return ref
          .watch(participantRepositoryProvider)
          .watchParticipants(eventId);
    });

final participantsCountProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  eventId,
) {
  return ref
      .watch(participantsProvider(eventId))
      .whenData((items) => items.length);
});
