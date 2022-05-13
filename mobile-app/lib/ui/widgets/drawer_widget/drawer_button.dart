import 'package:flutter/material.dart';

class DrawerButton extends StatefulWidget {
  const DrawerButton({
    Key? key,
    required this.component,
    required this.icon,
    required this.route,
  }) : super(key: key);

  final String component;
  final IconData icon;
  final Function route;

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
        onTap: () {
          widget.route();
        },
      ),
    );
  }
}
