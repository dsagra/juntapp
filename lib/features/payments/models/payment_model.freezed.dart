// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payment_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaymentModel {

 String get id; String get eventId; String get participantId; String get childName; String get payerName; double get amount; String get notes; String get receiptUrl; String get receiptPath; String get receiptType; PaymentStatus get status;@TimestampConverter() DateTime get uploadedAt;@TimestampConverter() DateTime? get reviewedAt; String? get reviewedBy; String? get rejectReason;
/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaymentModelCopyWith<PaymentModel> get copyWith => _$PaymentModelCopyWithImpl<PaymentModel>(this as PaymentModel, _$identity);

  /// Serializes this PaymentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.receiptPath, receiptPath) || other.receiptPath == receiptPath)&&(identical(other.receiptType, receiptType) || other.receiptType == receiptType)&&(identical(other.status, status) || other.status == status)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventId,participantId,childName,payerName,amount,notes,receiptUrl,receiptPath,receiptType,status,uploadedAt,reviewedAt,reviewedBy,rejectReason);

@override
String toString() {
  return 'PaymentModel(id: $id, eventId: $eventId, participantId: $participantId, childName: $childName, payerName: $payerName, amount: $amount, notes: $notes, receiptUrl: $receiptUrl, receiptPath: $receiptPath, receiptType: $receiptType, status: $status, uploadedAt: $uploadedAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class $PaymentModelCopyWith<$Res>  {
  factory $PaymentModelCopyWith(PaymentModel value, $Res Function(PaymentModel) _then) = _$PaymentModelCopyWithImpl;
@useResult
$Res call({
 String id, String eventId, String participantId, String childName, String payerName, double amount, String notes, String receiptUrl, String receiptPath, String receiptType, PaymentStatus status,@TimestampConverter() DateTime uploadedAt,@TimestampConverter() DateTime? reviewedAt, String? reviewedBy, String? rejectReason
});




}
/// @nodoc
class _$PaymentModelCopyWithImpl<$Res>
    implements $PaymentModelCopyWith<$Res> {
  _$PaymentModelCopyWithImpl(this._self, this._then);

  final PaymentModel _self;
  final $Res Function(PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? eventId = null,Object? participantId = null,Object? childName = null,Object? payerName = null,Object? amount = null,Object? notes = null,Object? receiptUrl = null,Object? receiptPath = null,Object? receiptType = null,Object? status = null,Object? uploadedAt = null,Object? reviewedAt = freezed,Object? reviewedBy = freezed,Object? rejectReason = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: null == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String,receiptPath: null == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String,receiptType: null == receiptType ? _self.receiptType : receiptType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaymentModel].
extension PaymentModelPatterns on PaymentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaymentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaymentModel value)  $default,){
final _that = this;
switch (_that) {
case _PaymentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaymentModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String eventId,  String participantId,  String childName,  String payerName,  double amount,  String notes,  String receiptUrl,  String receiptPath,  String receiptType,  PaymentStatus status, @TimestampConverter()  DateTime uploadedAt, @TimestampConverter()  DateTime? reviewedAt,  String? reviewedBy,  String? rejectReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.id,_that.eventId,_that.participantId,_that.childName,_that.payerName,_that.amount,_that.notes,_that.receiptUrl,_that.receiptPath,_that.receiptType,_that.status,_that.uploadedAt,_that.reviewedAt,_that.reviewedBy,_that.rejectReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String eventId,  String participantId,  String childName,  String payerName,  double amount,  String notes,  String receiptUrl,  String receiptPath,  String receiptType,  PaymentStatus status, @TimestampConverter()  DateTime uploadedAt, @TimestampConverter()  DateTime? reviewedAt,  String? reviewedBy,  String? rejectReason)  $default,) {final _that = this;
switch (_that) {
case _PaymentModel():
return $default(_that.id,_that.eventId,_that.participantId,_that.childName,_that.payerName,_that.amount,_that.notes,_that.receiptUrl,_that.receiptPath,_that.receiptType,_that.status,_that.uploadedAt,_that.reviewedAt,_that.reviewedBy,_that.rejectReason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String eventId,  String participantId,  String childName,  String payerName,  double amount,  String notes,  String receiptUrl,  String receiptPath,  String receiptType,  PaymentStatus status, @TimestampConverter()  DateTime uploadedAt, @TimestampConverter()  DateTime? reviewedAt,  String? reviewedBy,  String? rejectReason)?  $default,) {final _that = this;
switch (_that) {
case _PaymentModel() when $default != null:
return $default(_that.id,_that.eventId,_that.participantId,_that.childName,_that.payerName,_that.amount,_that.notes,_that.receiptUrl,_that.receiptPath,_that.receiptType,_that.status,_that.uploadedAt,_that.reviewedAt,_that.reviewedBy,_that.rejectReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaymentModel implements PaymentModel {
  const _PaymentModel({required this.id, required this.eventId, required this.participantId, required this.childName, required this.payerName, required this.amount, required this.notes, required this.receiptUrl, required this.receiptPath, required this.receiptType, required this.status, @TimestampConverter() required this.uploadedAt, @TimestampConverter() this.reviewedAt, this.reviewedBy, this.rejectReason});
  factory _PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);

@override final  String id;
@override final  String eventId;
@override final  String participantId;
@override final  String childName;
@override final  String payerName;
@override final  double amount;
@override final  String notes;
@override final  String receiptUrl;
@override final  String receiptPath;
@override final  String receiptType;
@override final  PaymentStatus status;
@override@TimestampConverter() final  DateTime uploadedAt;
@override@TimestampConverter() final  DateTime? reviewedAt;
@override final  String? reviewedBy;
@override final  String? rejectReason;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaymentModelCopyWith<_PaymentModel> get copyWith => __$PaymentModelCopyWithImpl<_PaymentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaymentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaymentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.eventId, eventId) || other.eventId == eventId)&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.childName, childName) || other.childName == childName)&&(identical(other.payerName, payerName) || other.payerName == payerName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.receiptPath, receiptPath) || other.receiptPath == receiptPath)&&(identical(other.receiptType, receiptType) || other.receiptType == receiptType)&&(identical(other.status, status) || other.status == status)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.reviewedAt, reviewedAt) || other.reviewedAt == reviewedAt)&&(identical(other.reviewedBy, reviewedBy) || other.reviewedBy == reviewedBy)&&(identical(other.rejectReason, rejectReason) || other.rejectReason == rejectReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,eventId,participantId,childName,payerName,amount,notes,receiptUrl,receiptPath,receiptType,status,uploadedAt,reviewedAt,reviewedBy,rejectReason);

@override
String toString() {
  return 'PaymentModel(id: $id, eventId: $eventId, participantId: $participantId, childName: $childName, payerName: $payerName, amount: $amount, notes: $notes, receiptUrl: $receiptUrl, receiptPath: $receiptPath, receiptType: $receiptType, status: $status, uploadedAt: $uploadedAt, reviewedAt: $reviewedAt, reviewedBy: $reviewedBy, rejectReason: $rejectReason)';
}


}

/// @nodoc
abstract mixin class _$PaymentModelCopyWith<$Res> implements $PaymentModelCopyWith<$Res> {
  factory _$PaymentModelCopyWith(_PaymentModel value, $Res Function(_PaymentModel) _then) = __$PaymentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String eventId, String participantId, String childName, String payerName, double amount, String notes, String receiptUrl, String receiptPath, String receiptType, PaymentStatus status,@TimestampConverter() DateTime uploadedAt,@TimestampConverter() DateTime? reviewedAt, String? reviewedBy, String? rejectReason
});




}
/// @nodoc
class __$PaymentModelCopyWithImpl<$Res>
    implements _$PaymentModelCopyWith<$Res> {
  __$PaymentModelCopyWithImpl(this._self, this._then);

  final _PaymentModel _self;
  final $Res Function(_PaymentModel) _then;

/// Create a copy of PaymentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? eventId = null,Object? participantId = null,Object? childName = null,Object? payerName = null,Object? amount = null,Object? notes = null,Object? receiptUrl = null,Object? receiptPath = null,Object? receiptType = null,Object? status = null,Object? uploadedAt = null,Object? reviewedAt = freezed,Object? reviewedBy = freezed,Object? rejectReason = freezed,}) {
  return _then(_PaymentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,eventId: null == eventId ? _self.eventId : eventId // ignore: cast_nullable_to_non_nullable
as String,participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,childName: null == childName ? _self.childName : childName // ignore: cast_nullable_to_non_nullable
as String,payerName: null == payerName ? _self.payerName : payerName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: null == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String,receiptPath: null == receiptPath ? _self.receiptPath : receiptPath // ignore: cast_nullable_to_non_nullable
as String,receiptType: null == receiptType ? _self.receiptType : receiptType // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PaymentStatus,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,reviewedAt: freezed == reviewedAt ? _self.reviewedAt : reviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewedBy: freezed == reviewedBy ? _self.reviewedBy : reviewedBy // ignore: cast_nullable_to_non_nullable
as String?,rejectReason: freezed == rejectReason ? _self.rejectReason : rejectReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
