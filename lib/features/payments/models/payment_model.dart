import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/timestamp_converter.dart';

part 'payment_model.freezed.dart';
part 'payment_model.g.dart';

@JsonEnum(valueField: 'value')
enum PaymentStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const PaymentStatus(this.value);
  final String value;
}

@freezed
sealed class PaymentModel with _$PaymentModel {
  const factory PaymentModel({
    required String id,
    required String eventId,
    required String participantId,
    required String childName,
    required String payerName,
    required double amount,
    required String notes,
    String? receiptUrl,
    String? receiptPath,
    String? receiptType,
    required PaymentStatus status,
    @TimestampConverter() required DateTime uploadedAt,
    @NullableTimestampConverter() DateTime? reviewedAt,
    String? reviewedBy,
    String? rejectReason,
  }) = _PaymentModel;

  factory PaymentModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentModelFromJson(json);
}
