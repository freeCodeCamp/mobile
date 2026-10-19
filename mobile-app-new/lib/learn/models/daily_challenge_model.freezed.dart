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


/// @nodoc
mixin _$DailyChallenge {

 String get id; int get challengeNumber; DateTime get date; String get title; String get description; DailyChallengeLanguageData get javascript; DailyChallengeLanguageData get python;
/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyChallengeCopyWith<DailyChallenge> get copyWith => _$DailyChallengeCopyWithImpl<DailyChallenge>(this as DailyChallenge, _$identity);

  /// Serializes this DailyChallenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.challengeNumber, challengeNumber) || other.challengeNumber == challengeNumber)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.javascript, javascript) || other.javascript == javascript)&&(identical(other.python, python) || other.python == python));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,challengeNumber,date,title,description,javascript,python);

@override
String toString() {
  return 'DailyChallenge(id: $id, challengeNumber: $challengeNumber, date: $date, title: $title, description: $description, javascript: $javascript, python: $python)';
}


}

/// @nodoc
abstract mixin class $DailyChallengeCopyWith<$Res>  {
  factory $DailyChallengeCopyWith(DailyChallenge value, $Res Function(DailyChallenge) _then) = _$DailyChallengeCopyWithImpl;
@useResult
$Res call({
 String id, int challengeNumber, DateTime date, String title, String description, DailyChallengeLanguageData javascript, DailyChallengeLanguageData python
});


$DailyChallengeLanguageDataCopyWith<$Res> get javascript;$DailyChallengeLanguageDataCopyWith<$Res> get python;

}
/// @nodoc
class _$DailyChallengeCopyWithImpl<$Res>
    implements $DailyChallengeCopyWith<$Res> {
  _$DailyChallengeCopyWithImpl(this._self, this._then);

  final DailyChallenge _self;
  final $Res Function(DailyChallenge) _then;

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? challengeNumber = null,Object? date = null,Object? title = null,Object? description = null,Object? javascript = null,Object? python = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,challengeNumber: null == challengeNumber ? _self.challengeNumber : challengeNumber // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,javascript: null == javascript ? _self.javascript : javascript // ignore: cast_nullable_to_non_nullable
as DailyChallengeLanguageData,python: null == python ? _self.python : python // ignore: cast_nullable_to_non_nullable
as DailyChallengeLanguageData,
  ));
}
/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyChallengeLanguageDataCopyWith<$Res> get javascript {

  return $DailyChallengeLanguageDataCopyWith<$Res>(_self.javascript, (value) {
    return _then(_self.copyWith(javascript: value));
  });
}/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyChallengeLanguageDataCopyWith<$Res> get python {

  return $DailyChallengeLanguageDataCopyWith<$Res>(_self.python, (value) {
    return _then(_self.copyWith(python: value));
  });
}
}


/// Adds pattern-matching-related methods to [DailyChallenge].
extension DailyChallengePatterns on DailyChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyChallenge value)  $default,){
final _that = this;
switch (_that) {
case _DailyChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int challengeNumber,  DateTime date,  String title,  String description,  DailyChallengeLanguageData javascript,  DailyChallengeLanguageData python)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
return $default(_that.id,_that.challengeNumber,_that.date,_that.title,_that.description,_that.javascript,_that.python);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int challengeNumber,  DateTime date,  String title,  String description,  DailyChallengeLanguageData javascript,  DailyChallengeLanguageData python)  $default,) {final _that = this;
switch (_that) {
case _DailyChallenge():
return $default(_that.id,_that.challengeNumber,_that.date,_that.title,_that.description,_that.javascript,_that.python);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int challengeNumber,  DateTime date,  String title,  String description,  DailyChallengeLanguageData javascript,  DailyChallengeLanguageData python)?  $default,) {final _that = this;
switch (_that) {
case _DailyChallenge() when $default != null:
return $default(_that.id,_that.challengeNumber,_that.date,_that.title,_that.description,_that.javascript,_that.python);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyChallenge implements DailyChallenge {
  const _DailyChallenge({required this.id, required this.challengeNumber, required this.date, required this.title, required this.description, required this.javascript, required this.python});
  factory _DailyChallenge.fromJson(Map<String, dynamic> json) => _$DailyChallengeFromJson(json);

@override final  String id;
@override final  int challengeNumber;
@override final  DateTime date;
@override final  String title;
@override final  String description;
@override final  DailyChallengeLanguageData javascript;
@override final  DailyChallengeLanguageData python;

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyChallengeCopyWith<_DailyChallenge> get copyWith => __$DailyChallengeCopyWithImpl<_DailyChallenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.challengeNumber, challengeNumber) || other.challengeNumber == challengeNumber)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.javascript, javascript) || other.javascript == javascript)&&(identical(other.python, python) || other.python == python));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,challengeNumber,date,title,description,javascript,python);

@override
String toString() {
  return 'DailyChallenge(id: $id, challengeNumber: $challengeNumber, date: $date, title: $title, description: $description, javascript: $javascript, python: $python)';
}


}

/// @nodoc
abstract mixin class _$DailyChallengeCopyWith<$Res> implements $DailyChallengeCopyWith<$Res> {
  factory _$DailyChallengeCopyWith(_DailyChallenge value, $Res Function(_DailyChallenge) _then) = __$DailyChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, int challengeNumber, DateTime date, String title, String description, DailyChallengeLanguageData javascript, DailyChallengeLanguageData python
});


@override $DailyChallengeLanguageDataCopyWith<$Res> get javascript;@override $DailyChallengeLanguageDataCopyWith<$Res> get python;

}
/// @nodoc
class __$DailyChallengeCopyWithImpl<$Res>
    implements _$DailyChallengeCopyWith<$Res> {
  __$DailyChallengeCopyWithImpl(this._self, this._then);

  final _DailyChallenge _self;
  final $Res Function(_DailyChallenge) _then;

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? challengeNumber = null,Object? date = null,Object? title = null,Object? description = null,Object? javascript = null,Object? python = null,}) {
  return _then(_DailyChallenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,challengeNumber: null == challengeNumber ? _self.challengeNumber : challengeNumber // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,javascript: null == javascript ? _self.javascript : javascript // ignore: cast_nullable_to_non_nullable
as DailyChallengeLanguageData,python: null == python ? _self.python : python // ignore: cast_nullable_to_non_nullable
as DailyChallengeLanguageData,
  ));
}

/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyChallengeLanguageDataCopyWith<$Res> get javascript {

  return $DailyChallengeLanguageDataCopyWith<$Res>(_self.javascript, (value) {
    return _then(_self.copyWith(javascript: value));
  });
}/// Create a copy of DailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DailyChallengeLanguageDataCopyWith<$Res> get python {

  return $DailyChallengeLanguageDataCopyWith<$Res>(_self.python, (value) {
    return _then(_self.copyWith(python: value));
  });
}
}


/// @nodoc
mixin _$DailyChallengeLanguageData {

 List<ChallengeTest> get tests; List<ChallengeFile> get challengeFiles;
/// Create a copy of DailyChallengeLanguageData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyChallengeLanguageDataCopyWith<DailyChallengeLanguageData> get copyWith => _$DailyChallengeLanguageDataCopyWithImpl<DailyChallengeLanguageData>(this as DailyChallengeLanguageData, _$identity);

  /// Serializes this DailyChallengeLanguageData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyChallengeLanguageData&&const DeepCollectionEquality().equals(other.tests, tests)&&const DeepCollectionEquality().equals(other.challengeFiles, challengeFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(tests),const DeepCollectionEquality().hash(challengeFiles));

@override
String toString() {
  return 'DailyChallengeLanguageData(tests: $tests, challengeFiles: $challengeFiles)';
}


}

/// @nodoc
abstract mixin class $DailyChallengeLanguageDataCopyWith<$Res>  {
  factory $DailyChallengeLanguageDataCopyWith(DailyChallengeLanguageData value, $Res Function(DailyChallengeLanguageData) _then) = _$DailyChallengeLanguageDataCopyWithImpl;
@useResult
$Res call({
 List<ChallengeTest> tests, List<ChallengeFile> challengeFiles
});




}
/// @nodoc
class _$DailyChallengeLanguageDataCopyWithImpl<$Res>
    implements $DailyChallengeLanguageDataCopyWith<$Res> {
  _$DailyChallengeLanguageDataCopyWithImpl(this._self, this._then);

  final DailyChallengeLanguageData _self;
  final $Res Function(DailyChallengeLanguageData) _then;

/// Create a copy of DailyChallengeLanguageData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tests = null,Object? challengeFiles = null,}) {
  return _then(_self.copyWith(
tests: null == tests ? _self.tests : tests // ignore: cast_nullable_to_non_nullable
as List<ChallengeTest>,challengeFiles: null == challengeFiles ? _self.challengeFiles : challengeFiles // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyChallengeLanguageData].
extension DailyChallengeLanguageDataPatterns on DailyChallengeLanguageData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyChallengeLanguageData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyChallengeLanguageData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyChallengeLanguageData value)  $default,){
final _that = this;
switch (_that) {
case _DailyChallengeLanguageData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyChallengeLanguageData value)?  $default,){
final _that = this;
switch (_that) {
case _DailyChallengeLanguageData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChallengeTest> tests,  List<ChallengeFile> challengeFiles)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyChallengeLanguageData() when $default != null:
return $default(_that.tests,_that.challengeFiles);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChallengeTest> tests,  List<ChallengeFile> challengeFiles)  $default,) {final _that = this;
switch (_that) {
case _DailyChallengeLanguageData():
return $default(_that.tests,_that.challengeFiles);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChallengeTest> tests,  List<ChallengeFile> challengeFiles)?  $default,) {final _that = this;
switch (_that) {
case _DailyChallengeLanguageData() when $default != null:
return $default(_that.tests,_that.challengeFiles);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyChallengeLanguageData implements DailyChallengeLanguageData {
  const _DailyChallengeLanguageData({final  List<ChallengeTest> tests = const [], final  List<ChallengeFile> challengeFiles = const []}): _tests = tests,_challengeFiles = challengeFiles;
  factory _DailyChallengeLanguageData.fromJson(Map<String, dynamic> json) => _$DailyChallengeLanguageDataFromJson(json);

 final  List<ChallengeTest> _tests;
@override@JsonKey() List<ChallengeTest> get tests {
  if (_tests is EqualUnmodifiableListView) return _tests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tests);
}

 final  List<ChallengeFile> _challengeFiles;
@override@JsonKey() List<ChallengeFile> get challengeFiles {
  if (_challengeFiles is EqualUnmodifiableListView) return _challengeFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_challengeFiles);
}


/// Create a copy of DailyChallengeLanguageData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyChallengeLanguageDataCopyWith<_DailyChallengeLanguageData> get copyWith => __$DailyChallengeLanguageDataCopyWithImpl<_DailyChallengeLanguageData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyChallengeLanguageDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyChallengeLanguageData&&const DeepCollectionEquality().equals(other._tests, _tests)&&const DeepCollectionEquality().equals(other._challengeFiles, _challengeFiles));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tests),const DeepCollectionEquality().hash(_challengeFiles));

@override
String toString() {
  return 'DailyChallengeLanguageData(tests: $tests, challengeFiles: $challengeFiles)';
}


}

/// @nodoc
abstract mixin class _$DailyChallengeLanguageDataCopyWith<$Res> implements $DailyChallengeLanguageDataCopyWith<$Res> {
  factory _$DailyChallengeLanguageDataCopyWith(_DailyChallengeLanguageData value, $Res Function(_DailyChallengeLanguageData) _then) = __$DailyChallengeLanguageDataCopyWithImpl;
@override @useResult
$Res call({
 List<ChallengeTest> tests, List<ChallengeFile> challengeFiles
});




}
/// @nodoc
class __$DailyChallengeLanguageDataCopyWithImpl<$Res>
    implements _$DailyChallengeLanguageDataCopyWith<$Res> {
  __$DailyChallengeLanguageDataCopyWithImpl(this._self, this._then);

  final _DailyChallengeLanguageData _self;
  final $Res Function(_DailyChallengeLanguageData) _then;

/// Create a copy of DailyChallengeLanguageData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tests = null,Object? challengeFiles = null,}) {
  return _then(_DailyChallengeLanguageData(
tests: null == tests ? _self._tests : tests // ignore: cast_nullable_to_non_nullable
as List<ChallengeTest>,challengeFiles: null == challengeFiles ? _self._challengeFiles : challengeFiles // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,
  ));
}


}

// dart format on
