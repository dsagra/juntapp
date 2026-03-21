// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EventModel _$EventModelFromJson(Map<String, dynamic> json) => _EventModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  eventDate: const TimestampConverter().fromJson(json['eventDate']),
  paymentDeadline: const TimestampConverter().fromJson(json['paymentDeadline']),
  amountPerParticipant: (json['amountPerParticipant'] as num).toDouble(),
  transferAlias: json['transferAlias'] as String,
  cvu: json['cvu'] as String?,
  accountHolder: json['accountHolder'] as String,
  instructions: json['instructions'] as String,
  isActive: json['isActive'] as bool,
  slug: json['slug'] as String,
  publicToken: json['publicToken'] as String?,
  createdBy: json['createdBy'] as String,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$EventModelToJson(_EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'eventDate': const TimestampConverter().toJson(instance.eventDate),
      'paymentDeadline': const TimestampConverter().toJson(
        instance.paymentDeadline,
      ),
      'amountPerParticipant': instance.amountPerParticipant,
      'transferAlias': instance.transferAlias,
      'cvu': instance.cvu,
      'accountHolder': instance.accountHolder,
      'instructions': instance.instructions,
      'isActive': instance.isActive,
      'slug': instance.slug,
      'publicToken': instance.publicToken,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
