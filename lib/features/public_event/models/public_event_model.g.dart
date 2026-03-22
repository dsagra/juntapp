// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublicEventModel _$PublicEventModelFromJson(Map<String, dynamic> json) =>
    _PublicEventModel(
      eventId: json['eventId'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      eventDate: const TimestampConverter().fromJson(json['eventDate']),
      paymentDeadline: const TimestampConverter().fromJson(
        json['paymentDeadline'],
      ),
      amountPerParticipant: (json['amountPerParticipant'] as num).toDouble(),
      transferAlias: json['transferAlias'] as String,
      cvu: json['cvu'] as String?,
      accountHolder: json['accountHolder'] as String,
      publicToken: json['publicToken'] as String?,
      isActive: json['isActive'] as bool,
    );

Map<String, dynamic> _$PublicEventModelToJson(_PublicEventModel instance) =>
    <String, dynamic>{
      'eventId': instance.eventId,
      'slug': instance.slug,
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
      'publicToken': instance.publicToken,
      'isActive': instance.isActive,
    };
