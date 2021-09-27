import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/podcast/podcast_viewmodel.dart';
import 'package:stacked/stacked.dart';

// ui view only

class PodcastView extends StatelessWidget {
  const PodcastView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        floatingActionButton:
            FloatingActionButton(onPressed: model.doSomething),
        body: Center(
          child: Text(model.title),
        ),
      ),
      viewModelBuilder: () => PodcastViewModel(),
    );
  }
}
