// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParticipantModel _$ParticipantModelFromJson(Map<String, dynamic> json) =>
    _ParticipantModel(
      id: json['id'] as String,
      childName: json['childName'] as String,
      familyName: json['familyName'] as String?,
      parentName: json['parentName'] as String?,
      parentPhone: json['parentPhone'] as String?,
      parentEmail: json['parentEmail'] as String?,
      participantToken: json['participantToken'] as String,
      status: json['status'] as String,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$ParticipantModelToJson(_ParticipantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'childName': instance.childName,
      'familyName': instance.familyName,
      'parentName': instance.parentName,
      'parentPhone': instance.parentPhone,
      'parentEmail': instance.parentEmail,
      'participantToken': instance.participantToken,
      'status': instance.status,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
    };
