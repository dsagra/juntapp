import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/public_event_model.dart';
import '../models/public_participant_model.dart';
import '../repositories/public_event_repository.dart';

final publicEventRepositoryProvider = Provider<PublicEventRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return PublicEventRepository(firestore);
});

final publicEventBySlugProvider =
    StreamProvider.family<PublicEventModel?, String>((ref, slug) {
      return ref.watch(publicEventRepositoryProvider).watchBySlug(slug);
    });

final publicParticipantsProvider =
  StreamProvider.family<List<PublicParticipantModel>, String>((ref, eventId) {
      return ref
          .watch(publicEventRepositoryProvider)
          .watchPublicParticipants(eventId);
    });
