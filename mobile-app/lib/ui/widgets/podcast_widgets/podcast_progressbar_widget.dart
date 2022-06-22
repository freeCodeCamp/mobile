import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/episode_audio_service.dart';

// ignore: must_be_immutable
class PodcastProgressBar extends StatefulWidget {
  final Duration duration;
  final String episodeId;

  PodcastProgressBar({
    Key? key,
    required this.duration,
    required this.episodeId,
  }) : super(key: key);

  final EpisodeAudioService _audioService = locator<EpisodeAudioService>();

  double _barWidth = 0.0;
  double get barWidth => _barWidth;

  Duration _progress = Duration.zero;
  Duration get progress => _progress;

  @override
  _PodcastProgressBarState createState() => _PodcastProgressBarState();
}

class _PodcastProgressBarState extends State<PodcastProgressBar> {
  void setBarWidthAndAudio(double value, double maxBarWidth) {
    setState(() {
      double newWidth = (value / maxBarWidth) * maxBarWidth;

      widget._barWidth = newWidth;

      double newDuration = (value / maxBarWidth) * widget.duration.inSeconds;

      setProgress = Duration(seconds: newDuration.toInt());

      widget._audioService.audioPlayer
          .seek(Duration(seconds: newDuration.toInt()));
    });
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  set setProgress(Duration value) {
    setState(() {
      widget._progress = value;
    });
  }

  @override
  void initState() {
    super.initState();
    widget._audioService.audioPlayer.positionStream.listen((event) {
      double maxBarWidth = MediaQuery.of(context).size.width * 0.8;
      double newWidth =
          (event.inSeconds / widget.duration.inSeconds) * maxBarWidth;
      widget._barWidth = newWidth;
      setProgress = event;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double getMaxPorgressBarWidth = screenWidth * 0.8;

    return SizedBox(
      width: getMaxPorgressBarWidth,
      child: Column(
        children: [
          GestureDetector(
            onTapDown: (details) {
              setBarWidthAndAudio(
                details.localPosition.dx,
                getMaxPorgressBarWidth,
              );
            },
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: getMaxPorgressBarWidth,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: const Color(0xFF0a0a23),
                    ),
                  ),
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      width: widget.barWidth,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                      ),
                    ),
                    GestureDetector(
                      onHorizontalDragUpdate: (details) => {
                        if (details.globalPosition.dx > 0 ||
                            details.globalPosition.dx <= getMaxPorgressBarWidth)
                          {
                            setBarWidthAndAudio(
                              details.globalPosition.dx,
                              getMaxPorgressBarWidth,
                            ),
                          }
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[300],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          printDuration(widget._progress),
                          style: const TextStyle(height: 1.2),
                        ),
                      ))),
              Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          printDuration(widget.duration),
                          style: const TextStyle(height: 1.2),
                        ),
                      ))),
            ],
          ),
        ],
      ),
    );
  }
}
