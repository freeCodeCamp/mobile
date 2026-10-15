// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'curriculum_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SuperBlockSummary {

 String get dashedName; String get title; bool get isPublic; bool get isDisabledByOverride;
/// Create a copy of SuperBlockSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SuperBlockSummaryCopyWith<SuperBlockSummary> get copyWith => _$SuperBlockSummaryCopyWithImpl<SuperBlockSummary>(this as SuperBlockSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuperBlockSummary&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.title, title) || other.title == title)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isDisabledByOverride, isDisabledByOverride) || other.isDisabledByOverride == isDisabledByOverride));
}


@override
int get hashCode => Object.hash(runtimeType,dashedName,title,isPublic,isDisabledByOverride);

@override
String toString() {
  return 'SuperBlockSummary(dashedName: $dashedName, title: $title, isPublic: $isPublic, isDisabledByOverride: $isDisabledByOverride)';
}


}

/// @nodoc
abstract mixin class $SuperBlockSummaryCopyWith<$Res>  {
  factory $SuperBlockSummaryCopyWith(SuperBlockSummary value, $Res Function(SuperBlockSummary) _then) = _$SuperBlockSummaryCopyWithImpl;
@useResult
$Res call({
 String dashedName, String title, bool isPublic, bool isDisabledByOverride
});




}
/// @nodoc
class _$SuperBlockSummaryCopyWithImpl<$Res>
    implements $SuperBlockSummaryCopyWith<$Res> {
  _$SuperBlockSummaryCopyWithImpl(this._self, this._then);

  final SuperBlockSummary _self;
  final $Res Function(SuperBlockSummary) _then;

/// Create a copy of SuperBlockSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dashedName = null,Object? title = null,Object? isPublic = null,Object? isDisabledByOverride = null,}) {
  return _then(_self.copyWith(
dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isDisabledByOverride: null == isDisabledByOverride ? _self.isDisabledByOverride : isDisabledByOverride // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SuperBlockSummary].
extension SuperBlockSummaryPatterns on SuperBlockSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SuperBlockSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SuperBlockSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SuperBlockSummary value)  $default,){
final _that = this;
switch (_that) {
case _SuperBlockSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SuperBlockSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SuperBlockSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dashedName,  String title,  bool isPublic,  bool isDisabledByOverride)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SuperBlockSummary() when $default != null:
return $default(_that.dashedName,_that.title,_that.isPublic,_that.isDisabledByOverride);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dashedName,  String title,  bool isPublic,  bool isDisabledByOverride)  $default,) {final _that = this;
switch (_that) {
case _SuperBlockSummary():
return $default(_that.dashedName,_that.title,_that.isPublic,_that.isDisabledByOverride);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dashedName,  String title,  bool isPublic,  bool isDisabledByOverride)?  $default,) {final _that = this;
switch (_that) {
case _SuperBlockSummary() when $default != null:
return $default(_that.dashedName,_that.title,_that.isPublic,_that.isDisabledByOverride);case _:
  return null;

}
}

}

/// @nodoc


class _SuperBlockSummary implements SuperBlockSummary {
  const _SuperBlockSummary({required this.dashedName, required this.title, required this.isPublic, this.isDisabledByOverride = false});
  

@override final  String dashedName;
@override final  String title;
@override final  bool isPublic;
@override@JsonKey() final  bool isDisabledByOverride;

/// Create a copy of SuperBlockSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuperBlockSummaryCopyWith<_SuperBlockSummary> get copyWith => __$SuperBlockSummaryCopyWithImpl<_SuperBlockSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuperBlockSummary&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.title, title) || other.title == title)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.isDisabledByOverride, isDisabledByOverride) || other.isDisabledByOverride == isDisabledByOverride));
}


@override
int get hashCode => Object.hash(runtimeType,dashedName,title,isPublic,isDisabledByOverride);

@override
String toString() {
  return 'SuperBlockSummary(dashedName: $dashedName, title: $title, isPublic: $isPublic, isDisabledByOverride: $isDisabledByOverride)';
}


}

/// @nodoc
abstract mixin class _$SuperBlockSummaryCopyWith<$Res> implements $SuperBlockSummaryCopyWith<$Res> {
  factory _$SuperBlockSummaryCopyWith(_SuperBlockSummary value, $Res Function(_SuperBlockSummary) _then) = __$SuperBlockSummaryCopyWithImpl;
@override @useResult
$Res call({
 String dashedName, String title, bool isPublic, bool isDisabledByOverride
});




}
/// @nodoc
class __$SuperBlockSummaryCopyWithImpl<$Res>
    implements _$SuperBlockSummaryCopyWith<$Res> {
  __$SuperBlockSummaryCopyWithImpl(this._self, this._then);

  final _SuperBlockSummary _self;
  final $Res Function(_SuperBlockSummary) _then;

/// Create a copy of SuperBlockSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dashedName = null,Object? title = null,Object? isPublic = null,Object? isDisabledByOverride = null,}) {
  return _then(_SuperBlockSummary(
dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,isDisabledByOverride: null == isDisabledByOverride ? _self.isDisabledByOverride : isDisabledByOverride // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ChallengeOrder {

 String get id; String get title;
/// Create a copy of ChallengeOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChallengeOrderCopyWith<ChallengeOrder> get copyWith => _$ChallengeOrderCopyWithImpl<ChallengeOrder>(this as ChallengeOrder, _$identity);

  /// Serializes this ChallengeOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChallengeOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'ChallengeOrder(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class $ChallengeOrderCopyWith<$Res>  {
  factory $ChallengeOrderCopyWith(ChallengeOrder value, $Res Function(ChallengeOrder) _then) = _$ChallengeOrderCopyWithImpl;
@useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class _$ChallengeOrderCopyWithImpl<$Res>
    implements $ChallengeOrderCopyWith<$Res> {
  _$ChallengeOrderCopyWithImpl(this._self, this._then);

  final ChallengeOrder _self;
  final $Res Function(ChallengeOrder) _then;

/// Create a copy of ChallengeOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ChallengeOrder].
extension ChallengeOrderPatterns on ChallengeOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChallengeOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChallengeOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChallengeOrder value)  $default,){
final _that = this;
switch (_that) {
case _ChallengeOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChallengeOrder value)?  $default,){
final _that = this;
switch (_that) {
case _ChallengeOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChallengeOrder() when $default != null:
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title)  $default,) {final _that = this;
switch (_that) {
case _ChallengeOrder():
return $default(_that.id,_that.title);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title)?  $default,) {final _that = this;
switch (_that) {
case _ChallengeOrder() when $default != null:
return $default(_that.id,_that.title);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChallengeOrder implements ChallengeOrder {
  const _ChallengeOrder({required this.id, required this.title});
  factory _ChallengeOrder.fromJson(Map<String, dynamic> json) => _$ChallengeOrderFromJson(json);

@override final  String id;
@override final  String title;

/// Create a copy of ChallengeOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChallengeOrderCopyWith<_ChallengeOrder> get copyWith => __$ChallengeOrderCopyWithImpl<_ChallengeOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChallengeOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChallengeOrder&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title);

@override
String toString() {
  return 'ChallengeOrder(id: $id, title: $title)';
}


}

/// @nodoc
abstract mixin class _$ChallengeOrderCopyWith<$Res> implements $ChallengeOrderCopyWith<$Res> {
  factory _$ChallengeOrderCopyWith(_ChallengeOrder value, $Res Function(_ChallengeOrder) _then) = __$ChallengeOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, String title
});




}
/// @nodoc
class __$ChallengeOrderCopyWithImpl<$Res>
    implements _$ChallengeOrderCopyWith<$Res> {
  __$ChallengeOrderCopyWithImpl(this._self, this._then);

  final _ChallengeOrder _self;
  final $Res Function(_ChallengeOrder) _then;

/// Create a copy of ChallengeOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,}) {
  return _then(_ChallengeOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$Block {

 String get superBlock; String get dashedName; String get name; BlockLayout get layout; BlockLabel get label; List<String> get description; List<ChallengeOrder> get challenges; bool get isDisabledByOverride;
/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockCopyWith<Block> get copyWith => _$BlockCopyWithImpl<Block>(this as Block, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Block&&(identical(other.superBlock, superBlock) || other.superBlock == superBlock)&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.name, name) || other.name == name)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other.description, description)&&const DeepCollectionEquality().equals(other.challenges, challenges)&&(identical(other.isDisabledByOverride, isDisabledByOverride) || other.isDisabledByOverride == isDisabledByOverride));
}


@override
int get hashCode => Object.hash(runtimeType,superBlock,dashedName,name,layout,label,const DeepCollectionEquality().hash(description),const DeepCollectionEquality().hash(challenges),isDisabledByOverride);

@override
String toString() {
  return 'Block(superBlock: $superBlock, dashedName: $dashedName, name: $name, layout: $layout, label: $label, description: $description, challenges: $challenges, isDisabledByOverride: $isDisabledByOverride)';
}


}

/// @nodoc
abstract mixin class $BlockCopyWith<$Res>  {
  factory $BlockCopyWith(Block value, $Res Function(Block) _then) = _$BlockCopyWithImpl;
@useResult
$Res call({
 String superBlock, String dashedName, String name, BlockLayout layout, BlockLabel label, List<String> description, List<ChallengeOrder> challenges, bool isDisabledByOverride
});




}
/// @nodoc
class _$BlockCopyWithImpl<$Res>
    implements $BlockCopyWith<$Res> {
  _$BlockCopyWithImpl(this._self, this._then);

  final Block _self;
  final $Res Function(Block) _then;

/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? superBlock = null,Object? dashedName = null,Object? name = null,Object? layout = null,Object? label = null,Object? description = null,Object? challenges = null,Object? isDisabledByOverride = null,}) {
  return _then(_self.copyWith(
superBlock: null == superBlock ? _self.superBlock : superBlock // ignore: cast_nullable_to_non_nullable
as String,dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as BlockLayout,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as BlockLabel,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as List<String>,challenges: null == challenges ? _self.challenges : challenges // ignore: cast_nullable_to_non_nullable
as List<ChallengeOrder>,isDisabledByOverride: null == isDisabledByOverride ? _self.isDisabledByOverride : isDisabledByOverride // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Block].
extension BlockPatterns on Block {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Block value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Block() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Block value)  $default,){
final _that = this;
switch (_that) {
case _Block():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Block value)?  $default,){
final _that = this;
switch (_that) {
case _Block() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String superBlock,  String dashedName,  String name,  BlockLayout layout,  BlockLabel label,  List<String> description,  List<ChallengeOrder> challenges,  bool isDisabledByOverride)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Block() when $default != null:
return $default(_that.superBlock,_that.dashedName,_that.name,_that.layout,_that.label,_that.description,_that.challenges,_that.isDisabledByOverride);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String superBlock,  String dashedName,  String name,  BlockLayout layout,  BlockLabel label,  List<String> description,  List<ChallengeOrder> challenges,  bool isDisabledByOverride)  $default,) {final _that = this;
switch (_that) {
case _Block():
return $default(_that.superBlock,_that.dashedName,_that.name,_that.layout,_that.label,_that.description,_that.challenges,_that.isDisabledByOverride);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String superBlock,  String dashedName,  String name,  BlockLayout layout,  BlockLabel label,  List<String> description,  List<ChallengeOrder> challenges,  bool isDisabledByOverride)?  $default,) {final _that = this;
switch (_that) {
case _Block() when $default != null:
return $default(_that.superBlock,_that.dashedName,_that.name,_that.layout,_that.label,_that.description,_that.challenges,_that.isDisabledByOverride);case _:
  return null;

}
}

}

/// @nodoc


class _Block implements Block {
  const _Block({required this.superBlock, required this.dashedName, required this.name, required this.layout, required this.label, required final  List<String> description, required final  List<ChallengeOrder> challenges, this.isDisabledByOverride = false}): _description = description,_challenges = challenges;
  

@override final  String superBlock;
@override final  String dashedName;
@override final  String name;
@override final  BlockLayout layout;
@override final  BlockLabel label;
 final  List<String> _description;
@override List<String> get description {
  if (_description is EqualUnmodifiableListView) return _description;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_description);
}

 final  List<ChallengeOrder> _challenges;
@override List<ChallengeOrder> get challenges {
  if (_challenges is EqualUnmodifiableListView) return _challenges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_challenges);
}

@override@JsonKey() final  bool isDisabledByOverride;

/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BlockCopyWith<_Block> get copyWith => __$BlockCopyWithImpl<_Block>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Block&&(identical(other.superBlock, superBlock) || other.superBlock == superBlock)&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.name, name) || other.name == name)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.label, label) || other.label == label)&&const DeepCollectionEquality().equals(other._description, _description)&&const DeepCollectionEquality().equals(other._challenges, _challenges)&&(identical(other.isDisabledByOverride, isDisabledByOverride) || other.isDisabledByOverride == isDisabledByOverride));
}


@override
int get hashCode => Object.hash(runtimeType,superBlock,dashedName,name,layout,label,const DeepCollectionEquality().hash(_description),const DeepCollectionEquality().hash(_challenges),isDisabledByOverride);

@override
String toString() {
  return 'Block(superBlock: $superBlock, dashedName: $dashedName, name: $name, layout: $layout, label: $label, description: $description, challenges: $challenges, isDisabledByOverride: $isDisabledByOverride)';
}


}

/// @nodoc
abstract mixin class _$BlockCopyWith<$Res> implements $BlockCopyWith<$Res> {
  factory _$BlockCopyWith(_Block value, $Res Function(_Block) _then) = __$BlockCopyWithImpl;
@override @useResult
$Res call({
 String superBlock, String dashedName, String name, BlockLayout layout, BlockLabel label, List<String> description, List<ChallengeOrder> challenges, bool isDisabledByOverride
});




}
/// @nodoc
class __$BlockCopyWithImpl<$Res>
    implements _$BlockCopyWith<$Res> {
  __$BlockCopyWithImpl(this._self, this._then);

  final _Block _self;
  final $Res Function(_Block) _then;

/// Create a copy of Block
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? superBlock = null,Object? dashedName = null,Object? name = null,Object? layout = null,Object? label = null,Object? description = null,Object? challenges = null,Object? isDisabledByOverride = null,}) {
  return _then(_Block(
superBlock: null == superBlock ? _self.superBlock : superBlock // ignore: cast_nullable_to_non_nullable
as String,dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as BlockLayout,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as BlockLabel,description: null == description ? _self._description : description // ignore: cast_nullable_to_non_nullable
as List<String>,challenges: null == challenges ? _self._challenges : challenges // ignore: cast_nullable_to_non_nullable
as List<ChallengeOrder>,isDisabledByOverride: null == isDisabledByOverride ? _self.isDisabledByOverride : isDisabledByOverride // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$Module {

 String get dashedName; String get name; bool get comingSoon; ModuleType? get moduleType; List<Block> get blocks;
/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModuleCopyWith<Module> get copyWith => _$ModuleCopyWithImpl<Module>(this as Module, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Module&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.name, name) || other.name == name)&&(identical(other.comingSoon, comingSoon) || other.comingSoon == comingSoon)&&(identical(other.moduleType, moduleType) || other.moduleType == moduleType)&&const DeepCollectionEquality().equals(other.blocks, blocks));
}


@override
int get hashCode => Object.hash(runtimeType,dashedName,name,comingSoon,moduleType,const DeepCollectionEquality().hash(blocks));

@override
String toString() {
  return 'Module(dashedName: $dashedName, name: $name, comingSoon: $comingSoon, moduleType: $moduleType, blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class $ModuleCopyWith<$Res>  {
  factory $ModuleCopyWith(Module value, $Res Function(Module) _then) = _$ModuleCopyWithImpl;
@useResult
$Res call({
 String dashedName, String name, bool comingSoon, ModuleType? moduleType, List<Block> blocks
});




}
/// @nodoc
class _$ModuleCopyWithImpl<$Res>
    implements $ModuleCopyWith<$Res> {
  _$ModuleCopyWithImpl(this._self, this._then);

  final Module _self;
  final $Res Function(Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dashedName = null,Object? name = null,Object? comingSoon = null,Object? moduleType = freezed,Object? blocks = null,}) {
  return _then(_self.copyWith(
dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,moduleType: freezed == moduleType ? _self.moduleType : moduleType // ignore: cast_nullable_to_non_nullable
as ModuleType?,blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<Block>,
  ));
}

}


/// Adds pattern-matching-related methods to [Module].
extension ModulePatterns on Module {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Module value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Module() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Module value)  $default,){
final _that = this;
switch (_that) {
case _Module():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Module value)?  $default,){
final _that = this;
switch (_that) {
case _Module() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dashedName,  String name,  bool comingSoon,  ModuleType? moduleType,  List<Block> blocks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Module() when $default != null:
return $default(_that.dashedName,_that.name,_that.comingSoon,_that.moduleType,_that.blocks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dashedName,  String name,  bool comingSoon,  ModuleType? moduleType,  List<Block> blocks)  $default,) {final _that = this;
switch (_that) {
case _Module():
return $default(_that.dashedName,_that.name,_that.comingSoon,_that.moduleType,_that.blocks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dashedName,  String name,  bool comingSoon,  ModuleType? moduleType,  List<Block> blocks)?  $default,) {final _that = this;
switch (_that) {
case _Module() when $default != null:
return $default(_that.dashedName,_that.name,_that.comingSoon,_that.moduleType,_that.blocks);case _:
  return null;

}
}

}

/// @nodoc


class _Module implements Module {
  const _Module({required this.dashedName, required this.name, this.comingSoon = false, this.moduleType, required final  List<Block> blocks}): _blocks = blocks;
  

@override final  String dashedName;
@override final  String name;
@override@JsonKey() final  bool comingSoon;
@override final  ModuleType? moduleType;
 final  List<Block> _blocks;
@override List<Block> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}


/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModuleCopyWith<_Module> get copyWith => __$ModuleCopyWithImpl<_Module>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Module&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.name, name) || other.name == name)&&(identical(other.comingSoon, comingSoon) || other.comingSoon == comingSoon)&&(identical(other.moduleType, moduleType) || other.moduleType == moduleType)&&const DeepCollectionEquality().equals(other._blocks, _blocks));
}


@override
int get hashCode => Object.hash(runtimeType,dashedName,name,comingSoon,moduleType,const DeepCollectionEquality().hash(_blocks));

@override
String toString() {
  return 'Module(dashedName: $dashedName, name: $name, comingSoon: $comingSoon, moduleType: $moduleType, blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class _$ModuleCopyWith<$Res> implements $ModuleCopyWith<$Res> {
  factory _$ModuleCopyWith(_Module value, $Res Function(_Module) _then) = __$ModuleCopyWithImpl;
@override @useResult
$Res call({
 String dashedName, String name, bool comingSoon, ModuleType? moduleType, List<Block> blocks
});




}
/// @nodoc
class __$ModuleCopyWithImpl<$Res>
    implements _$ModuleCopyWith<$Res> {
  __$ModuleCopyWithImpl(this._self, this._then);

  final _Module _self;
  final $Res Function(_Module) _then;

/// Create a copy of Module
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dashedName = null,Object? name = null,Object? comingSoon = null,Object? moduleType = freezed,Object? blocks = null,}) {
  return _then(_Module(
dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,moduleType: freezed == moduleType ? _self.moduleType : moduleType // ignore: cast_nullable_to_non_nullable
as ModuleType?,blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<Block>,
  ));
}


}

/// @nodoc
mixin _$Chapter {

 String get dashedName; String get name; bool get comingSoon; List<Module> get modules;
/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterCopyWith<Chapter> get copyWith => _$ChapterCopyWithImpl<Chapter>(this as Chapter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Chapter&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.name, name) || other.name == name)&&(identical(other.comingSoon, comingSoon) || other.comingSoon == comingSoon)&&const DeepCollectionEquality().equals(other.modules, modules));
}


@override
int get hashCode => Object.hash(runtimeType,dashedName,name,comingSoon,const DeepCollectionEquality().hash(modules));

@override
String toString() {
  return 'Chapter(dashedName: $dashedName, name: $name, comingSoon: $comingSoon, modules: $modules)';
}


}

/// @nodoc
abstract mixin class $ChapterCopyWith<$Res>  {
  factory $ChapterCopyWith(Chapter value, $Res Function(Chapter) _then) = _$ChapterCopyWithImpl;
@useResult
$Res call({
 String dashedName, String name, bool comingSoon, List<Module> modules
});




}
/// @nodoc
class _$ChapterCopyWithImpl<$Res>
    implements $ChapterCopyWith<$Res> {
  _$ChapterCopyWithImpl(this._self, this._then);

  final Chapter _self;
  final $Res Function(Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dashedName = null,Object? name = null,Object? comingSoon = null,Object? modules = null,}) {
  return _then(_self.copyWith(
dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,modules: null == modules ? _self.modules : modules // ignore: cast_nullable_to_non_nullable
as List<Module>,
  ));
}

}


/// Adds pattern-matching-related methods to [Chapter].
extension ChapterPatterns on Chapter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Chapter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Chapter value)  $default,){
final _that = this;
switch (_that) {
case _Chapter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Chapter value)?  $default,){
final _that = this;
switch (_that) {
case _Chapter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dashedName,  String name,  bool comingSoon,  List<Module> modules)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.dashedName,_that.name,_that.comingSoon,_that.modules);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dashedName,  String name,  bool comingSoon,  List<Module> modules)  $default,) {final _that = this;
switch (_that) {
case _Chapter():
return $default(_that.dashedName,_that.name,_that.comingSoon,_that.modules);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dashedName,  String name,  bool comingSoon,  List<Module> modules)?  $default,) {final _that = this;
switch (_that) {
case _Chapter() when $default != null:
return $default(_that.dashedName,_that.name,_that.comingSoon,_that.modules);case _:
  return null;

}
}

}

/// @nodoc


class _Chapter implements Chapter {
  const _Chapter({required this.dashedName, required this.name, this.comingSoon = false, required final  List<Module> modules}): _modules = modules;
  

@override final  String dashedName;
@override final  String name;
@override@JsonKey() final  bool comingSoon;
 final  List<Module> _modules;
@override List<Module> get modules {
  if (_modules is EqualUnmodifiableListView) return _modules;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_modules);
}


/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChapterCopyWith<_Chapter> get copyWith => __$ChapterCopyWithImpl<_Chapter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Chapter&&(identical(other.dashedName, dashedName) || other.dashedName == dashedName)&&(identical(other.name, name) || other.name == name)&&(identical(other.comingSoon, comingSoon) || other.comingSoon == comingSoon)&&const DeepCollectionEquality().equals(other._modules, _modules));
}


@override
int get hashCode => Object.hash(runtimeType,dashedName,name,comingSoon,const DeepCollectionEquality().hash(_modules));

@override
String toString() {
  return 'Chapter(dashedName: $dashedName, name: $name, comingSoon: $comingSoon, modules: $modules)';
}


}

/// @nodoc
abstract mixin class _$ChapterCopyWith<$Res> implements $ChapterCopyWith<$Res> {
  factory _$ChapterCopyWith(_Chapter value, $Res Function(_Chapter) _then) = __$ChapterCopyWithImpl;
@override @useResult
$Res call({
 String dashedName, String name, bool comingSoon, List<Module> modules
});




}
/// @nodoc
class __$ChapterCopyWithImpl<$Res>
    implements _$ChapterCopyWith<$Res> {
  __$ChapterCopyWithImpl(this._self, this._then);

  final _Chapter _self;
  final $Res Function(_Chapter) _then;

/// Create a copy of Chapter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dashedName = null,Object? name = null,Object? comingSoon = null,Object? modules = null,}) {
  return _then(_Chapter(
dashedName: null == dashedName ? _self.dashedName : dashedName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,comingSoon: null == comingSoon ? _self.comingSoon : comingSoon // ignore: cast_nullable_to_non_nullable
as bool,modules: null == modules ? _self._modules : modules // ignore: cast_nullable_to_non_nullable
as List<Module>,
  ));
}


}

/// @nodoc
mixin _$SuperBlock {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SuperBlock);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SuperBlock()';
}


}

/// @nodoc
class $SuperBlockCopyWith<$Res>  {
$SuperBlockCopyWith(SuperBlock _, $Res Function(SuperBlock) __);
}


/// Adds pattern-matching-related methods to [SuperBlock].
extension SuperBlockPatterns on SuperBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BlockSuperBlock value)?  blocks,TResult Function( ChapterSuperBlock value)?  chapters,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BlockSuperBlock() when blocks != null:
return blocks(_that);case ChapterSuperBlock() when chapters != null:
return chapters(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BlockSuperBlock value)  blocks,required TResult Function( ChapterSuperBlock value)  chapters,}){
final _that = this;
switch (_that) {
case BlockSuperBlock():
return blocks(_that);case ChapterSuperBlock():
return chapters(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BlockSuperBlock value)?  blocks,TResult? Function( ChapterSuperBlock value)?  chapters,}){
final _that = this;
switch (_that) {
case BlockSuperBlock() when blocks != null:
return blocks(_that);case ChapterSuperBlock() when chapters != null:
return chapters(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<Block> blocks)?  blocks,TResult Function( List<Chapter> chapters)?  chapters,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BlockSuperBlock() when blocks != null:
return blocks(_that.blocks);case ChapterSuperBlock() when chapters != null:
return chapters(_that.chapters);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<Block> blocks)  blocks,required TResult Function( List<Chapter> chapters)  chapters,}) {final _that = this;
switch (_that) {
case BlockSuperBlock():
return blocks(_that.blocks);case ChapterSuperBlock():
return chapters(_that.chapters);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<Block> blocks)?  blocks,TResult? Function( List<Chapter> chapters)?  chapters,}) {final _that = this;
switch (_that) {
case BlockSuperBlock() when blocks != null:
return blocks(_that.blocks);case ChapterSuperBlock() when chapters != null:
return chapters(_that.chapters);case _:
  return null;

}
}

}

/// @nodoc


class BlockSuperBlock implements SuperBlock {
  const BlockSuperBlock(final  List<Block> blocks): _blocks = blocks;
  

 final  List<Block> _blocks;
 List<Block> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}


/// Create a copy of SuperBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BlockSuperBlockCopyWith<BlockSuperBlock> get copyWith => _$BlockSuperBlockCopyWithImpl<BlockSuperBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BlockSuperBlock&&const DeepCollectionEquality().equals(other._blocks, _blocks));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_blocks));

@override
String toString() {
  return 'SuperBlock.blocks(blocks: $blocks)';
}


}

/// @nodoc
abstract mixin class $BlockSuperBlockCopyWith<$Res> implements $SuperBlockCopyWith<$Res> {
  factory $BlockSuperBlockCopyWith(BlockSuperBlock value, $Res Function(BlockSuperBlock) _then) = _$BlockSuperBlockCopyWithImpl;
@useResult
$Res call({
 List<Block> blocks
});




}
/// @nodoc
class _$BlockSuperBlockCopyWithImpl<$Res>
    implements $BlockSuperBlockCopyWith<$Res> {
  _$BlockSuperBlockCopyWithImpl(this._self, this._then);

  final BlockSuperBlock _self;
  final $Res Function(BlockSuperBlock) _then;

/// Create a copy of SuperBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? blocks = null,}) {
  return _then(BlockSuperBlock(
null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<Block>,
  ));
}


}

/// @nodoc


class ChapterSuperBlock implements SuperBlock {
  const ChapterSuperBlock(final  List<Chapter> chapters): _chapters = chapters;
  

 final  List<Chapter> _chapters;
 List<Chapter> get chapters {
  if (_chapters is EqualUnmodifiableListView) return _chapters;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chapters);
}


/// Create a copy of SuperBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChapterSuperBlockCopyWith<ChapterSuperBlock> get copyWith => _$ChapterSuperBlockCopyWithImpl<ChapterSuperBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChapterSuperBlock&&const DeepCollectionEquality().equals(other._chapters, _chapters));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_chapters));

@override
String toString() {
  return 'SuperBlock.chapters(chapters: $chapters)';
}


}

/// @nodoc
abstract mixin class $ChapterSuperBlockCopyWith<$Res> implements $SuperBlockCopyWith<$Res> {
  factory $ChapterSuperBlockCopyWith(ChapterSuperBlock value, $Res Function(ChapterSuperBlock) _then) = _$ChapterSuperBlockCopyWithImpl;
@useResult
$Res call({
 List<Chapter> chapters
});




}
/// @nodoc
class _$ChapterSuperBlockCopyWithImpl<$Res>
    implements $ChapterSuperBlockCopyWith<$Res> {
  _$ChapterSuperBlockCopyWithImpl(this._self, this._then);

  final ChapterSuperBlock _self;
  final $Res Function(ChapterSuperBlock) _then;

/// Create a copy of SuperBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? chapters = null,}) {
  return _then(ChapterSuperBlock(
null == chapters ? _self._chapters : chapters // ignore: cast_nullable_to_non_nullable
as List<Chapter>,
  ));
}


}

// dart format on
