import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/public_participant_model.dart';
import '../models/public_event_model.dart';

class PublicEventRepository {
  PublicEventRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Stream<PublicEventModel?> watchBySlug(String slug) {
    return _firestore.collection('public_events').doc(slug).snapshots().map((
      doc,
    ) {
      final data = doc.data();
      if (data == null) return null;
      return PublicEventModel.fromJson(data);
    });
  }

  Stream<List<PublicParticipantModel>> watchPublicParticipants(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('public_participants')
        .where('status', isEqualTo: 'active')
        .snapshots()
        .map((snapshot) {
      final participants = snapshot.docs
              .map((doc) => PublicParticipantModel.fromJson(doc.data()))
              .toList(growable: false);

      participants.sort((a, b) => a.childName.compareTo(b.childName));
      return participants;
        });
  }
}
