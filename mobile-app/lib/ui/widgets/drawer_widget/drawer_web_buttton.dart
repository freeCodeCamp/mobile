import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebButton extends StatefulWidget {
  const WebButton(
      {Key? key,
      required this.url,
      required this.icon,
      required this.component})
      : super(key: key);

  final String url;
  final String component;
  final IconData icon;

  @override
  State<StatefulWidget> createState() => _WebButtonState();
}

class _WebButtonState extends State<WebButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        dense: true,
        onTap: () {
          launchUrlString(widget.url);
        },
        leading: Icon(
          widget.icon,
          color: Colors.white,
        ),
        title: Text(
          widget.component,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.5),
        ),
      ),
    );
  }
}
