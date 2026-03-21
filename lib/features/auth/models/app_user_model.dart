import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/firebase/timestamp_converter.dart';

part 'app_user_model.freezed.dart';
part 'app_user_model.g.dart';

@freezed
sealed class AppUserModel with _$AppUserModel {
  const factory AppUserModel({
    required String id,
    required String email,
    required String displayName,
    @TimestampConverter() required DateTime createdAt,
  }) = _AppUserModel;

  factory AppUserModel.fromJson(Map<String, dynamic> json) =>
      _$AppUserModelFromJson(json);
}
