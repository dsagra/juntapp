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

    await _ref(eventId).doc(paymentId).set(payment.toJson());
  }

  Future<void> approvePayment({
    required String eventId,
    required String paymentId,
    required String reviewerId,
  }) async {
    await _ref(eventId).doc(paymentId).update({
      'status': PaymentStatus.approved.value,
      'reviewedAt': Timestamp.fromDate(DateTime.now()),
      'reviewedBy': reviewerId,
      'rejectReason': null,
    });
  }

  Future<void> rejectPayment({
    required String eventId,
    required String paymentId,
    required String reviewerId,
    required String reason,
  }) async {
    await _ref(eventId).doc(paymentId).update({
      'status': PaymentStatus.rejected.value,
      'reviewedAt': Timestamp.fromDate(DateTime.now()),
      'reviewedBy': reviewerId,
      'rejectReason': reason,
    });
  }
}
