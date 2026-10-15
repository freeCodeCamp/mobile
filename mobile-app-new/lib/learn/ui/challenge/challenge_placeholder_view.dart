import 'package:flutter/material.dart';

class ChallengePlaceholderView extends StatelessWidget {
  const ChallengePlaceholderView({super.key, required this.details});

  final String details;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenge')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Coming soon\n\n$details', textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
