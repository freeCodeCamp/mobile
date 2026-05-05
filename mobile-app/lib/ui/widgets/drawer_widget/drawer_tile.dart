import 'package:flutter/material.dart';

class DrawerTile extends StatefulWidget {
  const DrawerTile({
    super.key,
    this.textColor = Colors.white,
    required this.component,
    required this.icon,
    required this.route,
  });

  final String component;
  final dynamic icon;
  final Function route;
  final Color? textColor;
  @override
  State<StatefulWidget> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Tooltip(
        message: widget.component,
        child: Semantics(
          button: true,
          enabled: true,
          label: widget.component,
          onTap: () {
            widget.route();
          },
          child: ListTile(
            dense: true,
            leading: widget.icon != ''
                ? Semantics(
                    image: true,
                    label: widget.component,
                    child: Icon(
                      widget.icon,
                      color: widget.textColor,
                      semanticLabel: widget.component,
                    ),
                  )
                : Semantics(
                    image: true,
                    label: 'freeCodeCamp logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 30,
                      height: 30,
                      color: Colors.white,
                      semanticLabel: 'freeCodeCamp logo',
                    ),
                  ),
            title: Text(
              widget.component,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: widget.textColor,
                  letterSpacing: 0.5),
              semanticsLabel: widget.component,
            ),
            onTap: () {
              widget.route();
            },
          ),
        ),
      ),
    );
  }
}
