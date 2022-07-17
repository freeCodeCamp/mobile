import 'package:flutter/material.dart' show BuildContext, Color, Colors, EdgeInsets, FontWeight, Icon, IconData, Key, ListTile, Padding, State, StatefulWidget, Text, TextStyle, Widget;

class DrawerButton extends StatefulWidget {
  const DrawerButton({
    Key? key,
    this.textColor = Colors.white,
    required this.component,
    required this.icon,
    required this.route,
  }) : super(key: key);

  final String component;
  final IconData icon;
  final Function route;
  final Color? textColor;
  @override
  State<StatefulWidget> createState() => _DrawerButtonState();
}

class _DrawerButtonState extends State<DrawerButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        dense: true,
        leading: Icon(widget.icon, color: widget.textColor),
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
