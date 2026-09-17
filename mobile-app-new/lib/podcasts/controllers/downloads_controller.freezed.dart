// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'downloads_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DownloadStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadStatus()';
}


}

/// @nodoc
class $DownloadStatusCopyWith<$Res>  {
$DownloadStatusCopyWith(DownloadStatus _, $Res Function(DownloadStatus) __);
}


/// Adds pattern-matching-related methods to [DownloadStatus].
extension DownloadStatusPatterns on DownloadStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DownloadRunning value)?  running,TResult Function( DownloadFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DownloadRunning() when running != null:
return running(_that);case DownloadFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DownloadRunning value)  running,required TResult Function( DownloadFailed value)  failed,}){
final _that = this;
switch (_that) {
case DownloadRunning():
return running(_that);case DownloadFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DownloadRunning value)?  running,TResult? Function( DownloadFailed value)?  failed,}){
final _that = this;
switch (_that) {
case DownloadRunning() when running != null:
return running(_that);case DownloadFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( double progress)?  running,TResult Function()?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DownloadRunning() when running != null:
return running(_that.progress);case DownloadFailed() when failed != null:
return failed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( double progress)  running,required TResult Function()  failed,}) {final _that = this;
switch (_that) {
case DownloadRunning():
return running(_that.progress);case DownloadFailed():
return failed();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( double progress)?  running,TResult? Function()?  failed,}) {final _that = this;
switch (_that) {
case DownloadRunning() when running != null:
return running(_that.progress);case DownloadFailed() when failed != null:
return failed();case _:
  return null;

}
}

}

/// @nodoc


class DownloadRunning implements DownloadStatus {
  const DownloadRunning(this.progress);
  

 final  double progress;

/// Create a copy of DownloadStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DownloadRunningCopyWith<DownloadRunning> get copyWith => _$DownloadRunningCopyWithImpl<DownloadRunning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadRunning&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,progress);

@override
String toString() {
  return 'DownloadStatus.running(progress: $progress)';
}


}

/// @nodoc
abstract mixin class $DownloadRunningCopyWith<$Res> implements $DownloadStatusCopyWith<$Res> {
  factory $DownloadRunningCopyWith(DownloadRunning value, $Res Function(DownloadRunning) _then) = _$DownloadRunningCopyWithImpl;
@useResult
$Res call({
 double progress
});




}
/// @nodoc
class _$DownloadRunningCopyWithImpl<$Res>
    implements $DownloadRunningCopyWith<$Res> {
  _$DownloadRunningCopyWithImpl(this._self, this._then);

  final DownloadRunning _self;
  final $Res Function(DownloadRunning) _then;

/// Create a copy of DownloadStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? progress = null,}) {
  return _then(DownloadRunning(
null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class DownloadFailed implements DownloadStatus {
  const DownloadFailed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DownloadFailed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DownloadStatus.failed()';
}


}




// dart format on
