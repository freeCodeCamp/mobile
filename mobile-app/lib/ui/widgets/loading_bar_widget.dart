import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:developer' as dev;

// ignore: must_be_immutable
class LoadingBarIndiactor extends HookWidget {
  LoadingBarIndiactor(
      {Key? key,
      required this.arrayLength,
      this.start = 0,
      required this.end,
      this.progressColor = Colors.lightBlue,
      this.progressBgColor = Colors.red,
      this.progressHeight = 5.0})
      : super(key: key);

  final Color progressColor;
  final Color progressBgColor;
  final double progressHeight;

  final int arrayLength;

  final int start;
  final int end;

  @override
  Widget build(BuildContext context) {
    dev.log('begin: ' + start.toString());
    dev.log('arr' + arrayLength.toString());
    dev.log('end: ' + end.toString());

    var controller =
        useAnimationController(duration: const Duration(milliseconds: 2000));
    controller.reset();
    controller.forward();

    return LoadingBar(
      controller: controller,
      begin: start != 0 ? (start / arrayLength * 100).toDouble() : 1,
      end: end != 0 ? (end / arrayLength * 100).toDouble() : 5,
      progressBgColor: progressBgColor,
      progressColor: progressColor,
      progressHeight: progressHeight,
    );
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
      required this.end,
      this.progressHeight = 5.0})
      : super(
            key: key,
            listenable:
                Tween<double>(begin: begin, end: end).animate(controller));

  final Color progressColor;
  final Color progressBgColor;
  final double progressHeight;
  final double end;
  final double begin;

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
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
