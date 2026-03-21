// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'public_participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PublicParticipantModel _$PublicParticipantModelFromJson(
  Map<String, dynamic> json,
) => _PublicParticipantModel(
  id: json['id'] as String,
  childName: json['childName'] as String,
  participantToken: json['participantToken'] as String,
  status: json['status'] as String,
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$PublicParticipantModelToJson(
  _PublicParticipantModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'childName': instance.childName,
  'participantToken': instance.participantToken,
  'status': instance.status,
  'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
};
