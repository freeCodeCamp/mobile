// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_challenge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyChallengeOverview {

 String get id; int get challengeNumber; DateTime get date; String get title;
/// Create a copy of DailyChallengeOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyChallengeOverviewCopyWith<DailyChallengeOverview> get copyWith => _$DailyChallengeOverviewCopyWithImpl<DailyChallengeOverview>(this as DailyChallengeOverview, _$identity);

  /// Serializes this DailyChallengeOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyChallengeOverview&&(identical(other.id, id) || other.id == id)&&(identical(other.challengeNumber, challengeNumber) || other.challengeNumber == challengeNumber)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,challengeNumber,date,title);

@override
String toString() {
  return 'DailyChallengeOverview(id: $id, challengeNumber: $challengeNumber, date: $date, title: $title)';
}


}

/// @nodoc
abstract mixin class $DailyChallengeOverviewCopyWith<$Res>  {
  factory $DailyChallengeOverviewCopyWith(DailyChallengeOverview value, $Res Function(DailyChallengeOverview) _then) = _$DailyChallengeOverviewCopyWithImpl;
@useResult
$Res call({
 String id, int challengeNumber, DateTime date, String title
});




}
/// @nodoc
class _$DailyChallengeOverviewCopyWithImpl<$Res>
    implements $DailyChallengeOverviewCopyWith<$Res> {
  _$DailyChallengeOverviewCopyWithImpl(this._self, this._then);

  final DailyChallengeOverview _self;
  final $Res Function(DailyChallengeOverview) _then;

/// Create a copy of DailyChallengeOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? challengeNumber = null,Object? date = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,challengeNumber: null == challengeNumber ? _self.challengeNumber : challengeNumber // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyChallengeOverview].
extension DailyChallengeOverviewPatterns on DailyChallengeOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyChallengeOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyChallengeOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyChallengeOverview value)  $default,){
final _that = this;
switch (_that) {
case _DailyChallengeOverview():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyChallengeOverview value)?  $default,){
final _that = this;
switch (_that) {
case _DailyChallengeOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int challengeNumber,  DateTime date,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyChallengeOverview() when $default != null:
return $default(_that.id,_that.challengeNumber,_that.date,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int challengeNumber,  DateTime date,  String title)  $default,) {final _that = this;
switch (_that) {
case _DailyChallengeOverview():
return $default(_that.id,_that.challengeNumber,_that.date,_that.title);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int challengeNumber,  DateTime date,  String title)?  $default,) {final _that = this;
switch (_that) {
case _DailyChallengeOverview() when $default != null:
return $default(_that.id,_that.challengeNumber,_that.date,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyChallengeOverview extends DailyChallengeOverview {
  const _DailyChallengeOverview({required this.id, required this.challengeNumber, required this.date, required this.title}): super._();
  factory _DailyChallengeOverview.fromJson(Map<String, dynamic> json) => _$DailyChallengeOverviewFromJson(json);

@override final  String id;
@override final  int challengeNumber;
@override final  DateTime date;
@override final  String title;

/// Create a copy of DailyChallengeOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyChallengeOverviewCopyWith<_DailyChallengeOverview> get copyWith => __$DailyChallengeOverviewCopyWithImpl<_DailyChallengeOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyChallengeOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyChallengeOverview&&(identical(other.id, id) || other.id == id)&&(identical(other.challengeNumber, challengeNumber) || other.challengeNumber == challengeNumber)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,challengeNumber,date,title);

@override
String toString() {
  return 'DailyChallengeOverview(id: $id, challengeNumber: $challengeNumber, date: $date, title: $title)';
}


}

/// @nodoc
abstract mixin class _$DailyChallengeOverviewCopyWith<$Res> implements $DailyChallengeOverviewCopyWith<$Res> {
  factory _$DailyChallengeOverviewCopyWith(_DailyChallengeOverview value, $Res Function(_DailyChallengeOverview) _then) = __$DailyChallengeOverviewCopyWithImpl;
@override @useResult
$Res call({
 String id, int challengeNumber, DateTime date, String title
});




}
/// @nodoc
class __$DailyChallengeOverviewCopyWithImpl<$Res>
    implements _$DailyChallengeOverviewCopyWith<$Res> {
  __$DailyChallengeOverviewCopyWithImpl(this._self, this._then);

  final _DailyChallengeOverview _self;
  final $Res Function(_DailyChallengeOverview) _then;

/// Create a copy of DailyChallengeOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? challengeNumber = null,Object? date = null,Object? title = null,}) {
  return _then(_DailyChallengeOverview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,challengeNumber: null == challengeNumber ? _self.challengeNumber : challengeNumber // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
