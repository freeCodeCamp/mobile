import 'package:flutter/cupertino.dart';

class ProgressBarLoader extends StatefulWidget {
  final Function exectuteOnProgress;
  final Widget child;

  const ProgressBarLoader(
      {Key? key, required this.exectuteOnProgress, required this.child})
      : super(key: key);

  @override
  _ProgressBarLoaderState createState() => _ProgressBarLoaderState();
}

class _ProgressBarLoaderState extends State<ProgressBarLoader> {
  @override
  void initState() {
    super.initState();
    widget.exectuteOnProgress();
  }

  Widget build(BuildContext context) {
    return widget.child;
  }
}
