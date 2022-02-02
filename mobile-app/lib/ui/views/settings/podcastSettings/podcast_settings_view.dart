import 'package:flutter/material.dart';

import 'package:freecodecamp/ui/views/settings/podcastSettings/podcast_settings_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PodcastSettingsView extends StatelessWidget {
  const PodcastSettingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PodcastSettingsViewModel>.reactive(
        viewModelBuilder: () => PodcastSettingsViewModel(),
        builder: (context, model, child) => Scaffold(
              backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
              appBar: AppBar(
                backgroundColor: const Color(0xFF0a0a23),
                title: const Text('PODCAST SETTINGS'),
                centerTitle: true,
              ),
            ));
  }
}
