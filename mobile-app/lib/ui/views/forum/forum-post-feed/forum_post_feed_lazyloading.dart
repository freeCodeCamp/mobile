import 'package:flutter/material.dart';

class ForumLazyLoading extends StatefulWidget {
  final Function postCreated;
  final Widget child;

  const ForumLazyLoading(
      {Key? key, required this.postCreated, required this.child})
      : super(key: key);

  @override
  ForumLazyLoadingState createState() => ForumLazyLoadingState();
}

class ForumLazyLoadingState extends State<ForumLazyLoading> {
  @override
  void initState() {
    super.initState();
    widget.postCreated();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
