import 'package:flutter/material.dart';

class DrawerTile extends StatefulWidget {
  const DrawerTile({
    super.key,
    this.textColor = Colors.white,
    required this.component,
    required this.icon,
    required this.route,
    this.showNotification = false,
  });

  final String component;
  final dynamic icon;
  final Function route;
  final Color? textColor;
  final bool showNotification;

  @override
  State<StatefulWidget> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<DrawerTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        dense: true,
        leading: widget.icon != ''
            ? Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    widget.icon,
                    color: widget.textColor,
                  ),
                  if (widget.showNotification)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                ],
              )
            : Image.asset(
                'assets/images/logo.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
        title: Text(
          widget.component,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: widget.textColor,
              letterSpacing: 0.5),
        ),
        onTap: () {
          widget.route();
        },
      ),
    );
  }
}
