import 'package:flutter/material.dart';
import 'package:mobile_app_new/ui/core/drawer/drawer.dart';

class NewsFeedView extends StatefulWidget {
  const NewsFeedView({super.key});

  @override
  State<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tutorials')),
      drawer: const DrawerWidget(),
      body: Center(child: Text('LOADING...')),
    );
  }
}
