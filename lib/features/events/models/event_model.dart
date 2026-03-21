import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/timestamp_converter.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
sealed class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String title,
    required String description,
    @TimestampConverter() required DateTime eventDate,
    @TimestampConverter() required DateTime paymentDeadline,
    required double amountPerParticipant,
    required String transferAlias,
    String? cvu,
    required String accountHolder,
    required String instructions,
    required bool isActive,
    required String slug,
    String? publicToken,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);
}
