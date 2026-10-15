// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'challenge_file_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChallengeFile {

@JsonKey(unknownEnumValue: Ext.html) Ext get ext; String get name; String? get head; String? get tail; String get contents; List<String> get history; List<int> get editableRegionBoundaries;@JsonKey(readValue: _readFileKey) String get fileKey;
/// Create a copy of ChallengeFile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeFileCopyWith<ChallengeFile> get copyWith => _$ChallengeFileCopyWithImpl<ChallengeFile>(this as ChallengeFile, _$identity);

  /// Serializes this ChallengeFile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeFile&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.name, name) || other.name == name)&&(identical(other.head, head) || other.head == head)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.contents, contents) || other.contents == contents)&&const DeepCollectionEquality().equals(other.history, history)&&const DeepCollectionEquality().equals(other.editableRegionBoundaries, editableRegionBoundaries)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ext,name,head,tail,contents,const DeepCollectionEquality().hash(history),const DeepCollectionEquality().hash(editableRegionBoundaries),fileKey);

@override
String toString() {
  return 'ChallengeFile(ext: $ext, name: $name, head: $head, tail: $tail, contents: $contents, history: $history, editableRegionBoundaries: $editableRegionBoundaries, fileKey: $fileKey)';
}


}

/// @nodoc
abstract mixin class $ChallengeFileCopyWith<$Res>  {
  factory $ChallengeFileCopyWith(ChallengeFile value, $Res Function(ChallengeFile) _then) = _$ChallengeFileCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: Ext.html) Ext ext, String name, String? head, String? tail, String contents, List<String> history, List<int> editableRegionBoundaries,@JsonKey(readValue: _readFileKey) String fileKey
});




}
/// @nodoc
class _$ChallengeFileCopyWithImpl<$Res>
    implements $ChallengeFileCopyWith<$Res> {
  _$ChallengeFileCopyWithImpl(this._self, this._then);

  final ChallengeFile _self;
  final $Res Function(ChallengeFile) _then;

/// Create a copy of ChallengeFile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ext = null,Object? name = null,Object? head = freezed,Object? tail = freezed,Object? contents = null,Object? history = null,Object? editableRegionBoundaries = null,Object? fileKey = null,}) {
  return _then(_self.copyWith(
ext: null == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as Ext,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,head: freezed == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as String?,tail: freezed == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String?,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<String>,editableRegionBoundaries: null == editableRegionBoundaries ? _self.editableRegionBoundaries : editableRegionBoundaries // ignore: cast_nullable_to_non_nullable
as List<int>,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeFile].
extension ChallengeFilePatterns on ChallengeFile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeFile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeFile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeFile value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeFile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeFile value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeFile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: Ext.html)  Ext ext,  String name,  String? head,  String? tail,  String contents,  List<String> history,  List<int> editableRegionBoundaries, @JsonKey(readValue: _readFileKey)  String fileKey)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeFile() when $default != null:
return $default(_that.ext,_that.name,_that.head,_that.tail,_that.contents,_that.history,_that.editableRegionBoundaries,_that.fileKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: Ext.html)  Ext ext,  String name,  String? head,  String? tail,  String contents,  List<String> history,  List<int> editableRegionBoundaries, @JsonKey(readValue: _readFileKey)  String fileKey)  $default,) {final _that = this;
switch (_that) {
case _ChallengeFile():
return $default(_that.ext,_that.name,_that.head,_that.tail,_that.contents,_that.history,_that.editableRegionBoundaries,_that.fileKey);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: Ext.html)  Ext ext,  String name,  String? head,  String? tail,  String contents,  List<String> history,  List<int> editableRegionBoundaries, @JsonKey(readValue: _readFileKey)  String fileKey)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeFile() when $default != null:
return $default(_that.ext,_that.name,_that.head,_that.tail,_that.contents,_that.history,_that.editableRegionBoundaries,_that.fileKey);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeFile implements ChallengeFile {
  const _ChallengeFile({@JsonKey(unknownEnumValue: Ext.html) required this.ext, required this.name, this.head, this.tail, required this.contents, final  List<String> history = const [], final  List<int> editableRegionBoundaries = const [], @JsonKey(readValue: _readFileKey) required this.fileKey}): _history = history,_editableRegionBoundaries = editableRegionBoundaries;
  factory _ChallengeFile.fromJson(Map<String, dynamic> json) => _$ChallengeFileFromJson(json);

@override@JsonKey(unknownEnumValue: Ext.html) final  Ext ext;
@override final  String name;
@override final  String? head;
@override final  String? tail;
@override final  String contents;
 final  List<String> _history;
@override@JsonKey() List<String> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

 final  List<int> _editableRegionBoundaries;
@override@JsonKey() List<int> get editableRegionBoundaries {
  if (_editableRegionBoundaries is EqualUnmodifiableListView) return _editableRegionBoundaries;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_editableRegionBoundaries);
}

@override@JsonKey(readValue: _readFileKey) final  String fileKey;

/// Create a copy of ChallengeFile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeFileCopyWith<_ChallengeFile> get copyWith => __$ChallengeFileCopyWithImpl<_ChallengeFile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeFileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeFile&&(identical(other.ext, ext) || other.ext == ext)&&(identical(other.name, name) || other.name == name)&&(identical(other.head, head) || other.head == head)&&(identical(other.tail, tail) || other.tail == tail)&&(identical(other.contents, contents) || other.contents == contents)&&const DeepCollectionEquality().equals(other._history, _history)&&const DeepCollectionEquality().equals(other._editableRegionBoundaries, _editableRegionBoundaries)&&(identical(other.fileKey, fileKey) || other.fileKey == fileKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ext,name,head,tail,contents,const DeepCollectionEquality().hash(_history),const DeepCollectionEquality().hash(_editableRegionBoundaries),fileKey);

@override
String toString() {
  return 'ChallengeFile(ext: $ext, name: $name, head: $head, tail: $tail, contents: $contents, history: $history, editableRegionBoundaries: $editableRegionBoundaries, fileKey: $fileKey)';
}


}

/// @nodoc
abstract mixin class _$ChallengeFileCopyWith<$Res> implements $ChallengeFileCopyWith<$Res> {
  factory _$ChallengeFileCopyWith(_ChallengeFile value, $Res Function(_ChallengeFile) _then) = __$ChallengeFileCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: Ext.html) Ext ext, String name, String? head, String? tail, String contents, List<String> history, List<int> editableRegionBoundaries,@JsonKey(readValue: _readFileKey) String fileKey
});




}
/// @nodoc
class __$ChallengeFileCopyWithImpl<$Res>
    implements _$ChallengeFileCopyWith<$Res> {
  __$ChallengeFileCopyWithImpl(this._self, this._then);

  final _ChallengeFile _self;
  final $Res Function(_ChallengeFile) _then;

/// Create a copy of ChallengeFile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ext = null,Object? name = null,Object? head = freezed,Object? tail = freezed,Object? contents = null,Object? history = null,Object? editableRegionBoundaries = null,Object? fileKey = null,}) {
  return _then(_ChallengeFile(
ext: null == ext ? _self.ext : ext // ignore: cast_nullable_to_non_nullable
as Ext,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,head: freezed == head ? _self.head : head // ignore: cast_nullable_to_non_nullable
as String?,tail: freezed == tail ? _self.tail : tail // ignore: cast_nullable_to_non_nullable
as String?,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as String,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<String>,editableRegionBoundaries: null == editableRegionBoundaries ? _self._editableRegionBoundaries : editableRegionBoundaries // ignore: cast_nullable_to_non_nullable
as List<int>,fileKey: null == fileKey ? _self.fileKey : fileKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
