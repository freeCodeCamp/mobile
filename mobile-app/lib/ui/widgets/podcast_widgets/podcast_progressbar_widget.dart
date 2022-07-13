import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/app/app.locator.dart';
import 'package:freecodecamp/service/audio_service.dart';
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

  final _audioService = locator<AppAudioService>().audioHandler;

  final double ball = 15;

  double _barWidth = 0.0;
  double get barWidth => _barWidth;

  Duration _progress = Duration.zero;
  Duration get progress => _progress;

  StreamSubscription<Duration>? progressListener;

  @override
  PodcastProgressBarState createState() => PodcastProgressBarState();
}

class PodcastProgressBarState extends State<PodcastProgressBar> {
  void setBarWidthAndAudio(double value, double maxBarWidth) {
    value = value - MediaQuery.of(context).size.width * 0.1;
    setState(() {
      double newDuration = (value / maxBarWidth) * widget.duration.inSeconds;

      setProgress = Duration(seconds: newDuration.toInt());

      if (widget._audioService.episodeId == widget.episodeId) {
        widget._audioService.seek(Duration(seconds: newDuration.toInt()));
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
  }

  set setProgress(Duration value) {
    setState(() {
      double maxBarWidth = MediaQuery.of(context).size.width * 0.8;

      double newWidth =
          (value.inSeconds / widget.duration.inSeconds) * maxBarWidth;

      bool shouldSetNewWidth = newWidth + widget.ball < maxBarWidth;
      if (newWidth < widget.ball / 4) {
        widget._barWidth = widget.ball / 4;
      } else if (shouldSetNewWidth) {
        widget._barWidth = newWidth;
      }

      if (value.isNegative || newWidth.isNegative) {
        widget._progress = const Duration(milliseconds: 1);
        widget._audioService.seek(const Duration(milliseconds: 1));
      } else if (newWidth > maxBarWidth) {
        widget._progress = widget.duration;
        widget._audioService.seek(widget.duration);
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
          widget._audioService.seek(widget._progress);
        }
      } else {
        widget._barWidth = 0.0;
        setProgress = Duration.zero;
      }
    });

    widget.progressListener =
        AudioService.position.listen((event) {
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
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    width: getMaxPorgressBarWidth,
                    height: 5,
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
                      height: 5,
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
                        height: widget.ball,
                        width: widget.ball,
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
