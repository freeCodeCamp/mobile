class CodeRadio {
  const CodeRadio(
      {required this.id,
      required this.listenUrl,
      required this.totalListeners});

  final int id;
  final String listenUrl;

  final int totalListeners;
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
}
