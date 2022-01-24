class CodeRadio {
  const CodeRadio(
      {required this.id,
      required this.listenUrl,
      required this.totalListeners,
      required this.duration,
      required this.elapsed,
      required this.nowPlaying,
      required this.nextPlaying});

  final int id;
  final String listenUrl;

  final int totalListeners;

  final int duration;
  final int elapsed;

  final Song nowPlaying;
  final Song nextPlaying;

  factory CodeRadio.fromJson(Map<String, dynamic> data) {
    return CodeRadio(
        id: data['station']['id'],
        listenUrl: data['station']['listen_url'],
        totalListeners: data['listeners']['total'],
        elapsed: data['now_playing']['elapsed'],
        duration: data['now_playing']['duration'],
        nowPlaying: Song.fromJson(data['now_playing']['song']),
        nextPlaying: Song.fromJson(data['playing_next']['song']));
  }
}

class Song {
  const Song(
      {required this.title,
      required this.artist,
      required this.album,
      required this.genre,
      required this.artUrl});

  final String title;
  final String artist;
  final String album;
  final String genre;
  final String artUrl;

  factory Song.fromJson(Map<String, dynamic> data) {
    return Song(
        title: data['title'],
        artist: data['artist'],
        album: data['album'],
        genre: data['genre'],
        artUrl: data['art']);
  }
}
