// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Portfolio {

 String get id; String? get title; String? get url; String? get image; String? get description;
/// Create a copy of Portfolio
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PortfolioCopyWith<Portfolio> get copyWith => _$PortfolioCopyWithImpl<Portfolio>(this as Portfolio, _$identity);

  /// Serializes this Portfolio to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Portfolio&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.image, image) || other.image == image)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,url,image,description);

@override
String toString() {
  return 'Portfolio(id: $id, title: $title, url: $url, image: $image, description: $description)';
}


}

/// @nodoc
abstract mixin class $PortfolioCopyWith<$Res>  {
  factory $PortfolioCopyWith(Portfolio value, $Res Function(Portfolio) _then) = _$PortfolioCopyWithImpl;
@useResult
$Res call({
 String id, String? title, String? url, String? image, String? description
});




}
/// @nodoc
class _$PortfolioCopyWithImpl<$Res>
    implements $PortfolioCopyWith<$Res> {
  _$PortfolioCopyWithImpl(this._self, this._then);

  final Portfolio _self;
  final $Res Function(Portfolio) _then;

/// Create a copy of Portfolio
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = freezed,Object? url = freezed,Object? image = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Portfolio].
extension PortfolioPatterns on Portfolio {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Portfolio value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Portfolio() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Portfolio value)  $default,){
final _that = this;
switch (_that) {
case _Portfolio():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Portfolio value)?  $default,){
final _that = this;
switch (_that) {
case _Portfolio() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? title,  String? url,  String? image,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Portfolio() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.image,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? title,  String? url,  String? image,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Portfolio():
return $default(_that.id,_that.title,_that.url,_that.image,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? title,  String? url,  String? image,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Portfolio() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.image,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Portfolio implements Portfolio {
  const _Portfolio({required this.id, this.title, this.url, this.image, this.description});
  factory _Portfolio.fromJson(Map<String, dynamic> json) => _$PortfolioFromJson(json);

@override final  String id;
@override final  String? title;
@override final  String? url;
@override final  String? image;
@override final  String? description;

/// Create a copy of Portfolio
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PortfolioCopyWith<_Portfolio> get copyWith => __$PortfolioCopyWithImpl<_Portfolio>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PortfolioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Portfolio&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.image, image) || other.image == image)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,url,image,description);

@override
String toString() {
  return 'Portfolio(id: $id, title: $title, url: $url, image: $image, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PortfolioCopyWith<$Res> implements $PortfolioCopyWith<$Res> {
  factory _$PortfolioCopyWith(_Portfolio value, $Res Function(_Portfolio) _then) = __$PortfolioCopyWithImpl;
@override @useResult
$Res call({
 String id, String? title, String? url, String? image, String? description
});




}
/// @nodoc
class __$PortfolioCopyWithImpl<$Res>
    implements _$PortfolioCopyWith<$Res> {
  __$PortfolioCopyWithImpl(this._self, this._then);

  final _Portfolio _self;
  final $Res Function(_Portfolio) _then;

/// Create a copy of Portfolio
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = freezed,Object? url = freezed,Object? image = freezed,Object? description = freezed,}) {
  return _then(_Portfolio(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Experience {

 String get id; String get title; String get company; String get startDate; String get description; String get location; String get endDate;
/// Create a copy of Experience
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExperienceCopyWith<Experience> get copyWith => _$ExperienceCopyWithImpl<Experience>(this as Experience, _$identity);

  /// Serializes this Experience to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Experience&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,company,startDate,description,location,endDate);

@override
String toString() {
  return 'Experience(id: $id, title: $title, company: $company, startDate: $startDate, description: $description, location: $location, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $ExperienceCopyWith<$Res>  {
  factory $ExperienceCopyWith(Experience value, $Res Function(Experience) _then) = _$ExperienceCopyWithImpl;
@useResult
$Res call({
 String id, String title, String company, String startDate, String description, String location, String endDate
});




}
/// @nodoc
class _$ExperienceCopyWithImpl<$Res>
    implements $ExperienceCopyWith<$Res> {
  _$ExperienceCopyWithImpl(this._self, this._then);

  final Experience _self;
  final $Res Function(Experience) _then;

/// Create a copy of Experience
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? company = null,Object? startDate = null,Object? description = null,Object? location = null,Object? endDate = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Experience].
extension ExperiencePatterns on Experience {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Experience value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Experience() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Experience value)  $default,){
final _that = this;
switch (_that) {
case _Experience():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Experience value)?  $default,){
final _that = this;
switch (_that) {
case _Experience() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String company,  String startDate,  String description,  String location,  String endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Experience() when $default != null:
return $default(_that.id,_that.title,_that.company,_that.startDate,_that.description,_that.location,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String company,  String startDate,  String description,  String location,  String endDate)  $default,) {final _that = this;
switch (_that) {
case _Experience():
return $default(_that.id,_that.title,_that.company,_that.startDate,_that.description,_that.location,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String company,  String startDate,  String description,  String location,  String endDate)?  $default,) {final _that = this;
switch (_that) {
case _Experience() when $default != null:
return $default(_that.id,_that.title,_that.company,_that.startDate,_that.description,_that.location,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Experience implements Experience {
  const _Experience({required this.id, required this.title, required this.company, required this.startDate, required this.description, this.location = '', this.endDate = ''});
  factory _Experience.fromJson(Map<String, dynamic> json) => _$ExperienceFromJson(json);

@override final  String id;
@override final  String title;
@override final  String company;
@override final  String startDate;
@override final  String description;
@override@JsonKey() final  String location;
@override@JsonKey() final  String endDate;

/// Create a copy of Experience
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExperienceCopyWith<_Experience> get copyWith => __$ExperienceCopyWithImpl<_Experience>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExperienceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Experience&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.company, company) || other.company == company)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.description, description) || other.description == description)&&(identical(other.location, location) || other.location == location)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,company,startDate,description,location,endDate);

@override
String toString() {
  return 'Experience(id: $id, title: $title, company: $company, startDate: $startDate, description: $description, location: $location, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$ExperienceCopyWith<$Res> implements $ExperienceCopyWith<$Res> {
  factory _$ExperienceCopyWith(_Experience value, $Res Function(_Experience) _then) = __$ExperienceCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String company, String startDate, String description, String location, String endDate
});




}
/// @nodoc
class __$ExperienceCopyWithImpl<$Res>
    implements _$ExperienceCopyWith<$Res> {
  __$ExperienceCopyWithImpl(this._self, this._then);

  final _Experience _self;
  final $Res Function(_Experience) _then;

/// Create a copy of Experience
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? company = null,Object? startDate = null,Object? description = null,Object? location = null,Object? endDate = null,}) {
  return _then(_Experience(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,company: null == company ? _self.company : company // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ProfileUI {

 bool get isLocked; bool get showAbout; bool get showCerts; bool get showDonation; bool get showHeatMap; bool get showLocation; bool get showName; bool get showPoints; bool get showPortfolio; bool get showExperience; bool get showTimeLine;
/// Create a copy of ProfileUI
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileUICopyWith<ProfileUI> get copyWith => _$ProfileUICopyWithImpl<ProfileUI>(this as ProfileUI, _$identity);

  /// Serializes this ProfileUI to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileUI&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.showAbout, showAbout) || other.showAbout == showAbout)&&(identical(other.showCerts, showCerts) || other.showCerts == showCerts)&&(identical(other.showDonation, showDonation) || other.showDonation == showDonation)&&(identical(other.showHeatMap, showHeatMap) || other.showHeatMap == showHeatMap)&&(identical(other.showLocation, showLocation) || other.showLocation == showLocation)&&(identical(other.showName, showName) || other.showName == showName)&&(identical(other.showPoints, showPoints) || other.showPoints == showPoints)&&(identical(other.showPortfolio, showPortfolio) || other.showPortfolio == showPortfolio)&&(identical(other.showExperience, showExperience) || other.showExperience == showExperience)&&(identical(other.showTimeLine, showTimeLine) || other.showTimeLine == showTimeLine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isLocked,showAbout,showCerts,showDonation,showHeatMap,showLocation,showName,showPoints,showPortfolio,showExperience,showTimeLine);

@override
String toString() {
  return 'ProfileUI(isLocked: $isLocked, showAbout: $showAbout, showCerts: $showCerts, showDonation: $showDonation, showHeatMap: $showHeatMap, showLocation: $showLocation, showName: $showName, showPoints: $showPoints, showPortfolio: $showPortfolio, showExperience: $showExperience, showTimeLine: $showTimeLine)';
}


}

/// @nodoc
abstract mixin class $ProfileUICopyWith<$Res>  {
  factory $ProfileUICopyWith(ProfileUI value, $Res Function(ProfileUI) _then) = _$ProfileUICopyWithImpl;
@useResult
$Res call({
 bool isLocked, bool showAbout, bool showCerts, bool showDonation, bool showHeatMap, bool showLocation, bool showName, bool showPoints, bool showPortfolio, bool showExperience, bool showTimeLine
});




}
/// @nodoc
class _$ProfileUICopyWithImpl<$Res>
    implements $ProfileUICopyWith<$Res> {
  _$ProfileUICopyWithImpl(this._self, this._then);

  final ProfileUI _self;
  final $Res Function(ProfileUI) _then;

/// Create a copy of ProfileUI
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLocked = null,Object? showAbout = null,Object? showCerts = null,Object? showDonation = null,Object? showHeatMap = null,Object? showLocation = null,Object? showName = null,Object? showPoints = null,Object? showPortfolio = null,Object? showExperience = null,Object? showTimeLine = null,}) {
  return _then(_self.copyWith(
isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,showAbout: null == showAbout ? _self.showAbout : showAbout // ignore: cast_nullable_to_non_nullable
as bool,showCerts: null == showCerts ? _self.showCerts : showCerts // ignore: cast_nullable_to_non_nullable
as bool,showDonation: null == showDonation ? _self.showDonation : showDonation // ignore: cast_nullable_to_non_nullable
as bool,showHeatMap: null == showHeatMap ? _self.showHeatMap : showHeatMap // ignore: cast_nullable_to_non_nullable
as bool,showLocation: null == showLocation ? _self.showLocation : showLocation // ignore: cast_nullable_to_non_nullable
as bool,showName: null == showName ? _self.showName : showName // ignore: cast_nullable_to_non_nullable
as bool,showPoints: null == showPoints ? _self.showPoints : showPoints // ignore: cast_nullable_to_non_nullable
as bool,showPortfolio: null == showPortfolio ? _self.showPortfolio : showPortfolio // ignore: cast_nullable_to_non_nullable
as bool,showExperience: null == showExperience ? _self.showExperience : showExperience // ignore: cast_nullable_to_non_nullable
as bool,showTimeLine: null == showTimeLine ? _self.showTimeLine : showTimeLine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileUI].
extension ProfileUIPatterns on ProfileUI {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileUI value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileUI() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileUI value)  $default,){
final _that = this;
switch (_that) {
case _ProfileUI():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileUI value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileUI() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLocked,  bool showAbout,  bool showCerts,  bool showDonation,  bool showHeatMap,  bool showLocation,  bool showName,  bool showPoints,  bool showPortfolio,  bool showExperience,  bool showTimeLine)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileUI() when $default != null:
return $default(_that.isLocked,_that.showAbout,_that.showCerts,_that.showDonation,_that.showHeatMap,_that.showLocation,_that.showName,_that.showPoints,_that.showPortfolio,_that.showExperience,_that.showTimeLine);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLocked,  bool showAbout,  bool showCerts,  bool showDonation,  bool showHeatMap,  bool showLocation,  bool showName,  bool showPoints,  bool showPortfolio,  bool showExperience,  bool showTimeLine)  $default,) {final _that = this;
switch (_that) {
case _ProfileUI():
return $default(_that.isLocked,_that.showAbout,_that.showCerts,_that.showDonation,_that.showHeatMap,_that.showLocation,_that.showName,_that.showPoints,_that.showPortfolio,_that.showExperience,_that.showTimeLine);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLocked,  bool showAbout,  bool showCerts,  bool showDonation,  bool showHeatMap,  bool showLocation,  bool showName,  bool showPoints,  bool showPortfolio,  bool showExperience,  bool showTimeLine)?  $default,) {final _that = this;
switch (_that) {
case _ProfileUI() when $default != null:
return $default(_that.isLocked,_that.showAbout,_that.showCerts,_that.showDonation,_that.showHeatMap,_that.showLocation,_that.showName,_that.showPoints,_that.showPortfolio,_that.showExperience,_that.showTimeLine);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileUI implements ProfileUI {
  const _ProfileUI({this.isLocked = true, this.showAbout = false, this.showCerts = false, this.showDonation = false, this.showHeatMap = false, this.showLocation = false, this.showName = false, this.showPoints = false, this.showPortfolio = false, this.showExperience = false, this.showTimeLine = false});
  factory _ProfileUI.fromJson(Map<String, dynamic> json) => _$ProfileUIFromJson(json);

@override@JsonKey() final  bool isLocked;
@override@JsonKey() final  bool showAbout;
@override@JsonKey() final  bool showCerts;
@override@JsonKey() final  bool showDonation;
@override@JsonKey() final  bool showHeatMap;
@override@JsonKey() final  bool showLocation;
@override@JsonKey() final  bool showName;
@override@JsonKey() final  bool showPoints;
@override@JsonKey() final  bool showPortfolio;
@override@JsonKey() final  bool showExperience;
@override@JsonKey() final  bool showTimeLine;

/// Create a copy of ProfileUI
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileUICopyWith<_ProfileUI> get copyWith => __$ProfileUICopyWithImpl<_ProfileUI>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileUIToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileUI&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.showAbout, showAbout) || other.showAbout == showAbout)&&(identical(other.showCerts, showCerts) || other.showCerts == showCerts)&&(identical(other.showDonation, showDonation) || other.showDonation == showDonation)&&(identical(other.showHeatMap, showHeatMap) || other.showHeatMap == showHeatMap)&&(identical(other.showLocation, showLocation) || other.showLocation == showLocation)&&(identical(other.showName, showName) || other.showName == showName)&&(identical(other.showPoints, showPoints) || other.showPoints == showPoints)&&(identical(other.showPortfolio, showPortfolio) || other.showPortfolio == showPortfolio)&&(identical(other.showExperience, showExperience) || other.showExperience == showExperience)&&(identical(other.showTimeLine, showTimeLine) || other.showTimeLine == showTimeLine));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,isLocked,showAbout,showCerts,showDonation,showHeatMap,showLocation,showName,showPoints,showPortfolio,showExperience,showTimeLine);

@override
String toString() {
  return 'ProfileUI(isLocked: $isLocked, showAbout: $showAbout, showCerts: $showCerts, showDonation: $showDonation, showHeatMap: $showHeatMap, showLocation: $showLocation, showName: $showName, showPoints: $showPoints, showPortfolio: $showPortfolio, showExperience: $showExperience, showTimeLine: $showTimeLine)';
}


}

/// @nodoc
abstract mixin class _$ProfileUICopyWith<$Res> implements $ProfileUICopyWith<$Res> {
  factory _$ProfileUICopyWith(_ProfileUI value, $Res Function(_ProfileUI) _then) = __$ProfileUICopyWithImpl;
@override @useResult
$Res call({
 bool isLocked, bool showAbout, bool showCerts, bool showDonation, bool showHeatMap, bool showLocation, bool showName, bool showPoints, bool showPortfolio, bool showExperience, bool showTimeLine
});




}
/// @nodoc
class __$ProfileUICopyWithImpl<$Res>
    implements _$ProfileUICopyWith<$Res> {
  __$ProfileUICopyWithImpl(this._self, this._then);

  final _ProfileUI _self;
  final $Res Function(_ProfileUI) _then;

/// Create a copy of ProfileUI
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLocked = null,Object? showAbout = null,Object? showCerts = null,Object? showDonation = null,Object? showHeatMap = null,Object? showLocation = null,Object? showName = null,Object? showPoints = null,Object? showPortfolio = null,Object? showExperience = null,Object? showTimeLine = null,}) {
  return _then(_ProfileUI(
isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,showAbout: null == showAbout ? _self.showAbout : showAbout // ignore: cast_nullable_to_non_nullable
as bool,showCerts: null == showCerts ? _self.showCerts : showCerts // ignore: cast_nullable_to_non_nullable
as bool,showDonation: null == showDonation ? _self.showDonation : showDonation // ignore: cast_nullable_to_non_nullable
as bool,showHeatMap: null == showHeatMap ? _self.showHeatMap : showHeatMap // ignore: cast_nullable_to_non_nullable
as bool,showLocation: null == showLocation ? _self.showLocation : showLocation // ignore: cast_nullable_to_non_nullable
as bool,showName: null == showName ? _self.showName : showName // ignore: cast_nullable_to_non_nullable
as bool,showPoints: null == showPoints ? _self.showPoints : showPoints // ignore: cast_nullable_to_non_nullable
as bool,showPortfolio: null == showPortfolio ? _self.showPortfolio : showPortfolio // ignore: cast_nullable_to_non_nullable
as bool,showExperience: null == showExperience ? _self.showExperience : showExperience // ignore: cast_nullable_to_non_nullable
as bool,showTimeLine: null == showTimeLine ? _self.showTimeLine : showTimeLine // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$CompletedChallenge {

 String get id; String? get solution; String? get githubLink; int? get challengeType;@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) DateTime get completedDate; List<ChallengeFile> get files;
/// Create a copy of CompletedChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletedChallengeCopyWith<CompletedChallenge> get copyWith => _$CompletedChallengeCopyWithImpl<CompletedChallenge>(this as CompletedChallenge, _$identity);

  /// Serializes this CompletedChallenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompletedChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.solution, solution) || other.solution == solution)&&(identical(other.githubLink, githubLink) || other.githubLink == githubLink)&&(identical(other.challengeType, challengeType) || other.challengeType == challengeType)&&(identical(other.completedDate, completedDate) || other.completedDate == completedDate)&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,solution,githubLink,challengeType,completedDate,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'CompletedChallenge(id: $id, solution: $solution, githubLink: $githubLink, challengeType: $challengeType, completedDate: $completedDate, files: $files)';
}


}

/// @nodoc
abstract mixin class $CompletedChallengeCopyWith<$Res>  {
  factory $CompletedChallengeCopyWith(CompletedChallenge value, $Res Function(CompletedChallenge) _then) = _$CompletedChallengeCopyWithImpl;
@useResult
$Res call({
 String id, String? solution, String? githubLink, int? challengeType,@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) DateTime completedDate, List<ChallengeFile> files
});




}
/// @nodoc
class _$CompletedChallengeCopyWithImpl<$Res>
    implements $CompletedChallengeCopyWith<$Res> {
  _$CompletedChallengeCopyWithImpl(this._self, this._then);

  final CompletedChallenge _self;
  final $Res Function(CompletedChallenge) _then;

/// Create a copy of CompletedChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? solution = freezed,Object? githubLink = freezed,Object? challengeType = freezed,Object? completedDate = null,Object? files = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,solution: freezed == solution ? _self.solution : solution // ignore: cast_nullable_to_non_nullable
as String?,githubLink: freezed == githubLink ? _self.githubLink : githubLink // ignore: cast_nullable_to_non_nullable
as String?,challengeType: freezed == challengeType ? _self.challengeType : challengeType // ignore: cast_nullable_to_non_nullable
as int?,completedDate: null == completedDate ? _self.completedDate : completedDate // ignore: cast_nullable_to_non_nullable
as DateTime,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [CompletedChallenge].
extension CompletedChallengePatterns on CompletedChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompletedChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompletedChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompletedChallenge value)  $default,){
final _that = this;
switch (_that) {
case _CompletedChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompletedChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _CompletedChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? solution,  String? githubLink,  int? challengeType, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)  DateTime completedDate,  List<ChallengeFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompletedChallenge() when $default != null:
return $default(_that.id,_that.solution,_that.githubLink,_that.challengeType,_that.completedDate,_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? solution,  String? githubLink,  int? challengeType, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)  DateTime completedDate,  List<ChallengeFile> files)  $default,) {final _that = this;
switch (_that) {
case _CompletedChallenge():
return $default(_that.id,_that.solution,_that.githubLink,_that.challengeType,_that.completedDate,_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? solution,  String? githubLink,  int? challengeType, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)  DateTime completedDate,  List<ChallengeFile> files)?  $default,) {final _that = this;
switch (_that) {
case _CompletedChallenge() when $default != null:
return $default(_that.id,_that.solution,_that.githubLink,_that.challengeType,_that.completedDate,_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompletedChallenge implements CompletedChallenge {
  const _CompletedChallenge({required this.id, this.solution, this.githubLink, this.challengeType, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) required this.completedDate, final  List<ChallengeFile> files = const []}): _files = files;
  factory _CompletedChallenge.fromJson(Map<String, dynamic> json) => _$CompletedChallengeFromJson(json);

@override final  String id;
@override final  String? solution;
@override final  String? githubLink;
@override final  int? challengeType;
@override@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) final  DateTime completedDate;
 final  List<ChallengeFile> _files;
@override@JsonKey() List<ChallengeFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of CompletedChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletedChallengeCopyWith<_CompletedChallenge> get copyWith => __$CompletedChallengeCopyWithImpl<_CompletedChallenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompletedChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletedChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.solution, solution) || other.solution == solution)&&(identical(other.githubLink, githubLink) || other.githubLink == githubLink)&&(identical(other.challengeType, challengeType) || other.challengeType == challengeType)&&(identical(other.completedDate, completedDate) || other.completedDate == completedDate)&&const DeepCollectionEquality().equals(other._files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,solution,githubLink,challengeType,completedDate,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'CompletedChallenge(id: $id, solution: $solution, githubLink: $githubLink, challengeType: $challengeType, completedDate: $completedDate, files: $files)';
}


}

/// @nodoc
abstract mixin class _$CompletedChallengeCopyWith<$Res> implements $CompletedChallengeCopyWith<$Res> {
  factory _$CompletedChallengeCopyWith(_CompletedChallenge value, $Res Function(_CompletedChallenge) _then) = __$CompletedChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, String? solution, String? githubLink, int? challengeType,@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) DateTime completedDate, List<ChallengeFile> files
});




}
/// @nodoc
class __$CompletedChallengeCopyWithImpl<$Res>
    implements _$CompletedChallengeCopyWith<$Res> {
  __$CompletedChallengeCopyWithImpl(this._self, this._then);

  final _CompletedChallenge _self;
  final $Res Function(_CompletedChallenge) _then;

/// Create a copy of CompletedChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? solution = freezed,Object? githubLink = freezed,Object? challengeType = freezed,Object? completedDate = null,Object? files = null,}) {
  return _then(_CompletedChallenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,solution: freezed == solution ? _self.solution : solution // ignore: cast_nullable_to_non_nullable
as String?,githubLink: freezed == githubLink ? _self.githubLink : githubLink // ignore: cast_nullable_to_non_nullable
as String?,challengeType: freezed == challengeType ? _self.challengeType : challengeType // ignore: cast_nullable_to_non_nullable
as int?,completedDate: null == completedDate ? _self.completedDate : completedDate // ignore: cast_nullable_to_non_nullable
as DateTime,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,
  ));
}


}


/// @nodoc
mixin _$CompletedDailyChallenge {

 String get id;@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) DateTime get completedDate; List<String> get languages;
/// Create a copy of CompletedDailyChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletedDailyChallengeCopyWith<CompletedDailyChallenge> get copyWith => _$CompletedDailyChallengeCopyWithImpl<CompletedDailyChallenge>(this as CompletedDailyChallenge, _$identity);

  /// Serializes this CompletedDailyChallenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompletedDailyChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.completedDate, completedDate) || other.completedDate == completedDate)&&const DeepCollectionEquality().equals(other.languages, languages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,completedDate,const DeepCollectionEquality().hash(languages));

@override
String toString() {
  return 'CompletedDailyChallenge(id: $id, completedDate: $completedDate, languages: $languages)';
}


}

/// @nodoc
abstract mixin class $CompletedDailyChallengeCopyWith<$Res>  {
  factory $CompletedDailyChallengeCopyWith(CompletedDailyChallenge value, $Res Function(CompletedDailyChallenge) _then) = _$CompletedDailyChallengeCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) DateTime completedDate, List<String> languages
});




}
/// @nodoc
class _$CompletedDailyChallengeCopyWithImpl<$Res>
    implements $CompletedDailyChallengeCopyWith<$Res> {
  _$CompletedDailyChallengeCopyWithImpl(this._self, this._then);

  final CompletedDailyChallenge _self;
  final $Res Function(CompletedDailyChallenge) _then;

/// Create a copy of CompletedDailyChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? completedDate = null,Object? languages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,completedDate: null == completedDate ? _self.completedDate : completedDate // ignore: cast_nullable_to_non_nullable
as DateTime,languages: null == languages ? _self.languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CompletedDailyChallenge].
extension CompletedDailyChallengePatterns on CompletedDailyChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompletedDailyChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompletedDailyChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompletedDailyChallenge value)  $default,){
final _that = this;
switch (_that) {
case _CompletedDailyChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompletedDailyChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _CompletedDailyChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)  DateTime completedDate,  List<String> languages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompletedDailyChallenge() when $default != null:
return $default(_that.id,_that.completedDate,_that.languages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)  DateTime completedDate,  List<String> languages)  $default,) {final _that = this;
switch (_that) {
case _CompletedDailyChallenge():
return $default(_that.id,_that.completedDate,_that.languages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs)  DateTime completedDate,  List<String> languages)?  $default,) {final _that = this;
switch (_that) {
case _CompletedDailyChallenge() when $default != null:
return $default(_that.id,_that.completedDate,_that.languages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompletedDailyChallenge implements CompletedDailyChallenge {
  const _CompletedDailyChallenge({required this.id, @JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) required this.completedDate, final  List<String> languages = const []}): _languages = languages;
  factory _CompletedDailyChallenge.fromJson(Map<String, dynamic> json) => _$CompletedDailyChallengeFromJson(json);

@override final  String id;
@override@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) final  DateTime completedDate;
 final  List<String> _languages;
@override@JsonKey() List<String> get languages {
  if (_languages is EqualUnmodifiableListView) return _languages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_languages);
}


/// Create a copy of CompletedDailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletedDailyChallengeCopyWith<_CompletedDailyChallenge> get copyWith => __$CompletedDailyChallengeCopyWithImpl<_CompletedDailyChallenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompletedDailyChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletedDailyChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.completedDate, completedDate) || other.completedDate == completedDate)&&const DeepCollectionEquality().equals(other._languages, _languages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,completedDate,const DeepCollectionEquality().hash(_languages));

@override
String toString() {
  return 'CompletedDailyChallenge(id: $id, completedDate: $completedDate, languages: $languages)';
}


}

/// @nodoc
abstract mixin class _$CompletedDailyChallengeCopyWith<$Res> implements $CompletedDailyChallengeCopyWith<$Res> {
  factory _$CompletedDailyChallengeCopyWith(_CompletedDailyChallenge value, $Res Function(_CompletedDailyChallenge) _then) = __$CompletedDailyChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: _fromEpochMs, toJson: _toEpochMs) DateTime completedDate, List<String> languages
});




}
/// @nodoc
class __$CompletedDailyChallengeCopyWithImpl<$Res>
    implements _$CompletedDailyChallengeCopyWith<$Res> {
  __$CompletedDailyChallengeCopyWithImpl(this._self, this._then);

  final _CompletedDailyChallenge _self;
  final $Res Function(_CompletedDailyChallenge) _then;

/// Create a copy of CompletedDailyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? completedDate = null,Object? languages = null,}) {
  return _then(_CompletedDailyChallenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,completedDate: null == completedDate ? _self.completedDate : completedDate // ignore: cast_nullable_to_non_nullable
as DateTime,languages: null == languages ? _self._languages : languages // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$SavedChallenge {

 String get id; List<ChallengeFile> get files;
/// Create a copy of SavedChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavedChallengeCopyWith<SavedChallenge> get copyWith => _$SavedChallengeCopyWithImpl<SavedChallenge>(this as SavedChallenge, _$identity);

  /// Serializes this SavedChallenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavedChallenge&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.files, files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(files));

@override
String toString() {
  return 'SavedChallenge(id: $id, files: $files)';
}


}

/// @nodoc
abstract mixin class $SavedChallengeCopyWith<$Res>  {
  factory $SavedChallengeCopyWith(SavedChallenge value, $Res Function(SavedChallenge) _then) = _$SavedChallengeCopyWithImpl;
@useResult
$Res call({
 String id, List<ChallengeFile> files
});




}
/// @nodoc
class _$SavedChallengeCopyWithImpl<$Res>
    implements $SavedChallengeCopyWith<$Res> {
  _$SavedChallengeCopyWithImpl(this._self, this._then);

  final SavedChallenge _self;
  final $Res Function(SavedChallenge) _then;

/// Create a copy of SavedChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? files = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self.files : files // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,
  ));
}

}


/// Adds pattern-matching-related methods to [SavedChallenge].
extension SavedChallengePatterns on SavedChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavedChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavedChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavedChallenge value)  $default,){
final _that = this;
switch (_that) {
case _SavedChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavedChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _SavedChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<ChallengeFile> files)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavedChallenge() when $default != null:
return $default(_that.id,_that.files);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<ChallengeFile> files)  $default,) {final _that = this;
switch (_that) {
case _SavedChallenge():
return $default(_that.id,_that.files);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<ChallengeFile> files)?  $default,) {final _that = this;
switch (_that) {
case _SavedChallenge() when $default != null:
return $default(_that.id,_that.files);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavedChallenge implements SavedChallenge {
  const _SavedChallenge({required this.id, final  List<ChallengeFile> files = const []}): _files = files;
  factory _SavedChallenge.fromJson(Map<String, dynamic> json) => _$SavedChallengeFromJson(json);

@override final  String id;
 final  List<ChallengeFile> _files;
@override@JsonKey() List<ChallengeFile> get files {
  if (_files is EqualUnmodifiableListView) return _files;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_files);
}


/// Create a copy of SavedChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavedChallengeCopyWith<_SavedChallenge> get copyWith => __$SavedChallengeCopyWithImpl<_SavedChallenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavedChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavedChallenge&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._files, _files));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_files));

@override
String toString() {
  return 'SavedChallenge(id: $id, files: $files)';
}


}

/// @nodoc
abstract mixin class _$SavedChallengeCopyWith<$Res> implements $SavedChallengeCopyWith<$Res> {
  factory _$SavedChallengeCopyWith(_SavedChallenge value, $Res Function(_SavedChallenge) _then) = __$SavedChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, List<ChallengeFile> files
});




}
/// @nodoc
class __$SavedChallengeCopyWithImpl<$Res>
    implements _$SavedChallengeCopyWith<$Res> {
  __$SavedChallengeCopyWithImpl(this._self, this._then);

  final _SavedChallenge _self;
  final $Res Function(_SavedChallenge) _then;

/// Create a copy of SavedChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? files = null,}) {
  return _then(_SavedChallenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,files: null == files ? _self._files : files // ignore: cast_nullable_to_non_nullable
as List<ChallengeFile>,
  ));
}


}


/// @nodoc
mixin _$FccUserModel {

 String get id; String get email; String get username; String get name; String get picture; String? get currentChallengeId; String? get githubProfile; String? get linkedin; String? get twitter; String? get bluesky; String? get website; String? get location; String? get about; bool get emailVerified; bool get isEmailVerified; bool get isCheater; bool get isDonating; bool get isHonest; bool get isBanned; bool get isFrontEndCert; bool get isDataVisCert; bool get isBackEndCert; bool get isFullStackCert; bool get isRespWebDesignCert; bool get is2018DataVisCert; bool get isFrontEndLibsCert; bool get isJsAlgoDataStructCert; bool get isApisMicroservicesCert; bool get isInfosecQaCert; bool get isQaCertV7; bool get isInfosecCertV7; bool get is2018FullStackCert; bool get isSciCompPyCertV7; bool get isDataAnalysisPyCertV7; bool get isMachineLearningPyCertV7; bool get isRelationalDatabaseCertV8; bool get isCollegeAlgebraPyCertV8; bool get isFoundationalCSharpCertV8; DateTime get joinDate; int get points; Map<String, int> get calendar; List<CompletedChallenge> get completedChallenges; List<CompletedDailyChallenge> get completedDailyCodingChallenges; List<SavedChallenge> get savedChallenges; List<Portfolio> get portfolio; List<Experience> get experience; ProfileUI get profileUI;@JsonKey(fromJson: _yearsToStrings) List<String> get yearsTopContributor;
/// Create a copy of FccUserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FccUserModelCopyWith<FccUserModel> get copyWith => _$FccUserModelCopyWithImpl<FccUserModel>(this as FccUserModel, _$identity);

  /// Serializes this FccUserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FccUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.name, name) || other.name == name)&&(identical(other.picture, picture) || other.picture == picture)&&(identical(other.currentChallengeId, currentChallengeId) || other.currentChallengeId == currentChallengeId)&&(identical(other.githubProfile, githubProfile) || other.githubProfile == githubProfile)&&(identical(other.linkedin, linkedin) || other.linkedin == linkedin)&&(identical(other.twitter, twitter) || other.twitter == twitter)&&(identical(other.bluesky, bluesky) || other.bluesky == bluesky)&&(identical(other.website, website) || other.website == website)&&(identical(other.location, location) || other.location == location)&&(identical(other.about, about) || other.about == about)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.isCheater, isCheater) || other.isCheater == isCheater)&&(identical(other.isDonating, isDonating) || other.isDonating == isDonating)&&(identical(other.isHonest, isHonest) || other.isHonest == isHonest)&&(identical(other.isBanned, isBanned) || other.isBanned == isBanned)&&(identical(other.isFrontEndCert, isFrontEndCert) || other.isFrontEndCert == isFrontEndCert)&&(identical(other.isDataVisCert, isDataVisCert) || other.isDataVisCert == isDataVisCert)&&(identical(other.isBackEndCert, isBackEndCert) || other.isBackEndCert == isBackEndCert)&&(identical(other.isFullStackCert, isFullStackCert) || other.isFullStackCert == isFullStackCert)&&(identical(other.isRespWebDesignCert, isRespWebDesignCert) || other.isRespWebDesignCert == isRespWebDesignCert)&&(identical(other.is2018DataVisCert, is2018DataVisCert) || other.is2018DataVisCert == is2018DataVisCert)&&(identical(other.isFrontEndLibsCert, isFrontEndLibsCert) || other.isFrontEndLibsCert == isFrontEndLibsCert)&&(identical(other.isJsAlgoDataStructCert, isJsAlgoDataStructCert) || other.isJsAlgoDataStructCert == isJsAlgoDataStructCert)&&(identical(other.isApisMicroservicesCert, isApisMicroservicesCert) || other.isApisMicroservicesCert == isApisMicroservicesCert)&&(identical(other.isInfosecQaCert, isInfosecQaCert) || other.isInfosecQaCert == isInfosecQaCert)&&(identical(other.isQaCertV7, isQaCertV7) || other.isQaCertV7 == isQaCertV7)&&(identical(other.isInfosecCertV7, isInfosecCertV7) || other.isInfosecCertV7 == isInfosecCertV7)&&(identical(other.is2018FullStackCert, is2018FullStackCert) || other.is2018FullStackCert == is2018FullStackCert)&&(identical(other.isSciCompPyCertV7, isSciCompPyCertV7) || other.isSciCompPyCertV7 == isSciCompPyCertV7)&&(identical(other.isDataAnalysisPyCertV7, isDataAnalysisPyCertV7) || other.isDataAnalysisPyCertV7 == isDataAnalysisPyCertV7)&&(identical(other.isMachineLearningPyCertV7, isMachineLearningPyCertV7) || other.isMachineLearningPyCertV7 == isMachineLearningPyCertV7)&&(identical(other.isRelationalDatabaseCertV8, isRelationalDatabaseCertV8) || other.isRelationalDatabaseCertV8 == isRelationalDatabaseCertV8)&&(identical(other.isCollegeAlgebraPyCertV8, isCollegeAlgebraPyCertV8) || other.isCollegeAlgebraPyCertV8 == isCollegeAlgebraPyCertV8)&&(identical(other.isFoundationalCSharpCertV8, isFoundationalCSharpCertV8) || other.isFoundationalCSharpCertV8 == isFoundationalCSharpCertV8)&&(identical(other.joinDate, joinDate) || other.joinDate == joinDate)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other.calendar, calendar)&&const DeepCollectionEquality().equals(other.completedChallenges, completedChallenges)&&const DeepCollectionEquality().equals(other.completedDailyCodingChallenges, completedDailyCodingChallenges)&&const DeepCollectionEquality().equals(other.savedChallenges, savedChallenges)&&const DeepCollectionEquality().equals(other.portfolio, portfolio)&&const DeepCollectionEquality().equals(other.experience, experience)&&(identical(other.profileUI, profileUI) || other.profileUI == profileUI)&&const DeepCollectionEquality().equals(other.yearsTopContributor, yearsTopContributor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,username,name,picture,currentChallengeId,githubProfile,linkedin,twitter,bluesky,website,location,about,emailVerified,isEmailVerified,isCheater,isDonating,isHonest,isBanned,isFrontEndCert,isDataVisCert,isBackEndCert,isFullStackCert,isRespWebDesignCert,is2018DataVisCert,isFrontEndLibsCert,isJsAlgoDataStructCert,isApisMicroservicesCert,isInfosecQaCert,isQaCertV7,isInfosecCertV7,is2018FullStackCert,isSciCompPyCertV7,isDataAnalysisPyCertV7,isMachineLearningPyCertV7,isRelationalDatabaseCertV8,isCollegeAlgebraPyCertV8,isFoundationalCSharpCertV8,joinDate,points,const DeepCollectionEquality().hash(calendar),const DeepCollectionEquality().hash(completedChallenges),const DeepCollectionEquality().hash(completedDailyCodingChallenges),const DeepCollectionEquality().hash(savedChallenges),const DeepCollectionEquality().hash(portfolio),const DeepCollectionEquality().hash(experience),profileUI,const DeepCollectionEquality().hash(yearsTopContributor)]);

@override
String toString() {
  return 'FccUserModel(id: $id, email: $email, username: $username, name: $name, picture: $picture, currentChallengeId: $currentChallengeId, githubProfile: $githubProfile, linkedin: $linkedin, twitter: $twitter, bluesky: $bluesky, website: $website, location: $location, about: $about, emailVerified: $emailVerified, isEmailVerified: $isEmailVerified, isCheater: $isCheater, isDonating: $isDonating, isHonest: $isHonest, isBanned: $isBanned, isFrontEndCert: $isFrontEndCert, isDataVisCert: $isDataVisCert, isBackEndCert: $isBackEndCert, isFullStackCert: $isFullStackCert, isRespWebDesignCert: $isRespWebDesignCert, is2018DataVisCert: $is2018DataVisCert, isFrontEndLibsCert: $isFrontEndLibsCert, isJsAlgoDataStructCert: $isJsAlgoDataStructCert, isApisMicroservicesCert: $isApisMicroservicesCert, isInfosecQaCert: $isInfosecQaCert, isQaCertV7: $isQaCertV7, isInfosecCertV7: $isInfosecCertV7, is2018FullStackCert: $is2018FullStackCert, isSciCompPyCertV7: $isSciCompPyCertV7, isDataAnalysisPyCertV7: $isDataAnalysisPyCertV7, isMachineLearningPyCertV7: $isMachineLearningPyCertV7, isRelationalDatabaseCertV8: $isRelationalDatabaseCertV8, isCollegeAlgebraPyCertV8: $isCollegeAlgebraPyCertV8, isFoundationalCSharpCertV8: $isFoundationalCSharpCertV8, joinDate: $joinDate, points: $points, calendar: $calendar, completedChallenges: $completedChallenges, completedDailyCodingChallenges: $completedDailyCodingChallenges, savedChallenges: $savedChallenges, portfolio: $portfolio, experience: $experience, profileUI: $profileUI, yearsTopContributor: $yearsTopContributor)';
}


}

/// @nodoc
abstract mixin class $FccUserModelCopyWith<$Res>  {
  factory $FccUserModelCopyWith(FccUserModel value, $Res Function(FccUserModel) _then) = _$FccUserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String username, String name, String picture, String? currentChallengeId, String? githubProfile, String? linkedin, String? twitter, String? bluesky, String? website, String? location, String? about, bool emailVerified, bool isEmailVerified, bool isCheater, bool isDonating, bool isHonest, bool isBanned, bool isFrontEndCert, bool isDataVisCert, bool isBackEndCert, bool isFullStackCert, bool isRespWebDesignCert, bool is2018DataVisCert, bool isFrontEndLibsCert, bool isJsAlgoDataStructCert, bool isApisMicroservicesCert, bool isInfosecQaCert, bool isQaCertV7, bool isInfosecCertV7, bool is2018FullStackCert, bool isSciCompPyCertV7, bool isDataAnalysisPyCertV7, bool isMachineLearningPyCertV7, bool isRelationalDatabaseCertV8, bool isCollegeAlgebraPyCertV8, bool isFoundationalCSharpCertV8, DateTime joinDate, int points, Map<String, int> calendar, List<CompletedChallenge> completedChallenges, List<CompletedDailyChallenge> completedDailyCodingChallenges, List<SavedChallenge> savedChallenges, List<Portfolio> portfolio, List<Experience> experience, ProfileUI profileUI,@JsonKey(fromJson: _yearsToStrings) List<String> yearsTopContributor
});


$ProfileUICopyWith<$Res> get profileUI;

}
/// @nodoc
class _$FccUserModelCopyWithImpl<$Res>
    implements $FccUserModelCopyWith<$Res> {
  _$FccUserModelCopyWithImpl(this._self, this._then);

  final FccUserModel _self;
  final $Res Function(FccUserModel) _then;

/// Create a copy of FccUserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = null,Object? name = null,Object? picture = null,Object? currentChallengeId = freezed,Object? githubProfile = freezed,Object? linkedin = freezed,Object? twitter = freezed,Object? bluesky = freezed,Object? website = freezed,Object? location = freezed,Object? about = freezed,Object? emailVerified = null,Object? isEmailVerified = null,Object? isCheater = null,Object? isDonating = null,Object? isHonest = null,Object? isBanned = null,Object? isFrontEndCert = null,Object? isDataVisCert = null,Object? isBackEndCert = null,Object? isFullStackCert = null,Object? isRespWebDesignCert = null,Object? is2018DataVisCert = null,Object? isFrontEndLibsCert = null,Object? isJsAlgoDataStructCert = null,Object? isApisMicroservicesCert = null,Object? isInfosecQaCert = null,Object? isQaCertV7 = null,Object? isInfosecCertV7 = null,Object? is2018FullStackCert = null,Object? isSciCompPyCertV7 = null,Object? isDataAnalysisPyCertV7 = null,Object? isMachineLearningPyCertV7 = null,Object? isRelationalDatabaseCertV8 = null,Object? isCollegeAlgebraPyCertV8 = null,Object? isFoundationalCSharpCertV8 = null,Object? joinDate = null,Object? points = null,Object? calendar = null,Object? completedChallenges = null,Object? completedDailyCodingChallenges = null,Object? savedChallenges = null,Object? portfolio = null,Object? experience = null,Object? profileUI = null,Object? yearsTopContributor = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,picture: null == picture ? _self.picture : picture // ignore: cast_nullable_to_non_nullable
as String,currentChallengeId: freezed == currentChallengeId ? _self.currentChallengeId : currentChallengeId // ignore: cast_nullable_to_non_nullable
as String?,githubProfile: freezed == githubProfile ? _self.githubProfile : githubProfile // ignore: cast_nullable_to_non_nullable
as String?,linkedin: freezed == linkedin ? _self.linkedin : linkedin // ignore: cast_nullable_to_non_nullable
as String?,twitter: freezed == twitter ? _self.twitter : twitter // ignore: cast_nullable_to_non_nullable
as String?,bluesky: freezed == bluesky ? _self.bluesky : bluesky // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,isCheater: null == isCheater ? _self.isCheater : isCheater // ignore: cast_nullable_to_non_nullable
as bool,isDonating: null == isDonating ? _self.isDonating : isDonating // ignore: cast_nullable_to_non_nullable
as bool,isHonest: null == isHonest ? _self.isHonest : isHonest // ignore: cast_nullable_to_non_nullable
as bool,isBanned: null == isBanned ? _self.isBanned : isBanned // ignore: cast_nullable_to_non_nullable
as bool,isFrontEndCert: null == isFrontEndCert ? _self.isFrontEndCert : isFrontEndCert // ignore: cast_nullable_to_non_nullable
as bool,isDataVisCert: null == isDataVisCert ? _self.isDataVisCert : isDataVisCert // ignore: cast_nullable_to_non_nullable
as bool,isBackEndCert: null == isBackEndCert ? _self.isBackEndCert : isBackEndCert // ignore: cast_nullable_to_non_nullable
as bool,isFullStackCert: null == isFullStackCert ? _self.isFullStackCert : isFullStackCert // ignore: cast_nullable_to_non_nullable
as bool,isRespWebDesignCert: null == isRespWebDesignCert ? _self.isRespWebDesignCert : isRespWebDesignCert // ignore: cast_nullable_to_non_nullable
as bool,is2018DataVisCert: null == is2018DataVisCert ? _self.is2018DataVisCert : is2018DataVisCert // ignore: cast_nullable_to_non_nullable
as bool,isFrontEndLibsCert: null == isFrontEndLibsCert ? _self.isFrontEndLibsCert : isFrontEndLibsCert // ignore: cast_nullable_to_non_nullable
as bool,isJsAlgoDataStructCert: null == isJsAlgoDataStructCert ? _self.isJsAlgoDataStructCert : isJsAlgoDataStructCert // ignore: cast_nullable_to_non_nullable
as bool,isApisMicroservicesCert: null == isApisMicroservicesCert ? _self.isApisMicroservicesCert : isApisMicroservicesCert // ignore: cast_nullable_to_non_nullable
as bool,isInfosecQaCert: null == isInfosecQaCert ? _self.isInfosecQaCert : isInfosecQaCert // ignore: cast_nullable_to_non_nullable
as bool,isQaCertV7: null == isQaCertV7 ? _self.isQaCertV7 : isQaCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isInfosecCertV7: null == isInfosecCertV7 ? _self.isInfosecCertV7 : isInfosecCertV7 // ignore: cast_nullable_to_non_nullable
as bool,is2018FullStackCert: null == is2018FullStackCert ? _self.is2018FullStackCert : is2018FullStackCert // ignore: cast_nullable_to_non_nullable
as bool,isSciCompPyCertV7: null == isSciCompPyCertV7 ? _self.isSciCompPyCertV7 : isSciCompPyCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isDataAnalysisPyCertV7: null == isDataAnalysisPyCertV7 ? _self.isDataAnalysisPyCertV7 : isDataAnalysisPyCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isMachineLearningPyCertV7: null == isMachineLearningPyCertV7 ? _self.isMachineLearningPyCertV7 : isMachineLearningPyCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isRelationalDatabaseCertV8: null == isRelationalDatabaseCertV8 ? _self.isRelationalDatabaseCertV8 : isRelationalDatabaseCertV8 // ignore: cast_nullable_to_non_nullable
as bool,isCollegeAlgebraPyCertV8: null == isCollegeAlgebraPyCertV8 ? _self.isCollegeAlgebraPyCertV8 : isCollegeAlgebraPyCertV8 // ignore: cast_nullable_to_non_nullable
as bool,isFoundationalCSharpCertV8: null == isFoundationalCSharpCertV8 ? _self.isFoundationalCSharpCertV8 : isFoundationalCSharpCertV8 // ignore: cast_nullable_to_non_nullable
as bool,joinDate: null == joinDate ? _self.joinDate : joinDate // ignore: cast_nullable_to_non_nullable
as DateTime,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,calendar: null == calendar ? _self.calendar : calendar // ignore: cast_nullable_to_non_nullable
as Map<String, int>,completedChallenges: null == completedChallenges ? _self.completedChallenges : completedChallenges // ignore: cast_nullable_to_non_nullable
as List<CompletedChallenge>,completedDailyCodingChallenges: null == completedDailyCodingChallenges ? _self.completedDailyCodingChallenges : completedDailyCodingChallenges // ignore: cast_nullable_to_non_nullable
as List<CompletedDailyChallenge>,savedChallenges: null == savedChallenges ? _self.savedChallenges : savedChallenges // ignore: cast_nullable_to_non_nullable
as List<SavedChallenge>,portfolio: null == portfolio ? _self.portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as List<Portfolio>,experience: null == experience ? _self.experience : experience // ignore: cast_nullable_to_non_nullable
as List<Experience>,profileUI: null == profileUI ? _self.profileUI : profileUI // ignore: cast_nullable_to_non_nullable
as ProfileUI,yearsTopContributor: null == yearsTopContributor ? _self.yearsTopContributor : yearsTopContributor // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}
/// Create a copy of FccUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileUICopyWith<$Res> get profileUI {
  
  return $ProfileUICopyWith<$Res>(_self.profileUI, (value) {
    return _then(_self.copyWith(profileUI: value));
  });
}
}


/// Adds pattern-matching-related methods to [FccUserModel].
extension FccUserModelPatterns on FccUserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FccUserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FccUserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FccUserModel value)  $default,){
final _that = this;
switch (_that) {
case _FccUserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FccUserModel value)?  $default,){
final _that = this;
switch (_that) {
case _FccUserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String name,  String picture,  String? currentChallengeId,  String? githubProfile,  String? linkedin,  String? twitter,  String? bluesky,  String? website,  String? location,  String? about,  bool emailVerified,  bool isEmailVerified,  bool isCheater,  bool isDonating,  bool isHonest,  bool isBanned,  bool isFrontEndCert,  bool isDataVisCert,  bool isBackEndCert,  bool isFullStackCert,  bool isRespWebDesignCert,  bool is2018DataVisCert,  bool isFrontEndLibsCert,  bool isJsAlgoDataStructCert,  bool isApisMicroservicesCert,  bool isInfosecQaCert,  bool isQaCertV7,  bool isInfosecCertV7,  bool is2018FullStackCert,  bool isSciCompPyCertV7,  bool isDataAnalysisPyCertV7,  bool isMachineLearningPyCertV7,  bool isRelationalDatabaseCertV8,  bool isCollegeAlgebraPyCertV8,  bool isFoundationalCSharpCertV8,  DateTime joinDate,  int points,  Map<String, int> calendar,  List<CompletedChallenge> completedChallenges,  List<CompletedDailyChallenge> completedDailyCodingChallenges,  List<SavedChallenge> savedChallenges,  List<Portfolio> portfolio,  List<Experience> experience,  ProfileUI profileUI, @JsonKey(fromJson: _yearsToStrings)  List<String> yearsTopContributor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FccUserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.name,_that.picture,_that.currentChallengeId,_that.githubProfile,_that.linkedin,_that.twitter,_that.bluesky,_that.website,_that.location,_that.about,_that.emailVerified,_that.isEmailVerified,_that.isCheater,_that.isDonating,_that.isHonest,_that.isBanned,_that.isFrontEndCert,_that.isDataVisCert,_that.isBackEndCert,_that.isFullStackCert,_that.isRespWebDesignCert,_that.is2018DataVisCert,_that.isFrontEndLibsCert,_that.isJsAlgoDataStructCert,_that.isApisMicroservicesCert,_that.isInfosecQaCert,_that.isQaCertV7,_that.isInfosecCertV7,_that.is2018FullStackCert,_that.isSciCompPyCertV7,_that.isDataAnalysisPyCertV7,_that.isMachineLearningPyCertV7,_that.isRelationalDatabaseCertV8,_that.isCollegeAlgebraPyCertV8,_that.isFoundationalCSharpCertV8,_that.joinDate,_that.points,_that.calendar,_that.completedChallenges,_that.completedDailyCodingChallenges,_that.savedChallenges,_that.portfolio,_that.experience,_that.profileUI,_that.yearsTopContributor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String name,  String picture,  String? currentChallengeId,  String? githubProfile,  String? linkedin,  String? twitter,  String? bluesky,  String? website,  String? location,  String? about,  bool emailVerified,  bool isEmailVerified,  bool isCheater,  bool isDonating,  bool isHonest,  bool isBanned,  bool isFrontEndCert,  bool isDataVisCert,  bool isBackEndCert,  bool isFullStackCert,  bool isRespWebDesignCert,  bool is2018DataVisCert,  bool isFrontEndLibsCert,  bool isJsAlgoDataStructCert,  bool isApisMicroservicesCert,  bool isInfosecQaCert,  bool isQaCertV7,  bool isInfosecCertV7,  bool is2018FullStackCert,  bool isSciCompPyCertV7,  bool isDataAnalysisPyCertV7,  bool isMachineLearningPyCertV7,  bool isRelationalDatabaseCertV8,  bool isCollegeAlgebraPyCertV8,  bool isFoundationalCSharpCertV8,  DateTime joinDate,  int points,  Map<String, int> calendar,  List<CompletedChallenge> completedChallenges,  List<CompletedDailyChallenge> completedDailyCodingChallenges,  List<SavedChallenge> savedChallenges,  List<Portfolio> portfolio,  List<Experience> experience,  ProfileUI profileUI, @JsonKey(fromJson: _yearsToStrings)  List<String> yearsTopContributor)  $default,) {final _that = this;
switch (_that) {
case _FccUserModel():
return $default(_that.id,_that.email,_that.username,_that.name,_that.picture,_that.currentChallengeId,_that.githubProfile,_that.linkedin,_that.twitter,_that.bluesky,_that.website,_that.location,_that.about,_that.emailVerified,_that.isEmailVerified,_that.isCheater,_that.isDonating,_that.isHonest,_that.isBanned,_that.isFrontEndCert,_that.isDataVisCert,_that.isBackEndCert,_that.isFullStackCert,_that.isRespWebDesignCert,_that.is2018DataVisCert,_that.isFrontEndLibsCert,_that.isJsAlgoDataStructCert,_that.isApisMicroservicesCert,_that.isInfosecQaCert,_that.isQaCertV7,_that.isInfosecCertV7,_that.is2018FullStackCert,_that.isSciCompPyCertV7,_that.isDataAnalysisPyCertV7,_that.isMachineLearningPyCertV7,_that.isRelationalDatabaseCertV8,_that.isCollegeAlgebraPyCertV8,_that.isFoundationalCSharpCertV8,_that.joinDate,_that.points,_that.calendar,_that.completedChallenges,_that.completedDailyCodingChallenges,_that.savedChallenges,_that.portfolio,_that.experience,_that.profileUI,_that.yearsTopContributor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String username,  String name,  String picture,  String? currentChallengeId,  String? githubProfile,  String? linkedin,  String? twitter,  String? bluesky,  String? website,  String? location,  String? about,  bool emailVerified,  bool isEmailVerified,  bool isCheater,  bool isDonating,  bool isHonest,  bool isBanned,  bool isFrontEndCert,  bool isDataVisCert,  bool isBackEndCert,  bool isFullStackCert,  bool isRespWebDesignCert,  bool is2018DataVisCert,  bool isFrontEndLibsCert,  bool isJsAlgoDataStructCert,  bool isApisMicroservicesCert,  bool isInfosecQaCert,  bool isQaCertV7,  bool isInfosecCertV7,  bool is2018FullStackCert,  bool isSciCompPyCertV7,  bool isDataAnalysisPyCertV7,  bool isMachineLearningPyCertV7,  bool isRelationalDatabaseCertV8,  bool isCollegeAlgebraPyCertV8,  bool isFoundationalCSharpCertV8,  DateTime joinDate,  int points,  Map<String, int> calendar,  List<CompletedChallenge> completedChallenges,  List<CompletedDailyChallenge> completedDailyCodingChallenges,  List<SavedChallenge> savedChallenges,  List<Portfolio> portfolio,  List<Experience> experience,  ProfileUI profileUI, @JsonKey(fromJson: _yearsToStrings)  List<String> yearsTopContributor)?  $default,) {final _that = this;
switch (_that) {
case _FccUserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.name,_that.picture,_that.currentChallengeId,_that.githubProfile,_that.linkedin,_that.twitter,_that.bluesky,_that.website,_that.location,_that.about,_that.emailVerified,_that.isEmailVerified,_that.isCheater,_that.isDonating,_that.isHonest,_that.isBanned,_that.isFrontEndCert,_that.isDataVisCert,_that.isBackEndCert,_that.isFullStackCert,_that.isRespWebDesignCert,_that.is2018DataVisCert,_that.isFrontEndLibsCert,_that.isJsAlgoDataStructCert,_that.isApisMicroservicesCert,_that.isInfosecQaCert,_that.isQaCertV7,_that.isInfosecCertV7,_that.is2018FullStackCert,_that.isSciCompPyCertV7,_that.isDataAnalysisPyCertV7,_that.isMachineLearningPyCertV7,_that.isRelationalDatabaseCertV8,_that.isCollegeAlgebraPyCertV8,_that.isFoundationalCSharpCertV8,_that.joinDate,_that.points,_that.calendar,_that.completedChallenges,_that.completedDailyCodingChallenges,_that.savedChallenges,_that.portfolio,_that.experience,_that.profileUI,_that.yearsTopContributor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FccUserModel extends FccUserModel {
  const _FccUserModel({required this.id, required this.email, required this.username, this.name = '', this.picture = '', this.currentChallengeId, this.githubProfile, this.linkedin, this.twitter, this.bluesky, this.website, this.location, this.about, this.emailVerified = false, this.isEmailVerified = false, this.isCheater = false, this.isDonating = false, this.isHonest = false, this.isBanned = false, this.isFrontEndCert = false, this.isDataVisCert = false, this.isBackEndCert = false, this.isFullStackCert = false, this.isRespWebDesignCert = false, this.is2018DataVisCert = false, this.isFrontEndLibsCert = false, this.isJsAlgoDataStructCert = false, this.isApisMicroservicesCert = false, this.isInfosecQaCert = false, this.isQaCertV7 = false, this.isInfosecCertV7 = false, this.is2018FullStackCert = false, this.isSciCompPyCertV7 = false, this.isDataAnalysisPyCertV7 = false, this.isMachineLearningPyCertV7 = false, this.isRelationalDatabaseCertV8 = false, this.isCollegeAlgebraPyCertV8 = false, this.isFoundationalCSharpCertV8 = false, required this.joinDate, this.points = 0, final  Map<String, int> calendar = const {}, final  List<CompletedChallenge> completedChallenges = const [], final  List<CompletedDailyChallenge> completedDailyCodingChallenges = const [], final  List<SavedChallenge> savedChallenges = const [], final  List<Portfolio> portfolio = const [], final  List<Experience> experience = const [], this.profileUI = const ProfileUI(), @JsonKey(fromJson: _yearsToStrings) final  List<String> yearsTopContributor = const []}): _calendar = calendar,_completedChallenges = completedChallenges,_completedDailyCodingChallenges = completedDailyCodingChallenges,_savedChallenges = savedChallenges,_portfolio = portfolio,_experience = experience,_yearsTopContributor = yearsTopContributor,super._();
  factory _FccUserModel.fromJson(Map<String, dynamic> json) => _$FccUserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String username;
@override@JsonKey() final  String name;
@override@JsonKey() final  String picture;
@override final  String? currentChallengeId;
@override final  String? githubProfile;
@override final  String? linkedin;
@override final  String? twitter;
@override final  String? bluesky;
@override final  String? website;
@override final  String? location;
@override final  String? about;
@override@JsonKey() final  bool emailVerified;
@override@JsonKey() final  bool isEmailVerified;
@override@JsonKey() final  bool isCheater;
@override@JsonKey() final  bool isDonating;
@override@JsonKey() final  bool isHonest;
@override@JsonKey() final  bool isBanned;
@override@JsonKey() final  bool isFrontEndCert;
@override@JsonKey() final  bool isDataVisCert;
@override@JsonKey() final  bool isBackEndCert;
@override@JsonKey() final  bool isFullStackCert;
@override@JsonKey() final  bool isRespWebDesignCert;
@override@JsonKey() final  bool is2018DataVisCert;
@override@JsonKey() final  bool isFrontEndLibsCert;
@override@JsonKey() final  bool isJsAlgoDataStructCert;
@override@JsonKey() final  bool isApisMicroservicesCert;
@override@JsonKey() final  bool isInfosecQaCert;
@override@JsonKey() final  bool isQaCertV7;
@override@JsonKey() final  bool isInfosecCertV7;
@override@JsonKey() final  bool is2018FullStackCert;
@override@JsonKey() final  bool isSciCompPyCertV7;
@override@JsonKey() final  bool isDataAnalysisPyCertV7;
@override@JsonKey() final  bool isMachineLearningPyCertV7;
@override@JsonKey() final  bool isRelationalDatabaseCertV8;
@override@JsonKey() final  bool isCollegeAlgebraPyCertV8;
@override@JsonKey() final  bool isFoundationalCSharpCertV8;
@override final  DateTime joinDate;
@override@JsonKey() final  int points;
 final  Map<String, int> _calendar;
@override@JsonKey() Map<String, int> get calendar {
  if (_calendar is EqualUnmodifiableMapView) return _calendar;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_calendar);
}

 final  List<CompletedChallenge> _completedChallenges;
@override@JsonKey() List<CompletedChallenge> get completedChallenges {
  if (_completedChallenges is EqualUnmodifiableListView) return _completedChallenges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedChallenges);
}

 final  List<CompletedDailyChallenge> _completedDailyCodingChallenges;
@override@JsonKey() List<CompletedDailyChallenge> get completedDailyCodingChallenges {
  if (_completedDailyCodingChallenges is EqualUnmodifiableListView) return _completedDailyCodingChallenges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedDailyCodingChallenges);
}

 final  List<SavedChallenge> _savedChallenges;
@override@JsonKey() List<SavedChallenge> get savedChallenges {
  if (_savedChallenges is EqualUnmodifiableListView) return _savedChallenges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_savedChallenges);
}

 final  List<Portfolio> _portfolio;
@override@JsonKey() List<Portfolio> get portfolio {
  if (_portfolio is EqualUnmodifiableListView) return _portfolio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_portfolio);
}

 final  List<Experience> _experience;
@override@JsonKey() List<Experience> get experience {
  if (_experience is EqualUnmodifiableListView) return _experience;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_experience);
}

@override@JsonKey() final  ProfileUI profileUI;
 final  List<String> _yearsTopContributor;
@override@JsonKey(fromJson: _yearsToStrings) List<String> get yearsTopContributor {
  if (_yearsTopContributor is EqualUnmodifiableListView) return _yearsTopContributor;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_yearsTopContributor);
}


/// Create a copy of FccUserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FccUserModelCopyWith<_FccUserModel> get copyWith => __$FccUserModelCopyWithImpl<_FccUserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FccUserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FccUserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.name, name) || other.name == name)&&(identical(other.picture, picture) || other.picture == picture)&&(identical(other.currentChallengeId, currentChallengeId) || other.currentChallengeId == currentChallengeId)&&(identical(other.githubProfile, githubProfile) || other.githubProfile == githubProfile)&&(identical(other.linkedin, linkedin) || other.linkedin == linkedin)&&(identical(other.twitter, twitter) || other.twitter == twitter)&&(identical(other.bluesky, bluesky) || other.bluesky == bluesky)&&(identical(other.website, website) || other.website == website)&&(identical(other.location, location) || other.location == location)&&(identical(other.about, about) || other.about == about)&&(identical(other.emailVerified, emailVerified) || other.emailVerified == emailVerified)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified)&&(identical(other.isCheater, isCheater) || other.isCheater == isCheater)&&(identical(other.isDonating, isDonating) || other.isDonating == isDonating)&&(identical(other.isHonest, isHonest) || other.isHonest == isHonest)&&(identical(other.isBanned, isBanned) || other.isBanned == isBanned)&&(identical(other.isFrontEndCert, isFrontEndCert) || other.isFrontEndCert == isFrontEndCert)&&(identical(other.isDataVisCert, isDataVisCert) || other.isDataVisCert == isDataVisCert)&&(identical(other.isBackEndCert, isBackEndCert) || other.isBackEndCert == isBackEndCert)&&(identical(other.isFullStackCert, isFullStackCert) || other.isFullStackCert == isFullStackCert)&&(identical(other.isRespWebDesignCert, isRespWebDesignCert) || other.isRespWebDesignCert == isRespWebDesignCert)&&(identical(other.is2018DataVisCert, is2018DataVisCert) || other.is2018DataVisCert == is2018DataVisCert)&&(identical(other.isFrontEndLibsCert, isFrontEndLibsCert) || other.isFrontEndLibsCert == isFrontEndLibsCert)&&(identical(other.isJsAlgoDataStructCert, isJsAlgoDataStructCert) || other.isJsAlgoDataStructCert == isJsAlgoDataStructCert)&&(identical(other.isApisMicroservicesCert, isApisMicroservicesCert) || other.isApisMicroservicesCert == isApisMicroservicesCert)&&(identical(other.isInfosecQaCert, isInfosecQaCert) || other.isInfosecQaCert == isInfosecQaCert)&&(identical(other.isQaCertV7, isQaCertV7) || other.isQaCertV7 == isQaCertV7)&&(identical(other.isInfosecCertV7, isInfosecCertV7) || other.isInfosecCertV7 == isInfosecCertV7)&&(identical(other.is2018FullStackCert, is2018FullStackCert) || other.is2018FullStackCert == is2018FullStackCert)&&(identical(other.isSciCompPyCertV7, isSciCompPyCertV7) || other.isSciCompPyCertV7 == isSciCompPyCertV7)&&(identical(other.isDataAnalysisPyCertV7, isDataAnalysisPyCertV7) || other.isDataAnalysisPyCertV7 == isDataAnalysisPyCertV7)&&(identical(other.isMachineLearningPyCertV7, isMachineLearningPyCertV7) || other.isMachineLearningPyCertV7 == isMachineLearningPyCertV7)&&(identical(other.isRelationalDatabaseCertV8, isRelationalDatabaseCertV8) || other.isRelationalDatabaseCertV8 == isRelationalDatabaseCertV8)&&(identical(other.isCollegeAlgebraPyCertV8, isCollegeAlgebraPyCertV8) || other.isCollegeAlgebraPyCertV8 == isCollegeAlgebraPyCertV8)&&(identical(other.isFoundationalCSharpCertV8, isFoundationalCSharpCertV8) || other.isFoundationalCSharpCertV8 == isFoundationalCSharpCertV8)&&(identical(other.joinDate, joinDate) || other.joinDate == joinDate)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other._calendar, _calendar)&&const DeepCollectionEquality().equals(other._completedChallenges, _completedChallenges)&&const DeepCollectionEquality().equals(other._completedDailyCodingChallenges, _completedDailyCodingChallenges)&&const DeepCollectionEquality().equals(other._savedChallenges, _savedChallenges)&&const DeepCollectionEquality().equals(other._portfolio, _portfolio)&&const DeepCollectionEquality().equals(other._experience, _experience)&&(identical(other.profileUI, profileUI) || other.profileUI == profileUI)&&const DeepCollectionEquality().equals(other._yearsTopContributor, _yearsTopContributor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,email,username,name,picture,currentChallengeId,githubProfile,linkedin,twitter,bluesky,website,location,about,emailVerified,isEmailVerified,isCheater,isDonating,isHonest,isBanned,isFrontEndCert,isDataVisCert,isBackEndCert,isFullStackCert,isRespWebDesignCert,is2018DataVisCert,isFrontEndLibsCert,isJsAlgoDataStructCert,isApisMicroservicesCert,isInfosecQaCert,isQaCertV7,isInfosecCertV7,is2018FullStackCert,isSciCompPyCertV7,isDataAnalysisPyCertV7,isMachineLearningPyCertV7,isRelationalDatabaseCertV8,isCollegeAlgebraPyCertV8,isFoundationalCSharpCertV8,joinDate,points,const DeepCollectionEquality().hash(_calendar),const DeepCollectionEquality().hash(_completedChallenges),const DeepCollectionEquality().hash(_completedDailyCodingChallenges),const DeepCollectionEquality().hash(_savedChallenges),const DeepCollectionEquality().hash(_portfolio),const DeepCollectionEquality().hash(_experience),profileUI,const DeepCollectionEquality().hash(_yearsTopContributor)]);

@override
String toString() {
  return 'FccUserModel(id: $id, email: $email, username: $username, name: $name, picture: $picture, currentChallengeId: $currentChallengeId, githubProfile: $githubProfile, linkedin: $linkedin, twitter: $twitter, bluesky: $bluesky, website: $website, location: $location, about: $about, emailVerified: $emailVerified, isEmailVerified: $isEmailVerified, isCheater: $isCheater, isDonating: $isDonating, isHonest: $isHonest, isBanned: $isBanned, isFrontEndCert: $isFrontEndCert, isDataVisCert: $isDataVisCert, isBackEndCert: $isBackEndCert, isFullStackCert: $isFullStackCert, isRespWebDesignCert: $isRespWebDesignCert, is2018DataVisCert: $is2018DataVisCert, isFrontEndLibsCert: $isFrontEndLibsCert, isJsAlgoDataStructCert: $isJsAlgoDataStructCert, isApisMicroservicesCert: $isApisMicroservicesCert, isInfosecQaCert: $isInfosecQaCert, isQaCertV7: $isQaCertV7, isInfosecCertV7: $isInfosecCertV7, is2018FullStackCert: $is2018FullStackCert, isSciCompPyCertV7: $isSciCompPyCertV7, isDataAnalysisPyCertV7: $isDataAnalysisPyCertV7, isMachineLearningPyCertV7: $isMachineLearningPyCertV7, isRelationalDatabaseCertV8: $isRelationalDatabaseCertV8, isCollegeAlgebraPyCertV8: $isCollegeAlgebraPyCertV8, isFoundationalCSharpCertV8: $isFoundationalCSharpCertV8, joinDate: $joinDate, points: $points, calendar: $calendar, completedChallenges: $completedChallenges, completedDailyCodingChallenges: $completedDailyCodingChallenges, savedChallenges: $savedChallenges, portfolio: $portfolio, experience: $experience, profileUI: $profileUI, yearsTopContributor: $yearsTopContributor)';
}


}

/// @nodoc
abstract mixin class _$FccUserModelCopyWith<$Res> implements $FccUserModelCopyWith<$Res> {
  factory _$FccUserModelCopyWith(_FccUserModel value, $Res Function(_FccUserModel) _then) = __$FccUserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String username, String name, String picture, String? currentChallengeId, String? githubProfile, String? linkedin, String? twitter, String? bluesky, String? website, String? location, String? about, bool emailVerified, bool isEmailVerified, bool isCheater, bool isDonating, bool isHonest, bool isBanned, bool isFrontEndCert, bool isDataVisCert, bool isBackEndCert, bool isFullStackCert, bool isRespWebDesignCert, bool is2018DataVisCert, bool isFrontEndLibsCert, bool isJsAlgoDataStructCert, bool isApisMicroservicesCert, bool isInfosecQaCert, bool isQaCertV7, bool isInfosecCertV7, bool is2018FullStackCert, bool isSciCompPyCertV7, bool isDataAnalysisPyCertV7, bool isMachineLearningPyCertV7, bool isRelationalDatabaseCertV8, bool isCollegeAlgebraPyCertV8, bool isFoundationalCSharpCertV8, DateTime joinDate, int points, Map<String, int> calendar, List<CompletedChallenge> completedChallenges, List<CompletedDailyChallenge> completedDailyCodingChallenges, List<SavedChallenge> savedChallenges, List<Portfolio> portfolio, List<Experience> experience, ProfileUI profileUI,@JsonKey(fromJson: _yearsToStrings) List<String> yearsTopContributor
});


@override $ProfileUICopyWith<$Res> get profileUI;

}
/// @nodoc
class __$FccUserModelCopyWithImpl<$Res>
    implements _$FccUserModelCopyWith<$Res> {
  __$FccUserModelCopyWithImpl(this._self, this._then);

  final _FccUserModel _self;
  final $Res Function(_FccUserModel) _then;

/// Create a copy of FccUserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = null,Object? name = null,Object? picture = null,Object? currentChallengeId = freezed,Object? githubProfile = freezed,Object? linkedin = freezed,Object? twitter = freezed,Object? bluesky = freezed,Object? website = freezed,Object? location = freezed,Object? about = freezed,Object? emailVerified = null,Object? isEmailVerified = null,Object? isCheater = null,Object? isDonating = null,Object? isHonest = null,Object? isBanned = null,Object? isFrontEndCert = null,Object? isDataVisCert = null,Object? isBackEndCert = null,Object? isFullStackCert = null,Object? isRespWebDesignCert = null,Object? is2018DataVisCert = null,Object? isFrontEndLibsCert = null,Object? isJsAlgoDataStructCert = null,Object? isApisMicroservicesCert = null,Object? isInfosecQaCert = null,Object? isQaCertV7 = null,Object? isInfosecCertV7 = null,Object? is2018FullStackCert = null,Object? isSciCompPyCertV7 = null,Object? isDataAnalysisPyCertV7 = null,Object? isMachineLearningPyCertV7 = null,Object? isRelationalDatabaseCertV8 = null,Object? isCollegeAlgebraPyCertV8 = null,Object? isFoundationalCSharpCertV8 = null,Object? joinDate = null,Object? points = null,Object? calendar = null,Object? completedChallenges = null,Object? completedDailyCodingChallenges = null,Object? savedChallenges = null,Object? portfolio = null,Object? experience = null,Object? profileUI = null,Object? yearsTopContributor = null,}) {
  return _then(_FccUserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,picture: null == picture ? _self.picture : picture // ignore: cast_nullable_to_non_nullable
as String,currentChallengeId: freezed == currentChallengeId ? _self.currentChallengeId : currentChallengeId // ignore: cast_nullable_to_non_nullable
as String?,githubProfile: freezed == githubProfile ? _self.githubProfile : githubProfile // ignore: cast_nullable_to_non_nullable
as String?,linkedin: freezed == linkedin ? _self.linkedin : linkedin // ignore: cast_nullable_to_non_nullable
as String?,twitter: freezed == twitter ? _self.twitter : twitter // ignore: cast_nullable_to_non_nullable
as String?,bluesky: freezed == bluesky ? _self.bluesky : bluesky // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,about: freezed == about ? _self.about : about // ignore: cast_nullable_to_non_nullable
as String?,emailVerified: null == emailVerified ? _self.emailVerified : emailVerified // ignore: cast_nullable_to_non_nullable
as bool,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,isCheater: null == isCheater ? _self.isCheater : isCheater // ignore: cast_nullable_to_non_nullable
as bool,isDonating: null == isDonating ? _self.isDonating : isDonating // ignore: cast_nullable_to_non_nullable
as bool,isHonest: null == isHonest ? _self.isHonest : isHonest // ignore: cast_nullable_to_non_nullable
as bool,isBanned: null == isBanned ? _self.isBanned : isBanned // ignore: cast_nullable_to_non_nullable
as bool,isFrontEndCert: null == isFrontEndCert ? _self.isFrontEndCert : isFrontEndCert // ignore: cast_nullable_to_non_nullable
as bool,isDataVisCert: null == isDataVisCert ? _self.isDataVisCert : isDataVisCert // ignore: cast_nullable_to_non_nullable
as bool,isBackEndCert: null == isBackEndCert ? _self.isBackEndCert : isBackEndCert // ignore: cast_nullable_to_non_nullable
as bool,isFullStackCert: null == isFullStackCert ? _self.isFullStackCert : isFullStackCert // ignore: cast_nullable_to_non_nullable
as bool,isRespWebDesignCert: null == isRespWebDesignCert ? _self.isRespWebDesignCert : isRespWebDesignCert // ignore: cast_nullable_to_non_nullable
as bool,is2018DataVisCert: null == is2018DataVisCert ? _self.is2018DataVisCert : is2018DataVisCert // ignore: cast_nullable_to_non_nullable
as bool,isFrontEndLibsCert: null == isFrontEndLibsCert ? _self.isFrontEndLibsCert : isFrontEndLibsCert // ignore: cast_nullable_to_non_nullable
as bool,isJsAlgoDataStructCert: null == isJsAlgoDataStructCert ? _self.isJsAlgoDataStructCert : isJsAlgoDataStructCert // ignore: cast_nullable_to_non_nullable
as bool,isApisMicroservicesCert: null == isApisMicroservicesCert ? _self.isApisMicroservicesCert : isApisMicroservicesCert // ignore: cast_nullable_to_non_nullable
as bool,isInfosecQaCert: null == isInfosecQaCert ? _self.isInfosecQaCert : isInfosecQaCert // ignore: cast_nullable_to_non_nullable
as bool,isQaCertV7: null == isQaCertV7 ? _self.isQaCertV7 : isQaCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isInfosecCertV7: null == isInfosecCertV7 ? _self.isInfosecCertV7 : isInfosecCertV7 // ignore: cast_nullable_to_non_nullable
as bool,is2018FullStackCert: null == is2018FullStackCert ? _self.is2018FullStackCert : is2018FullStackCert // ignore: cast_nullable_to_non_nullable
as bool,isSciCompPyCertV7: null == isSciCompPyCertV7 ? _self.isSciCompPyCertV7 : isSciCompPyCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isDataAnalysisPyCertV7: null == isDataAnalysisPyCertV7 ? _self.isDataAnalysisPyCertV7 : isDataAnalysisPyCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isMachineLearningPyCertV7: null == isMachineLearningPyCertV7 ? _self.isMachineLearningPyCertV7 : isMachineLearningPyCertV7 // ignore: cast_nullable_to_non_nullable
as bool,isRelationalDatabaseCertV8: null == isRelationalDatabaseCertV8 ? _self.isRelationalDatabaseCertV8 : isRelationalDatabaseCertV8 // ignore: cast_nullable_to_non_nullable
as bool,isCollegeAlgebraPyCertV8: null == isCollegeAlgebraPyCertV8 ? _self.isCollegeAlgebraPyCertV8 : isCollegeAlgebraPyCertV8 // ignore: cast_nullable_to_non_nullable
as bool,isFoundationalCSharpCertV8: null == isFoundationalCSharpCertV8 ? _self.isFoundationalCSharpCertV8 : isFoundationalCSharpCertV8 // ignore: cast_nullable_to_non_nullable
as bool,joinDate: null == joinDate ? _self.joinDate : joinDate // ignore: cast_nullable_to_non_nullable
as DateTime,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,calendar: null == calendar ? _self._calendar : calendar // ignore: cast_nullable_to_non_nullable
as Map<String, int>,completedChallenges: null == completedChallenges ? _self._completedChallenges : completedChallenges // ignore: cast_nullable_to_non_nullable
as List<CompletedChallenge>,completedDailyCodingChallenges: null == completedDailyCodingChallenges ? _self._completedDailyCodingChallenges : completedDailyCodingChallenges // ignore: cast_nullable_to_non_nullable
as List<CompletedDailyChallenge>,savedChallenges: null == savedChallenges ? _self._savedChallenges : savedChallenges // ignore: cast_nullable_to_non_nullable
as List<SavedChallenge>,portfolio: null == portfolio ? _self._portfolio : portfolio // ignore: cast_nullable_to_non_nullable
as List<Portfolio>,experience: null == experience ? _self._experience : experience // ignore: cast_nullable_to_non_nullable
as List<Experience>,profileUI: null == profileUI ? _self.profileUI : profileUI // ignore: cast_nullable_to_non_nullable
as ProfileUI,yearsTopContributor: null == yearsTopContributor ? _self._yearsTopContributor : yearsTopContributor // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

/// Create a copy of FccUserModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileUICopyWith<$Res> get profileUI {
  
  return $ProfileUICopyWith<$Res>(_self.profileUI, (value) {
    return _then(_self.copyWith(profileUI: value));
  });
}
}

// dart format on
