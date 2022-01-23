class CodeRadio {
  const CodeRadio(
      {required this.id,
      required this.listenUrl,
      required this.totalListeners,
      required this.nowPlaying,
      required this.nextPlaying});

  final int id;
  final String listenUrl;

  final int totalListeners;

  final Song nowPlaying;
  final Song nextPlaying;

  factory CodeRadio.fromJson(Map<String, dynamic> data) {
    return CodeRadio(
        id: data['station']['id'],
        listenUrl: data['station'],
        totalListeners: data['listeners']['total'],
        nowPlaying: data['now_playing']['song'],
        nextPlaying: data['playing_next']['song']);
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
        title: data['text'],
        artist: data['artist'],
        album: data['album'],
        genre: data['genre'],
        artUrl: data['art']);
  }
}
