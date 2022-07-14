import 'package:flutter/material.dart';

class NewsFeedLazyLoading extends StatefulWidget {
  final Function articleCreated;
  final Widget child;

  const NewsFeedLazyLoading(
      {Key? key, required this.articleCreated, required this.child})
      : super(key: key);

  @override
  NewsFeedLazyLoadingState createState() => NewsFeedLazyLoadingState();
}

class NewsFeedLazyLoadingState extends State<NewsFeedLazyLoading> {
  @override
  void initState() {
    super.initState();
    widget.articleCreated();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
