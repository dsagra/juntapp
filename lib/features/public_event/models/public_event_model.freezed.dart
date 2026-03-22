// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'public_event_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PublicEventModel {

 String get eventId; String get slug; String get title; String get description;@TimestampConverter() DateTime get eventDate;@TimestampConverter() DateTime get paymentDeadline; double get amountPerParticipant; String get transferAlias; String? get cvu; String get accountHolder; String? get publicToken; bool get isActive;
/// Create a copy of PublicEventModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicEventModelCopyWith<PublicEventModel> get copyWith => _$PublicEventModelCopyWithImpl<PublicEventModel>(this as PublicEventModel, _$identity);

  /// Serializes this PublicEventModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicEventModel&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.amountPerParticipant, amountPerParticipant) || other.amountPerParticipant == amountPerParticipant)&&(identical(other.transferAlias, transferAlias) || other.transferAlias == transferAlias)&&(identical(other.cvu, cvu) || other.cvu == cvu)&&(identical(other.accountHolder, accountHolder) || other.accountHolder == accountHolder)&&(identical(other.publicToken, publicToken) || other.publicToken == publicToken)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,slug,title,description,eventDate,paymentDeadline,amountPerParticipant,transferAlias,cvu,accountHolder,publicToken,isActive);

@override
String toString() {
  return 'PublicEventModel(eventId: $eventId, slug: $slug, title: $title, description: $description, eventDate: $eventDate, paymentDeadline: $paymentDeadline, amountPerParticipant: $amountPerParticipant, transferAlias: $transferAlias, cvu: $cvu, accountHolder: $accountHolder, publicToken: $publicToken, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $PublicEventModelCopyWith<$Res>  {
  factory $PublicEventModelCopyWith(PublicEventModel value, $Res Function(PublicEventModel) _then) = _$PublicEventModelCopyWithImpl;
@useResult
$Res call({
 String eventId, String slug, String title, String description,@TimestampConverter() DateTime eventDate,@TimestampConverter() DateTime paymentDeadline, double amountPerParticipant, String transferAlias, String? cvu, String accountHolder, String? publicToken, bool isActive
});




}
/// @nodoc
class _$PublicEventModelCopyWithImpl<$Res>
    implements $PublicEventModelCopyWith<$Res> {
  _$PublicEventModelCopyWithImpl(this._self, this._then);

  final PublicEventModel _self;
  final $Res Function(PublicEventModel) _then;

/// Create a copy of PublicEventModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? eventId = null,Object? slug = null,Object? title = null,Object? description = null,Object? eventDate = null,Object? paymentDeadline = null,Object? amountPerParticipant = null,Object? transferAlias = null,Object? cvu = freezed,Object? accountHolder = null,Object? publicToken = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,paymentDeadline: null == paymentDeadline ? _self.paymentDeadline : paymentDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,amountPerParticipant: null == amountPerParticipant ? _self.amountPerParticipant : amountPerParticipant // ignore: cast_nullable_to_non_nullable
as double,transferAlias: null == transferAlias ? _self.transferAlias : transferAlias // ignore: cast_nullable_to_non_nullable
as String,cvu: freezed == cvu ? _self.cvu : cvu // ignore: cast_nullable_to_non_nullable
as String?,accountHolder: null == accountHolder ? _self.accountHolder : accountHolder // ignore: cast_nullable_to_non_nullable
as String,publicToken: freezed == publicToken ? _self.publicToken : publicToken // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PublicEventModel].
extension PublicEventModelPatterns on PublicEventModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicEventModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicEventModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicEventModel value)  $default,){
final _that = this;
switch (_that) {
case _PublicEventModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicEventModel value)?  $default,){
final _that = this;
switch (_that) {
case _PublicEventModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String eventId,  String slug,  String title,  String description, @TimestampConverter()  DateTime eventDate, @TimestampConverter()  DateTime paymentDeadline,  double amountPerParticipant,  String transferAlias,  String? cvu,  String accountHolder,  String? publicToken,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicEventModel() when $default != null:
return $default(_that.eventId,_that.slug,_that.title,_that.description,_that.eventDate,_that.paymentDeadline,_that.amountPerParticipant,_that.transferAlias,_that.cvu,_that.accountHolder,_that.publicToken,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String eventId,  String slug,  String title,  String description, @TimestampConverter()  DateTime eventDate, @TimestampConverter()  DateTime paymentDeadline,  double amountPerParticipant,  String transferAlias,  String? cvu,  String accountHolder,  String? publicToken,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _PublicEventModel():
return $default(_that.eventId,_that.slug,_that.title,_that.description,_that.eventDate,_that.paymentDeadline,_that.amountPerParticipant,_that.transferAlias,_that.cvu,_that.accountHolder,_that.publicToken,_that.isActive);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String eventId,  String slug,  String title,  String description, @TimestampConverter()  DateTime eventDate, @TimestampConverter()  DateTime paymentDeadline,  double amountPerParticipant,  String transferAlias,  String? cvu,  String accountHolder,  String? publicToken,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _PublicEventModel() when $default != null:
return $default(_that.eventId,_that.slug,_that.title,_that.description,_that.eventDate,_that.paymentDeadline,_that.amountPerParticipant,_that.transferAlias,_that.cvu,_that.accountHolder,_that.publicToken,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PublicEventModel implements PublicEventModel {
  const _PublicEventModel({required this.eventId, required this.slug, required this.title, required this.description, @TimestampConverter() required this.eventDate, @TimestampConverter() required this.paymentDeadline, required this.amountPerParticipant, required this.transferAlias, this.cvu, required this.accountHolder, this.publicToken, required this.isActive});
  factory _PublicEventModel.fromJson(Map<String, dynamic> json) => _$PublicEventModelFromJson(json);

@override final  String eventId;
@override final  String slug;
@override final  String title;
@override final  String description;
@override@TimestampConverter() final  DateTime eventDate;
@override@TimestampConverter() final  DateTime paymentDeadline;
@override final  double amountPerParticipant;
@override final  String transferAlias;
@override final  String? cvu;
@override final  String accountHolder;
@override final  String? publicToken;
@override final  bool isActive;

/// Create a copy of PublicEventModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicEventModelCopyWith<_PublicEventModel> get copyWith => __$PublicEventModelCopyWithImpl<_PublicEventModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PublicEventModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicEventModel&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.eventDate, eventDate) || other.eventDate == eventDate)&&(identical(other.paymentDeadline, paymentDeadline) || other.paymentDeadline == paymentDeadline)&&(identical(other.amountPerParticipant, amountPerParticipant) || other.amountPerParticipant == amountPerParticipant)&&(identical(other.transferAlias, transferAlias) || other.transferAlias == transferAlias)&&(identical(other.cvu, cvu) || other.cvu == cvu)&&(identical(other.accountHolder, accountHolder) || other.accountHolder == accountHolder)&&(identical(other.publicToken, publicToken) || other.publicToken == publicToken)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,eventId,slug,title,description,eventDate,paymentDeadline,amountPerParticipant,transferAlias,cvu,accountHolder,publicToken,isActive);

@override
String toString() {
  return 'PublicEventModel(eventId: $eventId, slug: $slug, title: $title, description: $description, eventDate: $eventDate, paymentDeadline: $paymentDeadline, amountPerParticipant: $amountPerParticipant, transferAlias: $transferAlias, cvu: $cvu, accountHolder: $accountHolder, publicToken: $publicToken, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$PublicEventModelCopyWith<$Res> implements $PublicEventModelCopyWith<$Res> {
  factory _$PublicEventModelCopyWith(_PublicEventModel value, $Res Function(_PublicEventModel) _then) = __$PublicEventModelCopyWithImpl;
@override @useResult
$Res call({
 String eventId, String slug, String title, String description,@TimestampConverter() DateTime eventDate,@TimestampConverter() DateTime paymentDeadline, double amountPerParticipant, String transferAlias, String? cvu, String accountHolder, String? publicToken, bool isActive
});




}
/// @nodoc
class __$PublicEventModelCopyWithImpl<$Res>
    implements _$PublicEventModelCopyWith<$Res> {
  __$PublicEventModelCopyWithImpl(this._self, this._then);

  final _PublicEventModel _self;
  final $Res Function(_PublicEventModel) _then;

/// Create a copy of PublicEventModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? eventId = null,Object? slug = null,Object? title = null,Object? description = null,Object? eventDate = null,Object? paymentDeadline = null,Object? amountPerParticipant = null,Object? transferAlias = null,Object? cvu = freezed,Object? accountHolder = null,Object? publicToken = freezed,Object? isActive = null,}) {
  return _then(_PublicEventModel(
eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,eventDate: null == eventDate ? _self.eventDate : eventDate // ignore: cast_nullable_to_non_nullable
as DateTime,paymentDeadline: null == paymentDeadline ? _self.paymentDeadline : paymentDeadline // ignore: cast_nullable_to_non_nullable
as DateTime,amountPerParticipant: null == amountPerParticipant ? _self.amountPerParticipant : amountPerParticipant // ignore: cast_nullable_to_non_nullable
as double,transferAlias: null == transferAlias ? _self.transferAlias : transferAlias // ignore: cast_nullable_to_non_nullable
as String,cvu: freezed == cvu ? _self.cvu : cvu // ignore: cast_nullable_to_non_nullable
as String?,accountHolder: null == accountHolder ? _self.accountHolder : accountHolder // ignore: cast_nullable_to_non_nullable
as String,publicToken: freezed == publicToken ? _self.publicToken : publicToken // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
