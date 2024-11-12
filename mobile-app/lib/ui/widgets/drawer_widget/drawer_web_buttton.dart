import 'package:firebase_analytics/firebase_analytics.dart';
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

  void startCustomTabs(String url) async {
    String location;
    switch (url) {
      case 'https://www.freecodecamp.org/news/privacy-policy/':
        location = 'Privacy Policy';
        break;
      case 'https://www.freecodecamp.org/donate/':
        location = 'Donation';
        break;
      default:
        location = url;
    }
    await FirebaseAnalytics.instance.logScreenView(
      screenClass: 'Web View - $location',
      screenName: 'Web View - $location',
    );
    launchUrl(
      Uri.parse(url),
      customTabsOptions: const CustomTabsOptions(
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        browser: CustomTabsBrowserConfiguration(
          fallbackCustomTabs: [
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
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
