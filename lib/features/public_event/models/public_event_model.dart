import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/timestamp_converter.dart';

part 'public_event_model.freezed.dart';
part 'public_event_model.g.dart';

@freezed
sealed class PublicEventModel with _$PublicEventModel {
  const factory PublicEventModel({
    required String eventId,
    required String slug,
    required String title,
    required String description,
    @TimestampConverter() required DateTime eventDate,
    @TimestampConverter() required DateTime paymentDeadline,
    required double amountPerParticipant,
    required String transferAlias,
    String? cvu,
    required String accountHolder,
    String? publicToken,
    required bool isActive,
  }) = _PublicEventModel;

  factory PublicEventModel.fromJson(Map<String, dynamic> json) =>
      _$PublicEventModelFromJson(json);
}
