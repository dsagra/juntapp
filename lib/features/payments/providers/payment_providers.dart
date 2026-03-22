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

final approvedPaymentsCountProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  eventId,
) {
  return ref
      .watch(paymentsProvider(eventId))
      .whenData(
        (payments) =>
            payments.where((p) => p.status == PaymentStatus.approved).length,
      );
});

final pendingPaymentsCountProvider = Provider.family<AsyncValue<int>, String>((
  ref,
  eventId,
) {
  return ref
      .watch(paymentsProvider(eventId))
      .whenData(
        (payments) =>
            payments.where((p) => p.status == PaymentStatus.pending).length,
      );
});
