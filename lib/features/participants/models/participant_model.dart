import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/timestamp_converter.dart';

part 'participant_model.freezed.dart';
part 'participant_model.g.dart';

@freezed
sealed class ParticipantModel with _$ParticipantModel {
  const factory ParticipantModel({
    required String id,
    required String childName,
    String? familyName,
    String? parentName,
    String? parentPhone,
    String? parentEmail,
    required String participantToken,
    required String status,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _ParticipantModel;

  factory ParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ParticipantModelFromJson(json);
}
