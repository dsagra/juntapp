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

final participantsCountProvider = FutureProvider.family<int, String>((
  ref,
  eventId,
) async {
  final firestore = ref.watch(firestoreProvider);
  final result = await firestore
      .collection('events')
      .doc(eventId)
      .collection('participants')
      .count()
      .get();
  return result.count ?? 0;
});
