import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/episode_audio_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  final double audioBallSize = 20;

  double _barWidth = 0.0;
  double get barWidth => _barWidth;

  Duration _progress = Duration.zero;
  Duration get progress => _progress;

  StreamSubscription<Duration>? progressListener;

  @override
  _PodcastProgressBarState createState() => _PodcastProgressBarState();
}

class _PodcastProgressBarState extends State<PodcastProgressBar> {
  void setBarWidthAndAudio(double value, double maxBarWidth) {
    value = value - MediaQuery.of(context).size.width * 0.1;
    setState(() {
      double newDuration = (value / maxBarWidth) * widget.duration.inSeconds;

      setProgress = Duration(seconds: newDuration.toInt());

      if (widget._audioService.episodeId == widget.episodeId) {
        widget._audioService.audioPlayer
            .seek(Duration(seconds: newDuration.toInt()));
      }
    });

    storeProgressAfterDispose();
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }

  void storeProgressAfterDispose() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt('${widget.episodeId}_progress', widget.progress.inSeconds);

    log('Storing progress: ${widget.progress.inSeconds}');
  }

  set setProgress(Duration value) {
    setState(() {
      double maxBarWidth = MediaQuery.of(context).size.width * 0.8;

      double newWidth =
          (value.inSeconds / widget.duration.inSeconds) * maxBarWidth;

      if (newWidth > widget.audioBallSize / 2 &&
          newWidth + widget.audioBallSize / 2 < maxBarWidth) {
        widget._barWidth = newWidth - widget.audioBallSize / 2;
      }

      if (value.isNegative || newWidth.isNegative) {
        widget._progress = const Duration(milliseconds: 1);
        widget._audioService.audioPlayer.seek(const Duration(milliseconds: 1));
      } else if (newWidth > maxBarWidth) {
        widget._progress = widget.duration;
        widget._audioService.audioPlayer.seek(widget.duration);
      } else if (value.inSeconds <= widget.duration.inSeconds) {
        widget._progress = value;
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getInt('${widget.episodeId}_progress') != null) {
        setProgress = Duration(
            seconds: prefs.getInt('${widget.episodeId}_progress') as int);
        if (widget.episodeId == widget._audioService.episodeId) {
          widget._audioService.audioPlayer.seek(widget._progress);
        }
      } else {
        widget._barWidth = 0.0;
        setProgress = Duration.zero;
      }
    });

    widget.progressListener =
        widget._audioService.audioPlayer.positionStream.listen((event) {
      if (widget._audioService.episodeId == widget.episodeId) {
        setProgress = event;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    storeProgressAfterDispose();
    widget.progressListener?.cancel();
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
                details.globalPosition.dx,
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
                Row(
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
                        setBarWidthAndAudio(
                          details.globalPosition.dx,
                          getMaxPorgressBarWidth,
                        ),
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        height: widget.audioBallSize,
                        width: widget.audioBallSize,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.grey[300],
                        ),
                      ),
                    ),
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
