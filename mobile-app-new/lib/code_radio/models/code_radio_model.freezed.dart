// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'code_radio_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CodeRadio {

 Station get station; Listeners get listeners;@JsonKey(name: 'now_playing') NowPlaying get nowPlaying;@JsonKey(name: 'playing_next') PlayingNext get playingNext;
/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CodeRadioCopyWith<CodeRadio> get copyWith => _$CodeRadioCopyWithImpl<CodeRadio>(this as CodeRadio, _$identity);

  /// Serializes this CodeRadio to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CodeRadio&&(identical(other.station, station) || other.station == station)&&(identical(other.listeners, listeners) || other.listeners == listeners)&&(identical(other.nowPlaying, nowPlaying) || other.nowPlaying == nowPlaying)&&(identical(other.playingNext, playingNext) || other.playingNext == playingNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,station,listeners,nowPlaying,playingNext);

@override
String toString() {
  return 'CodeRadio(station: $station, listeners: $listeners, nowPlaying: $nowPlaying, playingNext: $playingNext)';
}


}

/// @nodoc
abstract mixin class $CodeRadioCopyWith<$Res>  {
  factory $CodeRadioCopyWith(CodeRadio value, $Res Function(CodeRadio) _then) = _$CodeRadioCopyWithImpl;
@useResult
$Res call({
 Station station, Listeners listeners,@JsonKey(name: 'now_playing') NowPlaying nowPlaying,@JsonKey(name: 'playing_next') PlayingNext playingNext
});


$StationCopyWith<$Res> get station;$ListenersCopyWith<$Res> get listeners;$NowPlayingCopyWith<$Res> get nowPlaying;$PlayingNextCopyWith<$Res> get playingNext;

}
/// @nodoc
class _$CodeRadioCopyWithImpl<$Res>
    implements $CodeRadioCopyWith<$Res> {
  _$CodeRadioCopyWithImpl(this._self, this._then);

  final CodeRadio _self;
  final $Res Function(CodeRadio) _then;

/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? station = null,Object? listeners = null,Object? nowPlaying = null,Object? playingNext = null,}) {
  return _then(_self.copyWith(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as Station,listeners: null == listeners ? _self.listeners : listeners // ignore: cast_nullable_to_non_nullable
as Listeners,nowPlaying: null == nowPlaying ? _self.nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as NowPlaying,playingNext: null == playingNext ? _self.playingNext : playingNext // ignore: cast_nullable_to_non_nullable
as PlayingNext,
  ));
}
/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get station {
  
  return $StationCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListenersCopyWith<$Res> get listeners {
  
  return $ListenersCopyWith<$Res>(_self.listeners, (value) {
    return _then(_self.copyWith(listeners: value));
  });
}/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NowPlayingCopyWith<$Res> get nowPlaying {
  
  return $NowPlayingCopyWith<$Res>(_self.nowPlaying, (value) {
    return _then(_self.copyWith(nowPlaying: value));
  });
}/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayingNextCopyWith<$Res> get playingNext {
  
  return $PlayingNextCopyWith<$Res>(_self.playingNext, (value) {
    return _then(_self.copyWith(playingNext: value));
  });
}
}


/// Adds pattern-matching-related methods to [CodeRadio].
extension CodeRadioPatterns on CodeRadio {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CodeRadio value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CodeRadio() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CodeRadio value)  $default,){
final _that = this;
switch (_that) {
case _CodeRadio():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CodeRadio value)?  $default,){
final _that = this;
switch (_that) {
case _CodeRadio() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Station station,  Listeners listeners, @JsonKey(name: 'now_playing')  NowPlaying nowPlaying, @JsonKey(name: 'playing_next')  PlayingNext playingNext)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CodeRadio() when $default != null:
return $default(_that.station,_that.listeners,_that.nowPlaying,_that.playingNext);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Station station,  Listeners listeners, @JsonKey(name: 'now_playing')  NowPlaying nowPlaying, @JsonKey(name: 'playing_next')  PlayingNext playingNext)  $default,) {final _that = this;
switch (_that) {
case _CodeRadio():
return $default(_that.station,_that.listeners,_that.nowPlaying,_that.playingNext);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Station station,  Listeners listeners, @JsonKey(name: 'now_playing')  NowPlaying nowPlaying, @JsonKey(name: 'playing_next')  PlayingNext playingNext)?  $default,) {final _that = this;
switch (_that) {
case _CodeRadio() when $default != null:
return $default(_that.station,_that.listeners,_that.nowPlaying,_that.playingNext);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CodeRadio implements CodeRadio {
  const _CodeRadio({required this.station, required this.listeners, @JsonKey(name: 'now_playing') required this.nowPlaying, @JsonKey(name: 'playing_next') required this.playingNext});
  factory _CodeRadio.fromJson(Map<String, dynamic> json) => _$CodeRadioFromJson(json);

@override final  Station station;
@override final  Listeners listeners;
@override@JsonKey(name: 'now_playing') final  NowPlaying nowPlaying;
@override@JsonKey(name: 'playing_next') final  PlayingNext playingNext;

/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CodeRadioCopyWith<_CodeRadio> get copyWith => __$CodeRadioCopyWithImpl<_CodeRadio>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CodeRadioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CodeRadio&&(identical(other.station, station) || other.station == station)&&(identical(other.listeners, listeners) || other.listeners == listeners)&&(identical(other.nowPlaying, nowPlaying) || other.nowPlaying == nowPlaying)&&(identical(other.playingNext, playingNext) || other.playingNext == playingNext));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,station,listeners,nowPlaying,playingNext);

@override
String toString() {
  return 'CodeRadio(station: $station, listeners: $listeners, nowPlaying: $nowPlaying, playingNext: $playingNext)';
}


}

/// @nodoc
abstract mixin class _$CodeRadioCopyWith<$Res> implements $CodeRadioCopyWith<$Res> {
  factory _$CodeRadioCopyWith(_CodeRadio value, $Res Function(_CodeRadio) _then) = __$CodeRadioCopyWithImpl;
@override @useResult
$Res call({
 Station station, Listeners listeners,@JsonKey(name: 'now_playing') NowPlaying nowPlaying,@JsonKey(name: 'playing_next') PlayingNext playingNext
});


@override $StationCopyWith<$Res> get station;@override $ListenersCopyWith<$Res> get listeners;@override $NowPlayingCopyWith<$Res> get nowPlaying;@override $PlayingNextCopyWith<$Res> get playingNext;

}
/// @nodoc
class __$CodeRadioCopyWithImpl<$Res>
    implements _$CodeRadioCopyWith<$Res> {
  __$CodeRadioCopyWithImpl(this._self, this._then);

  final _CodeRadio _self;
  final $Res Function(_CodeRadio) _then;

/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? station = null,Object? listeners = null,Object? nowPlaying = null,Object? playingNext = null,}) {
  return _then(_CodeRadio(
station: null == station ? _self.station : station // ignore: cast_nullable_to_non_nullable
as Station,listeners: null == listeners ? _self.listeners : listeners // ignore: cast_nullable_to_non_nullable
as Listeners,nowPlaying: null == nowPlaying ? _self.nowPlaying : nowPlaying // ignore: cast_nullable_to_non_nullable
as NowPlaying,playingNext: null == playingNext ? _self.playingNext : playingNext // ignore: cast_nullable_to_non_nullable
as PlayingNext,
  ));
}

/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StationCopyWith<$Res> get station {
  
  return $StationCopyWith<$Res>(_self.station, (value) {
    return _then(_self.copyWith(station: value));
  });
}/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListenersCopyWith<$Res> get listeners {
  
  return $ListenersCopyWith<$Res>(_self.listeners, (value) {
    return _then(_self.copyWith(listeners: value));
  });
}/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NowPlayingCopyWith<$Res> get nowPlaying {
  
  return $NowPlayingCopyWith<$Res>(_self.nowPlaying, (value) {
    return _then(_self.copyWith(nowPlaying: value));
  });
}/// Create a copy of CodeRadio
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayingNextCopyWith<$Res> get playingNext {
  
  return $PlayingNextCopyWith<$Res>(_self.playingNext, (value) {
    return _then(_self.copyWith(playingNext: value));
  });
}
}


/// @nodoc
mixin _$Station {

@JsonKey(name: 'listen_url') String get listenUrl;
/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StationCopyWith<Station> get copyWith => _$StationCopyWithImpl<Station>(this as Station, _$identity);

  /// Serializes this Station to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Station&&(identical(other.listenUrl, listenUrl) || other.listenUrl == listenUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,listenUrl);

@override
String toString() {
  return 'Station(listenUrl: $listenUrl)';
}


}

/// @nodoc
abstract mixin class $StationCopyWith<$Res>  {
  factory $StationCopyWith(Station value, $Res Function(Station) _then) = _$StationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'listen_url') String listenUrl
});




}
/// @nodoc
class _$StationCopyWithImpl<$Res>
    implements $StationCopyWith<$Res> {
  _$StationCopyWithImpl(this._self, this._then);

  final Station _self;
  final $Res Function(Station) _then;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? listenUrl = null,}) {
  return _then(_self.copyWith(
listenUrl: null == listenUrl ? _self.listenUrl : listenUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Station].
extension StationPatterns on Station {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Station value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Station() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Station value)  $default,){
final _that = this;
switch (_that) {
case _Station():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Station value)?  $default,){
final _that = this;
switch (_that) {
case _Station() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'listen_url')  String listenUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Station() when $default != null:
return $default(_that.listenUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'listen_url')  String listenUrl)  $default,) {final _that = this;
switch (_that) {
case _Station():
return $default(_that.listenUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'listen_url')  String listenUrl)?  $default,) {final _that = this;
switch (_that) {
case _Station() when $default != null:
return $default(_that.listenUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Station implements Station {
  const _Station({@JsonKey(name: 'listen_url') required this.listenUrl});
  factory _Station.fromJson(Map<String, dynamic> json) => _$StationFromJson(json);

@override@JsonKey(name: 'listen_url') final  String listenUrl;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StationCopyWith<_Station> get copyWith => __$StationCopyWithImpl<_Station>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Station&&(identical(other.listenUrl, listenUrl) || other.listenUrl == listenUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,listenUrl);

@override
String toString() {
  return 'Station(listenUrl: $listenUrl)';
}


}

/// @nodoc
abstract mixin class _$StationCopyWith<$Res> implements $StationCopyWith<$Res> {
  factory _$StationCopyWith(_Station value, $Res Function(_Station) _then) = __$StationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'listen_url') String listenUrl
});




}
/// @nodoc
class __$StationCopyWithImpl<$Res>
    implements _$StationCopyWith<$Res> {
  __$StationCopyWithImpl(this._self, this._then);

  final _Station _self;
  final $Res Function(_Station) _then;

/// Create a copy of Station
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? listenUrl = null,}) {
  return _then(_Station(
listenUrl: null == listenUrl ? _self.listenUrl : listenUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$Listeners {

 int get total;
/// Create a copy of Listeners
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListenersCopyWith<Listeners> get copyWith => _$ListenersCopyWithImpl<Listeners>(this as Listeners, _$identity);

  /// Serializes this Listeners to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Listeners&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total);

@override
String toString() {
  return 'Listeners(total: $total)';
}


}

/// @nodoc
abstract mixin class $ListenersCopyWith<$Res>  {
  factory $ListenersCopyWith(Listeners value, $Res Function(Listeners) _then) = _$ListenersCopyWithImpl;
@useResult
$Res call({
 int total
});




}
/// @nodoc
class _$ListenersCopyWithImpl<$Res>
    implements $ListenersCopyWith<$Res> {
  _$ListenersCopyWithImpl(this._self, this._then);

  final Listeners _self;
  final $Res Function(Listeners) _then;

/// Create a copy of Listeners
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Listeners].
extension ListenersPatterns on Listeners {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Listeners value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Listeners() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Listeners value)  $default,){
final _that = this;
switch (_that) {
case _Listeners():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Listeners value)?  $default,){
final _that = this;
switch (_that) {
case _Listeners() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Listeners() when $default != null:
return $default(_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total)  $default,) {final _that = this;
switch (_that) {
case _Listeners():
return $default(_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total)?  $default,) {final _that = this;
switch (_that) {
case _Listeners() when $default != null:
return $default(_that.total);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Listeners implements Listeners {
  const _Listeners({required this.total});
  factory _Listeners.fromJson(Map<String, dynamic> json) => _$ListenersFromJson(json);

@override final  int total;

/// Create a copy of Listeners
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListenersCopyWith<_Listeners> get copyWith => __$ListenersCopyWithImpl<_Listeners>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListenersToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Listeners&&(identical(other.total, total) || other.total == total));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total);

@override
String toString() {
  return 'Listeners(total: $total)';
}


}

/// @nodoc
abstract mixin class _$ListenersCopyWith<$Res> implements $ListenersCopyWith<$Res> {
  factory _$ListenersCopyWith(_Listeners value, $Res Function(_Listeners) _then) = __$ListenersCopyWithImpl;
@override @useResult
$Res call({
 int total
});




}
/// @nodoc
class __$ListenersCopyWithImpl<$Res>
    implements _$ListenersCopyWith<$Res> {
  __$ListenersCopyWithImpl(this._self, this._then);

  final _Listeners _self;
  final $Res Function(_Listeners) _then;

/// Create a copy of Listeners
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,}) {
  return _then(_Listeners(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NowPlaying {

 int get duration; int get elapsed; Song get song;
/// Create a copy of NowPlaying
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NowPlayingCopyWith<NowPlaying> get copyWith => _$NowPlayingCopyWithImpl<NowPlaying>(this as NowPlaying, _$identity);

  /// Serializes this NowPlaying to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NowPlaying&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.song, song) || other.song == song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,duration,elapsed,song);

@override
String toString() {
  return 'NowPlaying(duration: $duration, elapsed: $elapsed, song: $song)';
}


}

/// @nodoc
abstract mixin class $NowPlayingCopyWith<$Res>  {
  factory $NowPlayingCopyWith(NowPlaying value, $Res Function(NowPlaying) _then) = _$NowPlayingCopyWithImpl;
@useResult
$Res call({
 int duration, int elapsed, Song song
});


$SongCopyWith<$Res> get song;

}
/// @nodoc
class _$NowPlayingCopyWithImpl<$Res>
    implements $NowPlayingCopyWith<$Res> {
  _$NowPlayingCopyWithImpl(this._self, this._then);

  final NowPlaying _self;
  final $Res Function(NowPlaying) _then;

/// Create a copy of NowPlaying
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? duration = null,Object? elapsed = null,Object? song = null,}) {
  return _then(_self.copyWith(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as int,song: null == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as Song,
  ));
}
/// Create a copy of NowPlaying
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongCopyWith<$Res> get song {
  
  return $SongCopyWith<$Res>(_self.song, (value) {
    return _then(_self.copyWith(song: value));
  });
}
}


/// Adds pattern-matching-related methods to [NowPlaying].
extension NowPlayingPatterns on NowPlaying {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NowPlaying value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NowPlaying() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NowPlaying value)  $default,){
final _that = this;
switch (_that) {
case _NowPlaying():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NowPlaying value)?  $default,){
final _that = this;
switch (_that) {
case _NowPlaying() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int duration,  int elapsed,  Song song)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NowPlaying() when $default != null:
return $default(_that.duration,_that.elapsed,_that.song);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int duration,  int elapsed,  Song song)  $default,) {final _that = this;
switch (_that) {
case _NowPlaying():
return $default(_that.duration,_that.elapsed,_that.song);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int duration,  int elapsed,  Song song)?  $default,) {final _that = this;
switch (_that) {
case _NowPlaying() when $default != null:
return $default(_that.duration,_that.elapsed,_that.song);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NowPlaying implements NowPlaying {
  const _NowPlaying({required this.duration, required this.elapsed, required this.song});
  factory _NowPlaying.fromJson(Map<String, dynamic> json) => _$NowPlayingFromJson(json);

@override final  int duration;
@override final  int elapsed;
@override final  Song song;

/// Create a copy of NowPlaying
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NowPlayingCopyWith<_NowPlaying> get copyWith => __$NowPlayingCopyWithImpl<_NowPlaying>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NowPlayingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NowPlaying&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.elapsed, elapsed) || other.elapsed == elapsed)&&(identical(other.song, song) || other.song == song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,duration,elapsed,song);

@override
String toString() {
  return 'NowPlaying(duration: $duration, elapsed: $elapsed, song: $song)';
}


}

/// @nodoc
abstract mixin class _$NowPlayingCopyWith<$Res> implements $NowPlayingCopyWith<$Res> {
  factory _$NowPlayingCopyWith(_NowPlaying value, $Res Function(_NowPlaying) _then) = __$NowPlayingCopyWithImpl;
@override @useResult
$Res call({
 int duration, int elapsed, Song song
});


@override $SongCopyWith<$Res> get song;

}
/// @nodoc
class __$NowPlayingCopyWithImpl<$Res>
    implements _$NowPlayingCopyWith<$Res> {
  __$NowPlayingCopyWithImpl(this._self, this._then);

  final _NowPlaying _self;
  final $Res Function(_NowPlaying) _then;

/// Create a copy of NowPlaying
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? duration = null,Object? elapsed = null,Object? song = null,}) {
  return _then(_NowPlaying(
duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int,elapsed: null == elapsed ? _self.elapsed : elapsed // ignore: cast_nullable_to_non_nullable
as int,song: null == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as Song,
  ));
}

/// Create a copy of NowPlaying
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongCopyWith<$Res> get song {
  
  return $SongCopyWith<$Res>(_self.song, (value) {
    return _then(_self.copyWith(song: value));
  });
}
}


/// @nodoc
mixin _$PlayingNext {

 Song get song;
/// Create a copy of PlayingNext
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayingNextCopyWith<PlayingNext> get copyWith => _$PlayingNextCopyWithImpl<PlayingNext>(this as PlayingNext, _$identity);

  /// Serializes this PlayingNext to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayingNext&&(identical(other.song, song) || other.song == song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,song);

@override
String toString() {
  return 'PlayingNext(song: $song)';
}


}

/// @nodoc
abstract mixin class $PlayingNextCopyWith<$Res>  {
  factory $PlayingNextCopyWith(PlayingNext value, $Res Function(PlayingNext) _then) = _$PlayingNextCopyWithImpl;
@useResult
$Res call({
 Song song
});


$SongCopyWith<$Res> get song;

}
/// @nodoc
class _$PlayingNextCopyWithImpl<$Res>
    implements $PlayingNextCopyWith<$Res> {
  _$PlayingNextCopyWithImpl(this._self, this._then);

  final PlayingNext _self;
  final $Res Function(PlayingNext) _then;

/// Create a copy of PlayingNext
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? song = null,}) {
  return _then(_self.copyWith(
song: null == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as Song,
  ));
}
/// Create a copy of PlayingNext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongCopyWith<$Res> get song {
  
  return $SongCopyWith<$Res>(_self.song, (value) {
    return _then(_self.copyWith(song: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayingNext].
extension PlayingNextPatterns on PlayingNext {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayingNext value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayingNext() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayingNext value)  $default,){
final _that = this;
switch (_that) {
case _PlayingNext():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayingNext value)?  $default,){
final _that = this;
switch (_that) {
case _PlayingNext() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Song song)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayingNext() when $default != null:
return $default(_that.song);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Song song)  $default,) {final _that = this;
switch (_that) {
case _PlayingNext():
return $default(_that.song);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Song song)?  $default,) {final _that = this;
switch (_that) {
case _PlayingNext() when $default != null:
return $default(_that.song);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayingNext implements PlayingNext {
  const _PlayingNext({required this.song});
  factory _PlayingNext.fromJson(Map<String, dynamic> json) => _$PlayingNextFromJson(json);

@override final  Song song;

/// Create a copy of PlayingNext
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayingNextCopyWith<_PlayingNext> get copyWith => __$PlayingNextCopyWithImpl<_PlayingNext>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayingNextToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayingNext&&(identical(other.song, song) || other.song == song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,song);

@override
String toString() {
  return 'PlayingNext(song: $song)';
}


}

/// @nodoc
abstract mixin class _$PlayingNextCopyWith<$Res> implements $PlayingNextCopyWith<$Res> {
  factory _$PlayingNextCopyWith(_PlayingNext value, $Res Function(_PlayingNext) _then) = __$PlayingNextCopyWithImpl;
@override @useResult
$Res call({
 Song song
});


@override $SongCopyWith<$Res> get song;

}
/// @nodoc
class __$PlayingNextCopyWithImpl<$Res>
    implements _$PlayingNextCopyWith<$Res> {
  __$PlayingNextCopyWithImpl(this._self, this._then);

  final _PlayingNext _self;
  final $Res Function(_PlayingNext) _then;

/// Create a copy of PlayingNext
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? song = null,}) {
  return _then(_PlayingNext(
song: null == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as Song,
  ));
}

/// Create a copy of PlayingNext
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongCopyWith<$Res> get song {
  
  return $SongCopyWith<$Res>(_self.song, (value) {
    return _then(_self.copyWith(song: value));
  });
}
}


/// @nodoc
mixin _$Song {

 String get id; String get title; String get artist; String get album; String get art;
/// Create a copy of Song
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SongCopyWith<Song> get copyWith => _$SongCopyWithImpl<Song>(this as Song, _$identity);

  /// Serializes this Song to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Song&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.art, art) || other.art == art));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,artist,album,art);

@override
String toString() {
  return 'Song(id: $id, title: $title, artist: $artist, album: $album, art: $art)';
}


}

/// @nodoc
abstract mixin class $SongCopyWith<$Res>  {
  factory $SongCopyWith(Song value, $Res Function(Song) _then) = _$SongCopyWithImpl;
@useResult
$Res call({
 String id, String title, String artist, String album, String art
});




}
/// @nodoc
class _$SongCopyWithImpl<$Res>
    implements $SongCopyWith<$Res> {
  _$SongCopyWithImpl(this._self, this._then);

  final Song _self;
  final $Res Function(Song) _then;

/// Create a copy of Song
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? album = null,Object? art = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,art: null == art ? _self.art : art // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Song].
extension SongPatterns on Song {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Song value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Song() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Song value)  $default,){
final _that = this;
switch (_that) {
case _Song():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Song value)?  $default,){
final _that = this;
switch (_that) {
case _Song() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String album,  String art)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Song() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.album,_that.art);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String artist,  String album,  String art)  $default,) {final _that = this;
switch (_that) {
case _Song():
return $default(_that.id,_that.title,_that.artist,_that.album,_that.art);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String artist,  String album,  String art)?  $default,) {final _that = this;
switch (_that) {
case _Song() when $default != null:
return $default(_that.id,_that.title,_that.artist,_that.album,_that.art);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Song implements Song {
  const _Song({required this.id, required this.title, required this.artist, required this.album, required this.art});
  factory _Song.fromJson(Map<String, dynamic> json) => _$SongFromJson(json);

@override final  String id;
@override final  String title;
@override final  String artist;
@override final  String album;
@override final  String art;

/// Create a copy of Song
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SongCopyWith<_Song> get copyWith => __$SongCopyWithImpl<_Song>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SongToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Song&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.art, art) || other.art == art));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,artist,album,art);

@override
String toString() {
  return 'Song(id: $id, title: $title, artist: $artist, album: $album, art: $art)';
}


}

/// @nodoc
abstract mixin class _$SongCopyWith<$Res> implements $SongCopyWith<$Res> {
  factory _$SongCopyWith(_Song value, $Res Function(_Song) _then) = __$SongCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String artist, String album, String art
});




}
/// @nodoc
class __$SongCopyWithImpl<$Res>
    implements _$SongCopyWith<$Res> {
  __$SongCopyWithImpl(this._self, this._then);

  final _Song _self;
  final $Res Function(_Song) _then;

/// Create a copy of Song
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? artist = null,Object? album = null,Object? art = null,}) {
  return _then(_Song(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: null == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String,album: null == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String,art: null == art ? _self.art : art // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
