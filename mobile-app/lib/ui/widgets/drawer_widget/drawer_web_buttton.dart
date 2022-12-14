import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/web_view/web_view_view.dart';

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
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration.zero,
              pageBuilder: (context, animation1, animation2) =>
                  WebViewView(url: widget.url),
              settings: RouteSettings(
                name: 'Web View - ${widget.component}',
              ),
            ),
          );
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
