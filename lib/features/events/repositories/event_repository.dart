import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/event_model.dart';
import '../../public_event/models/public_event_model.dart';

class EventRepository {
  EventRepository(this._firestore);

  final FirebaseFirestore _firestore;
  final Uuid _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _eventsRef =>
      _firestore.collection('events');

  CollectionReference<Map<String, dynamic>> get _publicEventsRef =>
      _firestore.collection('public_events');

  Stream<List<EventModel>> watchEventsByUser(String userId) {
    return _eventsRef.where('createdBy', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final events = snapshot.docs
          .where((doc) => doc.data()['deletedAt'] == null)
          .map((doc) => EventModel.fromJson(doc.data()))
          .toList(growable: false);

      events.sort((a, b) => a.eventDate.compareTo(b.eventDate));
      return events;
    });
  }

  Stream<EventModel> watchEventById(String eventId) {
    return _eventsRef.doc(eventId).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) {
        throw StateError('Evento no encontrado');
      }
      if (data['deletedAt'] != null) {
        throw StateError('Evento eliminado');
      }
      return EventModel.fromJson(data);
    });
  }

  Future<bool> slugExists(String slug) async {
    final doc = await _publicEventsRef.doc(slug).get();
    return doc.exists;
  }

  Future<String> createEvent({
    required String title,
    required String description,
    required DateTime eventDate,
    required DateTime paymentDeadline,
    required double amountPerParticipant,
    required String transferAlias,
    String? cvu,
    required String accountHolder,
    required bool isActive,
    required bool autoApproveReceipts,
    required String slug,
    required String publicToken,
    required String createdBy,
  }) async {
    final exists = await slugExists(slug);
    if (exists) {
      throw StateError('El slug ya existe. Elegí otro.');
    }

    final now = DateTime.now();
    final eventId = _uuid.v4();

    final event = EventModel(
      id: eventId,
      title: title,
      description: description,
      eventDate: eventDate,
      paymentDeadline: paymentDeadline,
      amountPerParticipant: amountPerParticipant,
      transferAlias: transferAlias,
      cvu: cvu,
      accountHolder: accountHolder,
      isActive: isActive,
      slug: slug,
      publicToken: publicToken,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );

    final publicData = PublicEventModel(
      eventId: eventId,
      slug: slug,
      title: title,
      description: description,
      eventDate: eventDate,
      paymentDeadline: paymentDeadline,
      amountPerParticipant: amountPerParticipant,
      transferAlias: transferAlias,
      cvu: cvu,
      accountHolder: accountHolder,
      publicToken: publicToken,
      isActive: isActive,
    );

    final batch = _firestore.batch();
    batch.set(_eventsRef.doc(eventId), {
      ...event.toJson(),
      'autoApproveReceipts': autoApproveReceipts,
    });
    batch.set(_publicEventsRef.doc(slug), {
      ...publicData.toJson(),
      'autoApproveReceipts': autoApproveReceipts,
    });
    await batch.commit();

    return eventId;
  }

  Future<void> deleteEvent({
    required String eventId,
    required String slug,
  }) async {
    final now = DateTime.now();

    final batch = _firestore.batch();
    batch.update(_eventsRef.doc(eventId), {
      'deletedAt': Timestamp.fromDate(now),
      'isActive': false,
      'updatedAt': Timestamp.fromDate(now),
    });
    batch.update(_publicEventsRef.doc(slug), {
      'deletedAt': Timestamp.fromDate(now),
      'isActive': false,
    });
    await batch.commit();
  }
}
