import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../models/participant_model.dart';

class ParticipantRepository {
  ParticipantRepository(this._firestore);

  final FirebaseFirestore _firestore;
  final Uuid _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> _ref(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('participants');
  }

  CollectionReference<Map<String, dynamic>> _publicRef(String eventId) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('public_participants');
  }

  Stream<List<ParticipantModel>> watchParticipants(String eventId) {
    return _ref(eventId).orderBy('childName').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ParticipantModel.fromJson(doc.data()))
          .toList(growable: false);
    });
  }

  Future<void> createParticipant({
    required String eventId,
    required String childName,
    String? familyName,
    String? parentName,
    String? parentPhone,
    String? parentEmail,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final model = ParticipantModel(
      id: id,
      childName: childName,
      familyName: familyName,
      parentName: parentName,
      parentPhone: parentPhone,
      parentEmail: parentEmail,
      participantToken: _uuid.v4().replaceAll('-', '').substring(0, 12),
      status: 'active',
      createdAt: now,
      updatedAt: now,
    );

    final batch = _firestore.batch();
    batch.set(_ref(eventId).doc(id), model.toJson());
    batch.set(_publicRef(eventId).doc(id), {
      'id': id,
      'childName': childName,
      'status': 'active',
      'participantToken': model.participantToken,
      'updatedAt': Timestamp.fromDate(now),
    });
    await batch.commit();
  }

  Future<void> updateParticipant({
    required String eventId,
    required ParticipantModel participant,
  }) async {
    final updated = participant.copyWith(updatedAt: DateTime.now());
    final batch = _firestore.batch();
    batch.set(_ref(eventId).doc(participant.id), updated.toJson());
    batch.set(_publicRef(eventId).doc(participant.id), {
      'id': participant.id,
      'childName': updated.childName,
      'status': updated.status,
      'participantToken': updated.participantToken,
      'updatedAt': Timestamp.fromDate(updated.updatedAt),
    });
    await batch.commit();
  }

  Future<void> deleteParticipant({
    required String eventId,
    required String participantId,
  }) async {
    final batch = _firestore.batch();
    batch.delete(_ref(eventId).doc(participantId));
    batch.delete(_publicRef(eventId).doc(participantId));
    await batch.commit();
  }
}
