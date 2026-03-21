// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_participant_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublicParticipantModel {

 String get id; String get childName; String get participantToken; String get status;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of PublicParticipantModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicParticipantModelCopyWith<PublicParticipantModel> get copyWith => _$PublicParticipantModelCopyWithImpl<PublicParticipantModel>(this as PublicParticipantModel, _$identity);

  /// Serializes this PublicParticipantModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.participantToken, participantToken) || other.participantToken == participantToken)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childName,participantToken,status,updatedAt);

@override
String toString() {
  return 'PublicParticipantModel(id: $id, childName: $childName, participantToken: $participantToken, status: $status, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $PublicParticipantModelCopyWith<$Res>  {
  factory $PublicParticipantModelCopyWith(PublicParticipantModel value, $Res Function(PublicParticipantModel) _then) = _$PublicParticipantModelCopyWithImpl;
@useResult
$Res call({
 String id, String childName, String participantToken, String status,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$PublicParticipantModelCopyWithImpl<$Res>
    implements $PublicParticipantModelCopyWith<$Res> {
  _$PublicParticipantModelCopyWithImpl(this._self, this._then);

  final PublicParticipantModel _self;
  final $Res Function(PublicParticipantModel) _then;

/// Create a copy of PublicParticipantModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? childName = null,Object? participantToken = null,Object? status = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,participantToken: null == participantToken ? _self.participantToken : participantToken // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicParticipantModel].
extension PublicParticipantModelPatterns on PublicParticipantModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicParticipantModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicParticipantModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicParticipantModel value)  $default,){
final _that = this;
switch (_that) {
case _PublicParticipantModel():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicParticipantModel value)?  $default,){
final _that = this;
switch (_that) {
case _PublicParticipantModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String childName,  String participantToken,  String status, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicParticipantModel() when $default != null:
return $default(_that.id,_that.childName,_that.participantToken,_that.status,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String childName,  String participantToken,  String status, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PublicParticipantModel():
return $default(_that.id,_that.childName,_that.participantToken,_that.status,_that.updatedAt);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String childName,  String participantToken,  String status, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PublicParticipantModel() when $default != null:
return $default(_that.id,_that.childName,_that.participantToken,_that.status,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicParticipantModel implements PublicParticipantModel {
  const _PublicParticipantModel({required this.id, required this.childName, required this.participantToken, required this.status, @TimestampConverter() required this.updatedAt});
  factory _PublicParticipantModel.fromJson(Map<String, dynamic> json) => _$PublicParticipantModelFromJson(json);

@override final  String id;
@override final  String childName;
@override final  String participantToken;
@override final  String status;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of PublicParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicParticipantModelCopyWith<_PublicParticipantModel> get copyWith => __$PublicParticipantModelCopyWithImpl<_PublicParticipantModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicParticipantModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicParticipantModel&&(identical(other.id, id) || other.id == id)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.participantToken, participantToken) || other.participantToken == participantToken)&&(identical(other.status, status) || other.status == status)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,childName,participantToken,status,updatedAt);

@override
String toString() {
  return 'PublicParticipantModel(id: $id, childName: $childName, participantToken: $participantToken, status: $status, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PublicParticipantModelCopyWith<$Res> implements $PublicParticipantModelCopyWith<$Res> {
  factory _$PublicParticipantModelCopyWith(_PublicParticipantModel value, $Res Function(_PublicParticipantModel) _then) = __$PublicParticipantModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String childName, String participantToken, String status,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$PublicParticipantModelCopyWithImpl<$Res>
    implements _$PublicParticipantModelCopyWith<$Res> {
  __$PublicParticipantModelCopyWithImpl(this._self, this._then);

  final _PublicParticipantModel _self;
  final $Res Function(_PublicParticipantModel) _then;

/// Create a copy of PublicParticipantModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? childName = null,Object? participantToken = null,Object? status = null,Object? updatedAt = null,}) {
  return _then(_PublicParticipantModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,participantToken: null == participantToken ? _self.participantToken : participantToken // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
