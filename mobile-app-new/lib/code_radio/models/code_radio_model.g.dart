// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_radio_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CodeRadio _$CodeRadioFromJson(Map<String, dynamic> json) => _CodeRadio(
  station: Station.fromJson(json['station'] as Map<String, dynamic>),
  listeners: Listeners.fromJson(json['listeners'] as Map<String, dynamic>),
  nowPlaying: NowPlaying.fromJson(json['now_playing'] as Map<String, dynamic>),
  playingNext: PlayingNext.fromJson(
    json['playing_next'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$CodeRadioToJson(_CodeRadio instance) =>
    <String, dynamic>{
      'station': instance.station,
      'listeners': instance.listeners,
      'now_playing': instance.nowPlaying,
      'playing_next': instance.playingNext,
    };

_Station _$StationFromJson(Map<String, dynamic> json) =>
    _Station(listenUrl: json['listen_url'] as String);

Map<String, dynamic> _$StationToJson(_Station instance) => <String, dynamic>{
  'listen_url': instance.listenUrl,
};

_Listeners _$ListenersFromJson(Map<String, dynamic> json) =>
    _Listeners(total: (json['total'] as num).toInt());

Map<String, dynamic> _$ListenersToJson(_Listeners instance) =>
    <String, dynamic>{'total': instance.total};

_NowPlaying _$NowPlayingFromJson(Map<String, dynamic> json) => _NowPlaying(
  duration: (json['duration'] as num).toInt(),
  elapsed: (json['elapsed'] as num).toInt(),
  song: Song.fromJson(json['song'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NowPlayingToJson(_NowPlaying instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'elapsed': instance.elapsed,
      'song': instance.song,
    };

_PlayingNext _$PlayingNextFromJson(Map<String, dynamic> json) =>
    _PlayingNext(song: Song.fromJson(json['song'] as Map<String, dynamic>));

Map<String, dynamic> _$PlayingNextToJson(_PlayingNext instance) =>
    <String, dynamic>{'song': instance.song};

_Song _$SongFromJson(Map<String, dynamic> json) => _Song(
  id: json['id'] as String,
  title: json['title'] as String,
  artist: json['artist'] as String,
  album: json['album'] as String,
  art: json['art'] as String,
);

Map<String, dynamic> _$SongToJson(_Song instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'artist': instance.artist,
  'album': instance.album,
  'art': instance.art,
};
