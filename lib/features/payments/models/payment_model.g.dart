// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) =>
    _PaymentModel(
      id: json['id'] as String,
      eventId: json['eventId'] as String,
      participantId: json['participantId'] as String,
      childName: json['childName'] as String,
      payerName: json['payerName'] as String,
      amount: (json['amount'] as num).toDouble(),
      notes: json['notes'] as String,
      receiptUrl: json['receiptUrl'] as String,
      receiptPath: json['receiptPath'] as String,
      receiptType: json['receiptType'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      uploadedAt: const TimestampConverter().fromJson(json['uploadedAt']),
      reviewedAt: const TimestampConverter().fromJson(json['reviewedAt']),
      reviewedBy: json['reviewedBy'] as String?,
      rejectReason: json['rejectReason'] as String?,
    );

Map<String, dynamic> _$PaymentModelToJson(_PaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'eventId': instance.eventId,
      'participantId': instance.participantId,
      'childName': instance.childName,
      'payerName': instance.payerName,
      'amount': instance.amount,
      'notes': instance.notes,
      'receiptUrl': instance.receiptUrl,
      'receiptPath': instance.receiptPath,
      'receiptType': instance.receiptType,
      'status': _$PaymentStatusEnumMap[instance.status]!,
      'uploadedAt': const TimestampConverter().toJson(instance.uploadedAt),
      'reviewedAt': _$JsonConverterToJson<Object?, DateTime>(
        instance.reviewedAt,
        const TimestampConverter().toJson,
      ),
      'reviewedBy': instance.reviewedBy,
      'rejectReason': instance.rejectReason,
    };

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.approved: 'approved',
  PaymentStatus.rejected: 'rejected',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
