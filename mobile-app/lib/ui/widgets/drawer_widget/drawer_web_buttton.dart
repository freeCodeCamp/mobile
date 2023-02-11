import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class CustomTabButton extends StatefulWidget {
  const CustomTabButton({
    Key? key,
    required this.url,
    required this.icon,
    required this.component,
  }) : super(key: key);

  final String url;
  final String component;
  final IconData icon;

  void startCustomTabs(String url) {
    launch(
      url,
      customTabsOption: const CustomTabsOption(
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: [
          'org.mozilla.firefox',
          'com.microsoft.emmx',
        ],
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _CustomTabButtonState();
}

class _CustomTabButtonState extends State<CustomTabButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        dense: true,
        onTap: () {
          widget.startCustomTabs(widget.url);
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
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
