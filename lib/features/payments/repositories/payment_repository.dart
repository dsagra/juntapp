import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/payment_model.dart';

class PaymentRepository {
  PaymentRepository(this._firestore, this._storage);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Uuid _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> _ref(String eventId) {
    return _firestore.collection('events').doc(eventId).collection('payments');
  }

  DocumentReference<Map<String, dynamic>> _publicParticipantRef({
    required String eventId,
    required String participantId,
  }) {
    return _firestore
        .collection('events')
        .doc(eventId)
        .collection('public_participants')
        .doc(participantId);
  }

  Stream<List<PaymentModel>> watchPayments(String eventId) {
    return _ref(
      eventId,
    ).orderBy('uploadedAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PaymentModel.fromJson(doc.data()))
          .toList(growable: false);
    });
  }

  Future<int> countByStatus(String eventId, PaymentStatus status) async {
    final query = await _ref(
      eventId,
    ).where('status', isEqualTo: status.value).count().get();
    return query.count ?? 0;
  }

  Future<void> submitPayment({
    required String eventId,
    required String participantId,
    required String childName,
    required String payerName,
    required double amount,
    required String notes,
    Uint8List? fileBytes,
    String? fileExtension,
    String? receiptType,
  }) async {
    final paymentId = _uuid.v4();
    final now = DateTime.now();

    String? receiptUrl;
    String? receiptPath;
    String? effectiveReceiptType;

    if (fileBytes != null &&
        fileExtension != null &&
        fileExtension.isNotEmpty &&
        receiptType != null &&
        receiptType.isNotEmpty) {
      final path = 'events/$eventId/payments/$paymentId/receipt.$fileExtension';

      final uploadTask = await _storage
          .ref(path)
          .putData(fileBytes, SettableMetadata(contentType: receiptType));
      receiptUrl = await uploadTask.ref.getDownloadURL();
      receiptPath = path;
      effectiveReceiptType = receiptType;
    }

    final payment = PaymentModel(
      id: paymentId,
      eventId: eventId,
      participantId: participantId,
      childName: childName,
      payerName: payerName,
      amount: amount,
      notes: notes,
      receiptUrl: receiptUrl,
      receiptPath: receiptPath,
      receiptType: effectiveReceiptType,
      status: PaymentStatus.pending,
      uploadedAt: now,
      reviewedAt: null,
      reviewedBy: null,
      rejectReason: null,
    );

    final batch = _firestore.batch();
    batch.set(_ref(eventId).doc(paymentId), payment.toJson());
    batch.set(
      _publicParticipantRef(eventId: eventId, participantId: participantId),
      {'status': 'pending_payment', 'updatedAt': Timestamp.fromDate(now)},
      SetOptions(merge: true),
    );
    await batch.commit();
  }

  Future<void> approvePayment({
    required String eventId,
    required String paymentId,
    required String reviewerId,
  }) async {
    final paymentDoc = await _ref(eventId).doc(paymentId).get();
    final data = paymentDoc.data();
    if (data == null) {
      throw StateError('Pago no encontrado');
    }

    final participantId = data['participantId'] as String?;
    if (participantId == null || participantId.isEmpty) {
      throw StateError('Pago inválido: participantId faltante');
    }

    final now = DateTime.now();
    final batch = _firestore.batch();
    batch.update(_ref(eventId).doc(paymentId), {
      'status': PaymentStatus.approved.value,
      'reviewedAt': Timestamp.fromDate(now),
      'reviewedBy': reviewerId,
      'rejectReason': null,
    });
    batch.set(
      _publicParticipantRef(eventId: eventId, participantId: participantId),
      {'status': 'paid', 'updatedAt': Timestamp.fromDate(now)},
      SetOptions(merge: true),
    );
    await batch.commit();
  }

  Future<void> rejectPayment({
    required String eventId,
    required String paymentId,
    required String reviewerId,
    required String reason,
  }) async {
    final paymentDoc = await _ref(eventId).doc(paymentId).get();
    final data = paymentDoc.data();
    if (data == null) {
      throw StateError('Pago no encontrado');
    }

    final participantId = data['participantId'] as String?;
    if (participantId == null || participantId.isEmpty) {
      throw StateError('Pago inválido: participantId faltante');
    }

    final now = DateTime.now();
    final batch = _firestore.batch();
    batch.update(_ref(eventId).doc(paymentId), {
      'status': PaymentStatus.rejected.value,
      'reviewedAt': Timestamp.fromDate(now),
      'reviewedBy': reviewerId,
      'rejectReason': reason,
    });
    batch.set(
      _publicParticipantRef(eventId: eventId, participantId: participantId),
      {'status': 'active', 'updatedAt': Timestamp.fromDate(now)},
      SetOptions(merge: true),
    );
    await batch.commit();
  }
}
