import 'package:flutter/material.dart';

class PodcastApp extends StatefulWidget {
  const PodcastApp({Key? key}) : super(key: key);

  @override
  _PodcastAppState createState() => _PodcastAppState();
}

class _PodcastAppState extends State<PodcastApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Podcasts'),
        backgroundColor: Color(0xFF0a0a23),
      ),
      backgroundColor: Color(0xFF0a0a23),
      body: Center(
        child: const Text(
          'No podcasts available',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
