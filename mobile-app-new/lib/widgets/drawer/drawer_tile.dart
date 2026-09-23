import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({
    super.key,
    this.textColor = Colors.white,
    required this.component,
    required this.route,
    this.icon,
  });

  final String component;
  final IconData? icon;
  final Function route;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        dense: true,
        leading: icon != null
            ? Icon(icon, color: textColor)
            : Image.asset(
                'assets/images/logo.png',
                width: 30,
                height: 30,
                color: Colors.white,
              ),
        title: Text(
          component,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
            letterSpacing: 0.5,
          ),
        ),
        onTap: () => route(),
      ),
    );
  }
}
