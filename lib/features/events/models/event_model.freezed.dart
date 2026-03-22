// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EventModel {

 String get id; String get title; String get description;@TimestampConverter() DateTime get eventDate;@TimestampConverter() DateTime get paymentDeadline; double get amountPerParticipant; String get transferAlias; String? get cvu; String get accountHolder; bool get isActive; String get slug; String? get publicToken; String get createdBy;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EventModelCopyWith<EventModel> get copyWith => _$EventModelCopyWithImpl<EventModel>(this as EventModel, _$identity);

  /// Serializes this EventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.amountPerParticipant, amountPerParticipant) || other.amountPerParticipant == amountPerParticipant)&&(identical(other.transferAlias, transferAlias) || other.transferAlias == transferAlias)&&(identical(other.cvu, cvu) || other.cvu == cvu)&&(identical(other.accountHolder, accountHolder) || other.accountHolder == accountHolder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.publicToken, publicToken) || other.publicToken == publicToken)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,eventDate,paymentDeadline,amountPerParticipant,transferAlias,cvu,accountHolder,isActive,slug,publicToken,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'EventModel(id: $id, title: $title, description: $description, eventDate: $eventDate, paymentDeadline: $paymentDeadline, amountPerParticipant: $amountPerParticipant, transferAlias: $transferAlias, cvu: $cvu, accountHolder: $accountHolder, isActive: $isActive, slug: $slug, publicToken: $publicToken, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $EventModelCopyWith<$Res>  {
  factory $EventModelCopyWith(EventModel value, $Res Function(EventModel) _then) = _$EventModelCopyWithImpl;
@useResult
$Res call({
 String id, String title, String description,@TimestampConverter() DateTime eventDate,@TimestampConverter() DateTime paymentDeadline, double amountPerParticipant, String transferAlias, String? cvu, String accountHolder, bool isActive, String slug, String? publicToken, String createdBy,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$EventModelCopyWithImpl<$Res>
    implements $EventModelCopyWith<$Res> {
  _$EventModelCopyWithImpl(this._self, this._then);

  final EventModel _self;
  final $Res Function(EventModel) _then;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = null,Object? eventDate = null,Object? paymentDeadline = null,Object? amountPerParticipant = null,Object? transferAlias = null,Object? cvu = freezed,Object? accountHolder = null,Object? isActive = null,Object? slug = null,Object? publicToken = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,paymentDeadline: null == paymentDeadline ? _self.paymentDeadline : paymentDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,amountPerParticipant: null == amountPerParticipant ? _self.amountPerParticipant : amountPerParticipant // ignore: cast_nullable_to_non_nullable
as double,transferAlias: null == transferAlias ? _self.transferAlias : transferAlias // ignore: cast_nullable_to_non_nullable
as String,cvu: freezed == cvu ? _self.cvu : cvu // ignore: cast_nullable_to_non_nullable
as String?,accountHolder: null == accountHolder ? _self.accountHolder : accountHolder // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,publicToken: freezed == publicToken ? _self.publicToken : publicToken // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [EventModel].
extension EventModelPatterns on EventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EventModel value)  $default,){
final _that = this;
switch (_that) {
case _EventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EventModel value)?  $default,){
final _that = this;
switch (_that) {
case _EventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String description, @TimestampConverter()  DateTime eventDate, @TimestampConverter()  DateTime paymentDeadline,  double amountPerParticipant,  String transferAlias,  String? cvu,  String accountHolder,  bool isActive,  String slug,  String? publicToken,  String createdBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EventModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.eventDate,_that.paymentDeadline,_that.amountPerParticipant,_that.transferAlias,_that.cvu,_that.accountHolder,_that.isActive,_that.slug,_that.publicToken,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String description, @TimestampConverter()  DateTime eventDate, @TimestampConverter()  DateTime paymentDeadline,  double amountPerParticipant,  String transferAlias,  String? cvu,  String accountHolder,  bool isActive,  String slug,  String? publicToken,  String createdBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _EventModel():
return $default(_that.id,_that.title,_that.description,_that.eventDate,_that.paymentDeadline,_that.amountPerParticipant,_that.transferAlias,_that.cvu,_that.accountHolder,_that.isActive,_that.slug,_that.publicToken,_that.createdBy,_that.createdAt,_that.updatedAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String description, @TimestampConverter()  DateTime eventDate, @TimestampConverter()  DateTime paymentDeadline,  double amountPerParticipant,  String transferAlias,  String? cvu,  String accountHolder,  bool isActive,  String slug,  String? publicToken,  String createdBy, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _EventModel() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.eventDate,_that.paymentDeadline,_that.amountPerParticipant,_that.transferAlias,_that.cvu,_that.accountHolder,_that.isActive,_that.slug,_that.publicToken,_that.createdBy,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EventModel implements EventModel {
  const _EventModel({required this.id, required this.title, required this.description, @TimestampConverter() required this.eventDate, @TimestampConverter() required this.paymentDeadline, required this.amountPerParticipant, required this.transferAlias, this.cvu, required this.accountHolder, required this.isActive, required this.slug, this.publicToken, required this.createdBy, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt});
  factory _EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);

@override final  String id;
@override final  String title;
@override final  String description;
@override@TimestampConverter() final  DateTime eventDate;
@override@TimestampConverter() final  DateTime paymentDeadline;
@override final  double amountPerParticipant;
@override final  String transferAlias;
@override final  String? cvu;
@override final  String accountHolder;
@override final  bool isActive;
@override final  String slug;
@override final  String? publicToken;
@override final  String createdBy;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EventModelCopyWith<_EventModel> get copyWith => __$EventModelCopyWithImpl<_EventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EventModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.amountPerParticipant, amountPerParticipant) || other.amountPerParticipant == amountPerParticipant)&&(identical(other.transferAlias, transferAlias) || other.transferAlias == transferAlias)&&(identical(other.cvu, cvu) || other.cvu == cvu)&&(identical(other.accountHolder, accountHolder) || other.accountHolder == accountHolder)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.publicToken, publicToken) || other.publicToken == publicToken)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,eventDate,paymentDeadline,amountPerParticipant,transferAlias,cvu,accountHolder,isActive,slug,publicToken,createdBy,createdAt,updatedAt);

@override
String toString() {
  return 'EventModel(id: $id, title: $title, description: $description, eventDate: $eventDate, paymentDeadline: $paymentDeadline, amountPerParticipant: $amountPerParticipant, transferAlias: $transferAlias, cvu: $cvu, accountHolder: $accountHolder, isActive: $isActive, slug: $slug, publicToken: $publicToken, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$EventModelCopyWith<$Res> implements $EventModelCopyWith<$Res> {
  factory _$EventModelCopyWith(_EventModel value, $Res Function(_EventModel) _then) = __$EventModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String description,@TimestampConverter() DateTime eventDate,@TimestampConverter() DateTime paymentDeadline, double amountPerParticipant, String transferAlias, String? cvu, String accountHolder, bool isActive, String slug, String? publicToken, String createdBy,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$EventModelCopyWithImpl<$Res>
    implements _$EventModelCopyWith<$Res> {
  __$EventModelCopyWithImpl(this._self, this._then);

  final _EventModel _self;
  final $Res Function(_EventModel) _then;

/// Create a copy of EventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = null,Object? eventDate = null,Object? paymentDeadline = null,Object? amountPerParticipant = null,Object? transferAlias = null,Object? cvu = freezed,Object? accountHolder = null,Object? isActive = null,Object? slug = null,Object? publicToken = freezed,Object? createdBy = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_EventModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,paymentDeadline: null == paymentDeadline ? _self.paymentDeadline : paymentDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,amountPerParticipant: null == amountPerParticipant ? _self.amountPerParticipant : amountPerParticipant // ignore: cast_nullable_to_non_nullable
as double,transferAlias: null == transferAlias ? _self.transferAlias : transferAlias // ignore: cast_nullable_to_non_nullable
as String,cvu: freezed == cvu ? _self.cvu : cvu // ignore: cast_nullable_to_non_nullable
as String?,accountHolder: null == accountHolder ? _self.accountHolder : accountHolder // ignore: cast_nullable_to_non_nullable
as String,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,publicToken: freezed == publicToken ? _self.publicToken : publicToken // ignore: cast_nullable_to_non_nullable
as String?,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
