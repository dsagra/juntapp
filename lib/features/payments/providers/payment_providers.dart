import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../models/payment_model.dart';
import '../repositories/payment_repository.dart';

final paymentRepositoryProvider = Provider<PaymentRepository>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final storage = ref.watch(storageProvider);
  return PaymentRepository(firestore, storage);
});

final paymentsProvider = StreamProvider.family<List<PaymentModel>, String>((
  ref,
  eventId,
) {
  return ref.watch(paymentRepositoryProvider).watchPayments(eventId);
});

final approvedPaymentsCountProvider = FutureProvider.family<int, String>((
  ref,
  eventId,
) async {
  return ref
      .watch(paymentRepositoryProvider)
      .countByStatus(eventId, PaymentStatus.approved);
});

final pendingPaymentsCountProvider = FutureProvider.family<int, String>((
  ref,
  eventId,
) async {
  return ref
      .watch(paymentRepositoryProvider)
      .countByStatus(eventId, PaymentStatus.pending);
});
