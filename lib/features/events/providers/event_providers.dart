import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../../auth/providers/auth_providers.dart';
import '../models/event_model.dart';
import '../repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return EventRepository(firestore);
});

final eventsByCurrentUserProvider = StreamProvider<List<EventModel>>((ref) {
  final user = ref.watch(currentUserProvider);
  if (user == null) return const Stream.empty();
  return ref.watch(eventRepositoryProvider).watchEventsByUser(user.uid);
});

final eventByIdProvider = StreamProvider.family<EventModel, String>((
  ref,
  eventId,
) {
  return ref.watch(eventRepositoryProvider).watchEventById(eventId);
});
