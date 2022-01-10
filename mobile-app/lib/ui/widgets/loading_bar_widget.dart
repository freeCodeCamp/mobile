import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:flutter_hooks/flutter_hooks.dart';

// ignore: must_be_immutable
class LoadingBarIndiactor extends HookWidget {
  LoadingBarIndiactor(
      {Key? key,
      required this.values,
      this.progressColor = Colors.lightBlue,
      this.progressBgColor = Colors.red,
      this.progressHeight = 5.0})
      : super(key: key);

  final Color progressColor;
  final Color progressBgColor;
  final double progressHeight;
  final List<int> values;
  double begin = 0;

  @override
  Widget build(BuildContext context) {
    dev.log('I get rebuild');
    var controller =
        useAnimationController(duration: const Duration(milliseconds: 2000));
    controller.reset();
    controller.forward();
    begin = values[1] != 0 ? ((values[1] - 1) / values[0] * 100).toDouble() : 0;

    return LoadingBar(
        controller: controller,
        progress: values[1] != 0 ? (values[1] / values[0] * 100).toDouble() : 5,
        progressBgColor: progressBgColor,
        progressColor: progressColor,
        progressHeight: progressHeight,
        begin: begin);
  }
}

// ignore: must_be_immutable
class LoadingBar extends AnimatedWidget {
  LoadingBar(
      {Key? key,
      required AnimationController controller,
      this.progressColor = Colors.lightBlue,
      this.progressBgColor = Colors.red,
      required this.begin,
      required this.progress,
      this.progressHeight = 5.0})
      : super(
            key: key,
            listenable:
                Tween<double>(begin: begin, end: progress).animate(controller));

  final Color progressColor;
  final Color progressBgColor;
  final double progressHeight;
  final double progress;
  final double begin;

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    dev.log('begin ' + begin.toString());
    dev.log('progress: ' + progress.toString());
    return Stack(
      children: [
        Container(
          color: progressBgColor,
          height: 5,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          color: progressColor,
          height: 5,
          width: MediaQuery.of(context).size.width * animation.value / 100,
        ),
      ],
    );
  }
}
