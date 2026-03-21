import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/timestamp_converter.dart';

part 'public_participant_model.freezed.dart';
part 'public_participant_model.g.dart';

@freezed
sealed class PublicParticipantModel with _$PublicParticipantModel {
  const factory PublicParticipantModel({
    required String id,
    required String childName,
    required String participantToken,
    required String status,
    @TimestampConverter() required DateTime updatedAt,
  }) = _PublicParticipantModel;

  factory PublicParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$PublicParticipantModelFromJson(json);
}
