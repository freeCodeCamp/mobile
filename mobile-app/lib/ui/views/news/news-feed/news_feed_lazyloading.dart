import 'package:flutter/material.dart';

class NewsFeedLazyLoading extends StatefulWidget {
  final Function tutorialCreated;
  final Widget child;

  const NewsFeedLazyLoading({
    Key? key,
    required this.tutorialCreated,
    required this.child,
  }) : super(key: key);

  @override
  NewsFeedLazyLoadingState createState() => NewsFeedLazyLoadingState();
}

class NewsFeedLazyLoadingState extends State<NewsFeedLazyLoading> {
  @override
  void initState() {
    super.initState();
    widget.tutorialCreated();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
