import 'package:freezed_annotation/freezed_annotation.dart';

part 'code_radio_model.freezed.dart';
part 'code_radio_model.g.dart';

@freezed
abstract class CodeRadio with _$CodeRadio {
  const factory CodeRadio({
    required Station station,
    required Listeners listeners,
    @JsonKey(name: 'now_playing') required NowPlaying nowPlaying,
    @JsonKey(name: 'playing_next') required PlayingNext playingNext,
  }) = _CodeRadio;

  factory CodeRadio.fromJson(Map<String, Object?> json) =>
      _$CodeRadioFromJson(json);
}

@freezed
abstract class Station with _$Station {
  const factory Station({
    @JsonKey(name: 'listen_url') required String listenUrl,
  }) = _Station;

  factory Station.fromJson(Map<String, Object?> json) =>
      _$StationFromJson(json);
}

@freezed
abstract class Listeners with _$Listeners {
  const factory Listeners({required int total}) = _Listeners;

  factory Listeners.fromJson(Map<String, Object?> json) =>
      _$ListenersFromJson(json);
}

@freezed
abstract class NowPlaying with _$NowPlaying {
  const factory NowPlaying({
    required int duration,
    required int elapsed,
    required Song song,
  }) = _NowPlaying;

  factory NowPlaying.fromJson(Map<String, Object?> json) =>
      _$NowPlayingFromJson(json);
}

@freezed
abstract class PlayingNext with _$PlayingNext {
  const factory PlayingNext({required Song song}) = _PlayingNext;

  factory PlayingNext.fromJson(Map<String, Object?> json) =>
      _$PlayingNextFromJson(json);
}

@freezed
abstract class Song with _$Song {
  const factory Song({
    required String id,
    required String title,
    required String artist,
    required String album,
    required String art,
  }) = _Song;

  factory Song.fromJson(Map<String, Object?> json) => _$SongFromJson(json);
}
